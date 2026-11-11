import 'dart:math';

import 'package:clock/clock.dart';
import 'package:crypto_tracker/app/live_ticker.dart';
import 'package:crypto_tracker/core/prices/price_ticker.dart';
import 'package:crypto_tracker/core/prices/random_walk.dart';
import 'package:crypto_tracker/core/prices/ticker_scheduler.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../helpers/fakes/fake_settings_repository.dart';

class _RecordingTicker extends PriceTicker {
  _RecordingTicker() : super(RandomWalk(Random(1)), clock);

  final calls = <String>[];

  @override
  void start(Duration interval) => calls.add('start');

  @override
  void stop() => calls.add('stop');
}

/// Lets the scheduler's pipeline settle. Its `switchMap` waits for a cancel
/// future that completes in the root zone (real time), then carries on in
/// the test's fake zone: so a turn of the real event loop, then a pump,
/// a few times over (conventions §11.122).
Future<void> settle(WidgetTester tester) async {
  for (var i = 0; i < 3; i++) {
    await tester.runAsync(pumpEventQueue);
    await tester.pump();
  }
}

void main() {
  late _RecordingTicker ticker;
  late FakeSettingsRepository settings;

  Future<void> pumpLiveTicker(WidgetTester tester) async {
    ticker = _RecordingTicker();
    settings = FakeSettingsRepository();
    final scheduler = TickerScheduler(ticker, settings);
    await tester.pumpWidget(
      LiveTicker(scheduler: scheduler, child: const SizedBox()),
    );
    await settle(tester);
  }

  Future<void> moveTo(
    WidgetTester tester,
    List<AppLifecycleState> states,
  ) async {
    for (final state in states) {
      tester.binding.handleAppLifecycleStateChanged(state);
    }
    await settle(tester);
  }

  testWidgets('on screen, the market ticks', (tester) async {
    await pumpLiveTicker(tester);

    expect(ticker.calls, ['start']);
  });

  testWidgets('hidden (another app, the home screen), it stops; shown '
      'again, it resumes', (tester) async {
    await pumpLiveTicker(tester);

    await moveTo(tester, [
      AppLifecycleState.inactive,
      AppLifecycleState.hidden,
    ]);
    expect(ticker.calls, ['start', 'stop']);

    await moveTo(tester, [
      AppLifecycleState.inactive,
      AppLifecycleState.resumed,
    ]);
    expect(ticker.calls, ['start', 'stop', 'start']);
  });

  testWidgets('a brief interruption (inactive: the control centre) keeps it '
      'ticking', (tester) async {
    await pumpLiveTicker(tester);

    await moveTo(tester, [AppLifecycleState.inactive]);
    await moveTo(tester, [AppLifecycleState.resumed]);

    expect(ticker.calls, ['start']);
  });

  testWidgets('removed from the tree, it stops the ticker', (tester) async {
    await pumpLiveTicker(tester);

    await tester.pumpWidget(const SizedBox());
    await settle(tester);

    expect(ticker.calls.last, 'stop');
  });
}
