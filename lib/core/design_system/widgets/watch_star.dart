import 'package:material_ui/material_ui.dart';

/// The watchlist star: filled when [coinName] is watched.
///
/// Its tooltip, which is also what a screen reader says, names the action
/// and the coin ("Add Bitcoin to watchlist"): in a list of fifteen stars, a
/// bare "Star" wouldn't say which coin it stars. The icon changes shape as
/// well as color, so color is never the only signal.
class WatchStar extends StatelessWidget {
  const WatchStar({
    super.key,
    required this.coinName,
    required this.isWatched,
    required this.onPressed,
  });

  final String coinName;
  final bool isWatched;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: isWatched
          ? 'Remove $coinName from watchlist'
          : 'Add $coinName to watchlist',
      icon: isWatched
          ? Icon(Icons.star, color: Theme.of(context).colorScheme.primary)
          : const Icon(Icons.star_border),
      onPressed: onPressed,
    );
  }
}
