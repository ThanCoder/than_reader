import 'package:flutter/material.dart';
import 'package:t_client/t_client.dart';
import 'package:t_widgets/t_widgets.dart';
import 'package:than_reader/apps/server/client/client_api_page.dart';
import 'package:than_reader/apps/server/client/client_ui_page.dart';
import 'package:than_reader/apps/server/reader_file_share.dart';
import 'package:than_reader/apps/server/utils.dart';
import 'package:than_reader/core/context_extensions.dart';
import 'package:than_reader/than_dev.dart';

class ClientHomeScreen extends StatefulWidget {
  const ClientHomeScreen({super.key});

  @override
  State<ClientHomeScreen> createState() => _ClientHomeScreenState();
}

class _ClientHomeScreenState extends State<ClientHomeScreen> {
  @override
  void initState() {
    super.initState();
    checkConnection();
  }

  @override
  void dispose() {
    super.dispose();
  }

  static String? activeHost;
  final share = ReaderFileShare.instance;
  final client = TClient();
  bool isLoading = false;
  List<String> allWifiList = [];

  Future<void> checkConnection() async {
    try {
      setState(() {
        isLoading = true;
      });
      // final wifiList = await share.allWifiList;
      activeHost = await findActiveHostAddress(port: 4445);
      allWifiList = await share.allWifiList;

      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      devPrint(e.toString());
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
      showTMessageDialogError(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    // devPrint('activeHost: $activeHost - ${activeHost == null}');
    return Scaffold(
      appBar: AppBar(
        title: Text('Book Client'),
        actions: [
          IconButton(
            onPressed: checkConnection,
            icon: Icon(Icons.connect_without_contact),
          ),
        ],
      ),
      body: bodyWidget,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: pageIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: context.darkMode ? Colors.white : Colors.black,
        onTap: (value) {
          setState(() {
            pageIndex = value;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.api), label: 'Api'),
        ],
      ),
    );
  }

  int pageIndex = 0;

  Widget get bodyWidget {
    if (isLoading) {
      return Center(child: TLoaderRandom());
    }
    if (activeHost == null) {
      return hostNullWidget;
    }

    return IndexedStack(
      index: pageIndex,
      children: [
        ClientUiPage(hostUrl: activeHost ?? ''),
        ClientApiPage(hostUrl: activeHost ?? ''),
      ],
    );
  }

  Widget get hostNullWidget {
    return Center(
      child: Column(
        mainAxisAlignment: .center,
        crossAxisAlignment: .center,
        spacing: 5,
        children: [
          Text(
            'Server Not Found!',
            style: TextStyle(
              fontSize: 18,
              fontWeight: .bold,
              color: Colors.red,
            ),
          ),
          IconButton(
            color: Colors.blue,
            onPressed: checkConnection,
            icon: Icon(Icons.connect_without_contact, size: 50),
          ),
          if (allWifiList.isNotEmpty) Text('Scanned Wifi List:'),
          Column(
            children: allWifiList
                .map(
                  (e) => TextButton(
                    onPressed: () {
                      checkHostAddress(e);
                    },
                    child: Text(e),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  void checkHostAddress(String hostAddresss) async {
    setState(() {
      isLoading = true;
    });
    activeHost = await checkHost(hostAddresss, share.server.port!);
    if (!mounted) return;
    setState(() {
      isLoading = false;
    });
  }
}
