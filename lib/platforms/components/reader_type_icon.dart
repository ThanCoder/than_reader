import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:than_reader/core/models/reader_file.dart';

class ReaderTypeIcon extends StatelessWidget {
  const ReaderTypeIcon({super.key, required this.file, this.size = 25});
  final ReaderFile file;
  final double size;

  @override
  Widget build(BuildContext context) {
    final col = Theme.of(context).colorScheme;
    return Container(
      width: size,
      height: size,
      padding: .all(3),
      decoration: BoxDecoration(
        color: col.surfaceContainer,
        borderRadius: .circular(15),
        boxShadow: [
          .new(
            blurRadius: 12,
            color: col.primary.withValues(alpha: .45),
            spreadRadius: 1,
          ),
        ],
      ),
      child: typeIcon,
    );
  }

  Widget get typeIcon {
    if (file.type == .pdf) {
      return SvgPicture.asset('assets/svg/pdf-file-svgrepo-com.svg');
    }
    return SvgPicture.asset('assets/svg/file-unknown-svgrepo-com.svg');
  }
}
