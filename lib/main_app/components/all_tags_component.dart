import 'package:flutter/material.dart';
import 'package:than_reader/core/context_extensions.dart';
import 'package:than_reader/core/state/reader_file_all_state_conroller.dart';
import 'package:than_reader/main_app/home/app_result_screen.dart';

class AllTagsComponent extends StatefulWidget {
  const AllTagsComponent({super.key});

  @override
  State<AllTagsComponent> createState() => _AllTagsComponentState();
}

class _AllTagsComponentState extends State<AllTagsComponent> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: ReaderFileAllStateConroller().stream,
      builder: (context, snapshot) {
        final allTags = ReaderFileAllStateConroller().allTags.toList();
        return Row(
          mainAxisAlignment: .start,
          crossAxisAlignment: .start,
          spacing: 4,
          children: List.generate(
            allTags.length,
            (index) => listItem(allTags[index]),
          ),
        );
      },
    );
  }

  Widget listItem(String tag) {
    return InkWell(
      onTap: () => goResutlPage(tag),
      mouseCursor: SystemMouseCursors.click,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 2, horizontal: 4),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 34, 34, 34),
          border: Border.all(),
          borderRadius: BorderRadius.circular(3),
        ),
        child: Text('#$tag', style: TextStyle(color: Colors.blue)),
      ),
    );
  }

  void goResutlPage(String tag) async {
    final list = ReaderFileAllStateConroller().getFilterTag(tag);
    await context.push(
      builder: (context) => AppResultScreen(title: tag, list: list),
    );
    ReaderFileAllStateConroller().refreshState();
  }
}
