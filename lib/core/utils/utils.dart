///sort((a, b)=> a2z ? naturalCompare(a.name, b.name):naturalCompare(b.name, a.name));
int naturalCompare(String a, String b) {
  final regex = RegExp(r'\d+|\D+');

  final aParts = regex.allMatches(a).map((e) => e.group(0)!).toList();
  final bParts = regex.allMatches(b).map((e) => e.group(0)!).toList();

  final length = aParts.length < bParts.length ? aParts.length : bParts.length;

  for (var i = 0; i < length; i++) {
    final x = aParts[i];
    final y = bParts[i];

    final xNum = int.tryParse(x);
    final yNum = int.tryParse(y);

    final result = xNum != null && yNum != null
        ? xNum.compareTo(yNum)
        : x.compareTo(y);

    if (result != 0) return result;
  }

  return aParts.length.compareTo(bParts.length);
}
