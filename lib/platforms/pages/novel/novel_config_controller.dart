import 'package:cfb_store/cfb_store.dart';
import 'package:than_reader/core/controller/i_controller.dart';
import 'package:than_reader/core/utils/app_utils.dart';
import 'package:than_reader/platforms/pages/novel/models/chapter_bookmark.dart';
import 'package:than_reader/platforms/pages/novel/models/novel_chapter.dart';

class NovelConfigControllerStateChanged extends IControllerEvent {}

class ChapterBookmarkChanged extends IControllerEvent {}

class NovelConfigController extends IController {
  static final NovelConfigController instance = NovelConfigController._();
  NovelConfigController._();
  factory NovelConfigController() => instance;

  final cf = CFBStore();

  Future<void> loadInit(String novelId) async {
    await cf.open(
      AppUtil.instance.getPlatfromExternalConfigPath('novel.db.$novelId.cf'),
    );

    _recentStorage.clear();
    _bookmark.clear();

    final recent = cf.getMap('recent');
    _recentStorage.addAll(recent.map((k, v) => .new(.fromVal(k), v)));
    // load bookmark
    final books = cf.getMapList('bookmark-list');

    final list = books.map((e) => ChapterBookmark.fromJson(e)).toList();
    _bookmark.addAll(list);

    addEvent(NovelConfigControllerStateChanged());
    addEvent(ChapterBookmarkChanged());
  }

  Future<void> saveRecentStorage() async {
    final val = _recentStorage.map((k, v) => .new(k.name, v));
    cf.put('recent', val);
    // save bookmark
    final books = _bookmark.map((e) => e.toJson()).toList();
    cf.put('bookmark-list', books);

    await cf.writeAll();
  }

  //***************Bookmark Storage***************************** */
  final List<ChapterBookmark> _bookmark = [];

  List<ChapterBookmark> get bookmarks => _bookmark;

  bool existsBookmark(ChapterBookmark book) {
    final index = _bookmark.indexWhere(
      (e) => e.chapter == book.chapter && e.lang == book.lang,
    );
    return index != -1;
  }

  void addBookmark(ChapterBookmark book) {
    _bookmark.add(book);

    _bookmark.sort((a, b) => a.chapter.compareTo(b.chapter));

    addEvent(ChapterBookmarkChanged());
  }

  void removeBookmark(ChapterBookmark book) {
    final index = _bookmark.indexWhere(
      (e) => e.chapter == book.chapter && e.lang == book.lang,
    );
    if (index == -1) return;
    _bookmark.removeAt(index);

    addEvent(ChapterBookmarkChanged());
  }

  //***************Recent Storage***************************** */
  final Map<ChapterLaguage, int> _recentStorage = {};

  void addRecentStorage(NovelChapter item) {
    _recentStorage[item.lang] = item.generatedId;

    addEvent(NovelConfigControllerStateChanged());
  }

  bool existsRecentStorage(NovelChapter item) {
    return (_recentStorage[item.lang] ?? -1) == item.generatedId;
  }

  @override
  Future<void> init() async {}
}
