import 'package:flutter/material.dart';
import 'package:t_widgets/t_widgets.dart';
import 'package:than_reader/core/controller/all_files/all_file_controller.dart';
import 'package:than_reader/core/controller/i_controller.dart';
import 'package:than_reader/core/models/reader_file.dart';
import 'package:than_reader/platforms/components/menu/item_menu.dart';
import 'package:than_reader/platforms/components/reader_grid_item.dart';
import 'package:than_reader/router.dart';

class MobileHomePage extends StatefulWidget {
  const MobileHomePage({super.key});

  @override
  State<MobileHomePage> createState() => _MobileHomePageState();
}

class _MobileHomePageState extends State<MobileHomePage> {
  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  final allC = ControllerManager.read<AllFileController>();

  Future<void> init({bool useCache = true}) async {
    await allC.loadAll(useCache: useCache);
  }

  ColorScheme get col => Theme.of(context).colorScheme;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: col.surface,
      appBar: AppBar(
        title: Text('Than Reader'),
        backgroundColor: col.surfaceContainer,
        foregroundColor: col.onSurfaceVariant,
        actions: _actions(col),
      ),
      body: _body(),
    );
  }

  List<Widget> _actions(ColorScheme col) {
    return [
      StreamBuilder(
        stream: allC.events.whereType<AllFileControllerStateChanged>(),
        builder: (context, asyncSnapshot) {
          return TSortProviderButton(
            value: allC.currentSort,
            list: allC.sortList,
            onApply: (item) {
              if (item.id == allC.currentSort.id &&
                  item.isTrue == allC.currentSort.isTrue) {
                return;
              }
              allC.setSort(item);
            },
          );
        },
      ),
    ];
  }

  Widget _body() {
    return StreamBuilder(
      stream: allC.events,
      builder: (context, snapshot) {
        final isLoading = allC.state.isLoading;
        final files = allC.list;

        if (isLoading) {
          return Center(child: TLoaderRandom());
        }
        if (files.isEmpty) {
          return _refershCard();
        }
        return RefreshIndicator.adaptive(
          onRefresh: () => init(useCache: false),
          child: CustomScrollView(
            slivers: [
              SliverPadding(
                padding: .symmetric(horizontal: 10),
                sliver: SliverGrid.builder(
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
              ),
            ],
          ),
        );
      },
    );
  }

  Center _refershCard() {
    return Center(
      child: Container(
        height: 220,
        width: 220,
        padding: .all(8),
        decoration: BoxDecoration(
          color: col.surfaceContainer,
          borderRadius: .circular(15),
        ),
        child: Column(
          children: [
            Icon(Icons.file_present, size: 42, color: col.onSurfaceVariant),
            SizedBox(height: 12),
            Text(
              'No Reader Files!',
              style: TextStyle(fontWeight: .w700, color: col.onSurface),
            ),
            SizedBox(height: 5),
            Text(
              'Your Reader Files empty!',
              style: TextStyle(fontSize: 12, color: col.onSurfaceVariant),
            ),
            SizedBox(height: 15),

            RefreshButton(text: Text('Scan Again'), onClicked: init),
          ],
        ),
      ),
    );
  }

  void onClicked(ReaderFile file) async {
    await goReaderModuleApp(context, file);
    if (!mounted) return;
    setState(() {});
  }

  void onRightClicked(ReaderFile file) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) => ItemMenu(file: file),
    );
  }
}
