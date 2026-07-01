import 'package:flutter/material.dart';

enum FolderStyleType {
  allPdf,
  allFolder;

  static FolderStyleType fromName(String type) {
    if (type == allFolder.name) return allFolder;
    return allPdf;
  }
}

class FolderStyleButton extends StatefulWidget {
  const FolderStyleButton({super.key});

  @override
  State<FolderStyleButton> createState() => _FolderStyleButtonState();

  static final styleNotifier = ValueNotifier<FolderStyleType>(.allPdf);
}

class _FolderStyleButtonState extends State<FolderStyleButton> {
  @override
  Widget build(BuildContext context) {
    return IconButton(onPressed: () {}, icon: iconWidget);
  }

  Widget get iconWidget {
    if (FolderStyleButton.styleNotifier.value == .allFolder) {
      return Icon(Icons.folder);
    }
    return Icon(Icons.picture_as_pdf_rounded);
  }
}
