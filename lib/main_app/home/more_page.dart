import 'package:flutter/material.dart';
import 'package:than_reader/core/partials/app_theme_chooser.dart';

class MorePage extends StatelessWidget {
  const MorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("More Apps")),
      body: ListView(children: [AppThemeChooser()]),
    );
  }
}
