import 'package:flutter/material.dart';
import 'package:t_client/t_client.dart';
import 'package:t_widgets/t_widgets.dart';
import 'package:than_reader/platforms/pages/share_server/share_controller.dart';

class ActiveHostScannerDialog extends StatefulWidget {
  const new({super.key});

  @override
  State<ActiveHostScannerDialog> createState() =>
      _ActiveHostScannerDialogState();
}

class _ActiveHostScannerDialogState extends State<ActiveHostScannerDialog> {
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
  List<String> activeHost = [];
  bool isLoading = false;
  String? error;
  void init() async {
    setState(() {
      isLoading = true;
    });
    final res = await client.scanNetworkInterfaceList();
    if (res.isErr) {
      error = res.unwrapError();
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
      return;
    }

    final wifiList = res.unwrap();
    if (wifiList.isEmpty) {
      error = 'Wifi Scan List Empty';
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
    }
    activeHost = await client.scanSubnet(
      wifiList.first,
      ShareController.instance.port,
    );
    if (!mounted) return;
    setState(() {
      isLoading = false;
    });
  }

  ColorScheme get col => Theme.of(context).colorScheme;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
      },
      child: AlertDialog.adaptive(
        scrollable: true,
        content: isLoading
            ? Center(
                child: Column(
                  spacing: 10,
                  mainAxisAlignment: .center,
                  children: [
                    CircularProgressIndicator.adaptive(),
                    Text('Active Wifi Host Scanning......'),
                  ],
                ),
              )
            : SingleChildScrollView(
                child: activeHost.isEmpty
                    ? Column(
                        spacing: 10,
                        crossAxisAlignment: .center,
                        mainAxisAlignment: .center,
                        children: [
                          Text('Not Found!'),
                          FilledButton.icon(
                            label: Text('Rescan'),
                            onPressed: init,
                            icon: Icon(Icons.repeat),
                          ),
                        ],
                      )
                    : Column(
                        spacing: 10,
                        crossAxisAlignment: .start,
                        children: [
                          Text('Active Wifi Host'),
                          SizedBox(height: 5),
                          ...activeHost.map((e) {
                            return ListTile(
                              tileColor: col.primaryContainer,
                              shape: RoundedRectangleBorder(
                                borderRadius: .circular(15),
                              ),
                              title: Text(
                                e,
                                style: TextStyle(color: col.onPrimaryContainer),
                              ),
                              onTap: () {
                                context.pop<String>(e);
                              },
                            );
                          }),
                        ],
                      ),
              ),
        actions: [
          if (!isLoading)
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: col.error,
                foregroundColor: col.onError,
              ),
              onPressed: () {
                context.pop();
              },
              child: Text('Close'),
            ),
        ],
      ),
    );
  }
}
