import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

/// The tabs, in the order of the shell's branches.
enum AppTab {
  market('Market', Icons.show_chart_outlined, Icons.show_chart),
  watchlist('Watchlist', Icons.star_outline, Icons.star),
  portfolio('Portfolio', Icons.pie_chart_outline, Icons.pie_chart),
  settings('Settings', Icons.settings_outlined, Icons.settings);

  const AppTab(this.label, this.icon, this.selectedIcon);

  final String label;
  final IconData icon;
  final IconData selectedIcon;
}

/// Hosts the bottom [NavigationBar] around the active tab.
///
/// [navigationShell] holds the tab navigators in an IndexedStack; this widget
/// only decides which branch is visible. Each tab screen brings its own
/// `Scaffold` and `AppBar`.
class MainShell extends StatelessWidget {
  const MainShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  // Every tab is a single screen (a coin and the holding form open above
  // the tabs, not inside one), so switching is all a tab needs: there is no
  // stack inside a tab for a second tap to clear.
  void _selectTab(int index) => navigationShell.goBranch(index);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      // The tab labels keep their size whatever the text setting, as the
      // platforms' own tab bars do. A long press shows the label in a
      // tooltip, and screen readers read it.
      bottomNavigationBar: MediaQuery.withNoTextScaling(
        child: NavigationBar(
          selectedIndex: navigationShell.currentIndex,
          onDestinationSelected: _selectTab,
          destinations: [
            for (final tab in AppTab.values)
              NavigationDestination(
                icon: Icon(tab.icon),
                selectedIcon: Icon(tab.selectedIcon),
                label: tab.label,
                tooltip: tab.label,
              ),
          ],
        ),
      ),
    );
  }
}
