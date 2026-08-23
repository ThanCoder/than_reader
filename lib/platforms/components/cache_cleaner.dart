import 'package:dart_core_extensions/dart_core_extensions.dart';
import 'package:flutter/material.dart';
import 'package:than_reader/core/utils/app_utils.dart';
import 'package:than_reader/platforms/components/dialog/confirm_alert_dialog.dart';
import 'package:than_reader/platforms/components/dialog/error_alert_dialog.dart';

class CacheCleaner extends StatefulWidget {
  const CacheCleaner({super.key});

  @override
  State<CacheCleaner> createState() => _CacheCleanerState();
}

class _CacheCleanerState extends State<CacheCleaner>
    with SingleTickerProviderStateMixin {
  late final AnimationController scanIconAniController;

  @override
  void initState() {
    scanIconAniController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );
    scanCache();
    super.initState();
  }

  @override
  void dispose() {
    scanIconAniController.stop();
    scanIconAniController.dispose();
    super.dispose();
  }

  bool isScanning = false;
  bool isCleaning = false;
  int count = 0;
  int size = 0;

  void scanCache() async {
    if (count > 0) {
      cleanCache();
      return;
    }
    try {
      count = 0;
      size = 0;
      scanIconAniController.repeat();
      setState(() {
        isScanning = true;
      });
      final cacheDir = AppUtils.instance.cacheDir;

      await for (var file in cacheDir.list()) {
        count++;
        size += file.size;
      }
      await Future.delayed(Duration(seconds: 1));

      if (!mounted) return;
      await stopAnimate();
      setState(() {
        isScanning = false;
      });
    } catch (e) {
      // scanIconAniController.stop();
      await stopAnimate();
      if (!mounted) return;
      setState(() {
        isScanning = false;
      });
    }
  }

  Future<void> cleanCache() async {
    try {
      count = 0;
      size = 0;
      final confirm = await showConfirmDialog(
        context,
        'Do You Want To Clean!',
        confirmColor: col.error,
        confirmForegroundColor: col.onError,
      );
      if (!confirm) return;
      scanIconAniController.repeat();
      setState(() {
        isCleaning = true;
      });
      await AppUtils.instance.deleteFolder(AppUtils.instance.cacheDir);
      if (!AppUtils.instance.cacheDir.existsSync()) {
        await AppUtils.instance.cacheDir.create(recursive: true);
      }

      await Future.delayed(Duration(seconds: 1));

      if (!mounted) return;
      await stopAnimate();
      setState(() {
        isCleaning = false;
      });

      // scanCache();
    } catch (e) {
      if (!mounted) return;
      stopAnimate();
      setState(() {
        isCleaning = false;
      });
      showErrorDialog(context, e.toString());
    }
  }

  Future<void> stopAnimate() async {
    if (!mounted) return;
    await scanIconAniController.animateTo(
      0,
      duration: const Duration(milliseconds: 200),
    );
  }

  ColorScheme get col => Theme.of(context).colorScheme;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isScanning ? null : scanCache,
      child: Container(
        padding: .symmetric(vertical: 10, horizontal: 12),
        decoration: BoxDecoration(
          color: col.surfaceContainer,
          borderRadius: .circular(15),
        ),
        child: Row(
          children: [
            RotationTransition(
              turns: scanIconAniController,
              child: Container(
                padding: .all(8),
                decoration: BoxDecoration(
                  color: col.tertiaryContainer,
                  borderRadius: .circular(15),
                ),
                child: Icon(
                  Icons.cached_outlined,
                  color: col.onTertiaryContainer,
                ),
              ),
            ),
            SizedBox(width: 10),
            _infoText(),
            Spacer(),
            Icon(Icons.touch_app, color: col.onSurface),
          ],
        ),
      ),
    );
  }

  Column _infoText() {
    String infoText = 'no need to clean!';
    if (isCleaning) {
      infoText = 'Cache Cleanning...';
    }
    if (isScanning) {
      infoText = 'Cache Scanning...';
    }
    if (count > 0) {
      infoText = '[Cache]: count: $count - ${size.fileSizeLabel()}';
    }
    return Column(
      crossAxisAlignment: .start,
      children: [
        Text(
          'Cache Cleaner',
          style: TextStyle(fontWeight: .w600, color: col.onSurface),
        ),
        Text(
          infoText,
          style: TextStyle(
            fontSize: 11,
            fontWeight: .w400,
            color: col.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
