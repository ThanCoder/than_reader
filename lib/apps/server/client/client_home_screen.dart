import 'package:flutter/material.dart';
import 'package:t_client/t_client.dart';
import 'package:t_widgets/t_widgets.dart';
import 'package:than_reader/apps/server/client/client_api_page.dart';
import 'package:than_reader/apps/server/client/client_ui_page.dart';
import 'package:than_reader/apps/server/reader_file_share.dart';
import 'package:than_reader/apps/server/utils.dart';
import 'package:than_reader/core/context_extensions.dart';

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

  static String? activeHost;
  final share = ReaderFileShare.instance;
  final client = TClient();
  bool isLoading = false;

  Future<void> checkConnection() async {
    try {
      setState(() {
        isLoading = true;
      });
      // final wifiList = await share.allWifiList;
      activeHost = await findActiveHostAddress(port: 4445);

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
      Center(
        child: Text(
          'Server Not Found!',
          style: TextStyle(fontSize: 18, fontWeight: .bold, color: Colors.red),
        ),
      );
    }

    return IndexedStack(
      index: pageIndex,
      children: [
        ClientUiPage(hostUrl: activeHost ?? ''),
        ClientApiPage(hostUrl: activeHost ?? ''),
      ],
    );

    // return Center(
    //   child: Text(
    //     'Active Host: $activeHost',
    //     style: TextStyle(fontSize: 18, fontWeight: .bold, color: Colors.green),
    //   ),
    // );
  }
}
