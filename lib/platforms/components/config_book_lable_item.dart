import 'package:material_ui/material_ui.dart';
import 'package:than_reader/core/controller/all_files/all_file_controller.dart';
import 'package:than_reader/core/controller/i_controller.dart';
import 'package:than_reader/core/models/reader_file.dart';
import 'package:than_reader/ui/build_context_x.dart';

class ConfigBookLableItem extends StatefulWidget {
  const new({super.key, required this.file, this.size = 25});
  final ReaderFile file;
  final double size;

  @override
  State<ConfigBookLableItem> createState() => _ConfigBookLableItemState();
}

class _ConfigBookLableItemState extends State<ConfigBookLableItem> {
  final con = ControllerManager.read<AllFileController>();

  @override
  Widget build(BuildContext context) {
    final configId = widget.file.configId;

    return StreamBuilder(
      stream: con.events.whereType<AllFileControllerConfigStateChanged>(),
      builder: (context, asyncSnapshot) {
        if (!con.adultBook.contains(configId) &&
            !con.completedBook.contains(configId)) {
          return SizedBox.shrink();
        }
        return _body();
      },
    );
  }

  Widget _body() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 5,
      children: [
        if (con.adultBook.contains(widget.file.configId))
          _iconItem(Icons.explicit_outlined),
        if (con.completedBook.contains(widget.file.configId))
          _iconItem(Icons.check_circle),
      ],
    );
  }

  Widget _iconItem(IconData icon) {
    return Container(
      width: widget.size,
      height: widget.size,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: context.colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            blurRadius: 12,
            color: context.colorScheme.primary.withValues(alpha: .45),
            spreadRadius: 1,
          ),
        ],
      ),
      child: Icon(
        icon,
        size: widget.size * .65,
        color: context.colorScheme.primary,
      ),
    );
  }
}
