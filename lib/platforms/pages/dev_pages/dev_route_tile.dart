import 'package:flutter/material.dart';

import 'dev_home_page.dart';

import 'package:t_widgets/t_widgets.dart';

class DevRouteTile extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final col = Theme.of(context).colorScheme;
    return ListTile(
      tileColor: col.surfaceContainer,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Icon(
        Icons.code_rounded,
        color: Theme.of(context).colorScheme.primary,
      ),
      title: const Text(
        'Developer',
        style: TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: const Text('About the developer'),
      trailing: const Icon(Icons.chevron_right_rounded),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      onTap: () {
        context.pushMaterialPageRoute(
          builder: (mainCtx) => const DevHomePage(),
        );
      },
    );
  }
}
