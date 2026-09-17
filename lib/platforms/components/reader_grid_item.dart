import 'package:flutter/material.dart';
import 'package:than_reader/const_keys.dart';
import 'package:than_reader/core/models/reader_file.dart';
import 'package:than_reader/core/utils/app_utils.dart';
import 'package:than_reader/platforms/components/reader_type_icon.dart';
import 'package:than_reader/platforms/pages/fav/fav_label.dart';
import 'package:than_reader/platforms/components/reader_cover_file.dart';

class ReaderGridItem extends StatelessWidget {
  const ReaderGridItem({
    super.key,
    required this.file,
    required this.onClicked,
    this.onRightClicked,
  });
  final ReaderFile file;
  final void Function(ReaderFile file) onClicked;
  final void Function(ReaderFile file)? onRightClicked;

  @override
  Widget build(BuildContext context) {
    final col = Theme.of(context).colorScheme;
    return InkWell(
      mouseCursor: SystemMouseCursors.click,
      borderRadius: .circular(15),
      onTap: () {
        AppUtils.instance.recentConfig.put(
          appListClickedReaderFileRecentIdKey,
          file.configId,
        );
        onClicked(file);
      },
      onSecondaryTap: () {
        AppUtils.instance.recentConfig.put(
          appListClickedReaderFileRecentIdKey,
          file.configId,
        );
        onRightClicked?.call(file);
      },
      onLongPress: () {
        AppUtils.instance.recentConfig.put(
          appListClickedReaderFileRecentIdKey,
          file.configId,
        );
        onRightClicked?.call(file);
      },
      child: StreamBuilder(
        stream: AppUtils.instance.recentConfig.stream.put.where(
          (e) => e.key == appListClickedReaderFileRecentIdKey,
        ),
        builder: (context, asyncSnapshot) {
          final lastId = AppUtils.instance.recentConfig.getString(
            appListClickedReaderFileRecentIdKey,
          );
          return Container(
            padding: .all(8),
            decoration: BoxDecoration(
              borderRadius: .circular(15),
              color: lastId == file.configId
                  ? col.primaryContainer
                  : col.surfaceContainer,
            ),
            child: Stack(
              children: [
                Positioned.fill(child: ReaderCoverFile(file: file)),
                Positioned(left: 0, top: 0, child: FavLabel(file: file)),
                Positioned(right: 0, top: 0, child: ReaderTypeIcon(file: file)),
                Positioned(left: 0, right: 0, bottom: 0, child: _content(col)),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _content(ColorScheme col) {
    return Container(
      padding: .symmetric(vertical: 5, horizontal: 8),
      decoration: BoxDecoration(
        color: col.surfaceContainer.withValues(alpha: .65),
      ),
      child: Text(
        file.name,
        maxLines: 2,
        overflow: .ellipsis,
        textAlign: .center,
        style: TextStyle(color: col.onSurface, fontSize: 14, fontWeight: .w600),
      ),
    );
  }
}
