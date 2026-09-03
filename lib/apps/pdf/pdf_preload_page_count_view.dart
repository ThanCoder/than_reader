import 'package:flutter/material.dart';
import 'package:t_pdf_reader/t_pdf_reader.dart';

class PdfPreloadPageCountView extends StatelessWidget {
  const new({super.key, required this.controller, this.onTap});

  final TPdfController controller;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: controller.stream.preloadPageCountChanged,
      builder: (context, asyncSnapshot) {
        return TextButton(
          onPressed: () {
            if (controller.state.preloadPageCount == 2) {
              controller.action.setPreloadPageCount(0);
            } else if (controller.state.preloadPageCount == 1) {
              controller.action.setPreloadPageCount(2);
            } else if (controller.state.preloadPageCount == 0) {
              controller.action.setPreloadPageCount(1);
            }
          },
          child: Text('Preload: ${controller.state.preloadPageCount}'),
        );
      },
    );
  }
}
