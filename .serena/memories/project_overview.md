# TripWallet Project Overview

## Purpose
A Flutter mobile app for tracking travel expenses with multi-currency support, budget management, exchange rate tracking, and statistics. Targets iOS 13+ and Android API 24+.

## Tech Stack
- **Framework**: Flutter (Dart SDK ^3.10.8)
- **Architecture**: Clean Architecture (domain/data/presentation separation per feature)
- **State Management**: Riverpod v3 (flutter_riverpod ^3.1.0)
  - Uses `Notifier`/`NotifierProvider` (NOT StateNotifier - removed in v3)
  - `StreamProvider` for reactive Drift queries
  - `FutureProvider.family` for parameterized queries
- **Database**: Drift ^2.30.1 (SQLite with type-safe queries)
- **Routing**: GoRouter ^17.0.1
- **i18n**: intl + ARB files (Korean/English, 137 strings)
- **Charts**: fl_chart ^1.1.1
- **Code Generation**: Freezed v3 + Drift build_runner
- **Testing**: mocktail ^1.0.4 (NOT mockito)
- **Monetization**: google_mobile_ads ^5.1.0, in_app_purchase ^3.2.0

## Project Status
- **All 38 tasks complete** across 7 implementation phases
- **199+ unit and widget tests passing**
- **flutter analyze**: zero warnings
- **Integration tests**: 4 files created
- **Status**: Production-ready, now adding monetization features

## Design System
- **Primary Color**: Teal #00897B
- **Font**: Lexend (via google_fonts package)
- **Border Radius**: 12px on all cards/containers
- **Material Design 3**: useMaterial3: true
- **Stitch Project ID**: 1536195772045761405
