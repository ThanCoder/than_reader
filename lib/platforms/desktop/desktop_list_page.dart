import 'package:flutter/material.dart';
import 'package:t_widgets/t_widgets.dart';
import 'package:than_reader/core/controller/all_files/all_file_controller.dart';
import 'package:than_reader/core/controller/i_controller.dart';
import 'package:than_reader/core/models/reader_file.dart';
import 'package:than_reader/platforms/components/list_style/list_style_chooser.dart';
import 'package:than_reader/platforms/components/list_style/list_style_provider.dart';
import 'package:than_reader/platforms/components/reader_grid_item.dart';
import 'package:than_reader/platforms/components/menu/item_menu.dart';
import 'package:than_reader/platforms/components/reader_list_item.dart';
import 'package:than_reader/router.dart';

class DesktopListPage extends StatefulWidget {
  const DesktopListPage({super.key});

  @override
  State<DesktopListPage> createState() => _DesktopListPageState();
}

class _DesktopListPageState extends State<DesktopListPage> {
  @override
  void initState() {
    super.initState();
    init();
  }

  final allC = ControllerManager.read<AllFileController>();

  Future<void> init({bool useCache = true}) async {
    await allC.loadAll(useCache: useCache);
  }

  @override
  Widget build(BuildContext context) {
    final col = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: col.surface,
      appBar: AppBar(
        title: Text('Than Reader Desktop'),
        backgroundColor: col.surfaceContainer,
        foregroundColor: col.onSurfaceVariant,
        actions: _actions(col),
      ),
      body: _body(),
    );
  }

  List<Widget> _actions(ColorScheme col) {
    return [
      Container(
        decoration: BoxDecoration(
          borderRadius: .circular(15),
          color: col.surfaceContainerHighest,
        ),
        child: IconButton(
          color: col.primary,
          onPressed: () => init(useCache: false),
          icon: Icon(Icons.refresh, color: col.onSurface),
        ),
      ),
      SizedBox(width: 10),
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
      SizedBox(width: 10),

      StreamBuilder(
        stream: allC.events.whereType<AllFileControllerSortChanged>(),
        builder: (context, asyncSnapshot) {
          return ListStyleChooser();
        },
      ),

      SizedBox(width: 10),
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
        return CustomScrollView(
          slivers: [
            SliverPadding(
              padding: .symmetric(vertical: 10, horizontal: 10),
              sliver: _listbuilder(files),
            ),
          ],
        );
      },
    );
  }

  Widget _listbuilder(List<ReaderFile> files) {
    return ListStyleProvider(
      gridBuilder: (context) => SliverGrid.builder(
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
