import 'package:crypto_tracker/core/common/result.dart';
import 'package:crypto_tracker/domain/model/holding.dart';
import 'package:crypto_tracker/domain/repository/portfolio_repository.dart';
import 'package:injectable/injectable.dart';

/// One holding, for the edit form.
@injectable
class FindHoldingUseCase {
  const FindHoldingUseCase(this._portfolio);

  final PortfolioRepository _portfolio;

  Future<Holding?> call(int id) => _portfolio.find(id);
}

/// A new holding (the form, from the Portfolio or a coin's page).
@injectable
class AddHoldingUseCase {
  const AddHoldingUseCase(this._portfolio);

  final PortfolioRepository _portfolio;

  Future<Result<int>> call({
    required String coinId,
    required double amount,
    required double buyPriceUsd,
  }) =>
      _portfolio.add(coinId: coinId, amount: amount, buyPriceUsd: buyPriceUsd);
}

/// An edited holding: its amount and buy price.
@injectable
class UpdateHoldingUseCase {
  const UpdateHoldingUseCase(this._portfolio);

  final PortfolioRepository _portfolio;

  Future<Result<bool>> call(
    int id, {
    required double amount,
    required double buyPriceUsd,
  }) => _portfolio.update(id, amount: amount, buyPriceUsd: buyPriceUsd);
}

/// Removes a holding, keeping what Undo needs.
@injectable
class RemoveHoldingUseCase {
  const RemoveHoldingUseCase(this._portfolio);

  final PortfolioRepository _portfolio;

  Future<Result<Holding?>> call(int id) => _portfolio.remove(id);
}

/// Undo: the removed holding again, with its id.
@injectable
class RestoreHoldingUseCase {
  const RestoreHoldingUseCase(this._portfolio);

  final PortfolioRepository _portfolio;

  Future<Result<void>> call(Holding holding) => _portfolio.restore(holding);
}
