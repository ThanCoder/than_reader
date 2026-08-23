import 'package:flutter/material.dart';
import 'package:than_reader/core/controller/fav_controller.dart';
import 'package:than_reader/core/controller/i_controller.dart';
import 'package:than_reader/core/models/reader_file.dart';
import 'package:than_reader/platforms/components/reader_grid_item.dart';
import 'package:than_reader/platforms/components/menu/item_menu.dart';
import 'package:than_reader/router.dart';

class FavListPage extends StatefulWidget {
  const FavListPage({super.key});

  @override
  State<FavListPage> createState() => _FavListPageState();
}

class _FavListPageState extends State<FavListPage> {
  ColorScheme get col => Theme.of(context).colorScheme;

  final favCon = ControllerManager.read<FavController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Favourite')),
      body: _body(),
    );
  }

  Widget _body() {
    return StreamBuilder(
      stream: favCon.events.whereType<FavControllerValueChanged>(),
      builder: (context, snapshot) {
        final files = favCon.list;
        return Padding(
          padding: const EdgeInsets.all(4.0),
          child: CustomScrollView(
            slivers: [
              SliverPadding(
                padding: .symmetric(vertical: 10),
                sliver: SliverGrid.builder(
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 220,
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
              ),
            ],
          ),
        );
      },
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
