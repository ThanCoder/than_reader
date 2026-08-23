import 'package:flutter/material.dart';
import 'package:t_widgets/t_widgets.dart';
import 'package:than_reader/platforms/pages/fav/fav_list_page.dart';
import 'package:than_reader/platforms/pages/reader_tracker/reader_tracker_page.dart';
import 'package:than_reader/platforms/pages/search/search_page.dart';
import 'package:than_reader/platforms/desktop/desktop_list_page.dart';
import 'package:than_reader/platforms/pages/more_page.dart';

class DesktopHome extends StatefulWidget {
  const DesktopHome({super.key});

  @override
  State<DesktopHome> createState() => _DesktopHomeState();
}

class _DesktopHomeState extends State<DesktopHome> {
  @override
  Widget build(BuildContext context) {
    final col = context.colorScheme;
    return Scaffold(
      backgroundColor: col.surface,
      body: Row(
        children: [
          // nav
          _nav(),
          VerticalDivider(),
          // body
          Expanded(child: _body()),
        ],
      ),
    );
  }

  Widget _nav() {
    final col = context.colorScheme;
    return NavigationRail(
      backgroundColor: col.surfaceContainer,
      scrollable: true,

      destinations: [
        .new(icon: Icon(Icons.home), label: Text('Home')),
        .new(icon: Icon(Icons.favorite), label: Text('Favourite')),
        .new(icon: Icon(Icons.search), label: Text('Search')),
        .new(
          icon: Icon(Icons.track_changes_outlined),
          label: Text('Reader Tracker'),
        ),
        .new(icon: Icon(Icons.grid_view_rounded), label: Text('More')),
      ],
      selectedIndex: index,
      onDestinationSelected: (value) {
        setState(() {
          index = value;
        });
      },
    );
  }

  int index = 0;
  Widget _body() {
    return IndexedStack(
      index: index,
      children: [
        DesktopListPage(),
        FavListPage(),
        SearchPage(),
        ReaderTrackerPage(),
        MorePage(),
      ],
    );
  }
}
