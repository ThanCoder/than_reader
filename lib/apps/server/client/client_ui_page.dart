import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:t_client/t_client.dart';
import 'package:t_widgets/t_widgets.dart';
import 'package:than_pkg/than_pkg.dart';
import 'package:than_pkg_android/than_pkg_android.dart';
import 'package:than_reader/apps/server/client/book_grid_item.dart';
import 'package:than_reader/apps/server/client/book_item_menu.dart';
import 'package:than_reader/core/models/reader_file.dart';

class ClientUiPage extends StatefulWidget {
  final String hostUrl;
  const ClientUiPage({super.key, required this.hostUrl});

  @override
  State<ClientUiPage> createState() => _ClientUiPageState();
}

class _ClientUiPageState extends State<ClientUiPage> {
  @override
  void initState() {
    super.initState();
    fetchApi();
  }

  final client = TClient();
  bool isLoading = false;
  List<ReaderFile> resultList = [];

  Future<void> fetchApi({String apiUrl = '/api/books'}) async {
    if (widget.hostUrl.isEmpty) return;
    try {
      final url = '${widget.hostUrl}$apiUrl';

      setState(() {
        isLoading = true;
      });
      final res = await client.get(url);

      if (res.statusCode == HttpStatus.ok) {
        final map = jsonDecode(res.data);
        if (map['success'] ?? false) {
          List<dynamic> data = map['data'] ?? [];
          resultList = data.map((e) => ReaderFile.fromMap(e)).toList();
        }
      }
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
      showTMessageDialogError(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(child: TLoaderRandom());
    }
    if (resultList.isEmpty) {
      return Center(
        child: RefreshButton(text: Text('Reload'), onClicked: fetchApi),
      );
    }
    return bodyWidget;
  }

  Widget get bodyWidget {
    return CustomScrollView(
      slivers: [
        SliverGrid.builder(
          itemCount: resultList.length,
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            mainAxisExtent: 200,
            maxCrossAxisExtent: 180,
            crossAxisSpacing: 3,
            mainAxisSpacing: 3,
          ),
          itemBuilder: (context, index) => gridItem(resultList[index]),
        ),
      ],
    );
  }

  Widget gridItem(ReaderFile book) {
    return BookGridItem(
      book: book,
      hostUrl: widget.hostUrl,
      onClicked: showItemMenu,
    );
  }

  void showItemMenu(ReaderFile book) async {
    Directory? outDir;
    if (Platform.isAndroid) {
      outDir = Directory(
        ThanPkgAndroid.getInstance.pathHandler.getDownloadPath(),
      );
    } else if (Platform.isLinux) {
      outDir = await getDownloadsDirectory();
    }

    if (!mounted) return;
    if (outDir == null) {
      showTMessageDialogError(context, 'getDownloadsDirectory is null!');
    }
    await showModalBottomSheet(
      context: context,
      builder: (context) =>
          BookItemMenu(book: book, hostUrl: widget.hostUrl, outDir: outDir!),
    );
    setState(() {});
  }
}
