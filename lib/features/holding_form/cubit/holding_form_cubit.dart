import 'dart:async';

import 'package:crypto_tracker/core/common/result.dart';
import 'package:crypto_tracker/core/formatting/money_formatter.dart';
import 'package:crypto_tracker/domain/model/coin.dart';
import 'package:crypto_tracker/domain/model/market_seed.dart';
import 'package:crypto_tracker/domain/usecase/load_market_use_case.dart';
import 'package:crypto_tracker/domain/usecase/observe_coin_price_use_case.dart';
import 'package:crypto_tracker/domain/usecase/portfolio_use_cases.dart';
import 'package:crypto_tracker/domain/usecase/settings_use_cases.dart';
import 'package:crypto_tracker/domain/validation/decimal_input.dart';
import 'package:crypto_tracker/features/holding_form/cubit/holding_form_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

/// Drives the holding form: a new holding (of [coinId], when it opens from a
/// coin's page) or an existing one ([holdingId]). Both are factory
/// parameters; the page passes both, one of them `null`.
///
/// Its one stream is the chosen coin, `switchMap`ped to that coin's live
/// price: "worth now" follows the market, and choosing another coin drops
/// the old coin's prices at once.
@injectable
class HoldingFormCubit extends Cubit<HoldingFormState> {
  HoldingFormCubit(
    @factoryParam this.coinId,
    @factoryParam this.holdingId,
    this._loadMarket,
    this._findHolding,
    this._addHolding,
    this._updateHolding,
    this._observePrice,
    this._currentSettings,
  ) : super(const HoldingFormState.loading());

  final String? coinId;
  final int? holdingId;
  final LoadMarketUseCase _loadMarket;
  final FindHoldingUseCase _findHolding;
  final AddHoldingUseCase _addHolding;
  final UpdateHoldingUseCase _updateHolding;
  final ObserveCoinPriceUseCase _observePrice;
  final CurrentSettingsUseCase _currentSettings;

  final _chosen = BehaviorSubject<String?>();
  final _failures = StreamController<String>.broadcast();
  StreamSubscription<double?>? _prices;

  /// Set the moment [close] starts (see `MarketCubit`).
  bool _closing = false;

  /// Why a save failed ("Couldn't save that change"): a one-off message for
  /// the view to show, not a state to keep.
  Stream<String> get failures => _failures.stream;

  HoldingForm? get _form => switch (state) {
    HoldingFormEditing(:final form) => form,
    _ => null,
  };

  /// Loads the coins (and, to edit one, the holding), then fills the form.
  /// "Try again" after a failure.
  Future<void> load() async {
    if (_prices != null) return;
    emit(const HoldingFormState.loading());
    final result = await _loadMarket();
    if (_closing) return;
    switch (result) {
      case Ok(value: final seed):
        final form = await _initialForm(seed);
        if (_closing) return;
        if (form == null) return emit(const HoldingFormState.notFound());
        emit(HoldingFormState.editing(form));
        _prices = _chosen
            .distinct()
            .switchMap(
              (id) =>
                  id == null ? Stream<double?>.value(null) : _observePrice(id),
            )
            .listen(_priceMoved);
        _chosen.add(form.coin?.id);
      case Err(:final exception):
        emit(HoldingFormState.error(exception.message));
    }
  }

  /// The form as it opens; `null` if the holding to edit doesn't exist.
  Future<HoldingForm?> _initialForm(MarketSeed seed) async {
    final currency = _currentSettings().currency;
    final rate = seed.rates.rateFor(currency);
    final empty = HoldingForm(
      coins: seed.coins,
      currency: currency,
      rate: rate,
    );
    final holdingId = this.holdingId;
    if (holdingId == null) {
      // From a coin's page, that coin; its price comes with the stream.
      final coin = _coinById(seed.coins, coinId);
      return empty.copyWith(coin: coin, initialCoinId: coin?.id);
    }
    final holding = await _findHolding(holdingId);
    final coin = _coinById(seed.coins, holding?.coinId);
    if (holding == null || coin == null) return null;
    final amount = formatDecimalInput(holding.amount);
    // Shown in the chosen currency (it's stored in dollars).
    final price = formatDecimalInput(holding.buyPriceUsd * rate);
    return empty.copyWith(
      coin: coin,
      holdingId: holdingId,
      amountText: amount,
      priceText: price,
      initialCoinId: coin.id,
      initialAmountText: amount,
      initialPriceText: price,
    );
  }

  /// The coin picker's choice (a new holding only: an existing holding's
  /// coin is fixed). A suggested buy price goes; the new coin's comes.
  void coinChosen(String id) {
    final form = _form;
    if (form == null || form.isEditing) return;
    final coin = _coinById(form.coins, id);
    if (coin == null || coin.id == form.coin?.id) return;
    emit(
      HoldingFormState.editing(
        form.copyWith(
          coin: coin,
          currentPriceUsd: null,
          priceText: form.priceIsSuggested ? '' : form.priceText,
        ),
      ),
    );
    _chosen.add(id);
  }

  void amountChanged(String text) =>
      _update((form) => form.copyWith(amountText: text));

  void priceChanged(String text) =>
      _update((form) => form.copyWith(priceText: text));

  /// Saves if every field is valid; otherwise shows every problem.
  Future<void> save() async {
    final form = _form;
    if (form == null || form.isSaving) return;
    final (coin, amount, price) = (
      form.coin,
      form.amount.value,
      form.price.value,
    );
    if (coin == null || amount == null || price == null) {
      return emit(HoldingFormState.editing(form.copyWith(submitted: true)));
    }
    emit(
      HoldingFormState.editing(form.copyWith(submitted: true, isSaving: true)),
    );
    // Typed in the chosen currency, stored in dollars (Correctness Rule 2).
    final priceUsd = price / form.rate;
    final holdingId = form.holdingId;
    final Result<Object?> result = holdingId == null
        ? await _addHolding(
            coinId: coin.id,
            amount: amount,
            buyPriceUsd: priceUsd,
          )
        : await _updateHolding(
            holdingId,
            amount: amount,
            buyPriceUsd: priceUsd,
          );
    if (_closing) return;
    final what =
        '${MoneyFormatter.coinAmount(amount)} ${coin.symbol.toUpperCase()}';
    switch (result) {
      case Ok(value: false):
        // Removed elsewhere while it was being edited.
        emit(const HoldingFormState.notFound());
      case Ok():
        emit(
          HoldingFormState.saved(
            holdingId == null
                ? 'Added $what to your portfolio'
                : 'Updated your $what',
          ),
        );
      case Err(:final exception):
        emit(HoldingFormState.editing(form.copyWith(submitted: true)));
        _failures.add(exception.message);
    }
  }

  void _priceMoved(double? priceUsd) {
    final form = _form;
    if (form == null) return;
    // A new holding's untouched buy price is the coin's price now, filled
    // in once: it doesn't change under the user while the market ticks.
    final suggest =
        !form.isEditing && form.priceText.isEmpty && priceUsd != null;
    final suggestion = suggest
        ? suggestedPriceInput(priceUsd, form.currency, form.rate)
        : form.suggestedPriceText;
    emit(
      HoldingFormState.editing(
        form.copyWith(
          currentPriceUsd: priceUsd,
          priceText: suggest ? suggestion! : form.priceText,
          suggestedPriceText: suggestion,
        ),
      ),
    );
  }

  void _update(HoldingForm Function(HoldingForm form) change) {
    final form = _form;
    if (form != null) emit(HoldingFormState.editing(change(form)));
  }

  static Coin? _coinById(List<Coin> coins, String? id) =>
      coins.where((coin) => coin.id == id).firstOrNull;

  @override
  Future<void> close() async {
    _closing = true;
    await _prices?.cancel();
    await (_chosen.close(), _failures.close()).wait;
    return super.close();
  }
}
