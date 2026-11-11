import 'package:crypto_tracker/domain/model/app_settings.dart';
import 'package:crypto_tracker/domain/model/app_theme_mode.dart';
import 'package:crypto_tracker/domain/model/currency.dart';
import 'package:crypto_tracker/domain/model/tick_interval.dart';
import 'package:crypto_tracker/domain/pipeline/price_display.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('only a change of currency or pause comes through', () {
    const start = AppSettings();
    final settings = Stream.fromIterable([
      start,
      start.copyWith(themeMode: AppThemeMode.dark),
      start.copyWith(
        themeMode: AppThemeMode.dark,
        interval: TickInterval.values.last,
      ),
      start.copyWith(currency: Currency.eur),
      start.copyWith(currency: Currency.eur, livePricesPaused: true),
    ]);

    expect(
      settings.priceDisplay(),
      emitsInOrder([
        (currency: Currency.usd, paused: false),
        (currency: Currency.eur, paused: false),
        (currency: Currency.eur, paused: true),
        emitsDone,
      ]),
    );
  });
}
