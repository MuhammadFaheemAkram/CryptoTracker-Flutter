import 'package:crypto_tracker/app/crypto_tracker_app.dart';
import 'package:crypto_tracker/di/injection.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  // Bindings must exist before any setup touches plugins or assets.
  WidgetsFlutterBinding.ensureInitialized();
  configureDependencies();
  runApp(const CryptoTrackerApp());
}
