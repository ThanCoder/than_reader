import 'package:dual_store/dual_store.dart';
import 'package:material_ui/material_ui.dart';
import 'package:than_reader/platforms/pages/novel/desc_page/novel_chapter_sliver_list.dart';
import 'package:than_reader/platforms/pages/novel/forms/novel_chapter_form_page.dart';
import 'package:than_reader/platforms/pages/novel/models/novel_chapter.dart';
import 'package:than_reader/ui/build_context_x.dart';

Future<void> goChapterFormPage(
  BuildContext context, {
  NovelChapter? editChapter,
  required DuBox<NovelChapter> box,
}) async {
  await context.pushMaterialPageRoute(
    builder: (mainCtx) => NovelChapterFormPage(
      lang: NovelChapterSliverList.lang,
      editChapter: editChapter,
      getLastChapter: (lang) async {
        final list = await box.find((e) => e.lang == lang);
        if (list.isNotEmpty) {
          list.sortChapter();
          return list.last;
        }
        return null;
      },
      getChapter: (lang, chNumber) async {
        final ch = await box.findOne(
          (e) => e.lang == lang && e.chapter == chNumber,
        );
        if (ch != null) {
          return ch;
        }
        return null;
      },
      onSaved: (ch, contentText) => _addOrUpdate(box, ch, contentText),
    ),
  );
}

Future<String?> _addOrUpdate(
  DuBox<NovelChapter> box,
  NovelChapter ch,
  String contentText,
) async {
  final lastCh = await box.findOne(
    (e) => e.chapter == ch.chapter && e.lang == ch.lang,
  );
  if (lastCh != null) {
    // update
    final res = await box.updateById(
      lastCh.generatedId,
      value: ch,
      contentWriter: TextCompressContentWriter(contentText),
    );
    if (res.isOk) {
      return 'Chapter: ${ch.chapter} Updated';
    }
  } else {
    // new
    final res = await box.add(
      ch,
      contentWriter: TextCompressContentWriter(contentText),
    );
    if (res.isOk) {
      return 'Chapter: ${ch.chapter} Added';
    }
  }
  return null;
}
