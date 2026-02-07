import 'dart:io';
import 'package:flutter/foundation.dart';

/// Ad unit IDs for different platforms and environments
class AdUnitIds {
  // Test Ad IDs (from Google)
  static const String testBannerId = 'ca-app-pub-3940256099942544/6300978111';
  static const String testInterstitialId = 'ca-app-pub-3940256099942544/1033173712';
  static const String testNativeId = 'ca-app-pub-3940256099942544/2247696110';

  // Production Ad IDs
  static const String prodBannerIdAndroid = 'ca-app-pub-8394008055710959/1643308908';
  static const String prodBannerIdIos = 'ca-app-pub-8394008055710959/7549950123';
  static const String prodInterstitialIdAndroid = 'ca-app-pub-8394008055710959/5382951780';
  static const String prodInterstitialIdIos = 'ca-app-pub-8394008055710959/4923786789';

  /// Get appropriate banner ad ID based on platform and build mode
  static String getBannerId() {
    // Always use test ads in debug mode
    if (kDebugMode) return testBannerId;
    return Platform.isAndroid ? prodBannerIdAndroid : prodBannerIdIos;
  }

  /// Get appropriate interstitial ad ID based on platform and build mode
  static String getInterstitialId() {
    if (kDebugMode) return testInterstitialId;
    return Platform.isAndroid ? prodInterstitialIdAndroid : prodInterstitialIdIos;
  }
}
