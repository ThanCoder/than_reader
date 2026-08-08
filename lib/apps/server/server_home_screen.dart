import 'package:flutter/material.dart';
import 'package:t_widgets/t_widgets.dart';

import 'package:than_reader/apps/server/reader_file_share.dart';

class ServerHomeScreen extends StatefulWidget {
  const ServerHomeScreen({super.key});

  @override
  State<ServerHomeScreen> createState() => _ServerHomeScreenState();
}

class _ServerHomeScreenState extends State<ServerHomeScreen> {
  final share = ReaderFileShare.instance;
  static List<ShareResultItem> list = [];
  List<String> wifiList = [];

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    try {
      wifiList = await share.allWifiList;
    } catch (e) {
      if (!mounted) return;
      showTMessageDialogError(context, e.toString());
    }

    if (!mounted) return;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: share.valueNotifier,
      builder: (context, value, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Share Server'),
            actions: [IconButton(onPressed: init, icon: Icon(Icons.refresh))],
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: RefreshIndicator.adaptive(
              onRefresh: init,
              child: CustomScrollView(
                slivers: [
                  if (wifiList.isNotEmpty)
                    SliverToBoxAdapter(
                      child: Text('အသုံးပြုနိုင်မယ့် Wifi List များ '),
                    ),
                  if (wifiList.isNotEmpty)
                    // wifi list
                    wifiListWidget,
                  if (wifiList.isNotEmpty) SliverToBoxAdapter(child: Divider()),
                  // list
                  shareResultListWidget,
                ],
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: share.server.isOpened ? Colors.red : Colors.green,
            onPressed: toggleShareServer,
            child: share.server.isOpened
                ? Icon(Icons.stop_circle)
                : Icon(Icons.play_arrow),
          ),
        );
      },
    );
  }

  Widget get wifiListWidget {
    return SliverList.separated(
      itemCount: wifiList.length,
      itemBuilder: (context, index) => wifiListItem(wifiList[index]),
      separatorBuilder: (context, index) => Divider(),
    );
  }

  Widget wifiListItem(String item) {
    return SelectableText(item, style: TextStyle(color: Colors.green));
  }

  Widget get shareResultListWidget {
    return SliverList.separated(
      itemCount: list.length,
      separatorBuilder: (context, index) => Divider(),
      itemBuilder: (context, index) => listItem(list[index]),
    );
  }

  Widget listItem(ShareResultItem item) {
    return Text(item.message);
  }

  void toggleShareServer() async {
    if (share.server.isOpened) {
      await share.stop();
      list.add(.new(message: 'Stop Server', type: .success));
    } else {
      await share.start();
      list.add(
        .new(
          message:
              'http://${share.server.getAddress!.host}:${share.server.port}',
          type: .success,
        ),
      );
      list.add(.new(message: '${share.server.getAddress}', type: .success));
    }
  }
}

enum ShareResultType { success, error }

class ShareResultItem {
  final String message;
  final ShareResultType type;
  ShareResultItem({required this.message, required this.type});
}
