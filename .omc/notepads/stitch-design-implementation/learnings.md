# Learnings - Core Layer Implementation

## TDD Approach
- Created test files FIRST (currency_formatter_test.dart, date_formatter_test.dart)
- Then implemented production code to make tests pass
- Tests verify currency formatting (KRW, USD, EUR, JPY) with correct decimal places
- Tests verify date formatting (yyyy.MM.dd format, date ranges, daysBetween)

## Design System Structure
- **Theme layer**: app_colors.dart, app_text_styles.dart, app_theme.dart
- **Primary color**: Teal #00897B (from Stitch design)
- **Typography**: Lexend font via google_fonts
- **Border radius**: 12px standard (Material Design 3)
- **8 expense categories** with distinct colors
- **4 budget status colors** (comfortable, caution, warning, exceeded)

## Currency System
- **7 supported currencies**: KRW, USD, EUR, JPY, GBP, AUD, CAD
- **SupportedCurrency enum** with code, symbol, localized names, decimal places
- **fromCode() method** handles case-insensitive lookup with USD fallback
- **CurrencyFormatter** uses intl package for proper locale formatting

## Error Handling Pattern
- **Failures** (domain layer): DatabaseFailure, NetworkFailure, ValidationFailure, NotFoundFailure, CacheFailure
- **Exceptions** (data layer): DatabaseException, NetworkException, CacheException, ValidationException
- Clean Architecture: Failures in domain, Exceptions in data layer

## Date Utilities
- **formatDate()**: yyyy.MM.dd format (Korean standard)
- **formatDateRange()**: "start - end" format
- **daysBetween()**: Ignores time component, pure date calculation
- **formatRelative()**: "today", "tomorrow", "in N days", "N days ago"

## Context Extensions
- BuildContext extensions for theme, textTheme, colorScheme, l10n, mediaQuery, screenSize
- Reduces boilerplate: `context.theme` instead of `Theme.of(context)`

## Files Created
### lib/core/
- theme/app_colors.dart
- theme/app_text_styles.dart
- theme/app_theme.dart
- constants/app_constants.dart
- constants/currency_constants.dart
- errors/failures.dart
- errors/exceptions.dart
- utils/currency_formatter.dart
- utils/date_formatter.dart
- extensions/context_extensions.dart

### test/core/
- utils/currency_formatter_test.dart (7 tests)
- utils/date_formatter_test.dart (5 tests)

## Next Steps
- Domain entities will use these utilities
- Theme will be applied in main.dart
- Error classes will be used in repository implementations
