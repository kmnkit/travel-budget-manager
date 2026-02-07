# TripWallet Project Overview

## Purpose
TripWallet is a Flutter mobile app for managing travel expenses with multi-currency support. It provides:
- 7 currency support (KRW, USD, EUR, JPY, GBP, AUD, CAD)
- Real-time exchange rate integration with 4-tier fallback
- Budget tracking with 4 status levels
- Statistics and charts (pie/bar charts)
- 8 expense categories, 5 payment method types
- Offline-first architecture with Drift SQLite

## Tech Stack
- **Framework**: Flutter 3.10.8+ / Dart 3.10.8+
- **State Management**: Riverpod v3 (NotifierProvider, StreamProvider, FutureProvider.family)
- **Database**: Drift 2.30.1 (SQLite, reactive streams)
- **Routing**: GoRouter 17.0.1
- **Immutability**: Freezed v3
- **Charts**: fl_chart 1.1.1
- **i18n**: intl + ARB (137 strings, Korean/English)
- **HTTP**: Dio 5.7.0
- **Testing**: mocktail (NOT mockito), flutter_test
- **Design**: Material Design 3, Teal #00897B, Lexend font

## Architecture
Clean Architecture pattern with strict layer separation:
```
presentation → domain ← data
```

Feature modules (each with domain/data/presentation):
- trip, expense, payment_method, exchange_rate
- budget, statistics, settings, onboarding

## Current Status
- **Branch**: analytics
- **Tests**: 231 statistics tests passing (Phase 1 + 2.1 + 2.2)
- **Build**: flutter analyze passes with 0 warnings
- **Version**: 1.0.0+1
- **Status**: Production-ready

## Analytics Enhancement Progress
- **Phase 1**: ✅ Complete (55 tests) - Base statistics infrastructure
- **Phase 2.1**: ✅ Complete (69 tests) - Trend Analysis (linear regression, spending velocity)
- **Phase 2.2**: ✅ Complete (~107 tests) - Comparative Analytics (period comparison, category insights)
- **Phase 2.3**: Pending - Budget Analytics
- **Total Statistics Tests**: 231
