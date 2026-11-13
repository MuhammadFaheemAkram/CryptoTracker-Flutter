import 'package:crypto_tracker/domain/model/currency.dart';
import 'package:material_ui/material_ui.dart';

/// The currencies, one radio row each: "US dollar · USD ($)".
///
/// A radio list rather than a menu: four options fit on screen, and a
/// screen reader announces each with its state ("selected, 1 of 4").
class CurrencyPicker extends StatelessWidget {
  const CurrencyPicker({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  final Currency selected;
  final ValueChanged<Currency> onChanged;

  /// The currency's name in words.
  static String nameOf(Currency currency) => switch (currency) {
    Currency.usd => 'US dollar',
    Currency.eur => 'Euro',
    Currency.gbp => 'British pound',
    Currency.jpy => 'Japanese yen',
  };

  @override
  Widget build(BuildContext context) {
    return RadioGroup<Currency>(
      groupValue: selected,
      onChanged: (currency) {
        if (currency != null) onChanged(currency);
      },
      child: Column(
        children: [
          for (final currency in Currency.values)
            RadioListTile<Currency>(
              value: currency,
              title: Text(nameOf(currency)),
              subtitle: Text('${currency.code} (${currency.symbol})'),
            ),
        ],
      ),
    );
  }
}
