import 'package:flutter/material.dart';

import '../core/l10n/app_localizations.dart';
import '../features/movies/presentation/favorites/view/favorites_page.dart';
import '../features/movies/presentation/home/view/home_page.dart';
import '../features/movies/presentation/search/view/search_page.dart';
import '../features/settings/presentation/view/settings_page.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final pages = const [
      HomePage(),
      SearchPage(),
      FavoritesPage(),
      SettingsPage(),
    ];

    return Scaffold(
      body: pages[_index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (value) => setState(() => _index = value),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.movie_creation_outlined),
            label: l10n.home,
          ),
          NavigationDestination(
            icon: const Icon(Icons.search),
            label: l10n.search,
          ),
          NavigationDestination(
            icon: const Icon(Icons.favorite_outline),
            label: l10n.favorites,
          ),
          NavigationDestination(
            icon: const Icon(Icons.settings_outlined),
            label: l10n.settings,
          ),
        ],
      ),
    );
  }
}
