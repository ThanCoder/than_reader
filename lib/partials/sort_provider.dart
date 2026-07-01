// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

///Sort Item
class SortItem {
  final int id;
  final Widget title;
  final bool isTrue;
  final Widget trueTitle;
  final Widget falseTitle;
  SortItem({
    required this.id,
    required this.title,
    required this.isTrue,
    required this.trueTitle,
    required this.falseTitle,
  });

  ///default name
  static final nameSortItem = SortItem(
    id: 1000,
    title: Text('Name'),
    trueTitle: Text("A To Z"),
    falseTitle: Text('Z To A'),
    isTrue: true,
  );

  /// default data
  static final dateSortItem = SortItem(
    id: 1001,
    title: Text('Date'),
    trueTitle: Text("New To Old"),
    falseTitle: Text('Old To New'),
    isTrue: true,
  );
  static final sizeSortItem = SortItem(
  id: 1,
  title: Text('Size'),
  isTrue: true,
  trueTitle: Text("Small To Big"),
  falseTitle: Text("Big To Small"),
);


  SortItem copyWith({
    int? id,
    Widget? title,
    Widget? trueTitle,
    Widget? falseTitle,
    bool? isTrue,
  }) {
    return SortItem(
      id: id ?? this.id,
      title: title ?? this.title,
      trueTitle: trueTitle ?? this.trueTitle,
      falseTitle: falseTitle ?? this.falseTitle,
      isTrue: isTrue ?? this.isTrue,
    );
  }

  @override
  String toString() {
    return 'SortItem(id: $id, title: $title, isTrue: $isTrue, trueTitle: $trueTitle, falseTitle: $falseTitle)';
  }

  // ပြဿနာကို ဖြေရှင်းပေးမယ့် ကုဒ်အပိုင်းအစ
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SortItem && runtimeType == other.runtimeType && id == other.id; // ID တူရင် Object ချင်း တူတယ်လို့ သတ်မှတ်ခိုင်းတာပါ

  @override
  int get hashCode => id.hashCode;
}

class SortButton extends StatelessWidget {
  final List<SortItem> list;
  final SortItem value;
  final BoxConstraints? boxConstraints;
  final void Function(SortItem item)? onApply;
  final Widget? title;
  const SortButton({
    super.key,
    required this.value,
    required this.list,
    this.onApply,
    this.title,
    this.boxConstraints,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async {
        final res = await showModalBottomSheet<SortItem>(
          context: context,
          builder: (context) => SortProviderDialog(
            list: list,
            value: value,
            title: title,
            boxConstraints: boxConstraints,
          ),
        );
        if (res == null) return;
        onApply?.call(res);
      },
      icon: Icon(Icons.sort),
    );
  }
}

class SortProviderDialog extends StatefulWidget {
  final List<SortItem> list;
  final SortItem value;
  final Widget? title;
  final BoxConstraints? boxConstraints;
  const SortProviderDialog({
    super.key,
    required this.list,
    required this.value,
    this.boxConstraints,
    this.title,
  });

  @override
  State<SortProviderDialog> createState() => _SortProviderDialogState();
}

class _SortProviderDialogState extends State<SortProviderDialog> {
  late SortItem item;
  @override
  void initState() {
    item = widget.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints:
          widget.boxConstraints ?? const BoxConstraints(minHeight: 400),
      child: SingleChildScrollView(
        child: Column(
          spacing: 2,
          children: [
            widget.title ?? ListTile(title: Text("Sort By")),
            Divider(),
            sortGropWidget,
            Divider(),

            sortResultWidgt,
            Divider(),
            applyWidget,
          ],
        ),
      ),
    );
  }

  Widget get sortGropWidget {
    return RadioGroup<SortItem>(
      groupValue: item,
      onChanged: (value) {
        setState(() {
          item = value!;
        });
      },
      child: Column(
        children: widget.list
            .map(
              (e) => RadioListTile<SortItem>.adaptive(value: e, title: e.title),
            )
            .toList(),
      ),
    );
  }

  Widget get sortResultWidgt {
    return RadioGroup<bool>(
      groupValue: item.isTrue,
      onChanged: (bool? value) {
        item = item.copyWith(isTrue: value);
        setState(() {});
      },
      child: Column(
        children: [
          RadioListTile<bool>.adaptive(value: true, title: item.trueTitle),
          RadioListTile<bool>.adaptive(value: false, title: item.falseTitle),
        ],
      ),
    );
  }

  Widget get applyWidget {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: .end,
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop<SortItem>(context, item);
            },
            child: Text('Apply'),
          ),
        ],
      ),
    );
  }
}
