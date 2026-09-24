import 'package:dart_core_extensions/dart_core_extensions.dart';
import 'package:flutter/material.dart';

class PdfImageCacheConfigWidget extends StatefulWidget {
  const new({
    super.key,
    required this.maxCount,
    required this.maxSizeBytes,
    required this.onMaxCountChanged,
    required this.onMaxSizeBytesChanged,
  });
  final int maxCount;
  final int maxSizeBytes;
  final void Function(int val) onMaxCountChanged;
  final void Function(int val) onMaxSizeBytesChanged;

  @override
  State<PdfImageCacheConfigWidget> createState() =>
      _PdfImageCacheConfigWidgetState();
}

class _PdfImageCacheConfigWidgetState extends State<PdfImageCacheConfigWidget> {
  final pow = 1024 * 1024;
  late int maxCount;
  late int maxSizeBytes;

  @override
  void initState() {
    maxCount = widget.maxCount;
    maxSizeBytes = widget.maxSizeBytes;
    super.initState();
  }

  int getSize(int mb) {
    return (mb * pow);
  }

  final maxCountList = [5, 30, 50, 100, 200, 300, 400, 500]
      .map(
        (e) => DropdownMenuItem<int>(
          value: e,
          child: Row(
            spacing: 5,
            children: [
              Text('$e', style: TextStyle(fontSize: 18, fontWeight: .w700)),
              Text('Max Count'),
            ],
          ),
        ),
      )
      .toList();

  late final maxSizeBytesList = [1, 3, 5, 10, 15, 20, 30, 50, 100]
      .map((n) => getSize(n))
      .map(
        (e) => DropdownMenuItem<int>(
          value: e,
          child: Row(
            spacing: 5,
            children: [
              Text(
                e.fileSizeLabel(asFixed: 0),
                style: TextStyle(fontSize: 18, fontWeight: .w700),
              ),
              Text('Max Size'),
            ],
          ),
        ),
      )
      .toList();
  ColorScheme get col => Theme.of(context).colorScheme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: .start,
        spacing: 10,
        children: [
          Text(
            'Page Image Cache',
            style: TextStyle(fontSize: 20, fontWeight: .w700),
          ),
          _maxCountWidget(),
          _maxSizeBytesWidget(),
        ],
      ),
    );
  }

  Container _maxCountWidget() {
    return Container(
      padding: .symmetric(vertical: 10, horizontal: 15),
      decoration: BoxDecoration(
        border: .all(color: col.outlineVariant),
        color: col.surfaceContainer,
        borderRadius: .circular(15),
      ),
      child: Row(
        children: [
          Text('Max Count', style: TextStyle(fontSize: 17, fontWeight: .w600)),
          Spacer(),
          DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              padding: .symmetric(vertical: 10, horizontal: 15),
              borderRadius: .circular(14),
              value: maxCount,
              items: maxCountList,
              onChanged: (value) {
                maxCount = value!;
                setState(() {});
                widget.onMaxCountChanged(value);
              },
            ),
          ),
        ],
      ),
    );
  }

  Container _maxSizeBytesWidget() {
    return Container(
      padding: .symmetric(vertical: 5, horizontal: 10),
      decoration: BoxDecoration(
        border: .all(color: col.outlineVariant),
        color: col.surfaceContainer,
        borderRadius: .circular(15),
      ),
      child: Row(
        children: [
          Text(
            'Max Size Bytes',
            style: TextStyle(fontSize: 17, fontWeight: .w600),
          ),
          Spacer(),
          DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              padding: .symmetric(vertical: 4, horizontal: 6),
              borderRadius: .circular(14),
              value: maxSizeBytes,
              items: maxSizeBytesList,
              onChanged: (value) {
                maxSizeBytes = value!;
                setState(() {});
                widget.onMaxSizeBytesChanged(value);
              },
            ),
          ),
        ],
      ),
    );
  }
}
