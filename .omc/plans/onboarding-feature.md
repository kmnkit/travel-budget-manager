# Onboarding Feature Implementation Plan

## Context

### Original Request
앱을 처음 시작하는 유저를 위한 onboarding 기능 개발

### Project Context
TripWallet is a Flutter travel expense management app with:
- Clean Architecture (domain/data/presentation layers)
- Riverpod v3 state management
- Drift SQLite database
- GoRouter navigation
- Material Design 3 with Teal #00897B primary color
- i18n support (Korean/English) via intl/ARB
- TDD enforcement (tests required for all code)

### Research Findings
- App entry: `lib/main.dart` initializes SharedPreferences and wraps app in ProviderScope
- Router: `lib/core/router/app_router.dart` uses GoRouter with `initialLocation: '/'`
- SharedPreferences already integrated via `sharedPreferencesProvider`
- Settings patterns exist in `lib/features/settings/presentation/providers/settings_providers.dart`
- Localization has 137 strings across `app_en.arb` and `app_ko.arb`
- Theme: Teal #00897B, 12px border radius, Lexend font, Material 3
- Testing: mocktail for mocks, ConsumerWidget pattern

---

## Work Objectives

### Core Objective
Implement a first-time user onboarding flow that introduces TripWallet's key features and allows users to skip or complete the onboarding.

### Deliverables
1. **Onboarding feature module** following Clean Architecture
2. **3-page onboarding flow**: Welcome, Features, Get Started
3. **First-time detection** via SharedPreferences
4. **GoRouter integration** with redirect logic
5. **Full localization** (Korean/English)
6. **Unit and widget tests** following TDD

### Definition of Done
- [ ] Onboarding screens display correctly on first app launch
- [ ] User can swipe through pages or use Next/Skip buttons
- [ ] Completing onboarding navigates to HomeScreen
- [ ] Skipping onboarding navigates to HomeScreen
- [ ] Returning users go directly to HomeScreen (no onboarding)
- [ ] All UI follows existing design system (Teal theme, 12px radius, Lexend font)
- [ ] Full Korean and English localization
- [ ] `flutter analyze` passes with zero warnings
- [ ] `flutter test` passes with zero failures
- [ ] Coverage for: provider logic, onboarding completion, widget rendering

---

## Guardrails

### Must Have
- SharedPreferences for onboarding completion persistence
- GoRouter redirect for conditional navigation
- Riverpod provider for onboarding state
- Page indicator dots for multi-page flow
- Skip button on all pages
- Get Started button on final page
- Consistent theming with existing app

### Must NOT Have
- Database changes (no Drift modifications)
- New dependencies (use existing packages only)
- Hardcoded strings (all text must be localized)
- Breaking changes to existing screens or routes

---

## Task Flow

```
[1] Domain Layer Setup
    └── [2] Data Layer Setup
        └── [3] Presentation Layer Setup
            ├── [4] Router Integration
            └── [5] Localization
                └── [6] Tests
                    └── [7] Integration & Polish
```

---

## Detailed Implementation

### Task 1: Domain Layer Setup

**Files to Create:**
- `lib/features/onboarding/domain/entities/onboarding_page.dart`
- `lib/features/onboarding/domain/repositories/onboarding_repository.dart`

**Implementation:**

```dart
// lib/features/onboarding/domain/entities/onboarding_page.dart
enum OnboardingPageType {
  welcome,
  features,
  getStarted,
}

class OnboardingPage {
  final OnboardingPageType type;
  final String titleKey;      // Localization key
  final String descriptionKey; // Localization key
  final String assetPath;      // Icon or illustration path

  const OnboardingPage({
    required this.type,
    required this.titleKey,
    required this.descriptionKey,
    required this.assetPath,
  });
}
```

```dart
// lib/features/onboarding/domain/repositories/onboarding_repository.dart
abstract class OnboardingRepository {
  Future<bool> isOnboardingCompleted();
  Future<void> setOnboardingCompleted(bool completed);
}
```

**Acceptance Criteria:**
- [ ] OnboardingPage entity defines page structure with localization keys
- [ ] OnboardingRepository interface defines persistence contract
- [ ] No external dependencies in domain layer

---

### Task 2: Data Layer Setup

**Files to Create:**
- `lib/features/onboarding/data/repositories/onboarding_repository_impl.dart`

**Implementation:**

```dart
// lib/features/onboarding/data/repositories/onboarding_repository_impl.dart
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/repositories/onboarding_repository.dart';

class OnboardingRepositoryImpl implements OnboardingRepository {
  final SharedPreferences _prefs;
  static const _key = 'onboarding_completed';

  OnboardingRepositoryImpl(this._prefs);

  @override
  Future<bool> isOnboardingCompleted() async {
    return _prefs.getBool(_key) ?? false;
  }

  @override
  Future<void> setOnboardingCompleted(bool completed) async {
    await _prefs.setBool(_key, completed);
  }
}
```

**Acceptance Criteria:**
- [ ] Repository uses SharedPreferences with key 'onboarding_completed'
- [ ] Default value is `false` (show onboarding)
- [ ] Persistence works across app restarts

---

### Task 3: Presentation Layer Setup

**Files to Create:**
- `lib/features/onboarding/presentation/providers/onboarding_providers.dart`
- `lib/features/onboarding/presentation/screens/onboarding_screen.dart`
- `lib/features/onboarding/presentation/widgets/onboarding_page_widget.dart`
- `lib/features/onboarding/presentation/widgets/page_indicator.dart`

**3.1 Providers:**

```dart
// lib/features/onboarding/presentation/providers/onboarding_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trip_wallet/features/settings/presentation/providers/settings_providers.dart';
import '../../data/repositories/onboarding_repository_impl.dart';
import '../../domain/repositories/onboarding_repository.dart';

final onboardingRepositoryProvider = Provider<OnboardingRepository>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return OnboardingRepositoryImpl(prefs);
});

final onboardingCompletedProvider = FutureProvider<bool>((ref) async {
  final repo = ref.watch(onboardingRepositoryProvider);
  return repo.isOnboardingCompleted();
});

final currentPageProvider = NotifierProvider<CurrentPageNotifier, int>(
  CurrentPageNotifier.new,
);

class CurrentPageNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void setPage(int page) => state = page;
  void nextPage() => state++;
  void previousPage() => state--;
}
```

**3.2 Screen:**

```dart
// lib/features/onboarding/presentation/screens/onboarding_screen.dart
// ConsumerStatefulWidget with PageController
// 3 pages: welcome, features, getStarted
// Skip button, Next/GetStarted button, Page indicator
// Uses AppColors.primary for theming
```

**3.3 Widgets:**

```dart
// lib/features/onboarding/presentation/widgets/onboarding_page_widget.dart
// Displays: Icon/Image, Title, Description
// Uses Theme.of(context).textTheme for consistent typography
// 24px padding, centered content

// lib/features/onboarding/presentation/widgets/page_indicator.dart
// Horizontal dots showing current page
// Active dot: AppColors.primary
// Inactive dot: AppColors.textHint
// 8px dot size, 4px spacing
```

**Acceptance Criteria:**
- [ ] PageController syncs with currentPageProvider
- [ ] Skip button visible on all pages
- [ ] Next button on pages 0-1, Get Started on page 2
- [ ] Smooth page transitions with animation
- [ ] Page indicator shows current position

---

### Task 4: Router Integration

**Files to Modify:**
- `lib/core/router/app_router.dart`

**Implementation:**

```dart
// Add import
import 'package:trip_wallet/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:trip_wallet/features/onboarding/presentation/providers/onboarding_providers.dart';

// Modify routerProvider to accept ref for redirect logic
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) async {
      // Check if navigating to onboarding
      if (state.matchedLocation == '/onboarding') {
        return null; // Allow
      }

      // Check onboarding status for root route
      if (state.matchedLocation == '/') {
        final onboardingAsync = ref.read(onboardingCompletedProvider);
        final isCompleted = onboardingAsync.valueOrNull ?? false;
        if (!isCompleted) {
          return '/onboarding';
        }
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      // ... existing routes
    ],
  );
});
```

**Alternative Approach (Simpler - Widget-based):**

If redirect complexity is an issue, use a wrapper widget approach:

```dart
// lib/app.dart - modify to check onboarding at app level
class TripWalletApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onboardingAsync = ref.watch(onboardingCompletedProvider);

    return onboardingAsync.when(
      loading: () => const MaterialApp(home: SplashScreen()),
      error: (_, __) => /* normal app */,
      data: (completed) {
        if (!completed) {
          return MaterialApp(home: OnboardingScreen(onComplete: () {
            ref.read(onboardingRepositoryProvider).setOnboardingCompleted(true);
            ref.invalidate(onboardingCompletedProvider);
          }));
        }
        return /* normal MaterialApp.router */;
      },
    );
  }
}
```

**Recommendation:** Use the widget-based approach for simplicity. It avoids async redirect issues in GoRouter.

**Acceptance Criteria:**
- [ ] First launch shows OnboardingScreen
- [ ] After completion, HomeScreen is shown
- [ ] App restart after completion goes directly to HomeScreen
- [ ] No flash of wrong screen during transition

---

### Task 5: Localization

**Files to Modify:**
- `lib/l10n/app_en.arb`
- `lib/l10n/app_ko.arb`

**Strings to Add:**

```json
// app_en.arb - add after "@_SETTINGS" section
"@_ONBOARDING": {},
"onboardingWelcomeTitle": "Welcome to TripWallet",
"onboardingWelcomeDescription": "Your smart travel companion for managing expenses across multiple currencies",
"onboardingFeaturesTitle": "Track Your Expenses",
"onboardingFeaturesDescription": "Record expenses in any currency with automatic conversion. Categorize by type and payment method.",
"onboardingGetStartedTitle": "Ready to Start?",
"onboardingGetStartedDescription": "Create your first trip and start tracking your travel budget today!",
"onboardingSkip": "Skip",
"onboardingNext": "Next",
"onboardingGetStarted": "Get Started"
```

```json
// app_ko.arb - add after "@_SETTINGS" section
"@_ONBOARDING": {},
"onboardingWelcomeTitle": "트립월렛에 오신 것을 환영합니다",
"onboardingWelcomeDescription": "다양한 통화로 여행 경비를 관리하는 스마트한 여행 동반자",
"onboardingFeaturesTitle": "지출을 기록하세요",
"onboardingFeaturesDescription": "어떤 통화로든 지출을 기록하고 자동으로 환산하세요. 유형과 지불수단별로 분류할 수 있습니다.",
"onboardingGetStartedTitle": "시작할 준비가 되셨나요?",
"onboardingGetStartedDescription": "첫 번째 여행을 만들고 오늘부터 여행 예산을 관리해보세요!",
"onboardingSkip": "건너뛰기",
"onboardingNext": "다음",
"onboardingGetStarted": "시작하기"
```

**After Adding:**
```bash
flutter gen-l10n
```

**Acceptance Criteria:**
- [ ] All 9 new strings in both ARB files
- [ ] `flutter gen-l10n` completes without errors
- [ ] Strings accessible via `AppLocalizations.of(context)!.onboardingWelcomeTitle`

---

### Task 6: Tests

**Files to Create:**
- `test/features/onboarding/data/repositories/onboarding_repository_impl_test.dart`
- `test/features/onboarding/presentation/providers/onboarding_providers_test.dart`
- `test/features/onboarding/presentation/screens/onboarding_screen_test.dart`

**6.1 Repository Tests:**

```dart
// test/features/onboarding/data/repositories/onboarding_repository_impl_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  group('OnboardingRepositoryImpl', () {
    test('isOnboardingCompleted returns false when not set', () async {
      // ...
    });

    test('isOnboardingCompleted returns true when set to true', () async {
      // ...
    });

    test('setOnboardingCompleted persists value', () async {
      // ...
    });
  });
}
```

**6.2 Provider Tests:**

```dart
// test/features/onboarding/presentation/providers/onboarding_providers_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';

void main() {
  group('onboardingCompletedProvider', () {
    test('returns false for new users', () async {
      // ...
    });

    test('returns true after onboarding completed', () async {
      // ...
    });
  });

  group('currentPageProvider', () {
    test('initial page is 0', () {
      // ...
    });

    test('nextPage increments', () {
      // ...
    });
  });
}
```

**6.3 Widget Tests:**

```dart
// test/features/onboarding/presentation/screens/onboarding_screen_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  group('OnboardingScreen', () {
    testWidgets('displays welcome page initially', (tester) async {
      // ...
    });

    testWidgets('skip button navigates to home', (tester) async {
      // ...
    });

    testWidgets('next button advances page', (tester) async {
      // ...
    });

    testWidgets('get started button on final page completes onboarding', (tester) async {
      // ...
    });

    testWidgets('page indicator shows correct dot', (tester) async {
      // ...
    });
  });
}
```

**Acceptance Criteria:**
- [ ] Repository tests: 3+ test cases
- [ ] Provider tests: 4+ test cases
- [ ] Widget tests: 5+ test cases
- [ ] All tests pass with `flutter test`

---

### Task 7: Integration & Polish

**Final Checklist:**
- [ ] Run `flutter analyze` - zero warnings
- [ ] Run `flutter test` - zero failures
- [ ] Manual test: Fresh install shows onboarding
- [ ] Manual test: Skip works correctly
- [ ] Manual test: Complete flow works correctly
- [ ] Manual test: Restart shows HomeScreen
- [ ] Test both English and Korean locales
- [ ] Verify theme consistency (Teal primary, 12px radius)

---

## File Summary

### New Files (11)
| Path | Purpose |
|------|---------|
| `lib/features/onboarding/domain/entities/onboarding_page.dart` | Page entity |
| `lib/features/onboarding/domain/repositories/onboarding_repository.dart` | Repository interface |
| `lib/features/onboarding/data/repositories/onboarding_repository_impl.dart` | SharedPreferences impl |
| `lib/features/onboarding/presentation/providers/onboarding_providers.dart` | Riverpod providers |
| `lib/features/onboarding/presentation/screens/onboarding_screen.dart` | Main screen |
| `lib/features/onboarding/presentation/widgets/onboarding_page_widget.dart` | Page content widget |
| `lib/features/onboarding/presentation/widgets/page_indicator.dart` | Dot indicator |
| `test/features/onboarding/data/repositories/onboarding_repository_impl_test.dart` | Repository tests |
| `test/features/onboarding/presentation/providers/onboarding_providers_test.dart` | Provider tests |
| `test/features/onboarding/presentation/screens/onboarding_screen_test.dart` | Widget tests |

### Modified Files (4)
| Path | Changes |
|------|---------|
| `lib/app.dart` | Add onboarding check wrapper |
| `lib/core/router/app_router.dart` | Add onboarding route |
| `lib/l10n/app_en.arb` | Add 9 onboarding strings |
| `lib/l10n/app_ko.arb` | Add 9 onboarding strings |

---

## Risk Assessment

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| GoRouter async redirect issues | Medium | High | Use widget-based approach in app.dart |
| SharedPreferences not initialized | Low | High | Already handled in main.dart |
| Localization generation fails | Low | Medium | Run `flutter gen-l10n` after ARB changes |
| Screen flash on startup | Medium | Medium | Add loading state while checking onboarding |
| Tests fail due to async timing | Medium | Medium | Use `container.listen()` pattern for StreamProvider |

---

## Commit Strategy

1. **Commit 1**: Domain layer (entities, repository interface)
2. **Commit 2**: Data layer (repository implementation)
3. **Commit 3**: Presentation layer (providers, screens, widgets)
4. **Commit 4**: Router integration and app.dart changes
5. **Commit 5**: Localization (ARB files + gen-l10n)
6. **Commit 6**: Tests (all test files)
7. **Commit 7**: Polish and final fixes (if needed)

---

## Success Criteria

- [ ] New users see 3-page onboarding flow
- [ ] Users can skip or complete onboarding
- [ ] Onboarding state persists across restarts
- [ ] UI matches existing app design (Teal theme)
- [ ] Full Korean/English localization
- [ ] `flutter analyze` passes
- [ ] `flutter test` passes
- [ ] 12+ new test cases covering feature

---

## Estimated Effort

| Task | Complexity | Estimated Time |
|------|------------|----------------|
| Task 1: Domain | Low | 15 min |
| Task 2: Data | Low | 15 min |
| Task 3: Presentation | Medium | 45 min |
| Task 4: Router | Medium | 30 min |
| Task 5: Localization | Low | 15 min |
| Task 6: Tests | Medium | 45 min |
| Task 7: Integration | Low | 15 min |
| **Total** | | **~3 hours** |

---

*Plan created by Prometheus (Planner) for RALPLAN session*
