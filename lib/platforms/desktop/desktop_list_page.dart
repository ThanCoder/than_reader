import 'package:flutter/material.dart';
import 'package:t_widgets/t_widgets.dart';
import 'package:than_reader/core/controller/all_files/all_file_controller.dart';
import 'package:than_reader/core/controller/i_controller.dart';
import 'package:than_reader/core/models/reader_file.dart';
import 'package:than_reader/platforms/components/desktop_grid_item.dart';
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
    final col = context.colorScheme;
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
          color: col.tertiaryContainer,
        ),
        child: IconButton(
          color: col.primary,
          onPressed: () => init(useCache: false),
          icon: Icon(Icons.refresh, color: col.onTertiaryContainer),
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
        return Padding(
          padding: const EdgeInsets.all(4.0),
          child: CustomScrollView(
            slivers: [
              SliverGrid.builder(
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 220,
                  childAspectRatio: .68,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: files.length,
                itemBuilder: (context, index) =>
                    DesktopGridItem(file: files[index], onClicked: onClicked),
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
}
