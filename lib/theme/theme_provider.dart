import 'package:material_ui/material_ui.dart';

enum MaterialThemeProviderType {
  system,
  light,
  dark;

  String get lable {
    if (this == light) return 'Light';
    if (this == dark) return 'Dark';
    return 'System';
  }

  static MaterialThemeProviderType fromName(String type) {
    if (type == light.name) return light;
    if (type == dark.name) return dark;
    return system;
  }
}

class MaterialThemeProvider extends StatefulWidget {
  /// use -> MaterialThemeProviderChooser
  ///
  const MaterialThemeProvider({
    super.key,
    required this.getTheme,
    required this.onChanged,
    required this.child,
    this.theme,
    this.darkTheme,
  });

  final Widget child;
  final MaterialThemeProviderType Function() getTheme;
  final void Function(MaterialThemeProviderType type) onChanged;
  final ThemeData? theme;
  final ThemeData? darkTheme;

  @override
  State<MaterialThemeProvider> createState() => _MaterialThemeProviderState();

  static final themeTypeNotifier = ValueNotifier<MaterialThemeProviderType>(
    .system,
  );

  static final MaterialThemeProviderChooser chooserWiget =
      MaterialThemeProviderChooser();
}

class _MaterialThemeProviderState extends State<MaterialThemeProvider>
    with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    MaterialThemeProvider.themeTypeNotifier.value = widget.getTheme();
    MaterialThemeProvider.themeTypeNotifier.addListener(() {
      widget.onChanged(MaterialThemeProvider.themeTypeNotifier.value);
    });
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
          theme: widget.theme ?? ThemeData.light(),
          darkTheme: widget.darkTheme ?? ThemeData.dark(useMaterial3: true),
          themeMode: currentThemeMode,
          home: widget.child,
        );
      },
    );
  }
}

class MaterialThemeProviderChooser extends StatefulWidget {
  const MaterialThemeProviderChooser({super.key, this.onChanged});
  final void Function(MaterialThemeProviderType type)? onChanged;

  @override
  State<MaterialThemeProviderChooser> createState() =>
      _MaterialThemeProviderChooserState();
}

class _MaterialThemeProviderChooserState
    extends State<MaterialThemeProviderChooser> {
  final items = MaterialThemeProviderType.values
      .map((e) => DropdownMenuItem(value: e, child: Text(e.lable)))
      .toList();

  @override
  Widget build(BuildContext context) {
    final col = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: col.surfaceContainer,
        borderRadius: .circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Row(
          children: [
            Container(
              padding: .all(8),
              decoration: BoxDecoration(
                borderRadius: .circular(15),
                color: col.surfaceContainerHigh,
              ),
              child: Icon(
                Icons.palette_outlined,
                size: 22,
                color: col.onSurface,
              ),
            ),

            const SizedBox(width: 12),

            const Expanded(
              child: Text(
                'Theme',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),

            ValueListenableBuilder<MaterialThemeProviderType>(
              valueListenable: MaterialThemeProvider.themeTypeNotifier,
              builder: (context, value, child) {
                return DropdownButtonHideUnderline(
                  child: DropdownButton<MaterialThemeProviderType>(
                    value: value,
                    items: items,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    icon: const Icon(Icons.keyboard_arrow_down_rounded),
                    dropdownColor: col.surfaceContainerHighest,
                    style: TextStyle(
                      color: col.onSurface,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    onChanged: (value) {
                      if (value != null) {
                        MaterialThemeProvider.themeTypeNotifier.value = value;
                        widget.onChanged?.call(value);
                      }
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
