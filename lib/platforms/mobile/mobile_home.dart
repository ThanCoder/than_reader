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
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: col.surfaceContainer,
        selectedItemColor: col.primary,
        unselectedItemColor: col.onSurfaceVariant,
        // showSelectedLabels: false,
        // showUnselectedLabels: false,
        currentIndex: index,
        onTap: (value) {
          setState(() {
            index = value;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favourite',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.track_changes_outlined),
            label: 'Reader Tracker',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_view_outlined),
            label: 'More',
          ),
        ],
      ),
    );
  }
}
