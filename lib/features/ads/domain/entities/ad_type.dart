/// Enum for different types of ads supported
enum AdType {
  banner,
  interstitial,
  rewarded,
}

extension AdTypeExtension on AdType {
  /// Get a readable string representation of the ad type
  String get displayName {
    switch (this) {
      case AdType.banner:
        return 'Banner';
      case AdType.interstitial:
        return 'Interstitial';
      case AdType.rewarded:
        return 'Rewarded';
    }
  }

  /// Get the ad type from string
  static AdType? fromString(String? value) {
    if (value == null) return null;
    try {
      return AdType.values.firstWhere(
        (type) => type.toString().split('.').last == value,
      );
    } catch (e) {
      return null;
    }
  }
}
