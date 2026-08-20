import 'package:cfb_store/cfb_store.dart';
import 'package:flutter/material.dart';
import 'package:t_widgets/t_widgets.dart';
import 'package:than_reader/core/constanst_keys.dart';
import 'package:than_reader/platforms/components/color_picker_dialog.dart';

class AppSeedsColorChooser extends StatefulWidget {
  const AppSeedsColorChooser({super.key});

  @override
  State<AppSeedsColorChooser> createState() => _AppSeedsColorChooserState();
}

class _AppSeedsColorChooserState extends State<AppSeedsColorChooser> {
  final cf = CFBStore.instance;

  void pickColor(Color seedColor) async {
    final res = await showDialog<Color>(
      context: context,
      builder: (context) => ColorPickerDialog(pickerColor: seedColor),
    );
    if (res == null) return;
    cf.putAndWriteAll(appSeedsColorIntKey, res.toARGB32());
  }

  @override
  Widget build(BuildContext context) {
    final col = context.colorScheme;
    return StreamBuilder(
      stream: cf.stream.put.where(
        (e) => e.key == appSeedsColorEnableKey || e.key == appSeedsColorIntKey,
      ),
      builder: (context, asyncSnapshot) {
        final seedInt = cf.getInt(appSeedsColorIntKey);
        final colorEnable = cf.getBool(appSeedsColorEnableKey);
        Color seedColor = Colors.red;
        if (seedInt != 0) {
          seedColor = Color(seedInt);
        }
        return Container(
          padding: .symmetric(vertical: 14, horizontal: 14),
          decoration: BoxDecoration(
            borderRadius: .circular(15),
            color: col.surfaceContainer,
          ),
          child: Row(
            children: [
              Container(
                padding: .all(8),
                decoration: BoxDecoration(
                  borderRadius: .circular(15),
                  color: !colorEnable
                      ? col.tertiaryContainer.withValues(alpha: .45)
                      : col.tertiaryContainer,
                ),
                child: Icon(
                  Icons.color_lens_outlined,
                  color: !colorEnable
                      ? col.onTertiaryContainer.withValues(alpha: .45)
                      : col.onTertiaryContainer,
                ),
              ),
              SizedBox(width: 10),
              Column(
                spacing: 4,
                crossAxisAlignment: .start,
                children: [
                  Text(
                    'App Seeds Color',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: .w600,
                      color: !colorEnable
                          ? col.onSurface.withValues(alpha: .45)
                          : col.onSurface,
                    ),
                  ),
                  Text(
                    'How To Changed App Color Seeds.',
                    maxLines: 2,
                    overflow: .ellipsis,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: .w400,
                      color: !colorEnable
                          ? col.onSurfaceVariant.withValues(alpha: .45)
                          : col.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              // SizedBox(width: 50),
              if (colorEnable)
                InkWell(
                  onTap: () => pickColor(seedColor),
                  customBorder: CircleBorder(),
                  child: Container(
                    width: 30,
                    height: 30,
                    padding: .all(10),
                    decoration: BoxDecoration(
                      color: seedColor,
                      borderRadius: .circular(20),
                      border: .all(),
                    ),
                  ),
                ),
              Spacer(),
              Container(
                decoration: BoxDecoration(
                  borderRadius: .circular(30),
                  boxShadow: !colorEnable
                      ? null
                      : [
                          .new(
                            color: col.primary.withValues(alpha: .45),
                            blurRadius: 12,
                            spreadRadius: 1,
                          ),
                        ],
                ),
                child: Switch.adaptive(
                  value: colorEnable,
                  onChanged: (value) {
                    cf.putAndWriteAll(appSeedsColorEnableKey, value);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
