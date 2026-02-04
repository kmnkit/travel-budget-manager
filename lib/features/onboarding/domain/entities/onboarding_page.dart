enum OnboardingPageType {
  welcome,
  features,
  getStarted,
}

class OnboardingPage {
  final OnboardingPageType type;
  final String titleKey;
  final String descriptionKey;
  final String iconName; // Material Icon name

  const OnboardingPage({
    required this.type,
    required this.titleKey,
    required this.descriptionKey,
    required this.iconName,
  });
}
