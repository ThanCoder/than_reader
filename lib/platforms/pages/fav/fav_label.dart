import 'package:flutter/material.dart';
import 'package:than_reader/core/controller/fav_controller.dart';
import 'package:than_reader/core/controller/i_controller.dart';
import 'package:than_reader/core/models/reader_file.dart';

class FavLabel extends StatefulWidget {
  const FavLabel({super.key, required this.file});
  final ReaderFile file;

  @override
  State<FavLabel> createState() => _FavLabelState();
}

class _FavLabelState extends State<FavLabel> {
  final favCon = ControllerManager.read<FavController>();
  ColorScheme get col => Theme.of(context).colorScheme;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: favCon.events.whereType<FavControllerValueChanged>(),
      builder: (context, snapshot) {
        if (!favCon.exists(widget.file)) {
          return SizedBox.shrink();
        }
        return Container(
          padding: .all(4),
          decoration: BoxDecoration(
            color: col.surfaceContainer.withValues(alpha: .45),
            borderRadius: .circular(15),
            boxShadow: [
              .new(
                color: col.surfaceContainerHighest,
                blurRadius: 12,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Icon(Icons.favorite_sharp, color: col.onSurfaceVariant),
        );
      },
    );
  }
}
