import 'package:flutter/material.dart';
import 'package:t_pdf_reader/t_pdf_reader.dart';

class PdfRenderImageTypeView extends StatelessWidget {
  const new({super.key, required this.controller, this.onTap});

  final TPdfController controller;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: controller.stream.pageRenderImageTypeChanged,
      builder: (context, asyncSnapshot) {
        return TextButton(
          onPressed: () {
            if (controller.state.renderImageType == .jpg) {
              controller.action.setRenderImageType(.png);
            } else {
              controller.action.setRenderImageType(.jpg);
            }
          },
          child: Text(controller.state.renderImageType.name.toUpperCase()),
        );
      },
    );
  }
}
