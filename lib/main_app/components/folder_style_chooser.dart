import 'package:cfb_store/cfb_store.dart';
import 'package:flutter/material.dart';

enum FolderStyleChooserType {
  allFiles,
  groupFolder;

  static FolderStyleChooserType fromVal(String val) {
    return values.firstWhere((e) => e.name == val, orElse: () => allFiles);
  }

  int get currentIndex {
    return values.indexWhere((e) => e.name == name);
  }

  IconData get iconData {
    if (name == groupFolder.name) {
      return Icons.folder;
    }
    return Icons.picture_as_pdf_sharp;
  }
}

class FolderStyleChooser extends StatefulWidget {
  const FolderStyleChooser({super.key});

  @override
  State<FolderStyleChooser> createState() => _FolderStyleChooserState();

  static final valueNotifier = ValueNotifier<FolderStyleChooserType>(.allFiles);
  static void setValue(FolderStyleChooserType type) {
    valueNotifier.value = type;
    CFBStore.getInstance.put('FolderStyleChooserType', type.name);
    CFBStore.getInstance.writeAll();
  }

  static void init() {
    final val = CFBStore.getInstance.getString('FolderStyleChooserType');
    valueNotifier.value = .fromVal(val);
  }
}

class _FolderStyleChooserState extends State<FolderStyleChooser> {
  @override
  void initState() {
    FolderStyleChooser.init();
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    // });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: FolderStyleChooser.valueNotifier,
      builder: (context, value, child) {
        return IconButton(
          onPressed: () {
            try {
              int curIndex =
                  FolderStyleChooser.valueNotifier.value.currentIndex;
              final len = FolderStyleChooserType.values.length;
              curIndex = (curIndex + 1) % len;

              FolderStyleChooser.setValue(
                FolderStyleChooserType.values[curIndex],
              );
            } catch (e) {
              debugPrint('[_FolderStyleChooserState:IconButton]: $e');
            }
          },
          icon: Icon(value.iconData),
        );
      },
    );
  }
}
