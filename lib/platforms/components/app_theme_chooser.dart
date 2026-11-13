import 'package:cfb_store/cfb_store.dart';
import 'package:material_ui/material_ui.dart';
import 'package:than_reader/const_keys.dart';
import 'package:than_reader/platforms/components/menu_item.dart';
import 'package:than_reader/ui/build_context_x.dart';
import 'package:than_reader/ui/theme/theme_provider.dart';

class AppThemeChooser extends StatefulWidget {
  const AppThemeChooser({super.key});

  @override
  State<AppThemeChooser> createState() => _AppThemeChooserState();
}

class _AppThemeChooserState extends State<AppThemeChooser> {
  late final col = context.colorScheme;
  final items = MaterialThemeProviderType.values
      .map(
        (e) => DropdownMenuItem<MaterialThemeProviderType>(
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
              value: MaterialThemeProviderType.fromName(
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
