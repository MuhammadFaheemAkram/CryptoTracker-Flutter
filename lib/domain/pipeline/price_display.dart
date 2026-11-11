import 'package:crypto_tracker/domain/model/app_settings.dart';
import 'package:crypto_tracker/domain/model/currency.dart';

/// The settings a price list or a coin's page depends on: the currency to
/// show, and whether live prices are paused.
typedef PriceDisplay = ({Currency currency, bool paused});

extension PriceDisplayOf on Stream<AppSettings> {
  /// Only the settings prices depend on, and only when they change: the
  /// update interval or the theme changing never recomputes a list.
  Stream<PriceDisplay> priceDisplay() => map(
    (settings) =>
        (currency: settings.currency, paused: settings.livePricesPaused),
  ).distinct();
}
