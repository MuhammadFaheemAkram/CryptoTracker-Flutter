import 'package:crypto_tracker/core/design_system/design_system.dart';
import 'package:crypto_tracker/domain/model/app_info.dart';
import 'package:crypto_tracker/domain/model/app_theme_mode.dart';
import 'package:crypto_tracker/domain/model/tick_interval.dart';
import 'package:crypto_tracker/features/settings/cubit/settings_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';

/// The Settings tab: what prices are shown in, how often they move, how the
/// app looks, and About.
///
/// Every control writes through [SettingsCubit] and shows what the stored
/// settings say: a change made elsewhere (the Market's Pause) shows here
/// too.
class SettingsView extends StatelessWidget {
  const SettingsView({
    super.key,
    required this.appInfo,
    required this.onShowLicenses,
  });

  final AppInfo appInfo;
  final VoidCallback onShowLicenses;

  /// Shown in About, and the README says it too: nothing here is real
  /// market data.
  static const simulatedNote = 'Prices are simulated, not real market data.';

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsCubit>().state;
    final cubit = context.read<SettingsCubit>();
    final stacked = context.prefersStackedLayout;
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.only(bottom: AppSpacing.large),
        children: [
          const _Header('Currency'),
          CurrencyPicker(
            selected: settings.currency,
            onChanged: cubit.currencyChanged,
          ),
          const _Header('Updates'),
          SwitchListTile(
            title: const Text('Live prices'),
            subtitle: const Text('Turn off to freeze every price.'),
            value: !settings.livePricesPaused,
            onChanged: (live) => cubit.livePricesChanged(live: live),
          ),
          _Padded(
            label: 'Update every',
            child: SegmentedButton<TickInterval>(
              segments: [
                for (final interval in TickInterval.values)
                  ButtonSegment(
                    value: interval,
                    label: Text(intervalLabel(interval)),
                  ),
              ],
              selected: {settings.interval},
              showSelectedIcon: false,
              direction: stacked ? Axis.vertical : Axis.horizontal,
              // Choosable while paused too: resuming uses it.
              onSelectionChanged: (selection) =>
                  cubit.intervalChanged(selection.single),
            ),
          ),
          const _Header('Appearance'),
          _Padded(
            child: SegmentedButton<AppThemeMode>(
              segments: [
                for (final mode in AppThemeMode.values)
                  ButtonSegment(
                    value: mode,
                    label: Text(themeLabel(mode)),
                    icon: Icon(_themeIcon(mode)),
                  ),
              ],
              selected: {settings.themeMode},
              showSelectedIcon: false,
              direction: stacked ? Axis.vertical : Axis.horizontal,
              onSelectionChanged: (selection) =>
                  cubit.themeChanged(selection.single),
            ),
          ),
          const _Header('About'),
          ListTile(
            title: Text(appInfo.name),
            subtitle: Text(
              'Version ${appInfo.version} (${appInfo.buildNumber})',
            ),
          ),
          const ListTile(
            leading: Icon(Icons.info_outline),
            title: Text(simulatedNote),
          ),
          ListTile(
            title: const Text('Open-source licenses'),
            trailing: const Icon(Icons.chevron_right),
            onTap: onShowLicenses,
          ),
        ],
      ),
    );
  }

  static String intervalLabel(TickInterval interval) => switch (interval) {
    TickInterval.oneSecond => '1 s',
    TickInterval.twoSeconds => '2 s',
    TickInterval.fiveSeconds => '5 s',
  };

  static String themeLabel(AppThemeMode mode) => switch (mode) {
    AppThemeMode.system => 'System',
    AppThemeMode.light => 'Light',
    AppThemeMode.dark => 'Dark',
  };

  static IconData _themeIcon(AppThemeMode mode) => switch (mode) {
    AppThemeMode.system => Icons.brightness_auto_outlined,
    AppThemeMode.light => Icons.light_mode_outlined,
    AppThemeMode.dark => Icons.dark_mode_outlined,
  };
}

class _Header extends StatelessWidget {
  const _Header(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.medium,
        AppSpacing.large,
        AppSpacing.medium,
        AppSpacing.xSmall,
      ),
      child: Semantics(
        header: true,
        child: Text(
          title,
          style: theme.textTheme.titleSmall?.copyWith(
            color: theme.colorScheme.primary,
          ),
        ),
      ),
    );
  }
}

/// A control with an optional label above it, at the list's margins.
class _Padded extends StatelessWidget {
  const _Padded({required this.child, this.label});

  final Widget child;
  final String? label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final label = this.label;
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.medium,
        vertical: AppSpacing.xSmall,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (label != null) ...[
            Text(label, style: theme.textTheme.bodyLarge),
            const SizedBox(height: AppSpacing.xSmall),
          ],
          child,
        ],
      ),
    );
  }
}
