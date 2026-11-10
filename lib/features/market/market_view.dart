import 'package:crypto_tracker/core/design_system/design_system.dart';
import 'package:crypto_tracker/core/formatting/money_formatter.dart';
import 'package:crypto_tracker/domain/model/currency.dart';
import 'package:crypto_tracker/domain/model/market_coin.dart';
import 'package:crypto_tracker/domain/model/sort_option.dart';
import 'package:crypto_tracker/features/market/cubit/market_cubit.dart';
import 'package:crypto_tracker/features/market/cubit/market_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';

/// Renders [MarketState] and forwards the user's intents to [MarketCubit].
///
/// It knows nothing about routes: opening a coin is [onOpenCoin], wired by
/// the page. Widget tests pump it with a mocked Cubit, one state per test.
class MarketView extends StatelessWidget {
  const MarketView({super.key, required this.onOpenCoin});

  final ValueChanged<String> onOpenCoin;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<MarketCubit>().state;
    final cubit = context.read<MarketCubit>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Market'),
        actions: [
          switch (state) {
            MarketReady(:final sort) => SortMenu(
              selected: sort,
              onSelected: cubit.sortChanged,
            ),
            _ => const SortMenu(selected: SortOption.rank),
          },
        ],
      ),
      body: switch (state) {
        MarketLoading() => const LoadingView(message: 'Loading the market…'),
        MarketError(:final message) => ErrorView(
          message: message,
          onRetry: cubit.load,
        ),
        MarketReady() => _MarketList(state: state, onOpenCoin: onOpenCoin),
      },
    );
  }
}

/// The search field, a line saying what's shown, and the rows.
class _MarketList extends StatefulWidget {
  const _MarketList({required this.state, required this.onOpenCoin});

  final MarketReady state;
  final ValueChanged<String> onOpenCoin;

  @override
  State<_MarketList> createState() => _MarketListState();
}

class _MarketListState extends State<_MarketList> {
  // Owned here, so it survives every new state (each keystroke is one) and
  // the field keeps its text and cursor.
  late final _search = TextEditingController(text: widget.state.query);

  // Phase 2 prices are in US dollars. Phase 3 formats in the user's
  // currency, at its rate.
  static final _money = MoneyFormatter(Currency.usd);

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<MarketCubit>();
    final MarketReady(:rows, :query, :sort) = widget.state;
    final theme = Theme.of(context);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.medium,
            AppSpacing.xSmall,
            AppSpacing.medium,
            AppSpacing.xSmall,
          ),
          child: AppSearchField(
            controller: _search,
            hintText: 'Search coins',
            onChanged: cubit.queryChanged,
            onCleared: () => cubit.queryChanged(''),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.medium),
          child: Align(
            alignment: AlignmentDirectional.centerStart,
            // Read out when it changes while searching, so a screen-reader
            // user hears how many coins match without leaving the field.
            child: Semantics(
              liveRegion: query.trim().isNotEmpty,
              child: Text(
                _summary(rows.length, query, sort.label),
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: rows.isEmpty
              ? EmptyStateView(
                  icon: Icons.search_off,
                  title: 'No coins match “${query.trim()}”',
                  message: 'Try a name like “Bitcoin” or a symbol like “BTC”.',
                )
              : ListView.builder(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  itemCount: rows.length,
                  itemBuilder: (context, index) => _row(rows[index]),
                ),
        ),
      ],
    );
  }

  Widget _row(MarketCoin row) {
    final MarketCoin(:coin, :quote) = row;
    return CoinRow(
      // Keyed by coin, so a re-sort moves rows instead of rebuilding them.
      key: ValueKey(coin.id),
      rank: coin.rank,
      symbol: coin.symbol,
      name: coin.name,
      price: _money.price(quote.priceUsd),
      change24hPercent: quote.change24hPercent,
      sparkline: coin.sparkline7d,
      onTap: () => widget.onOpenCoin(coin.id),
    );
  }

  static String _summary(int count, String query, String sortLabel) {
    final noun = query.trim().isEmpty
        ? (count == 1 ? 'coin' : 'coins')
        : (count == 1 ? 'match' : 'matches');
    return '$count $noun · by ${sortLabel.toLowerCase()}';
  }
}
