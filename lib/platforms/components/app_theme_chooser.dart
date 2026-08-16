import 'package:cfb_store/cfb_store.dart';
import 'package:flutter/material.dart';
import 'package:t_widgets/t_widgets.dart';
import 'package:than_reader/const_keys.dart';
import 'package:than_reader/platforms/components/menu_item.dart';

class AppThemeChooser extends StatefulWidget {
  const AppThemeChooser({super.key});

  @override
  State<AppThemeChooser> createState() => _AppThemeChooserState();
}

class _AppThemeChooserState extends State<AppThemeChooser> {
  late final col = context.colorScheme;
  final items = TMaterialThemeProviderType.values
      .map(
        (e) => DropdownMenuItem<TMaterialThemeProviderType>(
          value: e,
          child: Text(e.lable),
        ),
      )
      .toList();
  final cf = CFBStore.instance;

  @override
  Widget build(BuildContext context) {
    return MenuItem(
      title: 'App Theme',
      subTitle: 'Dark && Light Switcher',
      leadingIcon: Icons.color_lens,
      trailingWidget: StreamBuilder(
        stream: cf.stream.put.where((e) => e.key == appThemeKeys),
        builder: (context, asyncSnapshot) {
          return DropdownButtonHideUnderline(
            child: DropdownButton(
              borderRadius: .circular(15),
              value: TMaterialThemeProviderType.fromName(
                cf.getString(appThemeKeys),
              ),
              items: items,
              onChanged: (value) {
                cf.putAndWriteAll(appThemeKeys, value!.name);
              },
            ),
          );
        },
      ),
    );
  }
}
