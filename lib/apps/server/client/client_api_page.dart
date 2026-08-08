// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:t_client/t_client.dart';
import 'package:t_widgets/t_widgets.dart';

class ResultItem {
  final String message;
  final bool isError;
  const ResultItem({required this.message, this.isError = false});
}

class ClientApiPage extends StatefulWidget {
  final String hostUrl;
  const ClientApiPage({super.key, required this.hostUrl});

  @override
  State<ClientApiPage> createState() => _ClientApiPageState();
}

class _ClientApiPageState extends State<ClientApiPage> {
  @override
  void initState() {
    super.initState();
    fetchApi();
  }

  final client = TClient();
  bool isLoading = false;
  List<ResultItem> resultList = [];

  Future<void> fetchApi({String apiUrl = '/api'}) async {
    if (widget.hostUrl.isEmpty) return;

    try {
      final url = '${widget.hostUrl}$apiUrl';
      resultList.add(.new(message: 'Fetching: `Url: $url`', isError: false));
      setState(() {
        isLoading = true;
      });
      final res = await client.get(url);
      resultList.add(.new(message: 'statusCode: ${res.statusCode}'));

      if (res.statusCode == HttpStatus.ok) {
        resultList.add(.new(message: res.data.toString()));
      }
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      resultList.add(.new(message: e.toString(), isError: true));
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
      showTMessageDialogError(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return bodyWidget;
  }

  Widget get bodyWidget {
    return CustomScrollView(
      slivers: [
        // api buttons
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: .center,
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 20),
                child: apiFetchButton,
              ),
              Divider(),
            ],
          ),
        ),
        if (isLoading)
          SliverFillRemaining(child: Center(child: TLoaderRandom()))
        else
          SliverList.separated(
            itemCount: resultList.length,
            separatorBuilder: (context, index) => Divider(),
            itemBuilder: (context, index) {
              final res = resultList[index];
              return SelectableText(
                res.message,
                style: TextStyle(
                  color: res.isError ? Colors.red : Colors.green,
                ),
              );
            },
          ),
      ],
    );
  }

  Widget get apiFetchButton {
    return Row(
      mainAxisAlignment: .center,
      children: [
        IconButton(
          onPressed: () {
            resultList.clear();
            setState(() {});
          },
          icon: Icon(Icons.clear_all),
        ),
        TextButton(onPressed: fetchApi, child: Text('Fetch Api')),
        TextButton(
          onPressed: () => fetchApi(apiUrl: '/api/books'),
          child: Text('Fetch Books'),
        ),
      ],
    );
  }
}
