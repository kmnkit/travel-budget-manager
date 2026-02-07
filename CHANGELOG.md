# Changelog

All notable changes to TripWallet will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.1.0] - 2026-02-07

### Added - Phase 3.3: Export & Reporting

#### PDF Report Generation
- **5-page PDF report generation** with professional layout
  - Cover page: Trip title, dates, total spending, generation timestamp
  - Summary page: Budget status, spending statistics, key metrics
  - Expense list: Detailed expenses grouped by date with subtotals
  - Charts page: Category pie chart, daily bar chart, payment method distribution, budget burndown
  - Insights page: Smart analytics insights, trends, recommendations
- **Korean font support** (NotoSansKR) for perfect Hangul rendering
- **Automatic report data collection** from all features (trip, expenses, statistics, budget, insights, forecast)

#### Native Share Integration
- **Native share dialog** integration using share_plus
- **One-click sharing** to KakaoTalk, Email, Drive, and other apps
- **PDF file management** with automatic naming (trip_report_{id}_{timestamp}.pdf)

#### UI Integration
- **Export button** added to Statistics screen AppBar
- **Export button** added to Trip Detail screen AppBar
- **Export bottom sheet** with status-driven UI (idle → generating → completed → share)
- **Korean localization** for all export-related strings (11 new ARB entries)

#### Architecture & Testing
- **Clean Architecture** implementation (domain/data/presentation layers)
- **61 new tests** across all layers (entities, use cases, repositories, providers, widgets, integration)
- **TDD methodology** strictly followed (RED → GREEN → REFACTOR)
- **Riverpod v3 patterns** using NotifierProvider (not deprecated StateNotifier)

#### Dependencies Added
- `pdf: ^3.11.1` - PDF document generation
- `share_plus: ^10.1.2` - Native share functionality
- `printing: ^5.13.3` - PDF preview and printing support

### Changed
- **Test count**: 652 → 713 tests (all passing)
- **ARB strings**: 137 → 148 translations
- **Font stack**: Added NotoSansKR for PDF Korean text rendering

### Technical Details
- **Repository pattern**: ExportRepository with data collection and PDF generation
- **PDF Generator service**: Modular 5-page builder architecture
- **Error handling**: Graceful fallback for missing forecast data
- **Provider design**: ExportNotifier with state machine (idle/generating/completed/failed)
- **Integration points**: Statistics and Trip Detail screens

---

## [1.0.0] - 2026-02-03

### Added - Initial Release

#### Core Features
- Multi-currency expense tracking (7 currencies: KRW, USD, EUR, JPY, GBP, AUD, CAD)
- Trip management with budget tracking
- 8 expense categories with color coding
- 5 payment method types
- Real-time currency conversion with 4-tier fallback system
- Dual API fallback for exchange rates
- Budget status monitoring (4 levels: comfortable, warning, limit, over)

#### Statistics & Analytics
- Pie chart: Category-wise spending breakdown
- Bar chart: Daily spending trends
- Payment method distribution
- Comprehensive statistics dashboard

#### Technical Foundation
- **Architecture**: Clean Architecture (domain/data/presentation)
- **State Management**: Riverpod v3
- **Database**: Drift (SQLite) with 4 tables
- **Routing**: GoRouter
- **Immutability**: Freezed v3
- **Charts**: fl_chart
- **Design**: Material Design 3, Teal theme, Lexend font
- **i18n**: Korean/English (137 strings)

#### Testing
- 652 tests (unit, widget, integration)
- TDD methodology enforced
- Mocktail-based mocking
- Zero analyzer warnings

---

## Version Notes

- **v1.1.0**: Export & Reporting feature complete (Phase 3.3)
- **v1.0.0**: Initial production release

---

**Next Planned Features** (Future Phases):
- Cloud sync and backup
- Multi-device synchronization
- Advanced analytics and AI insights
- Expense receipt scanning (OCR)
- Travel itinerary integration
