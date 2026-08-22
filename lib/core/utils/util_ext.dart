import 'package:dart_core_extensions/dart_core_extensions.dart';

extension UtilDateExt on DateTime {
  String formatFullDate() {
    return '$year-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')} : ${formatTime()}';
  }
}
