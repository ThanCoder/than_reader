import 'package:material_ui/material_ui.dart';

import '../index.dart';

part 'sort_item.dart';

class SortProviderButton extends StatelessWidget {
  const new({
    super.key,
    required this.value,
    required this.list,
    this.onApply,
    this.title,
  });

  final List<SortItem> list;
  final SortItem value;
  final void Function(SortItem item)? onApply;
  final String? title;

  @override
  Widget build(BuildContext context) {
    final col = context.colorScheme;
    return IconButton(
      style: IconButton.styleFrom(
        backgroundColor: col.surfaceContainerHighest,
        foregroundColor: col.onSurface,
      ),
      onPressed: () async {
        final res = await showModalBottomSheet<SortItem>(
          context: context,
          showDragHandle: true,
          builder: (context) =>
              SortProviderDialog(list: list, value: value, title: title),
        );
        if (res == null) return;
        onApply?.call(res);
      },
      icon: Icon(Icons.sort),
    );
  }
}

class SortProviderDialog extends StatefulWidget {
  const SortProviderDialog({
    super.key,
    required this.list,
    required this.value,
    this.title,
  });
  final List<SortItem> list;
  final SortItem value;
  final String? title;
  @override
  State<SortProviderDialog> createState() => _SortProviderDialogState();

  static Widget buttonWidget({
    required SortItem value,
    required List<SortItem> list,
    void Function(SortItem item)? onApply,
    String? title,
  }) => SortProviderButton(
    value: value,
    list: list,
    title: title,
    onApply: onApply,
  );
}

class _SortProviderDialogState extends State<SortProviderDialog> {
  late SortItem item;

  @override
  void initState() {
    super.initState();
    item = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    final col = context.colorScheme;
    final textTheme = context.textTheme;
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        Navigator.pop<SortItem>(context, item);
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          spacing: 4,
          children: [
            // Header
            _header(col, textTheme),

            // Sort group
            sortGropWidget,

            SizedBox(height: 1),

            // Sort result
            sortResultWidgt,

            // Apply
            // applyWidget,
          ],
        ),
      ),
    );
  }

  SizedBox _header(ColorScheme col, TextTheme textTheme) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(4, 4, 4, 12),
        child: Row(
          children: [
            Container(
              padding: .all(5),
              decoration: BoxDecoration(
                borderRadius: .circular(10),
                color: col.surfaceContainerHighest,
              ),
              child: Icon(Icons.sort, color: col.onSurface),
            ),
            SizedBox(width: 10),
            Text(
              'Sort By',
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget get sortGropWidget {
    final col = context.colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: col.surfaceContainer,
        border: Border.all(color: col.outlineVariant),
      ),
      child: Material(
        color: col.surfaceContainer,

        child: RadioGroup<SortItem>(
          groupValue: item,
          onChanged: (value) {
            setState(() {
              item = value!;
            });
          },
          child: Column(
            spacing: 4,
            children: widget.list
                .map(
                  (e) => RadioListTile.adaptive(
                    tileColor: e.id != item.id
                        ? null
                        : col.surfaceContainerHighest,
                    shape: RoundedRectangleBorder(borderRadius: .circular(10)),
                    value: e,
                    title: Text(e.title),
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }

  Widget get sortResultWidgt {
    final col = context.colorScheme;
    return Container(
      padding: .symmetric(vertical: 16, horizontal: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: col.surfaceContainer,
        border: .all(color: col.outlineVariant),
      ),
      child: Material(
        color: col.surfaceContainer,
        child: RadioGroup<bool>(
          groupValue: item.isTrue,
          onChanged: (value) {
            item = item.copyWith(isTrue: value);
            setState(() {});
          },
          child: Column(
            spacing: 4,
            children: [
              RadioListTile.adaptive(
                tileColor: !item.isTrue ? null : col.surfaceContainerHighest,
                shape: RoundedRectangleBorder(borderRadius: .circular(10)),
                value: true,
                title: Text(item.trueTitle),
              ),
              RadioListTile.adaptive(
                tileColor: item.isTrue ? null : col.surfaceContainerHighest,
                shape: RoundedRectangleBorder(borderRadius: .circular(10)),
                value: false,
                title: Text(item.falseTitle),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
