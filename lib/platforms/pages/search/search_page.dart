import 'dart:async';

import 'package:flutter/material.dart';
import 'package:than_reader/core/controller/all_files/all_file_controller.dart';
import 'package:than_reader/core/controller/i_controller.dart';
import 'package:than_reader/core/models/reader_file.dart';
import 'package:than_reader/platforms/components/reader_grid_item.dart';
import 'package:than_reader/platforms/components/menu/item_menu.dart';
import 'package:than_reader/router.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  ColorScheme get col => Theme.of(context).colorScheme;

  final allC = ControllerManager.read<AllFileController>();
  List<ReaderFile> result = [];
  bool searching = false;
  Timer? _searchDelay;
  FocusNode focusNode = FocusNode();
  final searchController = TextEditingController();
  StreamSubscription? _sub;

  @override
  dispose() {
    focusNode.dispose();
    searchController.dispose();
    _sub?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    _sub = allC.events.whereType<AllFileControllerDeleted>().listen((event) {
      final index = result.indexWhere((e) => e.path == event.file.path);
      if (index == -1) return;
      result.removeAt(index);
      if (!mounted) return;
      setState(() {});
    });
    super.initState();
  }

  void onChanged(String value) {
    _searchDelay?.cancel();

    if (!searching) {
      setState(() {
        searching = true;
      });
    }
    if (value.isEmpty) {
      setState(() {
        searching = false;
      });
      return;
    }
    _searchDelay = Timer(Duration(milliseconds: 1200), () => search(value));
  }

  void search(String value) {
    result = allC.list.where((e) {
      final n = e.name.toUpperCase();
      final v = value.toUpperCase();
      return n.contains(v);
    }).toList();
    setState(() {
      searching = false;
    });
  }

  void onClicked(ReaderFile file) async {
    await goReaderModuleApp(context, file);
    if (!mounted) return;
    setState(() {});
  }

  void onRightClicked(ReaderFile file) async {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) => ItemMenu(file: file),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: col.surface,
      appBar: AppBar(title: Text('Search Page')),
      body: _body(),
    );
  }

  Widget _body() {
    return CustomScrollView(
      slivers: [
        _searchWidget(),
        if (searching) SliverToBoxAdapter(child: LinearProgressIndicator()),
        if (result.isEmpty) _emptyQueryWidget(),

        if (result.isNotEmpty) SliverToBoxAdapter(child: SizedBox(height: 10)),
        if (result.isNotEmpty)
          SliverPadding(
            padding: .symmetric(horizontal: 4),
            sliver: _resultWidget(),
          ),
      ],
    );
  }

  SliverGrid _resultWidget() {
    return SliverGrid.builder(
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 220,
        childAspectRatio: .68,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
      ),
      itemCount: result.length,
      itemBuilder: (context, index) => ReaderGridItem(
        file: result[index],
        onClicked: onClicked,
        onRightClicked: onRightClicked,
      ),
    );
  }

  SliverFillRemaining _emptyQueryWidget() {
    return SliverFillRemaining(
      child: Center(
        child: Container(
          padding: .symmetric(vertical: 10, horizontal: 12),
          decoration: BoxDecoration(
            color: col.surfaceContainer,
            borderRadius: .circular(15),
          ),
          child: Text(
            'Search for something',
            style: TextStyle(
              fontWeight: .w700,
              fontSize: 18,
              color: col.onSurface,
            ),
          ),
        ),
      ),
    );
  }

  SliverToBoxAdapter _searchWidget() {
    return SliverToBoxAdapter(
      child: SearchBar(
        hintText: 'Search...',
        focusNode: focusNode,
        controller: searchController,
        onChanged: onChanged,
        trailing: [
          IconButton(
            onPressed: () {
              focusNode.unfocus();
              searchController.text = '';
              result.clear();
              setState(() {
                searching = false;
              });
            },
            icon: Icon(Icons.clear_all_outlined),
          ),
        ],
      ),
    );
  }
}
