import 'package:crypto_tracker/domain/model/sort_option.dart';
import 'package:material_ui/material_ui.dart';

/// The words for each [SortOption], in the menu and above the list.
extension SortOptionLabel on SortOption {
  String get label => switch (this) {
    SortOption.rank => 'Rank',
    SortOption.price => 'Price',
    SortOption.change24h => '24h change',
    SortOption.name => 'Name',
  };
}

/// The app bar's sort button: a menu of the four orders, the current one
/// checked.
class SortMenu extends StatelessWidget {
  const SortMenu({super.key, required this.selected, this.onSelected});

  final SortOption selected;

  /// `null` disables the button (nothing to sort yet).
  final ValueChanged<SortOption>? onSelected;

  @override
  Widget build(BuildContext context) {
    final onSelected = this.onSelected;
    return PopupMenuButton<SortOption>(
      tooltip: 'Sort by ${selected.label.toLowerCase()}',
      icon: const Icon(Icons.sort),
      enabled: onSelected != null,
      initialValue: selected,
      onSelected: onSelected,
      itemBuilder: (context) => [
        for (final option in SortOption.values)
          CheckedPopupMenuItem(
            value: option,
            checked: option == selected,
            child: Text(option.label),
          ),
      ],
    );
  }
}
