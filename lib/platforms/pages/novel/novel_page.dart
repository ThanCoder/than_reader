import 'dart:typed_data';

import 'package:dual_store/dual_store.dart';
import 'package:flutter/material.dart';
import 'package:t_widgets/t_widgets.dart';
import 'package:than_reader/platforms/pages/novel/models/novel_chapter.dart';
import 'package:than_reader/platforms/pages/novel/novel_chapter_form_page.dart';
import 'package:than_reader/platforms/pages/novel/models/novel_desc.dart';
import 'package:than_reader/platforms/pages/novel/novel_chapter_sliver_list.dart';
import 'package:than_reader/platforms/pages/novel/novel_edit_form.dart';
import 'package:than_reader/platforms/pages/novel/novel_file.dart';
import 'package:url_launcher/url_launcher_string.dart';

class NovelPage extends StatefulWidget {
  const new({super.key, required this.file});
  final NovelFile file;

  @override
  State<NovelPage> createState() => NovelPageState();
}

class NovelPageState extends State<NovelPage> {
  @override
  void initState() {
    db.registerAdapter(NovelDescAdapter());
    db.registerAdapter(NovelChapterAdapter());
    init();
    super.initState();
  }

  @override
  void dispose() {
    db.dispose();
    super.dispose();
  }

  final db = DualStore();
  DuBox<NovelDesc> get descBox => db.getBox<NovelDesc>();
  DuBox<NovelChapter> get chapterBox => db.getBox();
  ImageBox get imageBox => db.getImageBox;
  int descId = -1;
  NovelDesc? desc;
  int imgDataId = -1;
  Uint8List? imgData;

  Future<void> init() async {
    await db.open(widget.file.path);
    final descList = await descBox.getAll();
    if (descList.isNotEmpty) {
      desc = descList.first;
      descId = descList.first.generatedId;
    }
    final img = await imageBox.getOne();
    if (img != null) {
      final bytes = await img.imageData;
      if (bytes != null) {
        imgData = bytes;
        imgDataId = img.generatedId;
      }
    }
    if (!mounted) return;
    setState(() {});
  }

  void editDesc() async {
    final formRes = await context.pushMaterialPageRoute<NovelEditFormResp>(
      builder: (mainCtx) =>
          NovelEditForm(desc: desc ?? .empty(), imgData: imgData),
    );
    if (!mounted) return;
    if (formRes == null) return;
    desc = formRes.desc;
    imgData = formRes.cover;

    // new
    if (descId == -1) {
      final res = await descBox.add(desc!);
      if (res.isOk) {
        descId = res.unwrap();
      }
    } else {
      // update
      await descBox.update(descId, value: desc!);
    }
    setState(() {});
    // image
    final resImgType = formRes.type;
    if (resImgType == .none) return;
    if (resImgType == .delete) {
      await imageBox.deleteById(imgDataId);
      if (!mounted) return;
      setState(() {});
      return;
    }

    if (resImgType == .update) {
      if (imgDataId == -1) {
        await imageBox.add(
          .fromBytes(imgData!, name: 'cover', ext: 'png', lastModified: .now()),
        );
      } else {
        await imageBox.updateById(
          imgDataId,
          file: .fromBytes(
            imgData!,
            name: 'cover',
            ext: 'png',
            lastModified: .now(),
          ),
        );
      }

      if (!mounted) return;
      setState(() {});
      return;
    }
  }

  void newChapter() async {
    await context.pushMaterialPageRoute(
      builder: (mainCtx) => NovelChapterFormPage(store: db),
    );
  }

  void showMenu() async {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) => SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            spacing: 10,
            children: [
              ListTile(
                tileColor: col.surfaceContainer,
                shape: RoundedRectangleBorder(borderRadius: .circular(14)),
                title: Text('Edit Description'),
                trailing: Icon(Icons.arrow_forward_ios_outlined),
                onTap: () {
                  context.pop();
                  editDesc();
                },
              ),
              ListTile(
                tileColor: col.surfaceContainer,
                shape: RoundedRectangleBorder(borderRadius: .circular(14)),
                title: Text('Add Chapter'),
                trailing: Icon(Icons.arrow_forward_ios_outlined),
                onTap: () {
                  context.pop();
                  newChapter();
                },
              ),
              SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }

  ColorScheme get col => Theme.of(context).colorScheme;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          desc != null ? desc!.title : widget.file.name,
          style: TextStyle(fontSize: 18),
        ),
        actions: [
          IconButton(onPressed: showMenu, icon: Icon(Icons.more_vert_outlined)),
        ],
      ),
      body: _body,
    );
  }

  Widget get _body {
    return StreamBuilder(
      stream: db.events.open,
      builder: (context, asyncSnapshot) {
        if (!db.opened) {
          return Center(child: CircularProgressIndicator.adaptive());
        }
        return CustomScrollView(
          slivers: [
            SliverPadding(
              padding: .symmetric(vertical: 10, horizontal: 5),
              sliver: _descWidget,
            ),

            SliverPadding(
              padding: .symmetric(vertical: 10, horizontal: 15),
              sliver: NovelChapterSliverList(db: db),
            ),
            SliverToBoxAdapter(child: SizedBox(height: 80)),
          ],
        );
      },
    );
  }

  Widget get _descWidget {
    final data = desc;

    if (data == null) {
      return SliverFillRemaining(
        child: Center(
          child: TextButton(
            onPressed: editDesc,
            child: const Text('Add Description'),
          ),
        ),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.all(16),
      sliver: SliverList.list(
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              final isMobile = constraints.maxWidth <= 500;
              if (isMobile) {
                return Wrap(
                  crossAxisAlignment: .center,
                  alignment: .center,
                  children: [
                    // Image placeholder
                    _coverImage(width: 200, height: 220),

                    const SizedBox(width: 16),

                    // Novel information
                    _coverContent(data),
                  ],
                );
              }
              return Row(
                crossAxisAlignment: .start,
                children: [
                  // Image placeholder
                  _coverImage(),

                  const SizedBox(width: 16),

                  // Novel information
                  Expanded(child: _coverContent(data)),
                ],
              );
            },
          ),

          if (data.desc.isNotEmpty) const SizedBox(height: 24),

          // const SizedBox(height: 8),
          if (data.desc.isNotEmpty)
            ExpansionTile(
              title: const Text(
                'Description',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              children: [
                Text(
                  data.desc,
                  style: const TextStyle(fontSize: 15, height: 1.6),
                ),
              ],
            ),

          if (data.tags.isNotEmpty) ...[
            const SizedBox(height: 24),

            const Text(
              'Tags',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [for (final tag in data.tags) Chip(label: Text(tag))],
            ),
          ],

          if (data.urls.isNotEmpty) ...[
            const SizedBox(height: 24),

            const Text(
              'Sources',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            for (final url in data.urls)
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.link),
                title: Text(url, maxLines: 1, overflow: TextOverflow.ellipsis),
                onTap: () {
                  launchUrlString(url);
                },
              ),
          ],
        ],
      ),
    );
  }

  ClipRRect _coverImage({double width = 120, double height = 175}) {
    Widget img = Icon(Icons.menu_book_outlined, size: 40);
    if (imgData != null) {
      img = Image.memory(imgData!);
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: width,
        height: height,
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        child: Center(child: img),
      ),
    );
  }

  Column _coverContent(NovelDesc data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          data.title,
          maxLines: 4,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.bold,
            height: 1.25,
          ),
        ),

        const SizedBox(height: 18),

        _infoItem(
          icon: Icons.person_outline,
          label: 'Author',
          value: data.author,
        ),

        _infoItem(
          icon: Icons.translate,
          label: 'Translator',
          value: data.translator,
        ),

        _infoItem(
          icon: Icons.face_outlined,
          label: 'Main Character',
          value: data.mc,
        ),
      ],
    );
  }

  Widget _infoItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    if (value.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
