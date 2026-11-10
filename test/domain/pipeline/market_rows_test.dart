import 'package:crypto_tracker/domain/model/sort_option.dart';
import 'package:crypto_tracker/domain/pipeline/market_rows.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fixtures.dart';

void main() {
  final market = smallMarket();

  List<String> ids({String query = '', SortOption sort = SortOption.rank}) => [
    for (final row in buildMarketRows(
      coins: market.coins,
      quotes: market.quotes,
      query: query,
      sort: sort,
    ))
      row.coin.id,
  ];

  group('search', () {
    test('an empty query lists every coin', () {
      expect(ids(), ['bitcoin', 'ethereum', 'tether', 'solana']);
      expect(ids(query: '   '), hasLength(4));
    });

    test('matches the name or the symbol, ignoring case', () {
      // "eth" is inside "Tether" too: a substring search finds both.
      expect(ids(query: 'ETH'), ['ethereum', 'tether']);
      expect(ids(query: 'btc'), ['bitcoin']);
      expect(ids(query: 'usdt'), ['tether']);
      expect(ids(query: 'Sol'), ['solana']);
      expect(ids(query: 'e'), ['ethereum', 'tether']);
    });

    test('ignores the spaces around the query', () {
      expect(ids(query: '  bitcoin '), ['bitcoin']);
    });

    test('no match is an empty list', () {
      expect(ids(query: 'doge'), isEmpty);
    });

    test('matchesQuery on its own', () {
      final bitcoin = market.coins.first;
      expect(matchesQuery(bitcoin, ''), isTrue);
      expect(matchesQuery(bitcoin, 'TC'), isTrue);
      expect(matchesQuery(bitcoin, 'coin '), isTrue);
      expect(matchesQuery(bitcoin, 'eth'), isFalse);
    });
  });

  group('sort', () {
    test('rank ascending', () {
      expect(ids(), ['bitcoin', 'ethereum', 'tether', 'solana']);
    });

    test('price descending', () {
      expect(ids(sort: SortOption.price), [
        'bitcoin',
        'ethereum',
        'solana',
        'tether',
      ]);
    });

    test('24 h change descending', () {
      expect(ids(sort: SortOption.change24h), [
        'solana',
        'bitcoin',
        'tether',
        'ethereum',
      ]);
    });

    test('name ascending, ignoring case', () {
      // Case-sensitive, "Beta" would come first ('B' sorts before 'a').
      final coins = [
        coin('b', name: 'Beta'),
        coin('a', rank: 2, name: 'alpha'),
      ];
      final rows = buildMarketRows(
        coins: coins,
        quotes: {'a': quote('a', 1), 'b': quote('b', 1)},
        sort: SortOption.name,
      );
      expect(rows.map((row) => row.coin.name), ['alpha', 'Beta']);
    });

    test('ties fall back to rank, for every option, whatever the input '
        'order (a stable list between ticks)', () {
      final coins = [
        coin('c', rank: 3, name: 'Same'),
        coin('a', name: 'Same'),
        coin('b', rank: 2, name: 'Same'),
      ];
      final quotes = {
        for (final id in ['a', 'b', 'c']) id: quote(id, 10, change: 1),
      };
      for (final sort in SortOption.values) {
        final rows = buildMarketRows(coins: coins, quotes: quotes, sort: sort);
        expect(rows.map((row) => row.coin.id), [
          'a',
          'b',
          'c',
        ], reason: '$sort');
      }
    });

    test('search and sort together', () {
      expect(ids(query: 'e', sort: SortOption.price), ['ethereum', 'tether']);
    });
  });

  test('a coin without a quote is left out', () {
    final rows = buildMarketRows(
      coins: market.coins,
      quotes: {...market.quotes}..remove('tether'),
    );
    expect(rows.map((row) => row.coin.id), isNot(contains('tether')));
  });

  test('rows carry their coin and quote, flat and unwatched for now', () {
    final row = buildMarketRows(
      coins: market.coins,
      quotes: market.quotes,
    ).first;
    expect(row.coin, market.coins.first);
    expect(row.quote, market.quotes['bitcoin']);
    expect(row.isWatched, isFalse);
  });
}
