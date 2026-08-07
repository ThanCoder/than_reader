import 'package:flutter/material.dart';
import 'package:than_reader/core/context_extensions.dart';
import 'package:than_reader/core/models/reader_file.dart';
import 'package:than_reader/core/state/reader_file_all_state_conroller.dart';
import 'package:than_reader/core/utils/pdf_tag_db.dart';
import 'package:than_reader/partials/tag_manager_screen.dart';

class TagButton extends StatefulWidget {
  final ReaderFile pdf;
  const TagButton({super.key, required this.pdf});

  @override
  State<TagButton> createState() => _TagButtonState();
}

class _TagButtonState extends State<TagButton> {
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
    return Row(
      crossAxisAlignment: .start,
      spacing: 4,
      children: [IconButton(onPressed: goTagManager, icon: Icon(Icons.tag))],
    );
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

  void goTagManager() async {
    if (!mounted) return;
    final updated = await context.push<List<String>>(
      builder: (context) => TagManagerScreen(
        tags: tags,
        allTags: ReaderFileAllStateConroller().allTags.toList(),
      ),
    );
    if (updated == null) return;
    tags = updated;
    PdfTagDB.instance.setList(widget.pdf.path, tags);
    ReaderFileAllStateConroller().refreshAllTags();
    setState(() {});
  }
}
