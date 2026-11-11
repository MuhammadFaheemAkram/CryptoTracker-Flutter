import 'dart:math';

import 'package:clock/clock.dart';
import 'package:crypto_tracker/core/prices/price_ticker.dart';
import 'package:crypto_tracker/core/prices/random_walk.dart';
import 'package:crypto_tracker/core/prices/ticker_scheduler.dart';
import 'package:crypto_tracker/domain/model/app_settings.dart';
import 'package:crypto_tracker/domain/model/currency.dart';
import 'package:crypto_tracker/domain/model/tick_interval.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fakes/fake_settings_repository.dart';

/// A ticker that records what the scheduler asks of it, instead of
/// ticking.
class _RecordingTicker extends PriceTicker {
  _RecordingTicker() : super(RandomWalk(Random(1)), clock);

  final calls = <String>[];

  @override
  void start(Duration interval) => calls.add('start ${interval.inSeconds}s');

  @override
  void stop() => calls.add('stop');
}

// In real time: switching between the foreground and the settings cancels
// a subscription, and rxdart's switchMap waits for that cancel's future,
// which fake time never completes (conventions §11.122).
void main() {
  late _RecordingTicker ticker;
  late FakeSettingsRepository settings;
  late TickerScheduler scheduler;

  setUp(() {
    ticker = _RecordingTicker();
    settings = FakeSettingsRepository();
    scheduler = TickerScheduler(ticker, settings);
  });

  tearDown(() async {
    await scheduler.dispose();
    await settings.dispose();
  });

  Future<void> settle() => pumpEventQueue();

  test('attached in the foreground: starts at the chosen interval', () async {
    scheduler.attach();
    await settle();

    expect(ticker.calls, ['start 2s']);
  });

  test('a new interval restarts it', () async {
    scheduler.attach();
    await settle();

    await settings.update((s) => s.copyWith(interval: TickInterval.oneSecond));
    await settle();

    expect(ticker.calls, ['start 2s', 'start 1s']);
  });

  test('pausing stops it; resuming restarts it at the same interval', () async {
    await settings.update(
      (s) => s.copyWith(interval: TickInterval.fiveSeconds),
    );
    scheduler.attach();
    await settle();

    await settings.update((s) => s.copyWith(livePricesPaused: true));
    await settle();
    await settings.update((s) => s.copyWith(livePricesPaused: false));
    await settle();

    expect(ticker.calls, ['start 5s', 'stop', 'start 5s']);
  });

  test('another setting (the currency) never restarts it', () async {
    scheduler.attach();
    await settle();

    await settings.update((s) => s.copyWith(currency: Currency.eur));
    await settle();

    expect(ticker.calls, ['start 2s']);
  });

  test('in the background it stops, and ignores the settings until it '
      'comes back, then picks them up', () async {
    scheduler.attach();
    await settle();

    scheduler.setForeground(foreground: false);
    await settle();
    await settings.update((s) => s.copyWith(interval: TickInterval.oneSecond));
    await settle();
    expect(ticker.calls, ['start 2s', 'stop']);

    scheduler.setForeground(foreground: true);
    await settle();
    expect(ticker.calls, ['start 2s', 'stop', 'start 1s']);
  });

  test('coming back while paused keeps it stopped', () async {
    await settings.update((s) => s.copyWith(livePricesPaused: true));
    scheduler.attach();
    await settle();

    scheduler
      ..setForeground(foreground: false)
      ..setForeground(foreground: true);
    await settle();

    expect(ticker.calls, ['stop']);
  });

  test('attaching twice follows once', () async {
    scheduler
      ..attach()
      ..attach();
    await settle();

    expect(ticker.calls, ['start 2s']);
  });

  test('detach stops it, and the settings no longer reach it', () async {
    scheduler.attach();
    await settle();

    await scheduler.detach();
    await settings.update((s) => s.copyWith(interval: TickInterval.oneSecond));
    await settle();

    expect(ticker.calls, ['start 2s', 'stop']);
  });

  test('defaults: two seconds, live', () {
    expect(const AppSettings().interval, TickInterval.twoSeconds);
    expect(const AppSettings().livePricesPaused, isFalse);
  });
}
