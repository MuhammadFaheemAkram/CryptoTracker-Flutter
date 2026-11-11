import 'package:crypto_tracker/domain/model/price_direction.dart';
import 'package:crypto_tracker/domain/pipeline/watchlist_rows.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fixtures.dart';

void main() {
  final market = smallMarket();

  List<String> ids(List<String> watched) => [
    for (final row in buildWatchlistRows(
      coins: market.coins,
      quotes: market.quotes,
      watchedIds: watched,
    ))
      row.coin.id,
  ];

  test('rows come in the starred order, not by rank', () {
    expect(ids(['solana', 'bitcoin', 'tether']), [
      'solana',
      'bitcoin',
      'tether',
    ]);
  });

  test('nothing starred, no rows', () {
    expect(ids(const []), isEmpty);
  });

  test('an id the market doesn\'t know, or a coin without a quote, is left '
      'out', () {
    final rows = buildWatchlistRows(
      coins: market.coins,
      quotes: {...market.quotes}..remove('ethereum'),
      watchedIds: ['gone', 'ethereum', 'bitcoin'],
    );

    expect([for (final row in rows) row.coin.id], ['bitcoin']);
  });

  test('every row is watched, with its quote and direction', () {
    final rows = buildWatchlistRows(
      coins: market.coins,
      quotes: market.quotes,
      watchedIds: ['bitcoin', 'ethereum'],
      directions: {'bitcoin': PriceDirection.up},
    );

    expect(rows.every((row) => row.isWatched), isTrue);
    expect(rows.first.quote, market.quotes['bitcoin']);
    expect(rows.first.direction, PriceDirection.up);
    expect(rows.last.direction, PriceDirection.flat);
  });
}
