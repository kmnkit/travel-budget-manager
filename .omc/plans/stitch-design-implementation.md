# TripWallet - Stitch Design Implementation Plan

> **Source**: PRD (10 User Stories) + Stitch UI Designs (9 Screens)
> **Branch**: `ralph/trip-wallet-v2`
> **Architecture**: Clean Architecture + Riverpod + Drift (SQLite) + GoRouter
> **Approach**: TDD (test-first for all domain/data layers)
> **Design System**: Teal #00897B, Lexend font, Material Design 3, 12px radius
> **Stitch Project ID**: `1536195772045761405` (use `get_screen` MCP tool to fetch screen designs)
> **RALPLAN Iteration**: 2 (revised per Critic + Architect feedback)

---

## Context

### Original Request
Build a complete travel expense tracking app (TripWallet) in Flutter with multi-currency support, budget tracking, statistics charts, and Korean/English i18n.

### Interview Summary
- PRD defines 10 user stories covering foundation through integration tests
- Stitch design system generated 9 mobile screens with teal/ocean blue theme
- Clean Architecture with feature-based folder structure
- TDD approach with mocktail for mocking
- Drift (SQLite) for local persistence, Riverpod for state, GoRouter for routing

### Research Findings / Design Decisions

**CRITICAL: Isar replaced with Drift (SQLite)**

Isar 3.x is abandoned (last release mid-2023) and has analyzer version conflicts with Dart 3.10.8. The Architect recommended Drift as the replacement:
- `drift` is actively maintained, type-safe SQLite wrapper
- Supports reactive `.watch()` streams (direct replacement for StreamProvider)
- Relational model (Trip->Expense, Trip->ExchangeRate) maps naturally with SQL JOINs
- Budget aggregation (`SUM(convertedAmount)`) is native SQL instead of manual Dart loops
- Cascading deletes via SQL `ON DELETE CASCADE` or Drift transactions
- Domain entities (freezed classes) remain UNCHANGED
- Presentation layers remain UNCHANGED

**CRITICAL Stitch Design Overrides (vs original PRD):**

| Aspect | Original PRD | Stitch Design (USE THIS) |
|--------|-------------|--------------------------|
| Primary Color | Sky Blue #4FC3F7 | **Teal #00897B** |
| Font | System default | **Lexend** (google_fonts) |
| Categories | 6 (food, transport, shopping, accommodation, activity, other) | **8** (food, transport, accommodation, shopping, entertainment, sightseeing, communication, other) |
| Payment Types | 3 (cash, creditCard, other) | **5** (cash, creditCard, debitCard, transitCard, other) |
| Languages | ko, en, ja | **ko, en only** (no Japanese) |
| Home budget | Text only | **Linear progress bar** on trip cards |
| Detail budget | Simple bar | **Circular progress** with center percentage |
| Trip Detail nav | Single scroll | **Bottom tabs** (지출/환율/통계) |
| Expense list | Single amount | **Dual currency** display (original + converted) |
| Exchange rate | Manual only | **Auto/manual toggle** with API fetch |
| Trip status | 2 states | **3 badge states** (예정=blue, 진행중=green, 완료=gray) |

**Stitch Screen Access**: Executor agents can fetch design specifications via the `get_screen` MCP tool using project ID `1536195772045761405`. Screen IDs are listed at the top of each screen task.

---

## Work Objectives

### Core Objective
Implement the complete TripWallet Flutter app matching all 10 PRD user stories with layout-accurate adherence to the 9 Stitch design specifications accessible via the MCP `get_screen` tool (project ID `1536195772045761405`).

### Deliverables
1. Fully functional Flutter app with Clean Architecture
2. All 9 screens matching Stitch designs (teal theme, Lexend font, correct layouts)
3. Drift SQLite database with Trip, Expense, PaymentMethod, ExchangeRate tables
4. Multi-currency support (7 currencies) with API (dual fallback) + manual exchange rates
5. Budget tracking with circular/linear progress visualizations
6. Statistics with pie, bar, and breakdown charts
7. Korean/English i18n with runtime switching
8. Comprehensive unit tests for all domain/data layers
9. Integration tests for key user flows
10. CLAUDE.md updated with project status (US-010 requirement)

### Definition of Done
- `flutter analyze` passes with zero warnings
- `flutter test` passes with all unit + widget tests green
- All 9 Stitch screens rendered with correct colors, fonts, layouts
- All 10 user story acceptance criteria met
- Integration tests pass for core flows
- CLAUDE.md updated to reflect project status

---

## Must Have / Must NOT Have

### MUST Have
- Teal #00897B as primary color throughout (NOT sky blue)
- Lexend font via google_fonts package
- 8 expense categories with correct icons
- 5 payment method types
- Circular budget progress in trip detail
- Linear budget progress in home trip cards
- Bottom tab navigation in trip detail (지출/환율/통계)
- Dual currency display in expense list items
- Auto/manual exchange rate toggle
- Trip status badges (예정=blue, 진행중=green, 완료=gray)
- 12px corner radius on cards/containers
- Material Design 3 theming
- Korean and English i18n only
- Exchange rate API with fallback chain (primary + fallback URL)
- Error/Failure domain classes for clean error handling

### MUST NOT Have
- Japanese language support (removed per Stitch scope)
- Sky Blue #4FC3F7 anywhere (replaced by Teal)
- Dark mode (not in Stitch designs, out of scope)
- Data backup/restore functionality (settings shows it but not implemented in MVP)
- Online sync or cloud features
- User authentication
- Isar database (replaced with Drift)

---

## Task Flow and Dependencies

```
PHASE 1: Foundation (Tasks 1-5)
  Task 1 (deps) ──┐
  Task 2 (dirs) ──┼── can run in parallel
  Task 3 (theme) ─┘   (Task 3 needs Task 2 done first)
  Task 4 (router) ── needs Task 2
  Task 5 (i18n)   ── needs Task 2

PHASE 2: Core Data Layer (Tasks 6-11)
  Task 6 (currency utils + errors) ── needs Task 2
  Task 7 (Trip entity + Drift table)     ──┐
  Task 8 (Expense entity + Drift table)  ──┼── can run in parallel, need Task 1
  Task 9 (PayMethod entity + Drift table)──┤
  Task 10 (ExRate entity + Drift table)  ──┘
  Task 11 (Drift AppDatabase)            ── needs Tasks 7-10

PHASE 3: Domain Layer (Tasks 12-17)
  Task 12 (Trip repo+UC)      ── needs Task 11
  Task 13 (Expense repo+UC)   ── needs Task 11, Task 16
  Task 14 (PayMethod repo+UC) ── needs Task 11
  Task 15 (ExRate repo+UC)    ── needs Task 11
  Task 16 (ExRate API)        ── needs Task 10
  Task 17 (Budget calc)       ── needs Task 13, Task 15

PHASE 4: State Management (Tasks 18-22)
  Task 18 (Trip providers)    ── needs Task 12
  Task 19 (Expense providers) ── needs Task 13
  Task 20 (PayMethod provs)   ── needs Task 14
  Task 21 (ExRate providers)  ── needs Task 15, Task 16
  Task 22 (Budget providers)  ── needs Task 17

PHASE 5: Presentation - Shared Widgets (Tasks 23-25)
  Task 23 (shared widgets)    ── needs Task 3, Task 6
  Task 24 (budget widgets)    ── needs Task 22, Task 23
  Task 25 (expense widgets)   ── needs Task 19, Task 23

PHASE 6: Presentation - Screens (Tasks 26-34)
  Task 26 (Home screen)       ── needs Task 18, Task 24
  Task 27 (Trip create/edit)  ── needs Task 18, Task 23
  Task 28 (Trip detail shell) ── needs Task 18, Task 24
  Task 29 (Expense list tab)  ── needs Task 25, Task 28
  Task 30 (Expense create/edit) ── needs Task 19, Task 20, Task 21
  Task 31 (PayMethod screen)  ── needs Task 20, Task 23
  Task 32 (ExRate tab)        ── needs Task 21, Task 28
  Task 33 (Statistics tab)    ── needs Task 19, Task 28
  Task 34 (Settings screen)   ── needs Task 5, Task 23

PHASE 7: Polish & Integration (Tasks 35-38)
  Task 35 (i18n all strings)  ── needs all screens
  Task 36 (app entry point)   ── needs Tasks 4, 11, 18
  Task 37 (integration tests) ── needs all above
  Task 38 (CLAUDE.md update)  ── needs Task 37
```

---

## Detailed Tasks

---

### PHASE 1: Project Foundation

---

#### Task 1: Add All Dependencies to pubspec.yaml
**User Story**: US-001
**Priority**: P0 (blocker for everything)
**Depends on**: nothing
**Estimated files**: 2

**Description**: Add all required packages to pubspec.yaml. Replace Isar with Drift. Update analysis_options.yaml to use latest `lints` package instead of deprecated `flutter_lints`. This unblocks all subsequent development.

**Files to modify**:
- `pubspec.yaml`
- `analysis_options.yaml`

**Dependencies to add**:
```yaml
dependencies:
  flutter_riverpod: ^2.6.1
  riverpod_annotation: ^2.6.1
  drift: ^2.30.1
  drift_flutter: ^0.2.8
  go_router: ^14.8.1
  intl: ^0.19.0
  flutter_localizations:
    sdk: flutter
  dio: ^5.7.0
  google_fonts: ^6.2.1
  fl_chart: ^0.70.2
  freezed_annotation: ^2.4.4
  json_annotation: ^4.9.0
  uuid: ^4.5.1
  shared_preferences: ^2.3.4
  connectivity_plus: ^6.1.1
  path_provider: ^2.1.5
  sqlite3_flutter_libs: ^0.5.28

dev_dependencies:
  drift_dev: ^2.30.1
  build_runner: ^2.4.14
  freezed: ^2.5.7
  json_serializable: ^6.9.4
  riverpod_generator: ^2.6.3
  mocktail: ^1.0.4
  lints: ^5.1.1
  flutter_test:
    sdk: flutter
  integration_test:
    sdk: flutter
```

**analysis_options.yaml update**:
```yaml
include: package:lints/recommended.yaml

analyzer:
  exclude:
    - "**/*.g.dart"
    - "**/*.freezed.dart"
```

**Acceptance Criteria**:
- [ ] All packages added with compatible versions
- [ ] Isar packages NOT present (replaced by drift, drift_flutter, drift_dev, sqlite3_flutter_libs)
- [ ] `flutter pub get` completes without errors
- [ ] No version conflict warnings
- [ ] analysis_options.yaml uses `lints` (not deprecated `flutter_lints`)
- [ ] Generated files (*.g.dart, *.freezed.dart) excluded from analysis

---

#### Task 2: Create Clean Architecture Directory Structure
**User Story**: US-001
**Priority**: P0
**Depends on**: nothing (can parallel with Task 1)
**Estimated files**: ~40 placeholder files

**Description**: Create the entire directory tree and placeholder barrel files for Clean Architecture with feature-based modules.

**Directories to create**:
```
lib/
├── main.dart                          (modify existing)
├── app.dart                           (new)
├── core/
│   ├── constants/
│   │   ├── app_constants.dart
│   │   └── currency_constants.dart
│   ├── theme/
│   │   ├── app_theme.dart
│   │   ├── app_colors.dart
│   │   └── app_text_styles.dart
│   ├── utils/
│   │   ├── currency_formatter.dart
│   │   └── date_formatter.dart
│   ├── extensions/
│   │   └── context_extensions.dart
│   ├── errors/
│   │   ├── failures.dart
│   │   └── exceptions.dart
│   └── network/
│       └── network_service.dart
├── features/
│   ├── trip/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── trip_local_datasource.dart
│   │   │   ├── models/
│   │   │   │   └── trip_model.dart
│   │   │   └── repositories/
│   │   │       └── trip_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── trip.dart
│   │   │   ├── repositories/
│   │   │   │   └── trip_repository.dart
│   │   │   └── usecases/
│   │   │       ├── create_trip.dart
│   │   │       ├── get_trips.dart
│   │   │       ├── update_trip.dart
│   │   │       └── delete_trip.dart
│   │   └── presentation/
│   │       ├── providers/
│   │       │   └── trip_providers.dart
│   │       ├── screens/
│   │       │   ├── home_screen.dart
│   │       │   ├── trip_create_screen.dart
│   │       │   ├── trip_detail_screen.dart
│   │       │   └── trip_edit_screen.dart
│   │       └── widgets/
│   │           ├── trip_card.dart
│   │           ├── trip_status_badge.dart
│   │           └── empty_trip_state.dart
│   ├── expense/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── expense_local_datasource.dart
│   │   │   ├── models/
│   │   │   │   └── expense_model.dart
│   │   │   └── repositories/
│   │   │       └── expense_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   ├── expense.dart
│   │   │   │   └── expense_category.dart
│   │   │   ├── repositories/
│   │   │   │   └── expense_repository.dart
│   │   │   └── usecases/
│   │   │       ├── create_expense.dart
│   │   │       ├── get_expenses.dart
│   │   │       ├── update_expense.dart
│   │   │       └── delete_expense.dart
│   │   └── presentation/
│   │       ├── providers/
│   │       │   └── expense_providers.dart
│   │       ├── screens/
│   │       │   ├── expense_list_screen.dart
│   │       │   └── expense_form_screen.dart
│   │       └── widgets/
│   │           ├── expense_item_card.dart
│   │           ├── category_grid.dart
│   │           ├── amount_input.dart
│   │           └── payment_method_chips.dart
│   ├── payment_method/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── payment_method_local_datasource.dart
│   │   │   ├── models/
│   │   │   │   └── payment_method_model.dart
│   │   │   └── repositories/
│   │   │       └── payment_method_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   ├── payment_method.dart
│   │   │   │   └── payment_method_type.dart
│   │   │   ├── repositories/
│   │   │   │   └── payment_method_repository.dart
│   │   │   └── usecases/
│   │   │       ├── create_payment_method.dart
│   │   │       ├── get_payment_methods.dart
│   │   │       ├── update_payment_method.dart
│   │   │       └── delete_payment_method.dart
│   │   └── presentation/
│   │       ├── providers/
│   │       │   └── payment_method_providers.dart
│   │       ├── screens/
│   │       │   └── payment_method_screen.dart
│   │       └── widgets/
│   │           ├── payment_method_card.dart
│   │           └── payment_method_bottom_sheet.dart
│   ├── exchange_rate/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   ├── exchange_rate_local_datasource.dart
│   │   │   │   └── exchange_rate_remote_datasource.dart
│   │   │   ├── models/
│   │   │   │   └── exchange_rate_model.dart
│   │   │   └── repositories/
│   │   │       └── exchange_rate_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── exchange_rate.dart
│   │   │   ├── repositories/
│   │   │   │   └── exchange_rate_repository.dart
│   │   │   └── usecases/
│   │   │       ├── fetch_latest_rates.dart
│   │   │       ├── get_exchange_rate.dart
│   │   │       ├── set_manual_rate.dart
│   │   │       └── convert_currency.dart
│   │   └── presentation/
│   │       ├── providers/
│   │       │   └── exchange_rate_providers.dart
│   │       ├── screens/
│   │       │   └── exchange_rate_screen.dart
│   │       └── widgets/
│   │           ├── exchange_rate_card.dart
│   │           └── auto_manual_toggle.dart
│   ├── budget/
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   ├── budget_summary.dart
│   │   │   │   └── budget_status.dart
│   │   │   └── usecases/
│   │   │       └── get_budget_summary.dart
│   │   └── presentation/
│   │       ├── providers/
│   │       │   └── budget_providers.dart
│   │       └── widgets/
│   │           ├── circular_budget_progress.dart
│   │           ├── linear_budget_progress.dart
│   │           └── budget_summary_card.dart
│   ├── statistics/
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── statistics_data.dart
│   │   │   └── usecases/
│   │   │       ├── get_category_stats.dart
│   │   │       ├── get_daily_stats.dart
│   │   │       └── get_payment_method_stats.dart
│   │   └── presentation/
│   │       ├── providers/
│   │       │   └── statistics_providers.dart
│   │       ├── screens/
│   │       │   └── statistics_screen.dart
│   │       └── widgets/
│   │           ├── category_pie_chart.dart
│   │           ├── daily_bar_chart.dart
│   │           └── payment_method_chart.dart
│   └── settings/
│       └── presentation/
│           ├── providers/
│           │   └── settings_providers.dart
│           ├── screens/
│           │   └── settings_screen.dart
│           └── widgets/
│               └── settings_tile.dart
├── shared/
│   ├── data/
│   │   └── database.dart
│   ├── providers/
│   │   ├── locale_provider.dart
│   │   └── shared_preferences_provider.dart
│   └── widgets/
│       ├── app_scaffold.dart
│       ├── currency_dropdown.dart
│       ├── date_picker_field.dart
│       ├── loading_indicator.dart
│       └── error_widget.dart
└── l10n/
    ├── l10n.yaml
    ├── app_en.arb
    └── app_ko.arb

test/
├── core/
│   └── utils/
│       ├── currency_formatter_test.dart
│       └── date_formatter_test.dart
├── features/
│   ├── trip/
│   │   ├── data/
│   │   │   └── repositories/
│   │   │       └── trip_repository_impl_test.dart
│   │   ├── domain/
│   │   │   └── usecases/
│   │   │       ├── create_trip_test.dart
│   │   │       ├── get_trips_test.dart
│   │   │       ├── update_trip_test.dart
│   │   │       └── delete_trip_test.dart
│   │   └── presentation/
│   │       ├── providers/
│   │       │   └── trip_providers_test.dart
│   │       └── widgets/
│   │           ├── trip_card_test.dart
│   │           └── home_screen_test.dart
│   ├── expense/
│   │   ├── data/
│   │   │   └── repositories/
│   │   │       └── expense_repository_impl_test.dart
│   │   ├── domain/
│   │   │   └── usecases/
│   │   │       ├── create_expense_test.dart
│   │   │       ├── get_expenses_test.dart
│   │   │       ├── update_expense_test.dart
│   │   │       └── delete_expense_test.dart
│   │   └── presentation/
│   │       └── providers/
│   │           └── expense_providers_test.dart
│   ├── payment_method/
│   │   ├── data/
│   │   │   └── repositories/
│   │   │       └── payment_method_repository_impl_test.dart
│   │   └── domain/
│   │       └── usecases/
│   │           └── payment_method_usecases_test.dart
│   ├── exchange_rate/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── exchange_rate_remote_datasource_test.dart
│   │   │   └── repositories/
│   │   │       └── exchange_rate_repository_impl_test.dart
│   │   └── domain/
│   │       └── usecases/
│   │           ├── convert_currency_test.dart
│   │           └── fetch_latest_rates_test.dart
│   ├── budget/
│   │   └── domain/
│   │       └── usecases/
│   │           └── get_budget_summary_test.dart
│   └── statistics/
│       └── domain/
│           └── usecases/
│               └── statistics_usecases_test.dart
└── shared/
    └── data/
        └── database_test.dart

integration_test/
├── trip_flow_test.dart
├── expense_flow_test.dart
├── multi_currency_test.dart
└── app_test.dart
```

**Acceptance Criteria**:
- [ ] All directories created
- [ ] Each directory has at least a placeholder .dart file
- [ ] Test directory mirrors lib directory structure
- [ ] integration_test directory created
- [ ] `lib/shared/data/database.dart` (NOT `isar_service.dart`) is the DB file

---

#### Task 3: Implement Design System (Theme, Colors, Typography)
**User Story**: US-001, US-009
**Priority**: P0
**Depends on**: Task 2
**Estimated files**: 4

**Description**: Implement the complete Material Design 3 theme matching Stitch designs. Use `ColorScheme.fromSeed(seedColor: Color(0xFF00897B))` as the base, then override specific colors from AppColors where Stitch designs require exact hex values. Teal #00897B primary, Lexend font, 12px corner radius.

**Files to create/modify**:
- `lib/core/theme/app_colors.dart`
- `lib/core/theme/app_text_styles.dart`
- `lib/core/theme/app_theme.dart`
- `lib/core/constants/app_constants.dart`

**Specification**:

```dart
// app_colors.dart
// These are EXACT hex values from Stitch designs.
// Used to override ColorScheme.fromSeed() where Stitch requires specific colors.
class AppColors {
  // Primary - Teal from Stitch (overrides seed-generated primary)
  static const Color primary = Color(0xFF00897B);         // Teal 600
  static const Color primaryLight = Color(0xFF4DB6AC);    // Teal 300
  static const Color primaryDark = Color(0xFF00695C);     // Teal 800
  static const Color onPrimary = Color(0xFFFFFFFF);

  // Surface
  static const Color surface = Color(0xFFFFFFFF);
  static const Color background = Color(0xFFFAFAFA);
  static const Color surfaceVariant = Color(0xFFF5F5F5);

  // Trip Status Badges (from Stitch)
  static const Color statusUpcoming = Color(0xFF2196F3);   // Blue
  static const Color statusOngoing = Color(0xFF4CAF50);    // Green
  static const Color statusCompleted = Color(0xFF9E9E9E);  // Gray

  // Budget Status
  static const Color budgetComfortable = Color(0xFF00897B); // Teal (primary)
  static const Color budgetCaution = Color(0xFFFFA726);     // Orange
  static const Color budgetWarning = Color(0xFFEF5350);     // Red
  static const Color budgetExceeded = Color(0xFFD32F2F);    // Dark Red

  // Text
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textHint = Color(0xFFBDBDBD);

  // Expense Category colors (for icons)
  static const Color categoryFood = Color(0xFFFF7043);
  static const Color categoryTransport = Color(0xFF42A5F5);
  static const Color categoryAccommodation = Color(0xFF7E57C2);
  static const Color categoryShop = Color(0xFFEC407A);
  static const Color categoryEntertainment = Color(0xFFFFCA28);
  static const Color categorySightseeing = Color(0xFF26A69A);
  static const Color categoryCommunication = Color(0xFF5C6BC0);
  static const Color categoryOther = Color(0xFF78909C);
}
```

```dart
// app_theme.dart
// Use ColorScheme.fromSeed as the BASE, then copyWith() to override
// specific slots where Stitch designs mandate exact hex values.
ThemeData buildAppTheme() {
  final colorScheme = ColorScheme.fromSeed(
    seedColor: const Color(0xFF00897B),
    brightness: Brightness.light,
  ).copyWith(
    primary: AppColors.primary,
    onPrimary: AppColors.onPrimary,
    surface: AppColors.surface,
    // ... other Stitch-mandated overrides
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    textTheme: GoogleFonts.lexendTextTheme(),
    cardTheme: CardTheme(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    // ... other component themes
  );
}
```

```dart
// app_constants.dart
class AppConstants {
  static const double borderRadius = 12.0;    // Stitch: round-12
  static const double minTouchTarget = 48.0;  // WCAG 2.1 AA
  static const int maxTitleLength = 100;
  static const double maxBudget = 10000000000; // 100억
  static const Duration apiTimeout = Duration(seconds: 5);
  static const Duration rateCacheDuration = Duration(hours: 24);
}
```

**Acceptance Criteria**:
- [ ] ThemeData uses Material 3 (`useMaterial3: true`)
- [ ] ColorScheme.fromSeed with teal #00897B as base, with `.copyWith()` overrides for Stitch-mandated hex values
- [ ] All text styles use Lexend via GoogleFonts.lexendTextTheme()
- [ ] Card theme has 12px border radius
- [ ] All 8 category colors defined
- [ ] 3 trip status colors defined (blue/green/gray)
- [ ] 4 budget status colors defined
- [ ] Touch targets minimum 48dp

---

#### Task 4: Configure GoRouter with All Routes
**User Story**: US-001
**Priority**: P0
**Depends on**: Task 2
**Estimated files**: 1

**Description**: Define all app routes using GoRouter. Routes match the screen navigation flow from Stitch designs.

**Files to create**:
- `lib/core/router/app_router.dart`

**Route definitions**:
```
/                                    → HomeScreen (여행 목록)
/trip/create                         → TripCreateScreen
/trip/:tripId                        → TripDetailScreen (with bottom tabs)
/trip/:tripId/edit                   → TripEditScreen
/trip/:tripId/expense/create         → ExpenseFormScreen (create mode)
/trip/:tripId/expense/:expenseId     → ExpenseFormScreen (edit mode)
/trip/:tripId/payment-methods        → PaymentMethodScreen
/settings                            → SettingsScreen
```

**Note**: Exchange rate and statistics are TABS within TripDetailScreen (not separate routes). The TripDetailScreen has a bottom tab bar with 3 tabs: 지출(expenses), 환율(exchange rates), 통계(statistics).

**Acceptance Criteria**:
- [ ] All routes defined and navigable
- [ ] Route parameters (tripId, expenseId) properly extracted
- [ ] GoRouter integrated with Riverpod
- [ ] Initial route is `/` (HomeScreen)
- [ ] Back navigation works correctly

---

#### Task 5: Configure i18n (Korean/English)
**User Story**: US-001, US-008
**Priority**: P0
**Depends on**: Task 2
**Estimated files**: 3

**Description**: Set up Flutter's built-in localization with ARB files for Korean and English. Initial setup with common strings only; full strings added in Task 35.

**Files to create**:
- `lib/l10n/l10n.yaml`
- `lib/l10n/app_en.arb`
- `lib/l10n/app_ko.arb`

**Initial ARB entries** (separate per locale):
```json
// app_en.arb
{
  "@@locale": "en",
  "appTitle": "TripWallet",
  "save": "Save",
  "cancel": "Cancel",
  "delete": "Delete",
  "edit": "Edit",
  "add": "Add",
  "settings": "Settings",
  "trips": "Trips",
  "expenses": "Expenses",
  "exchangeRates": "Exchange Rates",
  "statistics": "Statistics",
  "budget": "Budget",
  "total": "Total",
  "remaining": "Remaining"
}
```
```json
// app_ko.arb
{
  "@@locale": "ko",
  "appTitle": "TripWallet",
  "save": "저장",
  "cancel": "취소",
  "delete": "삭제",
  "edit": "수정",
  "add": "추가",
  "settings": "설정",
  "trips": "여행",
  "expenses": "지출",
  "exchangeRates": "환율",
  "statistics": "통계",
  "budget": "예산",
  "total": "합계",
  "remaining": "잔액"
}
```

**Acceptance Criteria**:
- [ ] `l10n.yaml` configured with `arb-dir: lib/l10n`
- [ ] `app_en.arb` with English strings only (no "Save / 저장" mixed format)
- [ ] `app_ko.arb` with Korean strings only
- [ ] `flutter gen-l10n` generates AppLocalizations class
- [ ] Locale provider for runtime language switching
- [ ] SharedPreferences persists selected language

---

### PHASE 2: Core Data Layer

---

#### Task 6: Currency Constants, Utilities, and Error/Failure Classes
**User Story**: US-001
**Priority**: P0
**Depends on**: Task 2
**Estimated files**: 5 (+ 1 test)

**Description**: Define the 7 supported currencies with formatting utilities and flag emoji mappings. Also implement the core error/failure domain classes referenced in the directory structure.

**Files to create**:
- `lib/core/constants/currency_constants.dart`
- `lib/core/utils/currency_formatter.dart`
- `lib/core/utils/date_formatter.dart`
- `lib/core/errors/failures.dart`
- `lib/core/errors/exceptions.dart`
- `test/core/utils/currency_formatter_test.dart`

**Currency definitions**:
```dart
enum SupportedCurrency {
  KRW(code: 'KRW', symbol: '₩', name: 'Korean Won', nameKo: '한국 원', flag: '🇰🇷', decimalDigits: 0),
  USD(code: 'USD', symbol: '\$', name: 'US Dollar', nameKo: '미국 달러', flag: '🇺🇸', decimalDigits: 2),
  EUR(code: 'EUR', symbol: '€', name: 'Euro', nameKo: '유로', flag: '🇪🇺', decimalDigits: 2),
  JPY(code: 'JPY', symbol: '¥', name: 'Japanese Yen', nameKo: '일본 엔', flag: '🇯🇵', decimalDigits: 0),
  GBP(code: 'GBP', symbol: '£', name: 'British Pound', nameKo: '영국 파운드', flag: '🇬🇧', decimalDigits: 2),
  AUD(code: 'AUD', symbol: 'A\$', name: 'Australian Dollar', nameKo: '호주 달러', flag: '🇦🇺', decimalDigits: 2),
  CAD(code: 'CAD', symbol: 'C\$', name: 'Canadian Dollar', nameKo: '캐나다 달러', flag: '🇨🇦', decimalDigits: 2),
}
```

**Error/Failure classes**:
```dart
// failures.dart - Domain-level failure representation
abstract class Failure {
  final String message;
  const Failure(this.message);
}

class DatabaseFailure extends Failure { ... }
class NetworkFailure extends Failure { ... }
class ValidationFailure extends Failure { ... }
class CacheFailure extends Failure { ... }

// exceptions.dart - Data-layer exceptions
class DatabaseException implements Exception { ... }
class NetworkException implements Exception { ... }
class CacheException implements Exception { ... }
```

**Acceptance Criteria**:
- [ ] 7 currencies with code, symbol, name, nameKo, flag, decimalDigits
- [ ] CurrencyFormatter formats amounts respecting decimal digits (KRW/JPY: 0, others: 2)
- [ ] CurrencyFormatter outputs locale-aware format (e.g. ₩1,500 / $15.00)
- [ ] DateFormatter handles date/date-range formatting
- [ ] Failure abstract class with DatabaseFailure, NetworkFailure, ValidationFailure, CacheFailure
- [ ] Exception classes for data layer (DatabaseException, NetworkException, CacheException)
- [ ] Unit tests for all formatting edge cases (zero, large numbers, negative)

---

#### Task 7: Trip Entity and Drift Table Definition
**User Story**: US-002
**Priority**: P0
**Depends on**: Task 1
**Estimated files**: 2

**Description**: Define the Trip domain entity (freezed) and Drift table definition. Trip status is computed from dates (not stored).

**Files to create**:
- `lib/features/trip/domain/entities/trip.dart`
- `lib/features/trip/data/models/trip_model.dart`

**Trip entity fields**:
```dart
@freezed
class Trip {
  id: int (auto-increment)
  title: String (max 100 chars)
  baseCurrency: String (currency code, e.g. 'KRW')
  budget: double (positive, max 10 billion)
  startDate: DateTime
  endDate: DateTime
  createdAt: DateTime
  updatedAt: DateTime

  // Computed (not stored)
  TripStatus get status => computed from dates
}

enum TripStatus { upcoming, ongoing, completed }
```

**Drift table definition**:
```dart
// trip_model.dart - Drift table
class Trips extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().withLength(min: 1, max: 100)();
  TextColumn get baseCurrency => text().withLength(min: 3, max: 3)();
  RealColumn get budget => real()();
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get endDate => dateTime()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
}
```

Conversion methods: `Trip toEntity(TripsCompanion row)` and `TripsCompanion fromEntity(Trip entity)`.

**Acceptance Criteria**:
- [ ] Trip entity is immutable (freezed)
- [ ] TripStatus computed: upcoming (startDate > now), ongoing (startDate <= now <= endDate), completed (endDate < now)
- [ ] Drift `Trips extends Table` with proper column types and constraints
- [ ] Index on title column
- [ ] Bidirectional conversion between domain entity and Drift companion/row
- [ ] `build_runner` generates .g.dart and .freezed.dart files

---

#### Task 8: Expense Entity and Drift Table Definition
**User Story**: US-004
**Priority**: P0
**Depends on**: Task 1
**Estimated files**: 3

**Description**: Define Expense domain entity, ExpenseCategory enum with 8 categories matching Stitch designs, and Drift table definition.

**Files to create**:
- `lib/features/expense/domain/entities/expense.dart`
- `lib/features/expense/domain/entities/expense_category.dart`
- `lib/features/expense/data/models/expense_model.dart`

**Expense entity fields**:
```dart
@freezed
class Expense {
  id: int
  tripId: int
  amount: double (original currency amount)
  currency: String (currency code)
  convertedAmount: double (in trip's base currency)
  category: ExpenseCategory
  paymentMethodId: int
  memo: String?
  date: DateTime
  createdAt: DateTime
}
```

**ExpenseCategory enum** (8 categories from Stitch):
```dart
enum ExpenseCategory {
  food(icon: Icons.restaurant, labelEn: 'Food', labelKo: '식비', color: AppColors.categoryFood),
  transport(icon: Icons.directions_bus, labelEn: 'Transport', labelKo: '교통', color: AppColors.categoryTransport),
  accommodation(icon: Icons.hotel, labelEn: 'Accommodation', labelKo: '숙박', color: AppColors.categoryAccommodation),
  shopping(icon: Icons.shopping_bag, labelEn: 'Shopping', labelKo: '쇼핑', color: AppColors.categoryShop),
  entertainment(icon: Icons.celebration, labelEn: 'Entertainment', labelKo: '오락', color: AppColors.categoryEntertainment),
  sightseeing(icon: Icons.photo_camera, labelEn: 'Sightseeing', labelKo: '관광', color: AppColors.categorySightseeing),
  communication(icon: Icons.phone, labelEn: 'Communication', labelKo: '통신', color: AppColors.categoryCommunication),
  other(icon: Icons.more_horiz, labelEn: 'Other', labelKo: '기타', color: AppColors.categoryOther),
}
```

**Drift table definition**:
```dart
class Expenses extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get tripId => integer().references(Trips, #id)();
  RealColumn get amount => real()();
  TextColumn get currency => text().withLength(min: 3, max: 3)();
  RealColumn get convertedAmount => real()();
  IntColumn get category => intEnum<ExpenseCategory>()();
  IntColumn get paymentMethodId => integer().references(PaymentMethods, #id)();
  TextColumn get memo => text().nullable()();
  DateTimeColumn get date => dateTime()();
  DateTimeColumn get createdAt => dateTime()();
}
```

**Acceptance Criteria**:
- [ ] 8 categories with icons, labels (en/ko), and colors
- [ ] Category icons match Stitch design (restaurant, bus, hotel, shopping_bag, celebration, camera, phone, more_horiz)
- [ ] Expense entity has convertedAmount field for dual-currency display
- [ ] Drift `Expenses extends Table` with foreign key references to Trips and PaymentMethods
- [ ] Index on tripId column for efficient trip-based queries
- [ ] `build_runner` generates code successfully

---

#### Task 9: PaymentMethod Entity and Drift Table Definition
**User Story**: US-003
**Priority**: P0
**Depends on**: Task 1
**Estimated files**: 3

**Description**: Define PaymentMethod entity with 5 types matching Stitch designs.

**Files to create**:
- `lib/features/payment_method/domain/entities/payment_method.dart`
- `lib/features/payment_method/domain/entities/payment_method_type.dart`
- `lib/features/payment_method/data/models/payment_method_model.dart`

**PaymentMethodType enum** (5 types from Stitch):
```dart
enum PaymentMethodType {
  cash(icon: Icons.money, labelEn: 'Cash', labelKo: '현금'),
  creditCard(icon: Icons.credit_card, labelEn: 'Credit Card', labelKo: '신용카드'),
  debitCard(icon: Icons.credit_card_outlined, labelEn: 'Debit Card', labelKo: '체크카드'),
  transitCard(icon: Icons.directions_transit, labelEn: 'Transit Card', labelKo: '교통카드'),
  other(icon: Icons.payment, labelEn: 'Other', labelKo: '기타'),
}
```

**PaymentMethod entity fields**:
```dart
@freezed
class PaymentMethod {
  id: int
  name: String
  type: PaymentMethodType
  isDefault: bool
  createdAt: DateTime
}
```

**Drift table definition**:
```dart
class PaymentMethods extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 50)();
  IntColumn get type => intEnum<PaymentMethodType>()();
  BoolColumn get isDefault => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();
}
```

**Default presets** (seeded on first launch):
- 현금 (Cash) - cash type, default
- 신용카드 (Credit Card) - creditCard type
- 교통카드 (Transit Card) - transitCard type

**Acceptance Criteria**:
- [ ] 5 payment method types with icons and bilingual labels
- [ ] PaymentMethod entity with isDefault flag
- [ ] 3 preset payment methods seeded on first launch
- [ ] Drift table with proper column types
- [ ] `build_runner` generates code successfully

---

#### Task 10: ExchangeRate Entity and Drift Table Definition
**User Story**: US-005
**Priority**: P0
**Depends on**: Task 1
**Estimated files**: 2

**Description**: Define ExchangeRate entity with support for both API-fetched and manual rates.

**Files to create**:
- `lib/features/exchange_rate/domain/entities/exchange_rate.dart`
- `lib/features/exchange_rate/data/models/exchange_rate_model.dart`

**ExchangeRate entity fields**:
```dart
@freezed
class ExchangeRate {
  id: int
  tripId: int?           // null = global rate, non-null = trip-specific
  baseCurrency: String
  targetCurrency: String
  rate: double
  isManual: bool         // true = user-set, false = API-fetched
  updatedAt: DateTime
}
```

**Drift table definition**:
```dart
class ExchangeRates extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get tripId => integer().nullable().references(Trips, #id)();
  TextColumn get baseCurrency => text().withLength(min: 3, max: 3)();
  TextColumn get targetCurrency => text().withLength(min: 3, max: 3)();
  RealColumn get rate => real()();
  BoolColumn get isManual => boolean().withDefault(const Constant(false))();
  DateTimeColumn get updatedAt => dateTime()();
}
```

**Acceptance Criteria**:
- [ ] Supports both trip-scoped and global rates (tripId nullable)
- [ ] isManual flag distinguishes API vs user-entered rates
- [ ] Drift table with nullable foreign key to Trips
- [ ] Unique constraint or index on (tripId, baseCurrency, targetCurrency) combination
- [ ] `build_runner` generates code successfully

---

#### Task 11: Drift AppDatabase Service
**User Story**: US-001
**Priority**: P0
**Depends on**: Tasks 7, 8, 9, 10
**Estimated files**: 2 (+ 1 test)

**Description**: Implement Drift `AppDatabase` class that registers all 4 tables and provides DAOs. Provide as Riverpod provider. Drift's `.watch()` method returns `Stream<List<T>>` which integrates directly with Riverpod's `StreamProvider`.

**Files to create**:
- `lib/shared/data/database.dart`
- `test/shared/data/database_test.dart`

**AppDatabase responsibilities**:
```dart
@DriftDatabase(tables: [Trips, Expenses, PaymentMethods, ExchangeRates])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
      // Seed default payment methods
    },
  );
}

// Riverpod provider
final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(() => db.close());
  return db;
});
```

**Key Drift features used**:
- `.watch()` on queries returns `Stream<List<T>>` for reactive UI updates via StreamProvider
- SQL `SUM(convertedAmount)` for budget aggregation (no manual Dart loops needed)
- Foreign key references enable relational integrity
- Cascading deletes via transactions (delete trip -> delete expenses + exchange rates)

**Acceptance Criteria**:
- [ ] AppDatabase extends _$AppDatabase with all 4 tables registered
- [ ] Default payment methods seeded via `MigrationStrategy.onCreate` (idempotent)
- [ ] `databaseProvider` available as Riverpod Provider
- [ ] DB file stored via `path_provider` for platform-appropriate directory
- [ ] `.watch()` streams confirmed working for reactive queries
- [ ] `build_runner` generates database.g.dart
- [ ] Unit test verifies init and seed behavior

---

### PHASE 3: Domain Layer (Repositories + Use Cases)

---

#### Task 12: Trip Repository and Use Cases
**User Story**: US-002
**Priority**: P0
**Depends on**: Task 11
**Estimated files**: 7 (+ 5 tests)

**Description**: Implement Trip repository interface, Drift implementation, and all CRUD use cases with TDD.

**Files to create**:
- `lib/features/trip/domain/repositories/trip_repository.dart` (interface)
- `lib/features/trip/data/datasources/trip_local_datasource.dart`
- `lib/features/trip/data/repositories/trip_repository_impl.dart`
- `lib/features/trip/domain/usecases/create_trip.dart`
- `lib/features/trip/domain/usecases/get_trips.dart`
- `lib/features/trip/domain/usecases/update_trip.dart`
- `lib/features/trip/domain/usecases/delete_trip.dart`
- `test/features/trip/data/repositories/trip_repository_impl_test.dart`
- `test/features/trip/domain/usecases/create_trip_test.dart`
- `test/features/trip/domain/usecases/get_trips_test.dart`
- `test/features/trip/domain/usecases/update_trip_test.dart`
- `test/features/trip/domain/usecases/delete_trip_test.dart`

**Repository interface**:
```dart
abstract class TripRepository {
  Future<Trip> createTrip(Trip trip);
  Future<Trip?> getTripById(int id);
  Future<List<Trip>> getAllTrips();
  Stream<List<Trip>> watchAllTrips();  // Drift .watch() stream
  Future<Trip> updateTrip(Trip trip);
  Future<void> deleteTrip(int id);
}
```

**Drift implementation notes**:
- `watchAllTrips()` uses `(select(trips)..orderBy([(t) => OrderingTerm.desc(t.startDate)])).watch()`
- `deleteTrip()` uses a Drift transaction to cascade-delete associated expenses and trip-specific exchange rates

**Use case validation rules**:
- CreateTrip: title not empty, max 100 chars; budget > 0, max 10B; baseCurrency in allowed list; endDate >= startDate
- DeleteTrip: cascade-deletes associated expenses and trip-specific exchange rates (in a transaction)

**Acceptance Criteria**:
- [ ] TDD: All tests written BEFORE implementation
- [ ] Repository interface in domain layer (no Drift dependency)
- [ ] Drift implementation in data layer
- [ ] `watchAllTrips()` returns a reactive stream via Drift `.watch()`
- [ ] CreateTrip validates all input constraints
- [ ] DeleteTrip cascades to expenses and exchange rates in a transaction
- [ ] GetTrips returns sorted by startDate descending
- [ ] All tests pass with mocktail mocks

---

#### Task 13: Expense Repository and Use Cases
**User Story**: US-004
**Priority**: P0
**Depends on**: Task 11, Task 16 (for currency conversion)
**Estimated files**: 7 (+ 5 tests)

**Description**: Implement Expense repository and CRUD use cases. CreateExpense and UpdateExpense auto-calculate convertedAmount using exchange rates. Budget aggregation uses Drift SQL `SUM(convertedAmount)`.

**Files to create**:
- `lib/features/expense/domain/repositories/expense_repository.dart`
- `lib/features/expense/data/datasources/expense_local_datasource.dart`
- `lib/features/expense/data/repositories/expense_repository_impl.dart`
- `lib/features/expense/domain/usecases/create_expense.dart`
- `lib/features/expense/domain/usecases/get_expenses.dart`
- `lib/features/expense/domain/usecases/update_expense.dart`
- `lib/features/expense/domain/usecases/delete_expense.dart`
- `test/features/expense/data/repositories/expense_repository_impl_test.dart`
- `test/features/expense/domain/usecases/create_expense_test.dart`
- `test/features/expense/domain/usecases/get_expenses_test.dart`
- `test/features/expense/domain/usecases/update_expense_test.dart`
- `test/features/expense/domain/usecases/delete_expense_test.dart`

**Repository interface**:
```dart
abstract class ExpenseRepository {
  Future<Expense> createExpense(Expense expense);
  Future<Expense?> getExpenseById(int id);
  Future<List<Expense>> getExpensesByTrip(int tripId);
  Stream<List<Expense>> watchExpensesByTrip(int tripId);  // Drift .watch()
  Future<Expense> updateExpense(Expense expense);
  Future<void> deleteExpense(int id);
  Future<void> deleteExpensesByTrip(int tripId);
  Future<double> getTotalSpentByTrip(int tripId); // SQL SUM(convertedAmount)
  Stream<double> watchTotalSpentByTrip(int tripId); // Reactive SUM
}
```

**Drift SQL aggregation** for getTotalSpentByTrip:
```dart
// Native Drift SQL expression instead of manual Dart loop
final query = selectOnly(expenses)
  ..addColumns([expenses.convertedAmount.sum()])
  ..where(expenses.tripId.equals(tripId));
```

**CreateExpense logic**:
1. Accept amount + currency
2. Look up trip's baseCurrency
3. If currency != baseCurrency, use ConvertCurrency use case to calculate convertedAmount
4. If currency == baseCurrency, convertedAmount = amount
5. Save with both original and converted amounts

**Acceptance Criteria**:
- [ ] TDD: All tests written BEFORE implementation
- [ ] CreateExpense auto-calculates convertedAmount
- [ ] UpdateExpense recalculates convertedAmount
- [ ] GetExpensesByTrip returns sorted by date descending
- [ ] `watchExpensesByTrip()` returns reactive stream via Drift `.watch()`
- [ ] `getTotalSpentByTrip` uses Drift SQL SUM (not manual Dart loop)
- [ ] `watchTotalSpentByTrip` provides reactive budget aggregation stream
- [ ] deleteExpensesByTrip used by Trip deletion cascade
- [ ] All tests pass

---

#### Task 14: PaymentMethod Repository and Use Cases
**User Story**: US-003
**Priority**: P0
**Depends on**: Task 11
**Estimated files**: 7 (+ 2 tests)

**Description**: Implement PaymentMethod CRUD with default management logic.

**Files to create**:
- `lib/features/payment_method/domain/repositories/payment_method_repository.dart`
- `lib/features/payment_method/data/datasources/payment_method_local_datasource.dart`
- `lib/features/payment_method/data/repositories/payment_method_repository_impl.dart`
- `lib/features/payment_method/domain/usecases/create_payment_method.dart`
- `lib/features/payment_method/domain/usecases/get_payment_methods.dart`
- `lib/features/payment_method/domain/usecases/update_payment_method.dart`
- `lib/features/payment_method/domain/usecases/delete_payment_method.dart`
- `test/features/payment_method/data/repositories/payment_method_repository_impl_test.dart`
- `test/features/payment_method/domain/usecases/payment_method_usecases_test.dart`

**Business rules**:
- Setting a payment method as default unsets all others (Drift transaction: UPDATE all to false, then SET target to true)
- Cannot delete the last remaining payment method
- Cannot delete a payment method that is used by existing expenses (check Expenses table foreign key)

**Acceptance Criteria**:
- [ ] TDD approach
- [ ] Default toggle logic (only one default at a time) via Drift transaction
- [ ] Delete protection for in-use methods (query Expenses table for references)
- [ ] Delete protection for last-remaining method
- [ ] All tests pass

---

#### Task 15: ExchangeRate Repository and Use Cases
**User Story**: US-005
**Priority**: P0
**Depends on**: Task 11
**Estimated files**: 6 (+ 3 tests)

**Description**: Implement ExchangeRate local repository and currency conversion use case with 4-step fallback chain.

**Files to create**:
- `lib/features/exchange_rate/domain/repositories/exchange_rate_repository.dart`
- `lib/features/exchange_rate/data/datasources/exchange_rate_local_datasource.dart`
- `lib/features/exchange_rate/data/repositories/exchange_rate_repository_impl.dart`
- `lib/features/exchange_rate/domain/usecases/get_exchange_rate.dart`
- `lib/features/exchange_rate/domain/usecases/set_manual_rate.dart`
- `lib/features/exchange_rate/domain/usecases/convert_currency.dart`
- `test/features/exchange_rate/data/repositories/exchange_rate_repository_impl_test.dart`
- `test/features/exchange_rate/domain/usecases/convert_currency_test.dart`

**ConvertCurrency 4-step fallback chain**:
1. Trip-specific rate (isManual or fetched, tripId matches)
2. Global rate (tripId == null)
3. Reverse rate (1 / rate for inverse pair)
4. USD pivot (convert from -> USD -> to, using USD rates)

**Repository interface**:
```dart
abstract class ExchangeRateRepository {
  Future<ExchangeRate?> getRate(String base, String target, {int? tripId});
  Future<List<ExchangeRate>> getRatesByTrip(int tripId);
  Stream<List<ExchangeRate>> watchRatesByTrip(int tripId);  // Drift .watch()
  Future<List<ExchangeRate>> getGlobalRates();
  Future<void> saveRate(ExchangeRate rate);
  Future<void> saveRates(List<ExchangeRate> rates);
  Future<void> deleteRatesByTrip(int tripId);
}
```

**Acceptance Criteria**:
- [ ] TDD approach
- [ ] 4-step fallback chain tested individually
- [ ] Manual rate overrides API rate for same pair
- [ ] Trip-specific rates take priority over global
- [ ] `watchRatesByTrip()` returns reactive stream via Drift `.watch()`
- [ ] ConvertCurrency returns accurate results
- [ ] All tests pass

---

#### Task 16: Exchange Rate Remote Data Source (API) with Fallback
**User Story**: US-005
**Priority**: P1
**Depends on**: Task 10, Task 1 (dio)
**Estimated files**: 3 (+ 1 test)

**Description**: Implement API client for fetching exchange rates with dual-source fallback chain and caching.

**Files to create**:
- `lib/features/exchange_rate/data/datasources/exchange_rate_remote_datasource.dart`
- `lib/features/exchange_rate/domain/usecases/fetch_latest_rates.dart`
- `lib/core/network/network_service.dart`
- `test/features/exchange_rate/data/datasources/exchange_rate_remote_datasource_test.dart`

**API Fallback Chain** (Architect recommendation):
1. **Primary**: `https://open.er-api.com/v6/latest/{base_currency}`
2. **Fallback**: `https://cdn.jsdelivr.net/npm/@fawazahmed0/currency-api@latest/v1/currencies/{base}.json`

If primary API fails (timeout, 5xx, parse error), automatically try fallback API before giving up.

**FetchLatestRates logic**:
1. Check if cached rates are < 24 hours old -> skip fetch if fresh
2. Check network connectivity via `connectivity_plus`
3. If online, try primary API with 5-second timeout
4. If primary fails, try fallback API with 5-second timeout
5. Parse response and save all 7 currency pairs to local DB
6. If both APIs fail or offline, silently skip (use cached rates)
7. Return fetched rates or cached rates

**Acceptance Criteria**:
- [ ] Dio client with 5-second timeout
- [ ] Primary API: `open.er-api.com`
- [ ] Fallback API: `cdn.jsdelivr.net/npm/@fawazahmed0/currency-api`
- [ ] Automatic fallback when primary fails
- [ ] 24-hour cache check before API call
- [ ] Network connectivity check before fetch
- [ ] Graceful offline handling (no crash, use cached)
- [ ] Parses API response for all 7 currencies
- [ ] Unit test with mocked Dio responses (primary success, primary fail + fallback success, both fail)

---

#### Task 17: Budget Calculation Use Cases
**User Story**: US-006
**Priority**: P0
**Depends on**: Task 13, Task 15
**Estimated files**: 4 (+ 1 test)

**Description**: Implement budget summary calculation with status color determination. Uses Drift's reactive `watchTotalSpentByTrip` stream for real-time budget updates.

**Files to create**:
- `lib/features/budget/domain/entities/budget_summary.dart`
- `lib/features/budget/domain/entities/budget_status.dart`
- `lib/features/budget/domain/usecases/get_budget_summary.dart`
- `test/features/budget/domain/usecases/get_budget_summary_test.dart`

**BudgetSummary model**:
```dart
@freezed
class BudgetSummary {
  totalBudget: double
  totalSpent: double
  remaining: double          // totalBudget - totalSpent
  usagePercent: double       // 0.0 to 1.0+ (can exceed 1.0)
  status: BudgetStatus
  currencyCode: String
}

enum BudgetStatus {
  comfortable, // 0-60% → teal
  caution,     // 60-80% → orange
  warning,     // 80-100% → red
  exceeded,    // 100%+ → dark red
}
```

**Acceptance Criteria**:
- [ ] TDD approach
- [ ] Correctly computes remaining and percentage
- [ ] Status thresholds: 0-60% comfortable, 60-80% caution, 80-100% warning, 100%+ exceeded
- [ ] Handles zero budget (no division by zero)
- [ ] Handles case with no expenses (100% remaining)
- [ ] All tests pass

---

### PHASE 4: State Management (Riverpod Providers)

---

#### Task 18: Trip Providers
**User Story**: US-002
**Priority**: P0
**Depends on**: Task 12
**Estimated files**: 2 (+ 1 test)

**Description**: Riverpod providers for trip state management. Uses Drift `.watch()` streams via `StreamProvider`.

**Files to create**:
- `lib/features/trip/presentation/providers/trip_providers.dart`
- `test/features/trip/presentation/providers/trip_providers_test.dart`

**Providers**:
```dart
// All trips list (reactive via Drift .watch() -> StreamProvider)
final tripListProvider = StreamProvider<List<Trip>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.watchAllTrips(); // Drift .watch() returns Stream<List<Trip>>
});

// Single trip by ID
final tripDetailProvider = FutureProvider.family<Trip?, int>((ref, tripId) => ...)

// Trip form state (for create/edit)
final tripFormProvider = StateNotifierProvider<TripFormNotifier, TripFormState>
```

**Acceptance Criteria**:
- [ ] tripListProvider uses Drift `.watch()` stream for reactive updates
- [ ] tripDetailProvider fetches single trip
- [ ] tripFormProvider manages form state (validation, submission)
- [ ] Providers properly invalidate/refresh after mutations
- [ ] Tests verify state transitions

---

#### Task 19: Expense Providers
**User Story**: US-004
**Priority**: P0
**Depends on**: Task 13
**Estimated files**: 2 (+ 1 test)

**Description**: Riverpod providers for expense state management.

**Files to create**:
- `lib/features/expense/presentation/providers/expense_providers.dart`
- `test/features/expense/presentation/providers/expense_providers_test.dart`

**Providers**:
```dart
// Expenses for a trip (reactive via Drift .watch())
final expenseListProvider = StreamProvider.family<List<Expense>, int>((ref, tripId) {
  final db = ref.watch(databaseProvider);
  return db.watchExpensesByTrip(tripId);
});

// Expense form state
final expenseFormProvider = StateNotifierProvider<ExpenseFormNotifier, ExpenseFormState>

// Expenses grouped by date (for list screen)
final groupedExpensesProvider = Provider.family<Map<DateTime, List<Expense>>, int>
```

**ExpenseFilter**:
```dart
class ExpenseFilter {
  int tripId;
  ExpenseCategory? category;      // optional category filter
  SortOrder sortOrder;             // date or amount
}
```

**Acceptance Criteria**:
- [ ] Expenses filterable by category
- [ ] Expenses sortable by date (최신순) or amount (금액순) matching Stitch design
- [ ] groupedExpensesProvider groups by date with daily totals (for Stitch Screen 9)
- [ ] Form provider handles create and edit modes
- [ ] Reactive updates via Drift `.watch()` stream

---

#### Task 20: PaymentMethod Providers
**User Story**: US-003
**Priority**: P0
**Depends on**: Task 14
**Estimated files**: 1

**Description**: Riverpod providers for payment method state.

**Files to create**:
- `lib/features/payment_method/presentation/providers/payment_method_providers.dart`

**Providers**:
```dart
final paymentMethodListProvider = FutureProvider<List<PaymentMethod>>
final defaultPaymentMethodProvider = Provider<PaymentMethod?>
```

**Acceptance Criteria**:
- [ ] Lists all payment methods
- [ ] Identifies the default payment method
- [ ] Refreshes after CRUD mutations

---

#### Task 21: ExchangeRate Providers
**User Story**: US-005
**Priority**: P0
**Depends on**: Task 15, Task 16
**Estimated files**: 1

**Description**: Riverpod providers for exchange rate state, including auto/manual mode toggle.

**Files to create**:
- `lib/features/exchange_rate/presentation/providers/exchange_rate_providers.dart`

**Providers**:
```dart
// Exchange rates for a trip (reactive via Drift .watch())
final tripExchangeRatesProvider = StreamProvider.family<List<ExchangeRate>, int>((ref, tripId) {
  final db = ref.watch(databaseProvider);
  return db.watchRatesByTrip(tripId);
});

// Auto/manual mode toggle
final exchangeRateModeProvider = StateProvider<ExchangeRateMode>

// Trigger API fetch
final fetchRatesProvider = FutureProvider<void>

enum ExchangeRateMode { auto, manual }
```

**Acceptance Criteria**:
- [ ] Auto mode triggers API fetch and displays fetched rates
- [ ] Manual mode allows editing rate fields
- [ ] Toggle between auto/manual preserved per session
- [ ] Rates refresh when switching to auto mode
- [ ] Reactive updates via Drift `.watch()` stream

---

#### Task 22: Budget Providers
**User Story**: US-006
**Priority**: P0
**Depends on**: Task 17
**Estimated files**: 1

**Description**: Riverpod providers for budget summary state.

**Files to create**:
- `lib/features/budget/presentation/providers/budget_providers.dart`

**Providers**:
```dart
// Budget summary for a trip (reactive via Drift watchTotalSpentByTrip)
final budgetSummaryProvider = StreamProvider.family<BudgetSummary, int>((ref, tripId) => ...)
```

**Acceptance Criteria**:
- [ ] Computes budget summary for any trip
- [ ] Auto-refreshes reactively when expenses change (via Drift stream)
- [ ] Returns loading/error states properly

---

### PHASE 5: Shared Widgets

---

#### Task 23: Shared/Reusable Widgets
**User Story**: US-001, US-009
**Priority**: P0
**Depends on**: Task 3, Task 6
**Estimated files**: 5

**Description**: Build reusable widgets used across multiple screens, styled per Stitch design system.

**Stitch Project ID**: `1536195772045761405` (use `get_screen` MCP tool to verify designs)

**Files to create**:
- `lib/shared/widgets/currency_dropdown.dart` - 7-currency dropdown with flags
- `lib/shared/widgets/date_picker_field.dart` - Date picker with Korean/English format
- `lib/shared/widgets/loading_indicator.dart` - Teal circular progress
- `lib/shared/widgets/error_widget.dart` - Error display with retry
- `lib/shared/widgets/app_scaffold.dart` - Common scaffold with teal AppBar

**CurrencyDropdown** (from Stitch Screen 2):
- Shows flag emoji + currency code (e.g. "🇰🇷 KRW")
- 7 options in dropdown
- Used in trip create, expense create

**DatePickerField** (from Stitch Screen 2):
- Shows formatted date in locale
- Taps to open date picker
- Supports single date and date range modes

**Acceptance Criteria**:
- [ ] All widgets use Teal theme
- [ ] CurrencyDropdown shows all 7 currencies with flags
- [ ] DatePickerField supports date range for trip, single date for expense
- [ ] Widgets are fully accessible (Semantics labels)
- [ ] 48dp minimum touch targets

---

#### Task 24: Budget Display Widgets
**User Story**: US-006
**Priority**: P0
**Depends on**: Task 22, Task 23
**Estimated files**: 3

**Description**: Build the two budget visualization widgets from Stitch designs: circular progress (trip detail) and linear progress (home cards).

**Stitch Project ID**: `1536195772045761405` (use `get_screen` MCP tool for Screen 1 and Screen 3)

**Files to create**:
- `lib/features/budget/presentation/widgets/circular_budget_progress.dart`
- `lib/features/budget/presentation/widgets/linear_budget_progress.dart`
- `lib/features/budget/presentation/widgets/budget_summary_card.dart`

**CircularBudgetProgress** (Stitch Screen 3 - Trip Detail):
- Circular/ring progress indicator
- Center: percentage text (e.g. "65%")
- Color changes by BudgetStatus (teal -> orange -> red -> dark red)
- Below: total budget, used, remaining amounts

**LinearBudgetProgress** (Stitch Screen 1 - Home Cards):
- Thin horizontal progress bar
- Teal fill color (changes with status)
- Used inside TripCard on home screen

**BudgetSummaryCard** (Stitch Screen 3):
- Card containing CircularBudgetProgress
- Three stat rows: total/used/remaining with amounts
- Currency-formatted amounts

**Acceptance Criteria**:
- [ ] Circular progress shows percentage in center
- [ ] Linear progress bar thin and compact for cards
- [ ] Colors match BudgetStatus thresholds
- [ ] Amounts formatted with correct currency
- [ ] Handles 0% and >100% edge cases visually

---

#### Task 25: Expense Display Widgets
**User Story**: US-004
**Priority**: P0
**Depends on**: Task 19, Task 23
**Estimated files**: 4

**Description**: Build reusable expense widgets matching Stitch designs.

**Stitch Project ID**: `1536195772045761405` (use `get_screen` MCP tool for Screen 4 and Screen 9)

**Files to create**:
- `lib/features/expense/presentation/widgets/expense_item_card.dart`
- `lib/features/expense/presentation/widgets/category_grid.dart`
- `lib/features/expense/presentation/widgets/amount_input.dart`
- `lib/features/expense/presentation/widgets/payment_method_chips.dart`

**ExpenseItemCard** (Stitch Screen 9 - Expense List):
- Left: category icon in colored circle
- Center: memo text, payment method icon
- Right: **dual amount display** - original amount (e.g. ¥1,500) + converted amount below (e.g. ₩13,500)
- Date shown in group header, not per card

**CategoryGrid** (Stitch Screen 4 - Expense Form):
- 2x4 grid layout
- 8 category buttons with icons and labels
- Selected state: teal highlight

**AmountInput** (Stitch Screen 4):
- Large text input for amount
- Currency dropdown on the left
- Real-time converted amount shown below

**PaymentMethodChips** (Stitch Screen 4):
- Horizontal scrollable chip row
- Each chip: icon + name
- Selected state: filled teal chip

**Acceptance Criteria**:
- [ ] ExpenseItemCard shows dual currency (original + converted)
- [ ] CategoryGrid renders 2x4 with all 8 categories
- [ ] AmountInput shows real-time conversion
- [ ] PaymentMethodChips horizontally scrollable
- [ ] All widgets match Stitch design colors and spacing

---

### PHASE 6: Screens

---

#### Task 26: Home Screen (여행 목록) - Stitch Screen 1
**User Story**: US-002
**Priority**: P0
**Depends on**: Task 18, Task 24
**Estimated files**: 4
**Stitch Project ID**: `1536195772045761405` (fetch Screen 1 via `get_screen` MCP tool)

**Description**: Implement the home screen matching Stitch Screen 1.

**Files to create**:
- `lib/features/trip/presentation/screens/home_screen.dart`
- `lib/features/trip/presentation/widgets/trip_card.dart`
- `lib/features/trip/presentation/widgets/trip_status_badge.dart`
- `lib/features/trip/presentation/widgets/empty_trip_state.dart`

**Layout** (from Stitch):
- **AppBar**: "TripWallet" title, teal background, settings icon button (right)
- **Body**: ListView of TripCards
- **TripCard**: Card with 12px radius containing:
  - Trip title (Lexend semibold)
  - Date range (e.g. "2024.01.15 - 2024.01.22")
  - Base currency badge (small chip, e.g. "KRW")
  - Linear budget progress bar (teal)
  - Trip status badge: 예정 (blue), 진행중 (green), 완료 (gray)
- **FAB**: Teal circular "+" button -> navigates to trip create
- **Empty state**: Suitcase illustration + "여행을 추가해보세요!" text

**Acceptance Criteria**:
- [ ] AppBar teal with "TripWallet" title
- [ ] TripCards show all required info (title, dates, currency, progress, status)
- [ ] Status badges with correct colors (blue/green/gray)
- [ ] Linear progress bar shows budget usage
- [ ] FAB navigates to /trip/create
- [ ] Tap card navigates to /trip/:id
- [ ] Empty state shown when no trips
- [ ] Settings icon navigates to /settings

---

#### Task 27: Trip Create/Edit Screen (여행 생성/수정) - Stitch Screen 2
**User Story**: US-002
**Priority**: P0
**Depends on**: Task 18, Task 23
**Estimated files**: 1
**Stitch Project ID**: `1536195772045761405` (fetch Screen 2 via `get_screen` MCP tool)

**Description**: Implement trip creation and editing form matching Stitch Screen 2.

**Files to create**:
- `lib/features/trip/presentation/screens/trip_create_screen.dart`
- `lib/features/trip/presentation/screens/trip_edit_screen.dart` (reuses form, prefills data)

**Layout** (from Stitch):
- **AppBar**: "여행 추가" (create) / "여행 수정" (edit), back arrow
- **Form fields**:
  1. 여행 제목 - TextFormField with validation
  2. 기본 통화 - CurrencyDropdown (7 currencies with flags)
  3. 예산 - Number input with currency symbol prefix
  4. 시작일 - DatePickerField
  5. 종료일 - DatePickerField
- **Buttons**:
  - 저장: Filled teal button (full width or prominent)
  - 취소: Outlined button

**Acceptance Criteria**:
- [ ] Create mode: empty form, AppBar "여행 추가"
- [ ] Edit mode: prefilled form, AppBar "여행 수정"
- [ ] Validation: title required (max 100), budget > 0, endDate >= startDate
- [ ] Currency dropdown shows flags and codes
- [ ] Save navigates to trip detail (create) or back (edit)
- [ ] Cancel navigates back without saving

---

#### Task 28: Trip Detail Screen Shell with Bottom Tabs - Stitch Screen 3
**User Story**: US-002, US-006
**Priority**: P0
**Depends on**: Task 18, Task 24
**Estimated files**: 1
**Stitch Project ID**: `1536195772045761405` (fetch Screen 3 via `get_screen` MCP tool)

**Description**: Implement the Trip Detail screen as a shell with bottom tab navigation. This screen hosts 3 tabs: Expenses, Exchange Rates, Statistics.

**Files to create**:
- `lib/features/trip/presentation/screens/trip_detail_screen.dart`

**Layout** (from Stitch):
- **AppBar**: Trip title, back arrow, overflow menu (edit/delete)
- **Header section** (always visible above tabs):
  - Trip title + date range + status badge
  - BudgetSummaryCard with CircularBudgetProgress (65% example)
  - Total / Used / Remaining amounts
- **Bottom Tab Bar** (3 tabs):
  - 지출 (Expenses) - default tab
  - 환율 (Exchange Rates)
  - 통계 (Statistics)
- **FAB**: "+" add expense (visible only on 지출 tab)

**Tab Content**:
- Tab 1 (지출): ExpenseListScreen (Task 29)
- Tab 2 (환율): ExchangeRateScreen (Task 32)
- Tab 3 (통계): StatisticsScreen (Task 33)

**Acceptance Criteria**:
- [ ] Header always visible with budget summary
- [ ] Circular progress shows correct percentage and color
- [ ] 3 bottom tabs with correct labels and icons
- [ ] Tab switching preserves state
- [ ] FAB only shown on expense tab
- [ ] Overflow menu has Edit and Delete options
- [ ] Delete shows confirmation dialog

---

#### Task 29: Expense List Tab (지출 목록) - Stitch Screen 9
**User Story**: US-004
**Priority**: P0
**Depends on**: Task 25, Task 28
**Estimated files**: 1
**Stitch Project ID**: `1536195772045761405` (fetch Screen 9 via `get_screen` MCP tool)

**Description**: Implement the expense list as a tab within Trip Detail, matching Stitch Screen 9.

**Files to create**:
- `lib/features/expense/presentation/screens/expense_list_screen.dart`

**Layout** (from Stitch):
- **Filter/sort bar** (top):
  - Category filter dropdown (All + 8 categories)
  - Sort dropdown: 최신순 (date desc), 금액순 (amount desc)
- **Expense list** (grouped by date):
  - Date header: "2024년 1월 17일 (수)" with daily total amount
  - ExpenseItemCards under each date header
  - Each card: category icon (colored circle), memo, **dual amount** (original + converted), payment method icon
- **Empty state**: "지출을 기록해보세요!"

**Acceptance Criteria**:
- [ ] Category filter works (shows filtered subset)
- [ ] Sort by date or amount works
- [ ] Expenses grouped by date with daily total headers
- [ ] Dual currency display on each item (original currency + base currency)
- [ ] Tap item navigates to expense edit
- [ ] Swipe-to-delete or long-press delete
- [ ] Empty state when no expenses

---

#### Task 30: Expense Create/Edit Screen (지출 생성/수정) - Stitch Screen 4
**User Story**: US-004
**Priority**: P0
**Depends on**: Task 19, Task 20, Task 21
**Estimated files**: 1
**Stitch Project ID**: `1536195772045761405` (fetch Screen 4 via `get_screen` MCP tool)

**Description**: Implement the expense creation/editing form matching Stitch Screen 4.

**Files to create**:
- `lib/features/expense/presentation/screens/expense_form_screen.dart`

**Layout** (from Stitch):
- **Large amount input** at top:
  - Currency dropdown (left) + large amount text field
  - Below: "= ₩13,500" converted amount in base currency (real-time)
- **Category grid** (2x4):
  - 식비, 교통, 숙박, 쇼핑, 오락, 관광, 통신, 기타
  - Selected: teal highlight
- **Payment method chips** (horizontal scroll):
  - Shows all user's payment methods
  - Selected: filled teal chip
- **Date picker**: defaults to today
- **Memo input**: optional text field
- **Save button**: Full-width teal filled button "저장"

**Acceptance Criteria**:
- [ ] Amount input with real-time currency conversion display
- [ ] All 8 categories displayed in 2x4 grid with icons
- [ ] Payment methods shown as scrollable chips
- [ ] Date defaults to today, changeable via picker
- [ ] Memo is optional
- [ ] Create mode: empty form
- [ ] Edit mode: prefilled with existing expense data
- [ ] Save validates: amount > 0, category selected, payment method selected
- [ ] After save: returns to expense list

---

#### Task 31: Payment Method Management Screen - Stitch Screen 5
**User Story**: US-003
**Priority**: P1
**Depends on**: Task 20, Task 23
**Estimated files**: 3
**Stitch Project ID**: `1536195772045761405` (fetch Screen 5 via `get_screen` MCP tool)

**Description**: Implement payment method management matching Stitch Screen 5.

**Files to create**:
- `lib/features/payment_method/presentation/screens/payment_method_screen.dart`
- `lib/features/payment_method/presentation/widgets/payment_method_card.dart`
- `lib/features/payment_method/presentation/widgets/payment_method_bottom_sheet.dart`

**Layout** (from Stitch):
- **AppBar**: "지불수단 관리", back arrow
- **List of PaymentMethodCards**:
  - Icon (by type), name, type label
  - "기본" default badge (if isDefault)
  - Edit button, delete button
- **FAB**: "+ 지불수단 추가"
- **Bottom sheet** (for add/edit):
  - Name input
  - Type selector chips (현금, 신용카드, 체크카드, 교통카드, 기타)
  - Default toggle switch

**Acceptance Criteria**:
- [ ] Lists all payment methods with correct icons
- [ ] Default badge shown on default method
- [ ] FAB opens bottom sheet for adding
- [ ] Edit opens bottom sheet with prefilled data
- [ ] Delete shows confirmation, prevents deleting last/in-use method
- [ ] Bottom sheet has name, type chips, default toggle

---

#### Task 32: Exchange Rate Tab (환율 관리) - Stitch Screen 6
**User Story**: US-005
**Priority**: P1
**Depends on**: Task 21, Task 28
**Estimated files**: 3
**Stitch Project ID**: `1536195772045761405` (fetch Screen 6 via `get_screen` MCP tool)

**Description**: Implement exchange rate management as a tab in Trip Detail, matching Stitch Screen 6.

**Files to create**:
- `lib/features/exchange_rate/presentation/screens/exchange_rate_screen.dart`
- `lib/features/exchange_rate/presentation/widgets/exchange_rate_card.dart`
- `lib/features/exchange_rate/presentation/widgets/auto_manual_toggle.dart`

**Layout** (from Stitch):
- **Auto/Manual toggle** at top (segmented button)
- **Currency rate cards** (up to 6, since base is one of 7):
  - Left: base currency flag -> target currency flag
  - Center: rate value (e.g. "1 USD = 1,320.50 KRW")
  - Right: last updated time
  - In manual mode: rate field is editable
- **Refresh button** in AppBar (auto mode only)
- **Last fetched timestamp** shown

**Acceptance Criteria**:
- [ ] Auto/manual toggle works
- [ ] Auto mode: shows API-fetched rates with refresh button
- [ ] Manual mode: rate fields become editable
- [ ] Flag emojis shown for each currency pair
- [ ] Last updated time displayed per rate
- [ ] Refresh triggers API fetch with fallback chain (with loading indicator)
- [ ] Offline: shows cached rates with "offline" indicator

---

#### Task 33: Statistics Tab (통계) - Stitch Screen 7
**User Story**: US-007
**Priority**: P1
**Depends on**: Task 19, Task 28
**Estimated files**: 5 (+ 1 test)
**Stitch Project ID**: `1536195772045761405` (fetch Screen 7 via `get_screen` MCP tool)

**Description**: Implement statistics charts as a tab in Trip Detail, matching Stitch Screen 7.

**Files to create**:
- `lib/features/statistics/presentation/screens/statistics_screen.dart`
- `lib/features/statistics/presentation/widgets/category_pie_chart.dart`
- `lib/features/statistics/presentation/widgets/daily_bar_chart.dart`
- `lib/features/statistics/presentation/widgets/payment_method_chart.dart`
- `lib/features/statistics/presentation/providers/statistics_providers.dart`
- `test/features/statistics/domain/usecases/statistics_usecases_test.dart`

**Layout** (from Stitch):
- **Period filter chips** (top): 전체, 이번 주, 이번 달, 직접 설정
- **Category donut chart**:
  - Donut/ring chart with category colors
  - Center: total amount
  - Legend below with category name + percentage
- **Daily spending bar chart**:
  - X-axis: dates
  - Y-axis: amounts
  - Teal bars
- **Payment method breakdown**:
  - Horizontal bar or pie chart
  - Shows spending by payment method

**Acceptance Criteria**:
- [ ] Period filter chips filter all charts
- [ ] Category donut chart with correct colors per category
- [ ] Total amount shown in donut center
- [ ] Daily bar chart with teal bars
- [ ] Payment method breakdown chart
- [ ] Empty state when no expenses: "지출 데이터가 없습니다"
- [ ] Charts use fl_chart library

---

#### Task 34: Settings Screen (설정) - Stitch Screen 8
**User Story**: US-009
**Priority**: P1
**Depends on**: Task 5, Task 23
**Estimated files**: 2
**Stitch Project ID**: `1536195772045761405` (fetch Screen 8 via `get_screen` MCP tool)

**Description**: Implement settings screen matching Stitch Screen 8.

**Files to create**:
- `lib/features/settings/presentation/screens/settings_screen.dart`
- `lib/features/settings/presentation/providers/settings_providers.dart`

**Layout** (from Stitch):
- **AppBar**: "설정", back arrow
- **Grouped list tiles**:
  - **일반 (General)**: section header in teal
    - 언어 (Language): Korean/English toggle
    - 기본 통화 (Default Currency): currency selector
  - **데이터 (Data)**: section header in teal
    - 백업 (Backup): disabled/placeholder for MVP
    - 복원 (Restore): disabled/placeholder for MVP
  - **정보 (Info)**: section header in teal
    - 버전 (Version): "1.0.0"
    - 개인정보 처리방침 (Privacy Policy): placeholder
    - 오픈소스 라이선스 (Licenses): opens Flutter license page
- **Footer**: TripWallet logo/text at bottom

**Acceptance Criteria**:
- [ ] Language switching works (Korean <-> English) without app restart
- [ ] Language preference saved to SharedPreferences
- [ ] Section headers in teal color
- [ ] Version info displayed
- [ ] License page opens Flutter's built-in license page
- [ ] Backup/Restore shown but disabled (MVP scope)

---

### PHASE 7: Polish and Integration

---

#### Task 35: Complete i18n - All UI Strings
**User Story**: US-008
**Priority**: P0
**Depends on**: All screen tasks (26-34)
**Estimated files**: 2

**Description**: Extract ALL hardcoded strings from all screens into ARB files. Ensure zero hardcoded strings remain. Each ARB file contains only its own locale's strings (no mixed "Save / 저장" format).

**Files to modify**:
- `lib/l10n/app_en.arb`
- `lib/l10n/app_ko.arb`

**String categories to cover**:
- Screen titles and section headers
- Button labels (save, cancel, delete, edit, add)
- Form field labels and hints
- Validation error messages
- Empty state messages
- Category names (8 categories)
- Payment method type names (5 types)
- Budget status labels
- Trip status labels (예정/진행중/완료)
- Settings labels
- Date format patterns
- Currency names
- Confirmation dialog messages
- Error messages (network, validation, generic)

**Acceptance Criteria**:
- [ ] Zero hardcoded user-visible strings in any .dart file
- [ ] All strings use AppLocalizations.of(context)
- [ ] Both app_en.arb and app_ko.arb have identical key sets
- [ ] Each ARB file contains only its locale's translations (no mixed formats)
- [ ] `flutter gen-l10n` succeeds
- [ ] Runtime language switch updates all visible text

---

#### Task 36: App Entry Point Integration (main.dart + app.dart)
**User Story**: US-001
**Priority**: P0
**Depends on**: Tasks 4, 11, 18
**Estimated files**: 2

**Description**: Wire everything together in main.dart and app.dart.

**Files to modify**:
- `lib/main.dart`
- `lib/app.dart`

**main.dart responsibilities**:
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const ProviderScope(
      child: TripWalletApp(),
    ),
  );
}
```

**app.dart (TripWalletApp)**:
- ConsumerWidget wrapping MaterialApp.router
- GoRouter from provider
- AppTheme applied
- Localization delegates configured
- Supported locales: [en, ko]
- Locale from localeProvider
- Background exchange rate fetch on startup (with fallback chain)

**Note**: No `Isar.initializeIsarCore()` needed -- Drift/SQLite initializes via the `databaseProvider`.

**Acceptance Criteria**:
- [ ] App launches without errors
- [ ] Drift DB initialized before UI renders (via Riverpod provider)
- [ ] ProviderScope wraps entire app
- [ ] Theme applied (teal, Lexend)
- [ ] Routing works (GoRouter)
- [ ] i18n works (locale-aware)
- [ ] Exchange rates fetched in background on startup (with dual API fallback)

---

#### Task 37: Integration Tests
**User Story**: US-010
**Priority**: P1
**Depends on**: All above tasks
**Estimated files**: 4

**Description**: Write integration tests covering the 4 key user flows specified in the PRD.

**Files to create**:
- `integration_test/trip_flow_test.dart`
- `integration_test/expense_flow_test.dart`
- `integration_test/multi_currency_test.dart`
- `integration_test/app_test.dart`

**Test flows**:

1. **Trip Lifecycle** (`trip_flow_test.dart`):
   - Create trip with title, currency, budget, dates
   - Verify trip appears in home list
   - Verify status badge (upcoming -> ongoing -> completed based on dates)
   - Edit trip title and budget
   - Delete trip and verify removal

2. **Expense Flow** (`expense_flow_test.dart`):
   - Create trip -> Add expense with category and payment method
   - Verify expense appears in list with correct amounts
   - Verify budget summary updates (spent/remaining)
   - Edit expense amount -> verify budget recalculation
   - Delete expense -> verify budget recalculation

3. **Multi-Currency** (`multi_currency_test.dart`):
   - Create KRW trip -> Add USD expense
   - Verify converted amount in KRW
   - Set manual exchange rate -> Add another expense
   - Verify new rate applied to new expense
   - Verify dual currency display in expense list

4. **Full App** (`app_test.dart`):
   - App launches to home screen
   - Navigate through all screens
   - Verify theme (teal AppBar, Lexend font)
   - Switch language and verify text changes

**Acceptance Criteria**:
- [ ] All 4 test files execute without errors
- [ ] Trip lifecycle flow passes
- [ ] Expense CRUD + budget recalculation passes
- [ ] Multi-currency conversion flow passes
- [ ] App navigation smoke test passes
- [ ] `flutter test integration_test/` passes

---

#### Task 38: Update CLAUDE.md with Project Status
**User Story**: US-010 (acceptance criterion: "CLAUDE.md 프로젝트 현황에 맞게 갱신")
**Priority**: P1
**Depends on**: Task 37
**Estimated files**: 1

**Description**: Update CLAUDE.md to reflect the current project status, architecture decisions, and development guidelines for TripWallet.

**File to modify**:
- `CLAUDE.md` (project root)

**Content to include**:
- Project overview (TripWallet - travel expense tracker)
- Architecture: Clean Architecture + Riverpod + Drift (SQLite) + GoRouter
- Design system: Teal #00897B, Lexend font, Material Design 3
- Supported currencies (7), categories (8), payment types (5)
- Languages: Korean, English
- Key commands: `flutter analyze`, `flutter test`, `flutter test integration_test/`
- Directory structure overview
- Development notes (TDD, freezed for entities, Drift for persistence)

**Acceptance Criteria**:
- [ ] CLAUDE.md exists in project root
- [ ] Contains accurate project status and architecture summary
- [ ] Contains development commands
- [ ] Reflects Drift (not Isar) as the database layer

---

## Commit Strategy

| After Tasks | Commit Message | Branch |
|-------------|---------------|--------|
| 1-2 | `feat: project foundation - dependencies and directory structure` | ralph/trip-wallet-v2 |
| 3-5 | `feat: design system, routing, and i18n setup` | ralph/trip-wallet-v2 |
| 6-11 | `feat: core data layer - entities, models, Drift database` | ralph/trip-wallet-v2 |
| 12-16 | `feat: domain layer - repositories and use cases` | ralph/trip-wallet-v2 |
| 17-22 | `feat: state management - budget calculation and Riverpod providers` | ralph/trip-wallet-v2 |
| 23-25 | `feat: shared and feature widgets` | ralph/trip-wallet-v2 |
| 26-28 | `feat: home, trip create/edit, and trip detail screens` | ralph/trip-wallet-v2 |
| 29-31 | `feat: expense list, expense form, and payment method screens` | ralph/trip-wallet-v2 |
| 32-34 | `feat: exchange rate, statistics, and settings screens` | ralph/trip-wallet-v2 |
| 35-36 | `feat: complete i18n and app entry point integration` | ralph/trip-wallet-v2 |
| 37-38 | `test: integration tests and CLAUDE.md update` | ralph/trip-wallet-v2 |

---

## Parallelization Groups

| Group | Tasks | Can Run In Parallel | Prerequisites |
|-------|-------|---------------------|---------------|
| **A** | 1, 2 | Yes | None |
| **B** | 3, 4, 5, 6 | Yes | Task 2 (Task 1 for packages) |
| **C** | 7, 8, 9, 10 | Yes | Task 1 |
| **D** | 11 | No (needs C) | Tasks 7-10 |
| **E** | 12, 13, 14, 15, 16 | Partial (13 needs 16) | Task 11 |
| **F** | 17, 18, 19, 20, 21 | Partial | Various from E |
| **G** | 22, 23 | Yes | Tasks 17, 3+6 |
| **H** | 24, 25 | Yes | Tasks 22+23, 19+23 |
| **I** | 26, 27, 28 | Yes | Tasks 18+24, 18+23, 18+24 |
| **J** | 29, 30, 31, 32, 33, 34 | Yes | Various from H+I |
| **K** | 35, 36 | Yes | All screens done |
| **L** | 37, 38 | Sequential (38 after 37) | Everything |

---

## Success Criteria

### Functional
- [ ] All 10 user story acceptance criteria met (including US-010 CLAUDE.md update)
- [ ] All 9 Stitch screens accurately rendered (layout-accurate per MCP-accessible designs)
- [ ] 7 currencies supported with conversion (dual API fallback)
- [ ] 8 expense categories functional
- [ ] 5 payment method types functional
- [ ] Korean/English switching works

### Visual / Design
- [ ] Primary color is Teal #00897B throughout
- [ ] Font is Lexend everywhere
- [ ] Card border radius is 12px
- [ ] Material Design 3 theming active (ColorScheme.fromSeed + Stitch overrides)
- [ ] Trip status badges: blue (예정), green (진행중), gray (완료)
- [ ] Circular budget progress in trip detail
- [ ] Linear budget progress in home cards
- [ ] Bottom tabs in trip detail (지출/환율/통계)
- [ ] Dual currency display in expense list

### Quality
- [ ] `flutter analyze` passes with 0 warnings
- [ ] `flutter test` all unit + widget tests pass
- [ ] `flutter test integration_test/` passes
- [ ] No hardcoded strings (all via AppLocalizations)
- [ ] TDD: tests exist for all domain/data layer code
- [ ] Error/Failure classes used for clean error handling

### Performance
- [ ] App cold start <= 2 seconds
- [ ] Expense save response <= 500ms
- [ ] Smooth scrolling with 100+ expenses
- [ ] Budget aggregation via SQL SUM (not Dart loops)

---

## Summary Statistics

| Metric | Value |
|--------|-------|
| Total Tasks | 38 |
| Total Files to Create | ~120 |
| Total Test Files | ~25 |
| User Stories Covered | 10/10 |
| Stitch Screens Covered | 9/9 |
| Supported Currencies | 7 |
| Expense Categories | 8 |
| Payment Method Types | 5 |
| Supported Languages | 2 (Korean, English) |
| Estimated Parallelization Groups | 12 |
| Database | Drift (SQLite) - NOT Isar |
| Exchange Rate APIs | 2 (primary + fallback) |
| Stitch Project ID | 1536195772045761405 |
