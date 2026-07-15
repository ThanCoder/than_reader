import 'package:flutter/material.dart';
import 'package:than_reader/core/models/app_file.dart';
import 'package:than_reader/core/utils/pdf_tag_db.dart';

class TagsView extends StatefulWidget {
  final AppFile pdf;
  const TagsView({super.key, required this.pdf});

  @override
  State<TagsView> createState() => _TagsViewState();
}

class _TagsViewState extends State<TagsView> {
  @override
  void initState() {
    init();
    super.initState();
  }

  List<String> tags = [];

  void init() {
    tags = PdfTagDB.instance.getList(widget.pdf.path);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return tagWidget;
  }

  Widget get tagWidget {
    return Wrap(
      alignment: .start,
      crossAxisAlignment: .start,
      spacing: 4,
      runSpacing: 4,
      children: List.generate(tags.length, (index) => tagItem(tags[index])),
    );
  }

  Widget tagItem(String tag) {
    return Text(
      '#$tag',
      overflow: .ellipsis,
      maxLines: 1,
      style: TextStyle(
        fontWeight: .bold,
        fontSize: 12,
        fontStyle: .italic,
        color: Colors.blueAccent,
      ),
    );
  }
}
