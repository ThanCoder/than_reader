import 'package:flutter/foundation.dart';

void devPrint(Object? object, {String tag = '[Dev]:'}) {
  if (kDebugMode) {
    print('$tag $object');
  }
}
