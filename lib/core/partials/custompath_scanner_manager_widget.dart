import 'package:cf_lite/cf_lite.dart';
import 'package:flutter/material.dart';
import 'package:t_widgets/t_widgets.dart';

class CustompathScannerManagerWidget extends StatefulWidget {
  const CustompathScannerManagerWidget({super.key});

  @override
  State<CustompathScannerManagerWidget> createState() =>
      _CustompathScannerManagerWidgetState();

  static List<String> get customPathList =>
      CFLite.getInstance().getList<String>('custom_scan_path_list', def: []);

  static void setCustomPathList(List<String> list) {
    CFLite.getInstance().put('custom_scan_path_list', list);
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
