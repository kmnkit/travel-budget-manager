# TripWallet Project Overview

## Purpose
A Flutter mobile app for tracking travel expenses with multi-currency support, budget management, exchange rate tracking, and statistics. Targets iOS 13+ and Android API 24+.

## Tech Stack
- **Language**: Dart (SDK ^3.10.8)
- **Framework**: Flutter
- **State Management**: Riverpod v3 (flutter_riverpod ^3.1.0)
  - Uses `Notifier`/`NotifierProvider` (NOT StateNotifier - deprecated in v3)
  - `StreamProvider` for reactive Drift queries
- **Database**: Drift ^2.30.1 (SQLite) with reactive `.watch()` streams
- **Routing**: GoRouter ^17.0.1
- **i18n**: intl ^0.20.2 + ARB files (Korean/English)
- **Charts**: fl_chart ^1.1.1
- **HTTP Client**: Dio ^5.7.0
- **Code Generation**: 
  - Freezed ^3.2.3 (immutable data classes)
  - drift_dev ^2.30.1
  - riverpod_generator ^4.0.0+1
- **Testing**: mocktail ^1.0.4 (NOT mockito)
- **Fonts**: google_fonts ^8.0.0 (Lexend)

## Design System
- **Primary Color**: Teal #00897B
- **Font**: Lexend (via google_fonts)
- **Border Radius**: 12px on cards/containers
- **Material Design 3**: `useMaterial3: true`
- **Trip Status Colors**: upcoming=blue #2196F3, ongoing=green #4CAF50, completed=gray #9E9E9E
- **Budget Status Colors**: comfortable=teal, caution=orange #FFA726, warning=red #EF5350, exceeded=dark red #D32F2F

## Supported Data
- **Currencies** (7): KRW, USD, EUR, JPY, GBP, AUD, CAD
- **Expense Categories** (8): food, transport, accommodation, shopping, entertainment, sightseeing, communication, other
- **Payment Method Types** (5): cash, creditCard, debitCard, transitCard, other

## Current Status
- All 38 tasks complete across 7 implementation phases
- 199+ unit and widget tests passing
- flutter analyze: zero warnings
- Integration tests: 4 files created
- Status: Production-ready
