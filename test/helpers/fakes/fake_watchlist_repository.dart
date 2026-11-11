import 'package:crypto_tracker/core/common/app_exception.dart';
import 'package:crypto_tracker/core/common/result.dart';
import 'package:crypto_tracker/domain/model/watched_coin.dart';
import 'package:crypto_tracker/domain/repository/watchlist_repository.dart';
import 'package:rxdart/rxdart.dart';

import '../fixtures.dart';

/// A [WatchlistRepository] in memory: a list in a `BehaviorSubject`, kept in
/// starred order as the real query keeps it. With [failWrites] set, every
/// write fails as a full disk would.
class FakeWatchlistRepository implements WatchlistRepository {
  FakeWatchlistRepository([List<String> starred = const []])
    : _items = BehaviorSubject.seeded([
        for (final (index, id) in starred.indexed)
          WatchedCoin(
            coinId: id,
            addedAt: testNow.add(Duration(minutes: index)),
          ),
      ]);

  final BehaviorSubject<List<WatchedCoin>> _items;
  bool failWrites = false;
  int _clock = 1000;

  /// The starred ids now.
  List<String> get ids => [for (final item in _items.value) item.coinId];

  @override
  Stream<List<String>> watchIds() =>
      _items.stream.map((items) => [for (final item in items) item.coinId]);

  @override
  Stream<bool> watchContains(String coinId) => _items.stream
      .map((items) => items.any((item) => item.coinId == coinId))
      .distinct();

  @override
  Future<Result<bool>> toggle(String coinId) async {
    if (failWrites) return const Err(StorageException());
    if (ids.contains(coinId)) {
      _set([..._items.value.where((item) => item.coinId != coinId)]);
      return const Ok(false);
    }
    _set([
      ..._items.value,
      WatchedCoin(
        coinId: coinId,
        addedAt: testNow.add(Duration(minutes: _clock++)),
      ),
    ]);
    return const Ok(true);
  }

  @override
  Future<Result<WatchedCoin?>> remove(String coinId) async {
    if (failWrites) return const Err(StorageException());
    final removed = _items.value.where((item) => item.coinId == coinId);
    if (removed.isEmpty) return const Ok(null);
    _set([..._items.value.where((item) => item.coinId != coinId)]);
    return Ok(removed.single);
  }

  @override
  Future<Result<void>> restore(WatchedCoin coin) async {
    if (failWrites) return const Err(StorageException());
    if (!ids.contains(coin.coinId)) _set([..._items.value, coin]);
    return const Ok(null);
  }

  void _set(List<WatchedCoin> items) =>
      _items.add(items..sort((a, b) => a.addedAt.compareTo(b.addedAt)));

  Future<void> dispose() => _items.close();
}
