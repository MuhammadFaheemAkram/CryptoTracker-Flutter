import 'package:crypto_tracker/core/design_system/design_system.dart';
import 'package:crypto_tracker/domain/model/coin.dart';
import 'package:crypto_tracker/domain/pipeline/market_rows.dart';
import 'package:material_ui/material_ui.dart';

/// Opens a searchable list of [coins] in a sheet; the id of the one picked,
/// or `null` if the sheet was dismissed.
Future<String?> showCoinPicker(
  BuildContext context, {
  required List<Coin> coins,
  String? selectedId,
}) => showModalBottomSheet<String>(
  context: context,
  isScrollControlled: true,
  useSafeArea: true,
  showDragHandle: true,
  builder: (context) => FractionallySizedBox(
    heightFactor: 0.9,
    child: CoinPicker(coins: coins, selectedId: selectedId),
  ),
);

/// The coins, filtered as the user types (by name or symbol, as the Market
/// searches: `matchesQuery`). Thirty-two coins need no debounce.
class CoinPicker extends StatefulWidget {
  const CoinPicker({super.key, required this.coins, this.selectedId});

  final List<Coin> coins;
  final String? selectedId;

  @override
  State<CoinPicker> createState() => _CoinPickerState();
}

class _CoinPickerState extends State<CoinPicker> {
  final _search = TextEditingController();
  var _query = '';

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final coins = [
      for (final coin in widget.coins)
        if (matchesQuery(coin, _query)) coin,
    ];
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.medium),
          child: Semantics(
            header: true,
            child: Text('Choose a coin', style: theme.textTheme.titleLarge),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(AppSpacing.medium),
          child: AppSearchField(
            controller: _search,
            hintText: 'Search coins',
            onChanged: (query) => setState(() => _query = query),
            onCleared: () => setState(() => _query = ''),
          ),
        ),
        Expanded(
          child: coins.isEmpty
              ? EmptyStateView(
                  icon: Icons.search_off,
                  title: 'No coins match “${_query.trim()}”',
                )
              : ListView.builder(
                  itemCount: coins.length,
                  itemBuilder: (context, index) {
                    final coin = coins[index];
                    final selected = coin.id == widget.selectedId;
                    return ListTile(
                      leading: CoinBadge(symbol: coin.symbol),
                      title: Text(coin.name),
                      subtitle: Text(coin.symbol.toUpperCase()),
                      trailing: selected ? const Icon(Icons.check) : null,
                      selected: selected,
                      onTap: () => Navigator.of(context).pop(coin.id),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
