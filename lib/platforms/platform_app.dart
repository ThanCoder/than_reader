import 'package:cfb_store/cfb_store.dart';
import 'package:flutter/material.dart';
import 'package:t_widgets/t_widgets.dart';
import 'package:than_reader/const_keys.dart';
import 'package:than_reader/core/constanst_keys.dart';
import 'package:than_reader/platforms/platform_app_switcher.dart';

class PlatformApp extends StatefulWidget {
  const PlatformApp({super.key});

  @override
  State<PlatformApp> createState() => _PlatformAppState();
}

class _PlatformAppState extends State<PlatformApp> {
  final cf = CFBStore.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: cf.stream.put.where(
        (e) => e.key == appSeedsColorEnableKey || e.key == appSeedsColorIntKey,
      ),
      builder: (context, asyncSnapshot) {
        final seedInt = cf.getInt(appSeedsColorIntKey);
        final colorEnable = cf.getBool(appSeedsColorEnableKey);
        final enable = colorEnable && seedInt != 0;

        return TMaterialThemeProvider(
          theme: !enable
              ? null
              : .light(useMaterial3: true).copyWith(
                  colorScheme: .fromSeed(
                    seedColor: Color(seedInt),
                    brightness: .light,
                  ),
                ),
          darkTheme: !enable
              ? null
              : .dark(useMaterial3: true).copyWith(
                  colorScheme: .fromSeed(
                    seedColor: Color(seedInt),
                    brightness: .dark,
                  ),
                ),
          getTheme: () =>
              TMaterialThemeProviderType.fromName(cf.getString(appThemeKeys)),
          onChanged: (TMaterialThemeProviderType type) {
            cf.putAndWriteAll(appThemeKeys, type.name);
          },
          child: PlatformAppSwitcher(),
        );
      },
    );
  }
}
