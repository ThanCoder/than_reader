import 'package:flutter/material.dart';
import 'package:t_widgets/t_widgets.dart';
import 'package:than_reader/platforms/pages/share_server/share_page.dart';

class ServerHomePage extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Share Server")),
      body: Center(
        child: Column(
          crossAxisAlignment: .center,
          mainAxisAlignment: .center,
          children: [
            FilledButton.icon(
              icon: Icon(Icons.share_outlined),
              onPressed: () {
                context.pushMaterialPageRoute(
                  builder: (mainCtx) => SharePage(),
                );
              },
              label: Text("Share"),
            ),
          ],
        ),
      ),
    );
  }
}
