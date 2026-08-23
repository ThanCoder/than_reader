import 'package:flutter/material.dart';

import 'package:dart_core_extensions/dart_core_extensions.dart';
import 'package:than_reader/core/controller/i_controller.dart';
import 'package:than_reader/core/controller/reader_track/reader_history_controller.dart';
import 'package:than_reader/core/models/reader_file.dart';
import 'package:than_reader/platforms/components/reader_cover_file.dart';
import 'package:than_reader/platforms/pages/reader_tracker/tracker_list_item.dart';
import 'package:than_reader/router.dart';

class ReaderTrackerPage extends StatefulWidget {
  const ReaderTrackerPage({super.key});

  @override
  State<ReaderTrackerPage> createState() => _ReaderTrackerPageState();
}

class _ReaderTrackerPageState extends State<ReaderTrackerPage> {
  final hisCon = ControllerManager.read<ReaderHistoryController>();

  void goReader(ReaderFile book) {
    goReaderModuleApp(context, book);
  }

  ColorScheme get col => Theme.of(context).colorScheme;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme;

    return Scaffold(
      backgroundColor: col.surface,
      // appBar: AppBar(
      //   actions: [
      //     IconButton(
      //       onPressed: () {
      //         hisCon.clear();
      //       },
      //       icon: Icon(Icons.lock_reset),
      //     ),
      //   ],
      // ),
      body: StreamBuilder(
        stream: hisCon.events.whereType<ReaderHistoryControllerValueChanged>(),
        builder: (context, asyncSnapshot) {
          final histories = hisCon.historyMap.values;

          if (histories.isEmpty) {
            return _hostoryEmptyWidget(context);
          }

          final totalReadTime = histories.fold<Duration>(
            Duration.zero,
            (total, item) => total + item.totalReadTime,
          );

          final totalSessions = histories.fold<int>(
            0,
            (total, item) => total + item.readCount,
          );
          final recentList = histories.toList()
            ..sort((a, b) {
              return b.lastReadAt.compareTo(a.lastReadAt);
            });

          final list = recentList.map((e) {
            final book = hisCon.allFileMap[e.fileId];
            return TrackerListItem.fromHistory(e, book!);
          }).toList();

          return _bodyWidget(
            color,
            context,
            totalReadTime,
            totalSessions,
            theme,
            list,
          );
        },
      ),
    );
  }

  RefreshIndicator _bodyWidget(
    ColorScheme color,
    BuildContext context,
    Duration totalReadTime,
    int totalSessions,
    ThemeData theme,
    List<TrackerListItem> list,
  ) {
    return RefreshIndicator.adaptive(
      onRefresh: hisCon.reload,
      child: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            title: const Text('Reader Tracker'),
            pinned: true,
            backgroundColor: color.surface.withValues(alpha: .8),
          ),
          // header
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  _fadeCard(
                    context,
                    child: _sessionHeader(
                      context,
                      totalReadTime,
                      totalSessions,
                    ),
                  ),

                  const SizedBox(height: 28),

                  _sectionTitle(
                    context,
                    'Continue Reading',
                    'Pick up where you left off',
                  ),

                  const SizedBox(height: 12),

                  _continuteToRead(context, color, theme, item: list.first),

                  const SizedBox(height: 28),

                  _sectionTitle(
                    context,
                    'Recently Read',
                    'Your latest reading activity',
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: .fromLTRB(16, 0, 16, 20),
            sliver: _recentListWidget(list),
          ),

          // list
        ],
      ),
    );
  }

  Center _hostoryEmptyWidget(BuildContext context) {
    return Center(
      child: Container(
        height: 150,
        padding: .symmetric(vertical: 10, horizontal: 12),
        decoration: BoxDecoration(
          color: col.surfaceContainer,
          borderRadius: .circular(15),
        ),
        child: Column(
          mainAxisAlignment: .center,
          children: [
            Text(
              'Nothing To Show!',
              style: TextStyle(
                fontWeight: .w700,
                color: col.onSurface,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Read Some Book!',
              style: TextStyle(
                fontWeight: .w400,
                color: col.onSurfaceVariant,
                fontSize: 12,
              ),
            ),
            SizedBox(height: 15),
            IconButton(
              style: IconButton.styleFrom(
                backgroundColor: col.surfaceContainerHighest,
                foregroundColor: col.onSurfaceVariant,
              ),
              onPressed: () {
                hisCon.reload();
              },
              icon: Icon(Icons.arrow_back_ios_new_outlined),
            ),
          ],
        ),
      ),
    );
  }

  SliverList _recentListWidget(List<TrackerListItem> list) {
    return SliverList.builder(
      itemCount: list.length,
      itemBuilder: (context, index) {
        final item = list[index];

        return GestureDetector(
          onTap: () => goReader(item.book),
          child: _historyTile(
            context,
            title: item.bookName,
            subtitle:
                '${item.totalReadTimeLabel}  •  ${item.lastReadAtTimeLabel}',
            progress: item.progress,
            book: item.book,
          ),
        );
      },
    );
  }

  Widget _continuteToRead(
    BuildContext context,
    ColorScheme color,
    ThemeData theme, {
    required TrackerListItem item,
  }) {
    return GestureDetector(
      onTap: () => goReader(item.book),
      child: _fadeCard(
        context,
        child: Row(
          children: [
            Container(
              width: 64,
              height: 88,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: color.primaryContainer,
              ),
              child: ReaderCoverFile(file: item.book),
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.bookName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    'Page ${item.lastPage} of ${item.totalPage}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: color.onSurfaceVariant,
                    ),
                  ),

                  const SizedBox(height: 12),

                  LinearProgressIndicator(
                    value: item.progress,
                    minHeight: 5,
                    borderRadius: BorderRadius.circular(10),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    '${(item.progress * 100).toStringAsFixed(2)}%  •  ${item.totalReadTimeLabel} read',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: color.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Row _sessionHeader(
    BuildContext context,
    Duration totalReadTime,
    int totalSessions,
  ) {
    return Row(
      mainAxisAlignment: .spaceBetween,
      children: [
        _stat(
          context,
          Icons.menu_book_outlined,
          'Books',
          hisCon.allBooks.toString().padLeft(2, '0'),
        ),
        _stat(
          context,
          Icons.schedule_outlined,
          'Reading',
          //'12h 35m',
          totalReadTime.formatTimeLable(),
        ),
        _stat(
          context,
          Icons.auto_stories_outlined,
          'Sessions',
          totalSessions.toString().padLeft(2, '0'),
        ),
      ],
    );
  }

  Widget _fadeCard(BuildContext context, {required Widget child}) {
    final color = Theme.of(context).colorScheme;
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.surfaceContainerHighest.withValues(alpha: .45),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: color.outlineVariant.withValues(alpha: .35),
          ),
        ),
        child: child,
      ),
    );
  }

  Widget _stat(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    final theme = Theme.of(context);
    final color = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 21, color: color.primary),
        const SizedBox(height: 10),
        Text(
          value,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: theme.textTheme.labelMedium?.copyWith(
            color: color.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _sectionTitle(BuildContext context, String title, String subtitle) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 3),
        Text(subtitle, style: theme.textTheme.bodySmall),
      ],
    );
  }

  Widget _historyTile(
    BuildContext context, {
    required String title,
    required String subtitle,
    required double progress,
    required ReaderFile book,
  }) {
    final theme = Theme.of(context);
    final color = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: _fadeCard(
        context,
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: color.primaryContainer,
              child: ReaderCoverFile(file: book),
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: color.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 9),
                  LinearProgressIndicator(
                    value: progress,
                    minHeight: 3,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
