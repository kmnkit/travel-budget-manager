import 'dart:io';
import 'package:flutter/foundation.dart';

class AdHelper {
  static String get homeListBannerAdUnitId {
    if (kDebugMode) {
      return Platform.isAndroid
          ? 'ca-app-pub-3940256099942544/6300978111' // Test banner
          : 'ca-app-pub-3940256099942544/2934735716'; // Test banner
    }
    return Platform.isAndroid
        ? 'ca-app-pub-8394008055710959/9309291335' // TODO: Replace with real ID
        : 'ca-app-pub-8394008055710959/5617458337'; // TODO: Replace with real ID
  }

  static String get expenseListBannerAdUnitId {
    if (kDebugMode) {
      return Platform.isAndroid
          ? 'ca-app-pub-3940256099942544/6300978111'
          : 'ca-app-pub-3940256099942544/2934735716';
    }
    return Platform.isAndroid
        ? 'ca-app-pub-8394008055710959/7828688709'
        : 'ca-app-pub-8394008055710959/5600302572';
  }
}
