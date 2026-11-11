import 'package:material_ui/material_ui.dart';

/// "Paused": the live prices are stopped, so nothing on screen is moving.
///
/// A label rather than a button (the app bar's button resumes): it says
/// *why* the market is still, so a quiet market doesn't look broken.
class PausedChip extends StatelessWidget {
  const PausedChip({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Chip(
      avatar: Icon(Icons.pause, size: 16, color: scheme.onSecondaryContainer),
      label: const Text('Paused'),
      labelStyle: TextStyle(color: scheme.onSecondaryContainer),
      backgroundColor: scheme.secondaryContainer,
      side: BorderSide.none,
      visualDensity: VisualDensity.compact,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}
