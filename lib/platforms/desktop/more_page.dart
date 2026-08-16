import 'package:flutter/material.dart';
import 'package:t_widgets/t_widgets.dart';
import 'package:than_reader/platforms/components/app_seeds_color_chooser.dart';

class MorePage extends StatelessWidget {
  const MorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colorScheme.surface,
      appBar: AppBar(title: Text('More')),
      body: Column(
        spacing: 5,
        children: [TMaterialThemeProviderChooser(), AppSeedsColorChooser()],
      ),
    );
  }
}
