import 'package:crypto_tracker/core/common/app_exception.dart';
import 'package:crypto_tracker/core/common/result.dart';
import 'package:crypto_tracker/domain/model/holding.dart';
import 'package:crypto_tracker/domain/repository/portfolio_repository.dart';
import 'package:rxdart/rxdart.dart';

import '../fixtures.dart';

/// A [PortfolioRepository] in memory, ordered as the real query orders it.
/// With [failWrites] set, every write fails as a full disk would.
class FakePortfolioRepository implements PortfolioRepository {
  FakePortfolioRepository([List<Holding> holdings = const []])
    : _holdings = BehaviorSubject.seeded([...holdings]),
      _nextId = holdings.fold(0, (max, h) => h.id > max ? h.id : max) + 1;

  final BehaviorSubject<List<Holding>> _holdings;
  int _nextId;
  bool failWrites = false;

  /// The holdings now.
  List<Holding> get holdings => _holdings.value;

  @override
  Stream<List<Holding>> watchHoldings() => _holdings.stream;

  @override
  Future<Holding?> find(int id) async =>
      holdings.where((h) => h.id == id).firstOrNull;

  @override
  Future<Result<int>> add({
    required String coinId,
    required double amount,
    required double buyPriceUsd,
  }) async {
    if (failWrites) return const Err(StorageException());
    final id = _nextId++;
    _set([
      ...holdings,
      Holding(
        id: id,
        coinId: coinId,
        amount: amount,
        buyPriceUsd: buyPriceUsd,
        createdAt: testNow.add(Duration(minutes: id)),
      ),
    ]);
    return Ok(id);
  }

  @override
  Future<Result<bool>> update(
    int id, {
    required double amount,
    required double buyPriceUsd,
  }) async {
    if (failWrites) return const Err(StorageException());
    if (await find(id) == null) return const Ok(false);
    _set([
      for (final h in holdings)
        h.id == id ? h.copyWith(amount: amount, buyPriceUsd: buyPriceUsd) : h,
    ]);
    return const Ok(true);
  }

  @override
  Future<Result<Holding?>> remove(int id) async {
    if (failWrites) return const Err(StorageException());
    final removed = await find(id);
    if (removed != null) _set([...holdings.where((h) => h.id != id)]);
    return Ok(removed);
  }

  @override
  Future<Result<void>> restore(Holding holding) async {
    if (failWrites) return const Err(StorageException());
    _set([...holdings, holding]);
    return const Ok(null);
  }

  void _set(List<Holding> next) => _holdings.add(
    next..sort((a, b) {
      final byTime = a.createdAt.compareTo(b.createdAt);
      return byTime != 0 ? byTime : a.id.compareTo(b.id);
    }),
  );

  Future<void> dispose() => _holdings.close();
}
