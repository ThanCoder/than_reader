import 'package:dart_core_extensions/dart_core_extensions.dart';
import 'package:flutter/material.dart';
import 'package:than_reader/core/utils/app_theme.dart';

class AppThemeChooser extends StatefulWidget {
  const AppThemeChooser({super.key});

  @override
  State<AppThemeChooser> createState() => _AppThemeChooserState();
}

class _AppThemeChooserState extends State<AppThemeChooser> {
  final list = AppThemeType.values;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Theme'),
          DropdownButton(
            hint: Text('Theme'),
            borderRadius: BorderRadius.circular(4),
            padding: EdgeInsets.all(3),
            value: AppThemeType.fromDB,
            items: list
                .map(
                  (e) => DropdownMenuItem(
                    value: e,
                    child: Text(e.name.toCaptalize),
                  ),
                )
                .toList(),
            onChanged: (value) async {
              await AppThemeType.setDB(value!);
              setState(() {});
              appThemeTypeNotifier.value = value;
            },
          ),
        ],
      ),
    );
  }
}
