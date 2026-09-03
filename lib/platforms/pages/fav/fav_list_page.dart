import 'package:flutter/material.dart';
import 'package:than_reader/core/controller/all_files/all_file_controller.dart';
import 'package:than_reader/core/controller/fav_controller.dart';
import 'package:than_reader/core/controller/i_controller.dart';
import 'package:than_reader/core/models/reader_file.dart';
import 'package:than_reader/platforms/components/list_style/list_style_chooser.dart';
import 'package:than_reader/platforms/components/list_style/list_style_provider.dart';
import 'package:than_reader/platforms/components/reader_grid_item.dart';
import 'package:than_reader/platforms/components/menu/item_menu.dart';
import 'package:than_reader/platforms/components/reader_list_item.dart'
    show ReaderListItem;
import 'package:than_reader/router.dart';

class FavListPage extends StatefulWidget {
  const FavListPage({super.key});

  @override
  State<FavListPage> createState() => _FavListPageState();
}

class _FavListPageState extends State<FavListPage> {
  ColorScheme get col => Theme.of(context).colorScheme;

  final favCon = ControllerManager.read<FavController>();
  final allC = ControllerManager.read<AllFileController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: col.surface,
      appBar: AppBar(
        title: Text('Favourite'),
        actions: [
          SizedBox(width: 10),

          StreamBuilder(
            stream: allC.events.whereType<AllFileControllerSortChanged>(),
            builder: (context, asyncSnapshot) {
              return ListStyleChooser();
            },
          ),
        ],
      ),
      body: _body(),
    );
  }

  Widget _body() {
    return StreamBuilder(
      stream: favCon.events.whereType<FavControllerValueChanged>(),
      builder: (context, snapshot) {
        final files = favCon.list;
        if (files.isEmpty) {
          return Center(
            child: Container(
              padding: .symmetric(vertical: 10, horizontal: 12),
              decoration: BoxDecoration(
                color: col.surfaceContainer,
                borderRadius: .circular(15),
              ),
              child: Text(
                'Favorite List Empty!',
                style: TextStyle(
                  fontWeight: .w700,
                  fontSize: 18,
                  color: col.onSurface,
                ),
              ),
            ),
          );
        }
        return Padding(
          padding: const EdgeInsets.all(4.0),
          child: CustomScrollView(
            slivers: [
              SliverPadding(
                padding: .symmetric(vertical: 10),
                sliver: _listbuilder(files),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _listbuilder(List<ReaderFile> files) {
    return ListStyleProvider(
      gridBuilder: (context) => SliverGrid.builder(
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200,
          childAspectRatio: .68,
          crossAxisSpacing: 4,
          mainAxisSpacing: 4,
        ),
        itemCount: files.length,
        itemBuilder: (context, index) => ReaderGridItem(
          file: files[index],
          onClicked: onClicked,
          onRightClicked: onRightClicked,
        ),
      ),
      listBuilder: (context) => SliverList.separated(
        itemCount: files.length,
        separatorBuilder: (context, index) => SizedBox(height: 8),
        itemBuilder: (context, index) => ReaderListItem(
          file: files[index],
          onClicked: onClicked,
          onRightClicked: onRightClicked,
        ),
      ),
    );
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
}
