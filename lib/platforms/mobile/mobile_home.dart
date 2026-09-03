import 'package:flutter/material.dart';
import 'package:t_widgets/t_widgets.dart';
import 'package:than_reader/platforms/pages/fav/fav_list_page.dart';
import 'package:than_reader/platforms/pages/reader_tracker/reader_tracker_page.dart';
import 'package:than_reader/platforms/pages/search/search_page.dart';
import 'package:than_reader/platforms/mobile/mobile_home_page.dart';
import 'package:than_reader/platforms/pages/more_page.dart';

class MobileHome extends StatefulWidget {
  const MobileHome({super.key});

  @override
  State<MobileHome> createState() => _MobileHomeState();
}

class _MobileHomeState extends State<MobileHome> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    final col = context.colorScheme;

    return Scaffold(
      body: IndexedStack(
        index: index,
        children: [
          MobileHomePage(),
          SearchPage(),
          FavListPage(),
          ReaderTrackerPage(),
          MorePage(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        backgroundColor: col.surfaceContainer,
        selectedIndex: index,
        onDestinationSelected: (value) {
          setState(() {
            index = value;
          });
        },

        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.search), label: 'Search'),
          NavigationDestination(icon: Icon(Icons.favorite), label: 'Favourite'),
          NavigationDestination(
            icon: Icon(Icons.track_changes_outlined),
            label: 'Tracker',
          ),
          NavigationDestination(
            icon: Icon(Icons.grid_view_outlined),
            label: 'More',
          ),
        ],
      ),
    );
  }
}
