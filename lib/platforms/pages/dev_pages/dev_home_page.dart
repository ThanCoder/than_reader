import 'package:flutter/material.dart';
import 'package:than_reader/platforms/components/dialog/error_alert_dialog.dart';
import 'package:url_launcher/url_launcher.dart';

import 'dev_page_api.dart';

import 'dev_page.dart';

// tiktok.com/@than6043

// https://www.facebook.com/thancoder2019
//https://t.me/thancoder_novel
// t.me/thancoder2024
class DevHomePage extends StatefulWidget {
  const DevHomePage({super.key});

  @override
  State<DevHomePage> createState() => _DevHomePageState();
}

class _DevHomePageState extends State<DevHomePage> {
  void launchPage(DevPage page) async {
    if (!await launchUrl(Uri.parse(page.url))) {
      if (!mounted) return;
      showErrorDialog(context, 'Url Can\'t launch!');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Developer')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _developerHeader(context),

          const SizedBox(height: 28),

          Text(
            'About',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          Text(
            'Developer & creator of this application.',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),

          const SizedBox(height: 28),

          Text(
            'Connect with me',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          listWidget,
        ],
      ),
    );
  }

  Widget _developerHeader(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      children: [
        Container(
          width: 96,
          height: 96,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: colorScheme.primaryContainer,
          ),
          child: Icon(
            Icons.code_rounded,
            size: 48,
            color: colorScheme.onPrimaryContainer,
          ),
        ),

        const SizedBox(height: 16),

        Text(
          'Than Coder',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 6),

        Text(
          'Flutter Developer',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget get listWidget {
    return FutureBuilder<List<DevPage>>(
      future: DevPageApi.getList(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == .waiting) {
          return Center(child: CircularProgressIndicator.adaptive());
        }
        final list = snapshot.data ?? [];
        // print(jsonEncode(list.map((e) => e.toMap()).toList()));
        return Column(
          children: list
              .map(
                (item) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _devCard(context, item),
                ),
              )
              .toList(),
        );
      },
    );
  }

  Widget _devCard(BuildContext context, DevPage item) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => launchPage(item),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              _icon(context, item),

              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      item.url,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.primary,
                      ),
                    ),

                    if (item.desc.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        item.desc,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(width: 8),

              Icon(
                Icons.open_in_new_rounded,
                size: 20,
                color: colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _icon(BuildContext context, DevPage item) {
    // final theme = Theme.of(context);
    // final colorScheme = theme.colorScheme;

    if (item.iconUrl != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Image.network(
          item.iconUrl!,
          width: 52,
          height: 52,
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) {
            return _defaultIcon(context);
          },
        ),
      );
    }

    return _defaultIcon(context);
  }

  Widget _defaultIcon(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: colorScheme.secondaryContainer,
      ),
      child: Icon(
        Icons.public_rounded,
        color: colorScheme.onSecondaryContainer,
      ),
    );
  }
}
