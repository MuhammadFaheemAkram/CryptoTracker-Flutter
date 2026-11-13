import 'package:crypto_tracker/di/injection.dart';
import 'package:crypto_tracker/domain/model/app_info.dart';
import 'package:crypto_tracker/features/settings/settings_view.dart';
import 'package:material_ui/material_ui.dart';

/// The Settings tab's entry point. The [SettingsView]'s Cubit is the app's
/// own (provided above the router); the page adds what only it reads: the
/// app's name and version, and the licenses page.
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final info = getIt<AppInfo>();
    return SettingsView(
      appInfo: info,
      onShowLicenses: () => showLicensePage(
        context: context,
        applicationName: info.name,
        applicationVersion: info.version,
        applicationLegalese: SettingsView.simulatedNote,
      ),
    );
  }
}
