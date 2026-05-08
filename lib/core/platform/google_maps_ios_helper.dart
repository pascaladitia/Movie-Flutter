import 'dart:io';

import 'package:flutter/services.dart';

class GoogleMapsIosHelper {
  static const MethodChannel _channel = MethodChannel('movie_flutter/maps');

  static Future<void> configure(String apiKey) async {
    if (!Platform.isIOS || apiKey.trim().isEmpty) return;
    await _channel.invokeMethod('setGoogleMapsApiKey', {'apiKey': apiKey});
  }
}
