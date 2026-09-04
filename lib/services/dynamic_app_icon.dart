import 'package:flutter/services.dart';

class DynamicAppIcon {
  DynamicAppIcon._();

  static const MethodChannel _channel = MethodChannel('dynamic_app_icon');

  static Future<void> change(String icon) async {
    await _channel.invokeMethod('changeIcon', {'icon': icon});
  }

  static Future<String> current() async {
    final result = await _channel.invokeMethod<String>('getCurrentIcon');

    return result ?? 'default';
  }
}
