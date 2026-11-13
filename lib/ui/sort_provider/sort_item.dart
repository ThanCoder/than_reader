part of 'sort_provider.dart';

///Sort Item
class SortItem {
  final int id;
  final String title;
  final bool isTrue;
  final String trueTitle;
  final String falseTitle;
  new({
    required this.id,
    required this.title,
    required this.isTrue,
    required this.trueTitle,
    required this.falseTitle,
  });

  ///default name
  ///
  ///trueTitle: "A To Z",
  static final nameItem = SortItem(
    id: 1000,
    title: 'Name',
    trueTitle: "A To Z",
    falseTitle: 'Z To A',
    isTrue: true,
  );

  /// default data
  ///
  /// trueTitle: "New To Old",
  static final dateItem = SortItem(
    id: 1001,
    title: 'Date',
    trueTitle: "New To Old",
    falseTitle: 'Old To New',
    isTrue: true,
  );

  ///  trueTitle: "Small To Big",
  static final sizeItem = SortItem(
    id: 1,
    title: 'Size',
    isTrue: true,
    trueTitle: "Small To Big",
    falseTitle: "Big To Small",
  );

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

  SortItem copyWith({
    int? id,
    String? title,
    bool? isTrue,
    String? trueTitle,
    String? falseTitle,
  }) {
    return SortItem(
      id: id ?? this.id,
      title: title ?? this.title,
      isTrue: isTrue ?? this.isTrue,
      trueTitle: trueTitle ?? this.trueTitle,
      falseTitle: falseTitle ?? this.falseTitle,
    );
  }
}
