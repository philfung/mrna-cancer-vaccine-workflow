import 'dart:js' as js;
import 'package:flutter/foundation.dart';

class AnalyticsUtils {
  static void logEvent(String name, [Map<String, dynamic>? parameters]) {
    if (!kIsWeb) return;

    try {
      if (parameters != null) {
        js.context.callMethod('gtag', [
          'event',
          name,
          js.JsObject.jsify(parameters),
        ]);
      } else {
        js.context.callMethod('gtag', [
          'event',
          name,
        ]);
      }
      debugPrint('GA4 Event logged: $name ${parameters ?? ""}');
    } catch (e) {
      debugPrint('Error logging GA4 event: $e');
    }
  }
}
