import 'package:crypto_tracker/core/common/result.dart';
import 'package:crypto_tracker/domain/model/holding.dart';

/// The user's holdings, stored on the device and observed live.
abstract interface class PortfolioRepository {
  /// Every holding, oldest first: the current list at once, then after
  /// every change.
  Stream<List<Holding>> watchHoldings();

  /// One holding (the edit form); `null` if there's none with [id].
  Future<Holding?> find(int id);

  /// A new holding; `Ok` carries its id.
  Future<Result<int>> add({
    required String coinId,
    required double amount,
    required double buyPriceUsd,
  });

  /// Changes a holding's amount and buy price. `Ok(false)` if it no longer
  /// exists (removed elsewhere meanwhile).
  Future<Result<bool>> update(
    int id, {
    required double amount,
    required double buyPriceUsd,
  });

  /// Removes a holding. `Ok` carries what was removed, for Undo (`null` if
  /// there was none).
  Future<Result<Holding?>> remove(int id);

  /// Undo: puts [holding] back with the same id, in the same place.
  Future<Result<void>> restore(Holding holding);
}
