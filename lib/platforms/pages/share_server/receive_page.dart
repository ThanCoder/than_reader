import 'dart:convert';

import 'package:dart_core_extensions/dart_core_extensions.dart';
import 'package:flutter/material.dart';
import 'package:t_client/t_client.dart';
import 'package:t_widgets/t_widgets.dart';
import 'package:than_reader/core/models/reader_file.dart';
import 'package:than_reader/core/utils/platform_util.dart';
import 'package:than_reader/platforms/components/dialog/error_alert_dialog.dart';
import 'package:than_reader/platforms/pages/share_server/active_host_scanner_dialog.dart';
import 'package:than_reader/platforms/pages/share_server/share_download_menu.dart';
import 'package:than_reader/platforms/pages/share_server/share_downloader_dialog.dart';
import 'package:than_reader/platforms/pages/share_server/share_grid_item.dart';

String? _connectAddress;

class ReceivePage extends StatefulWidget {
  const new({super.key});

  @override
  State<ReceivePage> createState() => _ReceivePageState();
}

class _ReceivePageState extends State<ReceivePage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((e) => init());
    super.initState();
  }

  @override
  void dispose() {
    client.close();
    super.dispose();
  }

  final client = TClient();
  bool isLoading = false;

  List<ReaderFile> files = [];

  Future<void> init() async {
    try {
      _connectAddress ??= await showDialog<String>(
        context: context,
        barrierDismissible: false,
        builder: (context) => ActiveHostScannerDialog(),
      );
      if (_connectAddress == null) return;
      if (!mounted) return;
      setState(() {
        isLoading = true;
      });
      final url = 'http://$_connectAddress/api';
      final apiRes = await client.get(url);
      if (apiRes.isErr) {
        if (!mounted) return;
        setState(() {
          isLoading = false;
        });
        _connectAddress = null;
        showErrorDialog(context, 'Api Url: $url\n${apiRes.unwrapError()}');
        return;
      }
      final apiInfo = apiRes.unwrap();
      if (apiInfo.statusCode != 200) {
        if (!mounted) return;
        setState(() {
          isLoading = false;
        });
        showErrorDialog(
          context,
          'Api statusCode : $url\n${apiInfo.statusCode}',
        );
        return;
      }
      List<dynamic> jsonList = jsonDecode(apiInfo.body);
      files = jsonList.map((e) => ReaderFile.fromMap(e)).toList();

      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
      setState(() {});
    } catch (e) {
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
      showErrorDialog(context, e.toString());
    }
  }

  ColorScheme get col => Theme.of(context).colorScheme;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Receive Page'),
        actions: [
          if (TPlatform.isDesktop && !isLoading)
            IconButton(onPressed: init, icon: Icon(Icons.refresh_outlined)),
        ],
      ),
      body: RefreshIndicator.adaptive(
        onRefresh: init,
        child: isLoading
            ? Center(child: TLoaderRandom())
            : CustomScrollView(
                slivers: [
                  if (_connectAddress != null)
                    SliverToBoxAdapter(
                      child: Center(
                        child: Text(
                          'Connected: $_connectAddress',
                          style: TextStyle(fontSize: 20, fontWeight: .w700),
                        ),
                      ),
                    )
                  else
                    SliverFillRemaining(
                      child: Center(
                        child: Container(
                          padding: .symmetric(vertical: 10, horizontal: 15),
                          decoration: BoxDecoration(
                            color: col.surfaceContainer,
                            borderRadius: .circular(15),
                            border: .all(color: col.outlineVariant),
                          ),
                          child: Column(
                            mainAxisAlignment: .center,
                            mainAxisSize: .min,
                            children: [
                              Text(
                                'Rescan',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: .w700,
                                ),
                              ),
                              SizedBox(height: 10),
                              IconButton(
                                style: IconButton.styleFrom(
                                  backgroundColor: col.primary,
                                  foregroundColor: col.onPrimary,
                                ),
                                onPressed: init,
                                icon: Icon(Icons.repeat),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  SliverPadding(
                    padding: .symmetric(vertical: 10, horizontal: 15),
                    sliver: _connectAddress == null ? null : _body,
                  ),
                ],
              ),
      ),
    );
  }

  Widget get _body {
    return SliverGrid.builder(
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 220,
        childAspectRatio: .68,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
      ),
      itemCount: files.length,
      itemBuilder: (context, index) {
        final file = files[index];
        return ShareGridItem(
          file: file,
          host: _connectAddress!,
          onClicked: download,
        );
      },
    );
  }

  void download(ReaderFile file) async {
    final downloadF = await showModalBottomSheet<ReaderFile>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) => ShareDownloadMenu(file: file),
    );
    if (downloadF == null) return;
    if (!mounted) return;

    final hostUr = 'http://$_connectAddress';
    final outPath = await PlatformUtil.getOutPath(
      '${file.name}.${file.type.extname}',
    );
    if (!mounted) return;
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) =>
          ShareDownloaderDialog(hostUr: hostUr, file: file, outPath: outPath),
    );
  }
}
