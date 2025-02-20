// ignore_for_file: unnecessary_this

import 'package:flutter/foundation.dart';

extension ExceptionalHandling on Object {
  void logException() {
    try {
      debugPrint('*========== Exception ==========*');
      debugPrint(this.toString());
      debugPrint('*========== Exception ==========*');
    } catch (exception) {
      debugPrint('*========== Exception ==========*');
      debugPrint(exception.toString());
      debugPrint('*========== Exception ==========*');
    }
  }
}
