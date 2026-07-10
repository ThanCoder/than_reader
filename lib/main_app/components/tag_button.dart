import 'package:flutter/material.dart';
import 'package:than_reader/core/extensions/context_extensions.dart';
import 'package:than_reader/core/models/pdf_file.dart';
import 'package:than_reader/core/state/pdf_state_conroller.dart';
import 'package:than_reader/core/utils/pdf_tag_db.dart';
import 'package:than_reader/partials/tag_manager_screen.dart';

class TagButton extends StatefulWidget {
  final PdfFile pdf;
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
    return Wrap(
      crossAxisAlignment: .center,
      alignment: .center,
      children: [
        IconButton(onPressed: goTagManager, icon: Icon(Icons.tag)),
        tagWidget,
      ],
    );
  }

  Widget get tagWidget {
    return Wrap(
      spacing: 2,
      runSpacing: 2,
      children: List.generate(tags.length, (index) => tagItem(tags[index])),
    );
  }

  Widget tagItem(String tag) {
    return Text('#$tag', style: TextStyle(fontWeight: .bold, fontSize: 12));
  }

  void goTagManager() async {
    if (!mounted) return;
    final updated = await context.push<List<String>>(
      builder: (context) => TagManagerScreen(
        tags: tags,
        allTags: PdfStateConroller().allTags.toList(),
      ),
    );
    if (updated == null) return;
    tags = updated;
    PdfTagDB.instance.setList(widget.pdf.path, tags);
    PdfStateConroller().refreshAllTags();
    setState(() {});
  }
}
