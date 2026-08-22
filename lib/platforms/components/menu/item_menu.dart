import 'package:flutter/material.dart';
import 'package:t_widgets/t_widgets.dart';
import 'package:than_reader/core/controller/all_files/all_file_controller.dart';
import 'package:than_reader/core/controller/fav_controller.dart';
import 'package:than_reader/core/controller/i_controller.dart';
import 'package:than_reader/core/models/reader_file.dart';
import 'package:than_reader/platforms/components/dialog/confirm_alert_dialog.dart';
import 'package:than_reader/platforms/components/menu/info_menu.dart';

class ItemMenu extends StatefulWidget {
  const ItemMenu({super.key, required this.file});

  final ReaderFile file;

  @override
  State<ItemMenu> createState() => _ItemMenuState();
}

class _ItemMenuState extends State<ItemMenu> {
  ColorScheme get col => Theme.of(context).colorScheme;

  final favCon = ControllerManager.read<FavController>();
  final allCon = ControllerManager.read<AllFileController>();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          spacing: 8,
          children: [
            Text(
              'T: ${widget.file.name}',
              maxLines: 1,
              overflow: .ellipsis,
              style: TextStyle(
                fontWeight: .w700,
                fontSize: 18,
                color: col.onSurface,
              ),
            ),
            Divider(),
            infoWidget,
            favWidget,

            deleteWiget,

            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget get infoWidget {
    return ListTile(
      tileColor: col.surfaceContainer,
      shape: RoundedRectangleBorder(borderRadius: .circular(15)),
      leading: Icon(Icons.info_outline, color: col.onSurfaceVariant),
      title: Text('Info'),
      trailing: Icon(
        Icons.arrow_forward_ios_outlined,
        color: col.onSurfaceVariant.withValues(alpha: .45),
      ),
      onTap: () {
        context.pop();
        showModalBottomSheet(
          context: context,
          showDragHandle: true,
          isScrollControlled: true,
          builder: (context) => InfoMenu(file: widget.file),
        );
      },
    );
  }

  Widget get deleteWiget {
    return ListTile(
      tileColor: col.errorContainer,
      shape: RoundedRectangleBorder(borderRadius: .circular(15)),
      leading: Icon(Icons.info_outline, color: col.onErrorContainer),
      title: Text('Delete', style: TextStyle(color: col.onErrorContainer)),
      trailing: Icon(
        Icons.arrow_forward_ios_outlined,
        color: col.onSurfaceVariant.withValues(alpha: .45),
      ),
      onTap: () async {
        context.pop();
        final conf = await showConfirmDialog(
          context,
          'Want To Delete?',
          closeText: 'No!',
          confirmText: 'Delete Forever!',
          confirmColor: col.error,
          confirmForegroundColor: col.onError,
        );
        if (!conf) return;
        allCon.deleteForever(widget.file);
      },
    );
  }

  Widget get favWidget {
    return StreamBuilder(
      stream: favCon.events.whereType<FavControllerValueChanged>(),
      builder: (context, asyncSnapshot) {
        return Column(
          children: [
            if (!favCon.exists(widget.file))
              ListTile(
                shape: RoundedRectangleBorder(borderRadius: .circular(15)),
                tileColor: col.surfaceContainer,
                leading: Icon(Icons.favorite, color: col.onPrimary),
                title: Text('Add Favorite'),
                trailing: Icon(
                  Icons.add,
                  color: col.onSurfaceVariant.withValues(alpha: .45),
                ),
                onTap: () {
                  context.pop();
                  favCon.add(widget.file);
                },
              )
            else
              ListTile(
                shape: RoundedRectangleBorder(borderRadius: .circular(15)),
                tileColor: col.surfaceContainer,
                leading: Icon(Icons.favorite, color: col.onError),
                title: Text('Remove Favorite'),
                trailing: Icon(
                  Icons.remove,
                  color: col.onSurfaceVariant.withValues(alpha: .45),
                ),
                onTap: () {
                  context.pop();
                  favCon.remove(widget.file);
                },
              ),
          ],
        );
      },
    );
  }
}
