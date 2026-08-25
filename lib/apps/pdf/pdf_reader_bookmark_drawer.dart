import 'package:flutter/material.dart';
import 'package:than_reader/apps/pdf/pdf_config.dart';
import 'package:than_reader/apps/pdf/pdf_config_bookmark.dart';
import 'package:than_reader/platforms/components/dialog/prompt_alert_dialog.dart';

class PdfReaderBookmarkDrawer extends StatefulWidget {
  const PdfReaderBookmarkDrawer({
    super.key,
    required this.config,
    required this.onClicked,
    required this.currentPage,
  });

  final PdfConfig config;
  final int currentPage;
  final void Function(int page) onClicked;

  @override
  State<PdfReaderBookmarkDrawer> createState() =>
      _PdfReaderBookmarkDrawerState();
}

class _PdfReaderBookmarkDrawerState extends State<PdfReaderBookmarkDrawer> {
  ColorScheme get col => Theme.of(context).colorScheme;

  void addQuick({String title = 'Untitled'}) {
    widget.config.bookmark.add(.new(page: widget.currentPage, title: title));
    widget.config.bookmark.sortPageNumber();
    setState(() {});
  }

  int findIndex(int page) {
    return widget.config.bookmark.indexWhere((e) => e.page == page);
  }

  bool get existsCurrent {
    final page = widget.currentPage;
    return findIndex(page) != -1;
  }

  void add() async {
    final text = await showDialog<String>(
      context: context,
      builder: (context) => PromptAlertDialog(
        promptText: 'Untitled',
        onErrorCheck: (text) {
          if (text.isEmpty) return 'field is empty';
          return null;
        },
      ),
    );
    if (text == null) return;
    addQuick(title: text);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: col.surface,
      child: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: .symmetric(vertical: 10, horizontal: 12),
              sliver: SliverList(
                delegate: SliverChildListDelegate([_header(), Divider()]),
              ),
            ),
            SliverList.separated(
              itemCount: widget.config.bookmark.length,
              separatorBuilder: (context, index) => SizedBox(height: 4),
              itemBuilder: (context, index) =>
                  listItem(widget.config.bookmark[index]),
            ),
          ],
        ),
      ),
    );
  }

  Wrap _header() {
    return Wrap(
      spacing: 4,
      runSpacing: 4,
      children: [
        FilledButton.icon(
          label: Text('Add && Title'),
          icon: Icon(Icons.add_circle_outline_outlined),
          onPressed: existsCurrent ? null : add,
        ),
        FilledButton.icon(
          style: FilledButton.styleFrom(
            backgroundColor: col.primary.withValues(alpha: 45),
          ),
          label: Text('Add Quick'),
          icon: Icon(Icons.add_circle_outline),
          onPressed: existsCurrent ? null : addQuick,
        ),
      ],
    );
  }

  Widget listItem(PdfConfigBookmark book) {
    final canJumpPage = widget.currentPage == book.page;
    return ListTile(
      tileColor: canJumpPage ? col.primaryContainer : col.surfaceContainer,
      shape: RoundedRectangleBorder(borderRadius: .circular(15)),
      contentPadding: .symmetric(vertical: 2, horizontal: 4),
      leading: Icon(Icons.bookmark),
      title: Text(
        book.page.toString(),
        style: TextStyle(fontWeight: .w600, fontSize: 16, color: col.onSurface),
      ),
      subtitle: Text(
        book.title,
        maxLines: 1,
        overflow: .ellipsis,
        style: TextStyle(
          fontWeight: .w400,
          fontSize: 12,
          color: col.onSurfaceVariant,
        ),
      ),

      trailing: IconButton(
        style: IconButton.styleFrom(
          backgroundColor: col.errorContainer,
          foregroundColor: col.onErrorContainer,
        ),
        onPressed: () {
          final index = findIndex(book.page);
          if (index == -1) return;
          widget.config.bookmark.removeAt(index);
          setState(() {});
        },
        icon: Icon(Icons.remove_circle_outline),
      ),
      onTap: canJumpPage
          ? null
          : () {
              widget.onClicked(book.page);
            },
    );
  }
}
