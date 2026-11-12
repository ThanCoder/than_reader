import 'package:material_ui/material_ui.dart';
import 'package:than_reader/const_keys.dart';
import 'package:than_reader/core/constanst_keys.dart';
import 'package:than_reader/core/utils/app_utils.dart';
import 'package:than_reader/platforms/platform_app_switcher.dart';
import 'package:than_reader/theme/theme_provider.dart';

class PlatformApp extends StatefulWidget {
  const PlatformApp({super.key});

  @override
  State<PlatformApp> createState() => _PlatformAppState();
}

class _PlatformAppState extends State<PlatformApp> {
  final cf = AppUtil.instance.config;

  @override
  Widget build(BuildContext context) {
    return _body;
  }

  Widget get _body {
    return StreamBuilder(
      stream: cf.stream.put.where(
        (e) => e.key == appSeedsColorEnableKey || e.key == appSeedsColorIntKey,
      ),
      builder: (context, asyncSnapshot) {
        final seedInt = cf.getInt(appSeedsColorIntKey);
        final colorEnable = cf.getBool(appSeedsColorEnableKey);
        final enable = colorEnable && seedInt != 0;

        return MaterialThemeProvider(
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
              MaterialThemeProviderType.fromName(cf.getString(appThemeKeys)),
          onChanged: (MaterialThemeProviderType type) {
            cf.putAndWriteAll(appThemeKeys, type.name);
          },
          child: PlatformAppSwitcher(),
        );
      },
    );
  }
}
