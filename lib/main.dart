import 'package:crypto_tracker/app/crypto_tracker_app.dart';
import 'package:crypto_tracker/di/injection.dart';
import 'package:material_ui/material_ui.dart';

Future<void> main() async {
  // Bindings must exist before any setup touches plugins or assets.
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  runApp(const CryptoTrackerApp());
}
