import 'package:material_ui/material_ui.dart';

/// The WCAG contrast ratio between two colors (1:1 to 21:1).
double contrast(Color a, Color b) {
  final (hi, lo) = (a.computeLuminance(), b.computeLuminance());
  return hi > lo ? (hi + 0.05) / (lo + 0.05) : (lo + 0.05) / (hi + 0.05);
}
