/// Helper class for inserting ads into lists with smart frequency
class AdInsertionHelper {
  /// Insert ads into a list every N items
  /// Returns a new list with ads interleaved at specified intervals
  static List<T> insertAdsIntoList<T>(
    List<T> items,
    T adItem, {
    required int frequencyInterval,
  }) {
    if (items.isEmpty || frequencyInterval <= 0) return items;

    final result = <T>[];
    var adCount = 0;

    for (var i = 0; i < items.length; i++) {
      result.add(items[i]);

      // Add ad after every N items
      if ((i + 1) % frequencyInterval == 0 &&
          i + 1 < items.length &&
          adCount < _maxAdsPerScreen) {
        result.add(adItem);
        adCount++;
      }
    }

    return result;
  }

  /// Maximum ads to show per screen to avoid overwhelming users
  static const int _maxAdsPerScreen = 3;

  /// Standard frequency intervals for different screen types
  static const int frequencyHomeScreen = 4; // Show ad every 4 items
  static const int frequencyListScreen = 3; // Show ad every 3 items
  static const int frequencySettingsScreen = 5; // Show ad every 5 items

  /// Check if an item is an ad placeholder
  static bool isAdPlaceholder<T>(T item, T adItem) {
    return identical(item, adItem);
  }

  /// Build index from original index accounting for inserted ads
  static int getOriginalIndex<T>(
    int indexWithAds,
    int frequencyInterval,
  ) {
    var originalIndex = 0;
    var currentIndex = 0;

    while (currentIndex <= indexWithAds) {
      if (currentIndex % (frequencyInterval + 1) != frequencyInterval) {
        originalIndex++;
      }
      currentIndex++;
    }

    return originalIndex - 1;
  }
}
