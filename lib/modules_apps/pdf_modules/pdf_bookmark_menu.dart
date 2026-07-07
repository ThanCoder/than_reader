import 'package:flutter/material.dart';
import 'package:t_widgets/t_widgets.dart';
import 'package:than_reader/modules_apps/pdf_modules/pdf_params.dart';

class PdfBookmarkMenu extends StatefulWidget {
  final PdfConfig config;
  final int currentPage;
  final void Function(PdfConfig config) onChanged;
  final void Function(int navigatePage)? onNavigate;
  const PdfBookmarkMenu({
    super.key,
    required this.config,
    required this.currentPage,
    required this.onChanged,
    this.onNavigate,
  });

  @override
  State<PdfBookmarkMenu> createState() => _PdfBookmarkMenuState();
}

class _PdfBookmarkMenuState extends State<PdfBookmarkMenu> {
  @override
  void initState() {
    init();
    super.initState();
  }

  List<PdfBookmark> bookmarkList = [];

  void init() async {
    bookmarkList = widget.config.bookmarkList;
    setState(() {});
  }

  bool get isCurrentAdded {
    final pages = bookmarkList.map((e) => e.page).toSet();
    return pages.contains(widget.currentPage);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: headerWidget),
              listWidget,
            ],
          ),
        ),
      ),
    );
  }

  Widget get headerWidget {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          if (!isCurrentAdded)
            IconButton(
              onPressed: () {
                bookmarkList.add(
                  PdfBookmark(page: widget.currentPage, title: 'Untitled'),
                );
                setState(() {});
              },
              icon: Icon(Icons.bookmark_add, color: Colors.blue),
            ),
          if (!isCurrentAdded)
            IconButton(
              onPressed: addWithText,
              icon: Icon(Icons.bookmark_add, color: Colors.teal),
            ),
        ],
      ),
    );
  }

  Widget get listWidget {
    return SliverList.builder(
      itemCount: bookmarkList.length,
      itemBuilder: (context, index) => listItem(bookmarkList[index]),
    );
  }

  Widget listItem(PdfBookmark book) {
    return ListTile(
      enabled: widget.currentPage != book.page,
      title: Text(
        'Page: ${book.page}',
        style: TextStyle(fontSize: 17, fontWeight: .bold),
        maxLines: 2,
        overflow: .ellipsis,
      ),
      subtitle: Text(
        book.title,
        style: TextStyle(fontSize: 11),
        overflow: .ellipsis,
        maxLines: 1,
      ),
      trailing: IconButton(
        onPressed: () {
          final index = bookmarkList.indexWhere((e) => e.page == book.page);
          if (index == -1) return;
          bookmarkList.removeAt(index);
          setState(() {});
        },
        icon: Icon(Icons.bookmark_remove, color: Colors.red),
      ),
      onTap: () => widget.onNavigate?.call(book.page),
    );
  }

  void addWithText() {
    showTReanmeDialog(
      context,
      text: 'Untitled',
      title: Text('With Title'),
      submitText: 'Add',
      onSubmit: (text) {
        bookmarkList.add(PdfBookmark(page: widget.currentPage, title: text));
        setState(() {});
      },
    );
  }
}
