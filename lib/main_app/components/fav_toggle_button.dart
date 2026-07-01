import 'package:flutter/material.dart';
import 'package:than_reader/core/models/pdf_file.dart';
import 'package:than_reader/core/state/pdf_fav_controller.dart';

class FavToggleButton extends StatelessWidget {
  final PdfFile file;
  const FavToggleButton({super.key, required this.file});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: PdfFavController().stateStream,
      initialData: PdfFavController().state,
      builder: (context, snapshot) {
        final exists = PdfFavController().isExists(file);
        return IconButton(
          onPressed: () {
            if (exists) {
              PdfFavController().remove(file);
            } else {
              PdfFavController().add(file);
            }
          },
          icon: exists ? Icon(Icons.favorite) : Icon(Icons.favorite_border),
        );
      },
    );
  }
}
