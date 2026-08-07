import 'package:flutter/material.dart';
import 'package:than_reader/core/models/reader_file.dart';
import 'package:than_reader/main_app/components/pdf_grid_item.dart';

class HomePageCardList extends StatelessWidget {
  final List<ReaderFile> files;
  final int maxShowCount;
  final double itemHeight;
  final double itemWidth;
  final Widget title;
  final void Function()? onShowAllClicked;
  final void Function(ReaderFile file)? onItemClicked;
  final void Function(ReaderFile file)? onItemMenuClicked;
  const HomePageCardList({
    super.key,
    required this.files,
    required this.title,
    this.maxShowCount = 10,
    this.itemHeight = 260,
    this.itemWidth = 140,
    this.onShowAllClicked,
    this.onItemClicked,
    this.onItemMenuClicked,
  });

  @override
  Widget build(BuildContext context) {
    final len = files.length.clamp(0, maxShowCount);
    return Container(
      margin: EdgeInsets.only(bottom: 6),
      child: SizedBox(
        height: itemHeight,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            spacing: 4,
            children: [
              Row(
                children: [
                  title,
                  Spacer(),
                  IconButton(
                    color: Colors.blue,
                    onPressed: onShowAllClicked,
                    icon: Icon(Icons.next_plan),
                  ),
                ],
              ),
              Expanded(
                child: ListView.builder(
                  scrollDirection: .horizontal,
                  itemCount: len,
                  itemBuilder: (context, index) {
                    final item = files[index];

                    return Container(
                      margin: EdgeInsets.only(right: 10),
                      child: SizedBox(
                        // height: 180,
                        width: itemWidth,
                        child: PdfGridItem(
                          pdf: item,
                          onClicked: onItemClicked,
                          onMenuClicked: onItemMenuClicked,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
