import 'package:crypto_tracker/core/design_system/theme/app_colors.dart';
import 'package:crypto_tracker/core/design_system/theme/app_radius.dart';
import 'package:material_ui/material_ui.dart';

/// Builds the app's Material 3 light and dark themes.
///
/// Screens style themselves through `Theme.of(context)`, never with
/// hard-coded colors, so restyling the app means changing [seedColor] and the
/// component themes here, and nothing else.
abstract final class AppTheme {
  /// An indigo: the whole palette is derived from it. Deliberately neither
  /// green nor red, which belong to prices going up and down ([AppColors]).
  static const Color seedColor = Color(0xFF4C5BD4);

  static ThemeData light() => _build(Brightness.light);

  static ThemeData dark() => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: brightness,
      // `fidelity` keeps the primary color close to the seed; the default
      // variant (`tonalSpot`) would noticeably mute it.
      dynamicSchemeVariant: DynamicSchemeVariant.fidelity,
    );
    return ThemeData(
      colorScheme: colorScheme,
      extensions: [
        if (brightness == Brightness.light) AppColors.light else AppColors.dark,
      ],
      cardTheme: const CardThemeData(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(AppRadius.medium)),
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(AppRadius.small)),
        ),
      ),
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
      ),
      // A row's icon stays level with its title when large text wraps the
      // row onto several lines, instead of drifting to the row's middle.
      listTileTheme: const ListTileThemeData(
        titleAlignment: ListTileTitleAlignment.titleHeight,
      ),
    );
  }
}
