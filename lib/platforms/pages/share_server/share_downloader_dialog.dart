import 'package:flutter/material.dart';
import 'package:t_client/t_client.dart';
import 'package:t_widgets/t_widgets.dart';
import 'package:than_reader/core/models/reader_file.dart';

class ShareDownloaderDialog extends StatefulWidget {
  const new({
    super.key,
    required this.hostUr,
    required this.file,
    required this.outPath,
  });
  final String hostUr;
  final ReaderFile file;
  final String outPath;

  @override
  State<ShareDownloaderDialog> createState() => _ShareDownloaderDialogState();
}

class _ShareDownloaderDialogState extends State<ShareDownloaderDialog> {
  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  void dispose() {
    client.close();
    super.dispose();
  }

  final client = TClient();
  bool isLoading = false;
  double? progress;
  String? error;

  void init() async {
    setState(() {
      progress = null;
      error = null;
    });
    final url = '${widget.hostUr}/api/book/${widget.file.configId}';
    final res = await client.downloadProgress(
      url,
      widget.outPath,
      onProgress: (progress) {
        if (!mounted) return;
        setState(() {
          this.progress = progress;
        });
      },
    );
    if (!mounted) return;
    if (res.isErr) {
      setState(() {
        error = res.unwrapError();
      });
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    final col = Theme.of(context).colorScheme;

    return AlertDialog.adaptive(
      scrollable: true,
      content: Center(
        child: error != null
            ? Text('Erro: $error', style: TextStyle(color: Colors.red))
            : Column(
                spacing: 10,
                mainAxisAlignment: .center,
                crossAxisAlignment: .start,
                children: [
                  Text(
                    '${widget.file.name}: ${(progress ?? 0) < 1 ? 'Downloading' : 'Downloaded'}...',
                    maxLines: 1,
                    overflow: .ellipsis,
                    style: TextStyle(fontWeight: .w600, color: col.onSurface),
                  ),
                  LinearProgressIndicator(value: progress),
                  if (progress != null)
                    Text(
                      '${((progress ?? 0) * 100).toStringAsFixed(0)}%',
                      style: TextStyle(
                        fontWeight: .w800,
                        color: col.onSurfaceVariant,
                      ),
                    ),
                  Text(
                    'Saved: ${widget.outPath}',
                    style: TextStyle(
                      fontWeight: .w300,
                      color: col.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
      ),
      actions: [
        FilledButton(
          onPressed: () {
            context.pop();
          },
          child: Text('Close'),
        ),
      ],
    );
  }
}
