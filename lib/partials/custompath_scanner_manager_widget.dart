import 'package:cfb_store/cfb_store.dart';
import 'package:flutter/material.dart';
import 'package:t_widgets/t_widgets.dart';

class CustompathScannerManagerWidget extends StatefulWidget {
  const CustompathScannerManagerWidget({super.key});

  @override
  State<CustompathScannerManagerWidget> createState() =>
      _CustompathScannerManagerWidgetState();

  static List<String> get customPathList {
    // CFLite.getInstance().getList<String>('custom_scan_path_list', def: []);
    final list = CFBStore.getInstance.getList('custom_scan_path_list');
    return List<String>.from(list);
  }

  static void setCustomPathList(List<String> list) async {
    // await CFLite.getInstance().put<List<String>>('custom_scan_path_list', list);
    CFBStore.getInstance.put('custom_scan_path_list', list);
    await CFBStore.getInstance.writeAll();
  }
}

class _CustompathScannerManagerWidgetState
    extends State<CustompathScannerManagerWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text('Custom Path'),
        Expanded(
          child: ExpansionTile(
            title: Text('Scan Path List'),
            children: [
              ...listWidget,

              IconButton(
                onPressed: showScanPathDialog,
                icon: Icon(Icons.add_circle, color: Colors.green),
              ),
            ],
          ),
        ),
      ],
    );
  }

  List<Widget> get listWidget {
    return CustompathScannerManagerWidget.customPathList
        .map(
          (e) => ListTile(
            title: Text(e),
            trailing: IconButton(
              onPressed: () => deleteConfirm(e),
              icon: Icon(Icons.delete, color: Colors.red),
            ),
          ),
        )
        .toList();
  }

  void deleteConfirm(String path) {
    showTConfirmDialog(
      context,
      contentText: 'ဖျက်ချင်တာသေချာပီလား?',
      submitText: 'Delete Forever',
      onSubmit: () {
        final list = CustompathScannerManagerWidget.customPathList.toList();
        final index = list.indexWhere((e) => e == path);
        if (index == -1) return;
        list.removeAt(index);
        CustompathScannerManagerWidget.setCustomPathList(list);
        setState(() {});
      },
    );
  }

  void showScanPathDialog() {
    showTReanmeDialog(
      context,
      text: '',
      labelText: Text("Folder Path"),
      submitText: 'Add Path',
      onSubmit: (text) {
        if (text.isEmpty) return;
        final list = CustompathScannerManagerWidget.customPathList.toList();
        list.add(text);
        CustompathScannerManagerWidget.setCustomPathList(list);
        setState(() {});
      },
    );
  }
}
