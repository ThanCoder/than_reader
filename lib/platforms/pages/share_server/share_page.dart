import 'dart:io';

import 'package:flutter/material.dart';
import 'package:than_pkg_android/than_pkg_android.dart';
import 'package:than_reader/core/utils/platform_util.dart';
import 'package:than_reader/platforms/components/dialog/error_alert_dialog.dart';
import 'package:than_reader/platforms/pages/share_server/share_controller.dart';

class SharePage extends StatefulWidget {
  const new({super.key});

  @override
  State<SharePage> createState() => _SharePageState();
}

class _SharePageState extends State<SharePage> {
  @override
  void initState() {
    init();
    super.initState();
    if (Platform.isAndroid) {
      ThanPkgAndroid.getInstance.osHandler.keepScreenOn(true);
    }
  }

  @override
  void dispose() {
    shareCon.server.stop();
    if (Platform.isAndroid) {
      ThanPkgAndroid.getInstance.osHandler.keepScreenOn(false);
    }
    super.dispose();
  }

  final shareCon = ShareController.instance;
  ColorScheme get col => Theme.of(context).colorScheme;

  void init() async {
    try {
      await shareCon.init();
      await shareCon.start();
      setState(() {});
    } catch (e) {
      if (!mounted) return;
      showErrorDialog(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: col.surface,
      appBar: AppBar(title: Text('Share')),
      body: Center(child: _body),
    );
  }

  Widget get _body {
    final colorScheme = Theme.of(context).colorScheme;

    if (!shareCon.server.isOpened) {
      return Center(
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.cloud_off_rounded,
                  size: 48,
                  color: colorScheme.onSurfaceVariant,
                ),
                const SizedBox(height: 16),
                Text(
                  'Server is not running',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 6),
                Text(
                  'Start the server to share files over your network.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium
                      ?.copyWith(color: colorScheme.onSurfaceVariant),
                ),
                const SizedBox(height: 20),
                FilledButton.icon(
                  onPressed: () async {
                    await shareCon.start();
                    setState(() {});
                  },
                  icon: const Icon(Icons.play_arrow_rounded),
                  label: const Text('Start Server'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final url =
        'http://${shareCon.server.getAddress?.host}:${shareCon.server.port}';

    return Center(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.wifi_rounded,
                  color: colorScheme.onPrimaryContainer,
                  size: 30,
                ),
              ),
              const SizedBox(height: 16),

              Text(
                'Server Running',
                style: Theme.of(context).textTheme.titleLarge
                    ?.copyWith(fontWeight: FontWeight.w600),
              ),

              const SizedBox(height: 6),

              Text(
                'Open this address on another device',
                style: Theme.of(context).textTheme.bodyMedium
                    ?.copyWith(color: colorScheme.onSurfaceVariant),
              ),

              const SizedBox(height: 20),

              InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  PlatformUtil.launchUrl(url);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.link_rounded,
                        size: 20,
                        color: colorScheme.primary,
                      ),
                      const SizedBox(width: 10),
                      Flexible(
                        child: Text(
                          url,
                          style: TextStyle(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.open_in_new_rounded,
                        size: 18,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
