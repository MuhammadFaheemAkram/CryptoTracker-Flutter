import 'package:crypto_tracker/domain/model/coin.dart';
import 'package:crypto_tracker/domain/model/currency.dart';
import 'package:crypto_tracker/domain/validation/decimal_input.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'holding_form_state.freezed.dart';

/// What the holding form shows.
@freezed
sealed class HoldingFormState with _$HoldingFormState {
  /// The market's seed (the coins to pick from) or the holding is on its
  /// way.
  const factory HoldingFormState.loading() = HoldingFormLoading;

  /// The market couldn't be loaded; the view offers "Try again".
  const factory HoldingFormState.error(String message) = HoldingFormError;

  /// The holding to edit doesn't exist (removed, or a mistyped link).
  const factory HoldingFormState.notFound() = HoldingFormNotFound;

  /// The form, as the user is filling it.
  const factory HoldingFormState.editing(HoldingForm form) = HoldingFormEditing;

  /// Saved: the page closes, and says so ([message]).
  const factory HoldingFormState.saved(String message) = HoldingFormSaved;
}

/// The form's fields, what they hold now and what they held at the start.
@freezed
abstract class HoldingForm with _$HoldingForm {
  const factory HoldingForm({
    /// The coins to pick from, in rank order.
    required List<Coin> coins,

    /// The chosen coin; `null` until one is picked.
    Coin? coin,

    /// The holding being edited; `null` for a new one (its coin is then
    /// fixed).
    int? holdingId,

    /// Exactly what's typed.
    @Default('') String amountText,
    @Default('') String priceText,

    /// The currency the buy price is typed in, and its rate per dollar.
    required Currency currency,
    required double rate,

    /// The coin's price now, in dollars (live; the "worth now" preview).
    double? currentPriceUsd,

    /// What the form started with: changes to these ask before discarding.
    String? initialCoinId,
    @Default('') String initialAmountText,
    @Default('') String initialPriceText,

    /// The buy price the form filled in itself (a new holding's coin, at
    /// its price then). Not the user's change; replaced if the coin is.
    String? suggestedPriceText,

    /// Save was tapped: every problem shows now, an empty field included.
    @Default(false) bool submitted,
    @Default(false) bool isSaving,
  }) = _HoldingForm;

  const HoldingForm._();

  bool get isEditing => holdingId != null;

  ({double? value, DecimalInputError? error}) get amount =>
      parseDecimalInput(amountText);

  ({double? value, DecimalInputError? error}) get price =>
      parseDecimalInput(priceText);

  /// The amount's problem, if it should show: always after Save; while
  /// typing, only for something typed (an empty field isn't an error yet).
  DecimalInputError? get amountError => _shown(amount.error, amountText);

  DecimalInputError? get priceError => _shown(price.error, priceText);

  /// "Choose a coin", after Save without one.
  bool get coinMissing => submitted && coin == null;

  DecimalInputError? _shown(DecimalInputError? error, String text) =>
      submitted || (error != null && error != DecimalInputError.empty)
      ? error
      : null;

  /// Whether the buy price is the form's own suggestion, untouched.
  bool get priceIsSuggested =>
      priceText.isEmpty || priceText == suggestedPriceText;

  /// Anything to lose: the user changed something since the form opened (a
  /// suggested price isn't a change).
  bool get isDirty =>
      coin?.id != initialCoinId ||
      amountText != initialAmountText ||
      (priceText != initialPriceText && priceText != suggestedPriceText);

  bool get isValid =>
      coin != null && amount.value != null && price.value != null;

  /// The amount × the coin's price now, in dollars; `null` until both are
  /// known.
  double? get worthNowUsd => switch ((amount.value, currentPriceUsd)) {
    (final amount?, final price?) => amount * price,
    _ => null,
  };

  /// The amount × the typed buy price, in dollars.
  double? get costUsd => switch ((amount.value, price.value)) {
    (final amount?, final price?) => amount * price / rate,
    _ => null,
  };
}
