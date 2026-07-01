import 'package:cfb_store/cfb_store.dart';
import 'package:dart_core_extensions/dart_core_extensions.dart';
import 'package:flutter/material.dart';

enum MaterialThemeProviderType {
  system,
  light,
  dark;

  static MaterialThemeProviderType fromName(String type) {
    if (type == light.name) return light;
    if (type == dark.name) return dark;
    return system;
  }
}

class MaterialThemeProvider extends StatefulWidget {
  final Widget child;
  const MaterialThemeProvider({super.key, required this.child});

  @override
  State<MaterialThemeProvider> createState() => _MaterialThemeProviderState();

  static final themeTypeNotifier = ValueNotifier<MaterialThemeProviderType>(
    MaterialThemeProviderType.fromName(
      CFBStore.getInstance.getString('app-theme'),
    ),
  );
  static void setTheme(MaterialThemeProviderType type) {
    themeTypeNotifier.value = type;
    CFBStore.getInstance.put('app-theme', type.name);
    CFBStore.getInstance.writeAll();
  }
}

class _MaterialThemeProviderState extends State<MaterialThemeProvider>
    with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    MaterialThemeProvider.themeTypeNotifier.value =
        MaterialThemeProviderType.fromName(
          CFBStore.getInstance.getString('app-theme'),
        );
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangePlatformBrightness() {
    super.didChangePlatformBrightness();
    if (MaterialThemeProvider.themeTypeNotifier.value == .system) {
      setState(() {});
    }
  }

  ThemeMode get currentThemeMode {
    final themeType = MaterialThemeProvider.themeTypeNotifier.value;
    return switch (themeType) {
      .dark => .dark,
      .light => .light,
      _ => .system,
    };
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: MaterialThemeProvider.themeTypeNotifier,
      builder: (context, value, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: currentThemeMode,
          home: widget.child,
        );
      },
    );
  }
}

class MaterialThemeProviderChooser extends StatelessWidget {
  MaterialThemeProviderChooser({super.key});

  final items = MaterialThemeProviderType.values
      .map((e) => DropdownMenuItem(value: e, child: Text(e.name.toCaptalize)))
      .toList();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: 5),
        Expanded(
          child: Text(
            'Theme',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        ValueListenableBuilder(
          valueListenable: MaterialThemeProvider.themeTypeNotifier,
          builder: (context, value, child) {
            return DropdownButton(
              padding: EdgeInsets.all(4),
              borderRadius: BorderRadius.circular(4),
              value: MaterialThemeProvider.themeTypeNotifier.value,
              items: items,
              onChanged: (value) {
                MaterialThemeProvider.setTheme(value!);
              },
            );
          },
        ),
      ],
    );
  }
}
