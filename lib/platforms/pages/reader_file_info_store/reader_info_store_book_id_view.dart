import 'package:flutter/material.dart';
import 'package:than_reader/core/models/reader_file.dart';
import 'package:than_reader/platforms/pages/reader_file_info_store/reader_info_store.dart';

class ReaderInfoStoreBookIdView extends StatefulWidget {
  const new({super.key, required this.book});
  final ReaderFile book;

  @override
  State<ReaderInfoStoreBookIdView> createState() =>
      _ReaderInfoStoreBookIdViewState();
}

class _ReaderInfoStoreBookIdViewState extends State<ReaderInfoStoreBookIdView> {
  final store = ReaderInfoStore.instance.store;
  final infoBox = ReaderInfoStore.instance.infoBox;
  ColorScheme get col => Theme.of(context).colorScheme;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: infoBox.events.update,
      builder: (context, asyncSnapshot) {
        return StreamBuilder(
          stream: infoBox.events.add,
          builder: (context, asyncSnapshot) {
            return FutureBuilder(
              future: ReaderInfoStore.instance.infoExistsByid(
                widget.book.configId,
              ),
              builder: (context, snapshot) {
                final ok = snapshot.data ?? false;
                if (ok) {
                  return SizedBox(
                    width: 30,
                    height: 30,
                    child: Container(
                      decoration: BoxDecoration(
                        color: col.primary,
                        borderRadius: .circular(15),
                      ),
                      child: Icon(Icons.info_outline, color: col.onPrimary),
                    ),
                  );
                }
                return SizedBox.shrink();
              },
            );
          },
        );
      },
    );
  }
}
