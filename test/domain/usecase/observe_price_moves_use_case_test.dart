import 'package:async/async.dart';
import 'package:crypto_tracker/domain/model/price_direction.dart';
import 'package:crypto_tracker/domain/model/price_snapshot.dart';
import 'package:crypto_tracker/domain/usecase/observe_price_moves_use_case.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fakes/fake_market_repository.dart';

void main() {
  late FakeMarketRepository market;

  setUp(() async {
    market = FakeMarketRepository();
    await market.loadMarket();
  });

  tearDown(() => market.dispose());

  test('the first snapshot: every quote, nothing moved', () async {
    final moves = StreamQueue(ObservePriceMovesUseCase(market)());

    final first = await moves.next;

    expect(first.quotes, market.currentQuotes);
    expect(first.directions, isEmpty);
    expect(first.directionOf('bitcoin'), PriceDirection.flat);
    await moves.cancel();
  });

  test('each tick: the new quotes, with which way each moved since the '
      'last tick (one snapshot, both together)', () async {
    final moves = StreamQueue(ObservePriceMovesUseCase(market)());
    await moves.next;
    final start = market.currentQuotes;

    market.emitQuotes({
      ...start,
      'bitcoin': start['bitcoin']!.copyWith(priceUsd: 70000),
      'ethereum': start['ethereum']!.copyWith(priceUsd: 3000),
    });
    final second = await moves.next;
    expect(second.directionOf('bitcoin'), PriceDirection.up);
    expect(second.directionOf('ethereum'), PriceDirection.down);
    expect(second.directionOf('tether'), PriceDirection.flat);

    // Compared with the tick before, not with the start.
    market.emitQuotes({
      ...second.quotes,
      'bitcoin': second.quotes['bitcoin']!.copyWith(priceUsd: 69000),
    });
    final third = await moves.next;
    expect(third.directionOf('bitcoin'), PriceDirection.down);
    expect(third.directionOf('ethereum'), PriceDirection.flat);
    await moves.cancel();
  });

  test(
    'a listener that joins late starts flat (its own first snapshot)',
    () async {
      market.emitQuotes({
        ...market.currentQuotes,
        'bitcoin': market.currentQuotes['bitcoin']!.copyWith(priceUsd: 1),
      });

      final moves = StreamQueue(ObservePriceMovesUseCase(market)());
      final PriceSnapshot first = await moves.next;

      expect(first.directions, isEmpty);
      await moves.cancel();
    },
  );
}
