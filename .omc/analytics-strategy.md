# TripWallet Analytics Strategy & Roadmap
*Strategic Plan for Analytics Enhancement*

**Branch**: `analytics`
**Created**: 2026-02-07
**Status**: Planning Phase

---

## Executive Summary

The current statistics module provides **basic visualization** (3 charts, period filtering) but lacks **analytical depth**, **test coverage**, and **actionable insights**. This plan proposes a phased enhancement to transform statistics into a comprehensive analytics platform.

---

## Current State Analysis

### ✅ Implemented Features
| Feature | Status | Details |
|---------|--------|---------|
| Category Pie Chart | ✅ Working | 8 expense categories with color coding |
| Daily Bar Chart | ✅ Working | Daily spending trends |
| Payment Method Chart | ✅ Working | Payment distribution visualization |
| Period Filtering | ✅ Working | All/Week/Month/Custom date ranges |
| Data Aggregation | ✅ Working | Category/Daily/Payment totals |

### ❌ Critical Gaps
| Gap | Impact | Priority |
|-----|--------|----------|
| **Zero Test Coverage** | High risk of regression | 🔴 CRITICAL |
| Limited analytical depth | Low user value beyond charts | 🔴 HIGH |
| No comparative analytics | Can't compare trips/periods | 🟡 MEDIUM |
| No predictive insights | No budget forecasting | 🟡 MEDIUM |
| No export/reports | Can't share insights | 🟢 LOW |

---

## Strategic Enhancement Phases

### **Phase 1: Foundation & Quality** 🔴 CRITICAL
*Goal: Establish testing foundation and fix architectural issues*

#### 1.1 Test Coverage (TDD Compliance)
**Priority**: CRITICAL
**Effort**: 3-5 days

**Deliverables**:
- [ ] `test/features/statistics/presentation/providers/statistics_providers_test.dart`
  - Mock expense data aggregation
  - Test period filtering logic
  - Test empty state handling
- [ ] `test/features/statistics/presentation/widgets/category_pie_chart_test.dart`
  - Widget rendering tests
  - Color mapping verification
  - Empty data handling
- [ ] `test/features/statistics/presentation/widgets/daily_bar_chart_test.dart`
  - Chart data transformation tests
  - Date normalization tests
- [ ] `test/features/statistics/presentation/widgets/payment_method_chart_test.dart`
  - Payment method aggregation tests
  - Chart rendering tests

**Success Criteria**:
- `flutter test` passes for all statistics tests
- Coverage: >80% for statistics module
- Zero `flutter analyze` warnings

#### 1.2 Code Quality Improvements
**Priority**: HIGH
**Effort**: 1-2 days

**Improvements**:
- Extract magic numbers to constants
- Add comprehensive error handling
- Improve state management patterns
- Add loading states for heavy computations

---

### **Phase 2: Enhanced Analytics** 🟡 HIGH
*Goal: Add analytical depth and user insights*

#### 2.1 Trend Analysis
**Priority**: HIGH
**Effort**: 3-4 days

**Features**:
- [ ] **Spending Velocity Metrics**
  - Average daily spending
  - Spending rate ($/day)
  - Projected end-of-trip total
- [ ] **Trend Indicators**
  - Up/down arrows for trends
  - Percentage change vs previous period
  - Moving averages (7-day, 30-day)
- [ ] **Category Trends**
  - Which categories are increasing/decreasing
  - Category spending patterns over time

**UI Components**:
```dart
class TrendIndicator extends StatelessWidget {
  final double currentAmount;
  final double previousAmount;
  final String label;
}

class SpendingVelocityCard extends StatelessWidget {
  final double avgDailySpend;
  final double projectedTotal;
  final double budgetRemaining;
}
```

#### 2.2 Comparative Analytics
**Priority**: HIGH
**Effort**: 4-5 days

**Features**:
- [ ] **Trip-to-Trip Comparison**
  - Compare current trip vs past trips
  - Category breakdown comparison
  - Budget efficiency comparison
- [ ] **Period-to-Period Comparison**
  - This week vs last week
  - This month vs last month
  - Custom period comparison
- [ ] **Category Deep Dive**
  - Drill down into category details
  - Subcategory analysis (if implemented)
  - Top expenses per category

**Data Structures**:
```dart
class ComparisonData {
  final double currentAmount;
  final double comparisonAmount;
  final double percentageChange;
  final TrendDirection direction;
}

class CategoryInsight {
  final ExpenseCategory category;
  final double percentage;
  final double amount;
  final List<Expense> topExpenses;
}
```

#### 2.3 Intelligent Insights
**Priority**: MEDIUM
**Effort**: 5-7 days

**Features**:
- [ ] **Spending Insights**
  - "You spend 40% of your budget on food"
  - "Transportation costs are 20% higher than average"
  - "You're on track to stay within budget"
- [ ] **Anomaly Detection**
  - Flag unusually high expenses
  - Detect spending spikes
  - Alert on budget threshold breaches
- [ ] **Recommendations**
  - "Consider reducing food expenses by 15%"
  - "You have $200 left for 3 days ($66/day)"
  - "Similar trips spent 30% less on entertainment"

**Provider Pattern**:
```dart
final insightsProvider = FutureProvider.family<List<Insight>, int>((ref, tripId) async {
  final statistics = await ref.watch(statisticsDataProvider(tripId).future);
  final budget = await ref.watch(budgetSummaryProvider(tripId).future);

  return InsightEngine.generateInsights(statistics, budget);
});
```

---

### **Phase 3: Advanced Features** 🟢 MEDIUM
*Goal: Add power-user capabilities*

#### 3.1 Budget Forecasting
**Priority**: MEDIUM
**Effort**: 3-4 days

**Features**:
- [ ] Linear projection based on current spending rate
- [ ] Confidence intervals (best case / worst case)
- [ ] Budget burn-down chart
- [ ] Days until budget exhaustion

**Visualization**:
- Line chart with historical + projected spending
- Budget threshold line
- Shaded confidence region

#### 3.2 Custom Analytics Dashboard
**Priority**: MEDIUM
**Effort**: 5-6 days

**Features**:
- [ ] Drag-and-drop widget arrangement
- [ ] Widget selection (choose which charts to display)
- [ ] Saved dashboard presets
- [ ] Quick filters (category/payment method)

**Widgets Available**:
- Category breakdown (pie/bar)
- Daily trends (line/bar)
- Payment method distribution
- Budget progress
- Top expenses list
- Insights cards

#### 3.3 Export & Reporting
**Priority**: LOW
**Effort**: 4-5 days

**Features**:
- [ ] PDF report generation
  - Trip summary
  - All charts
  - Detailed expense list
  - Insights & recommendations
- [ ] CSV export
  - Raw expense data
  - Aggregated statistics
  - Custom date ranges
- [ ] Share functionality
  - Share as image
  - Share as PDF
  - Share to Google Sheets

---

### **Phase 4: Advanced Analytics** 🟢 LOW
*Goal: Machine learning and predictive analytics*

#### 4.1 Predictive Models
**Priority**: LOW
**Effort**: 7-10 days

**Features**:
- [ ] Budget forecasting with ML
- [ ] Spending pattern recognition
- [ ] Category prediction (auto-categorize)
- [ ] Trip cost estimation for future trips

**Tech Stack**:
- TensorFlow Lite for on-device ML
- Historical data training
- Model versioning

#### 4.2 Cross-Trip Intelligence
**Priority**: LOW
**Effort**: 5-7 days

**Features**:
- [ ] Trip similarity analysis
- [ ] Destination-based spending benchmarks
- [ ] Seasonal trend analysis
- [ ] Traveler profile insights

---

## Technical Architecture

### Data Layer Enhancements

#### New Domain Entities
```dart
// lib/features/analytics/domain/entities/

@freezed
class AnalyticsInsight with _$AnalyticsInsight {
  const factory AnalyticsInsight({
    required String id,
    required InsightType type,
    required String title,
    required String description,
    required InsightPriority priority,
    required DateTime generatedAt,
    Map<String, dynamic>? metadata,
  }) = _AnalyticsInsight;
}

enum InsightType {
  spending, // Spending pattern insight
  budget,   // Budget-related insight
  trend,    // Trend analysis
  anomaly,  // Unusual activity
  recommendation, // Actionable recommendation
}

@freezed
class TrendData with _$TrendData {
  const factory TrendData({
    required List<DataPoint> historicalData,
    required List<DataPoint> projectedData,
    required TrendDirection direction,
    required double changePercentage,
    required double confidence,
  }) = _TrendData;
}

@freezed
class ComparisonResult with _$ComparisonResult {
  const factory ComparisonResult({
    required String label,
    required double currentValue,
    required double comparisonValue,
    required double difference,
    required double percentageChange,
  }) = _ComparisonResult;
}
```

#### New Use Cases
```dart
// lib/features/analytics/domain/usecases/

class GenerateInsights {
  Future<List<AnalyticsInsight>> call(int tripId);
}

class CompareTripStatistics {
  Future<ComparisonResult> call(int tripId1, int tripId2);
}

class ForecastBudget {
  Future<TrendData> call(int tripId, int daysAhead);
}

class DetectAnomalies {
  Future<List<AnalyticsInsight>> call(int tripId);
}
```

### Presentation Layer Enhancements

#### New Widgets
```dart
// lib/features/analytics/presentation/widgets/

- InsightCard (displays individual insights)
- TrendLineChart (historical + projected)
- ComparisonBarChart (side-by-side comparison)
- SpendingVelocityGauge (speedometer-style)
- BudgetBurndownChart (burndown visualization)
- CategoryDrilldownSheet (bottom sheet with details)
- AnomalyAlert (warning banner)
```

#### New Providers
```dart
// lib/features/analytics/presentation/providers/

final analyticsInsightsProvider = FutureProvider.family<List<AnalyticsInsight>, int>(...);
final trendAnalysisProvider = FutureProvider.family<TrendData, int>(...);
final tripComparisonProvider = FutureProvider.family<ComparisonResult, TripComparisonParams>(...);
final budgetForecastProvider = FutureProvider.family<TrendData, ForecastParams>(...);
```

---

## Testing Strategy

### Test Pyramid
```
        /\
       /UI\        Integration Tests (10%)
      /----\       - Full user flows
     /Widget\      Widget Tests (30%)
    /--------\     - Chart rendering
   /   Unit   \    Unit Tests (60%)
  /____________\   - Use cases, providers, calculations
```

### Test Coverage Goals
| Layer | Target Coverage | Priority |
|-------|----------------|----------|
| Domain (Use Cases) | 95%+ | CRITICAL |
| Data (Repositories) | 90%+ | HIGH |
| Providers | 85%+ | HIGH |
| Widgets | 70%+ | MEDIUM |

### Test Files Structure
```
test/features/analytics/
├── domain/
│   ├── usecases/
│   │   ├── generate_insights_test.dart
│   │   ├── compare_trips_test.dart
│   │   └── forecast_budget_test.dart
│   └── entities/
│       └── analytics_insight_test.dart
├── presentation/
│   ├── providers/
│   │   ├── analytics_insights_provider_test.dart
│   │   └── trend_analysis_provider_test.dart
│   └── widgets/
│       ├── insight_card_test.dart
│       ├── trend_line_chart_test.dart
│       └── comparison_bar_chart_test.dart
```

---

## Implementation Priorities

### Immediate Action Items (Next Sprint)
1. 🔴 **Create test suite for existing statistics module** (Phase 1.1)
   - Effort: 3-5 days
   - Blocker: TDD compliance, prevents future work
2. 🔴 **Fix code quality issues** (Phase 1.2)
   - Effort: 1-2 days
   - Improves maintainability

### Short-term Goals (1-2 Months)
1. 🟡 **Implement trend analysis** (Phase 2.1)
   - Adds immediate user value
   - Foundation for predictive features
2. 🟡 **Add comparative analytics** (Phase 2.2)
   - High user demand
   - Differentiates from competitors

### Medium-term Goals (3-6 Months)
1. 🟡 **Build intelligent insights engine** (Phase 2.3)
   - Transforms data into actionable recommendations
2. 🟢 **Implement budget forecasting** (Phase 3.1)
   - Helps users stay within budget

### Long-term Vision (6+ Months)
1. 🟢 **Machine learning integration** (Phase 4.1)
   - Advanced predictive capabilities
2. 🟢 **Cross-trip intelligence** (Phase 4.2)
   - Community insights

---

## Success Metrics

### Technical Metrics
- [ ] Test coverage: >80% for analytics module
- [ ] Zero `flutter analyze` warnings
- [ ] All tests pass: `flutter test`
- [ ] Build time: <2 minutes
- [ ] App size increase: <2MB

### User Experience Metrics
- [ ] Insight generation time: <500ms
- [ ] Chart rendering time: <200ms
- [ ] Smooth scrolling: 60fps
- [ ] Zero crashes in analytics screens

### Business Metrics
- [ ] User engagement: +30% time on statistics screen
- [ ] Feature adoption: 70%+ users view insights
- [ ] User satisfaction: 4.5+ rating for analytics
- [ ] Budget adherence: +20% users stay within budget

---

## Risk Assessment

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| Performance degradation with large datasets | Medium | High | Implement pagination, lazy loading |
| Complex calculations slow UI | Medium | Medium | Use isolates for heavy computation |
| Test suite takes too long | Low | Medium | Parallel test execution |
| User confusion with insights | Medium | Medium | Clear onboarding, tooltips |
| ML model size bloat | Medium | High | On-demand model download |

---

## Technical Debt

### Current Debt
1. No tests for statistics module
2. Hard-coded period filtering logic
3. No error handling for edge cases
4. Tight coupling between UI and data layer

### Debt Repayment Plan
- Phase 1 addresses testing debt
- Phase 2 refactors filtering logic
- Phase 3 adds comprehensive error handling
- Continuous refactoring throughout

---

## Dependencies & Prerequisites

### Technical Dependencies
- ✅ Riverpod v3 (already implemented)
- ✅ Drift database (already implemented)
- ✅ fl_chart (already implemented)
- ⏳ charts_flutter (optional, for advanced charts)
- ⏳ pdf (for PDF export)
- ⏳ share_plus (for sharing)
- ⏳ tflite_flutter (for ML, Phase 4 only)

### Data Prerequisites
- ✅ Expense data with categories
- ✅ Budget data
- ✅ Multi-currency support
- ⏳ Historical trip data (for comparisons)
- ⏳ User preferences (for personalization)

---

## Resource Allocation

### Team Composition (Suggested)
- **1 Senior Flutter Developer**: Architecture, complex features
- **1 Mid-level Flutter Developer**: UI implementation, testing
- **1 QA Engineer**: Test coverage, integration tests
- **1 Designer**: UX for insights, dashboards (optional)

### Time Estimates
| Phase | Effort | Duration |
|-------|--------|----------|
| Phase 1 (Foundation) | 4-7 days | 1 sprint |
| Phase 2 (Enhanced Analytics) | 12-16 days | 2-3 sprints |
| Phase 3 (Advanced Features) | 12-15 days | 2-3 sprints |
| Phase 4 (ML & Intelligence) | 12-17 days | 3-4 sprints |
| **Total** | **40-55 days** | **8-11 sprints** |

---

## Next Steps

### Immediate Actions
1. **Review & Approval**: Get stakeholder sign-off on strategy
2. **Create Phase 1 Tasks**: Break down testing work into tasks
3. **Set Up Branch**: Ensure `analytics` branch is up to date
4. **Begin TDD Cycle**: Start with first test file

### Week 1 Plan
```bash
# Day 1-2: Statistics Provider Tests
- Write tests for statisticsDataProvider
- Test category aggregation
- Test daily aggregation
- Test payment method aggregation

# Day 3-4: Widget Tests
- CategoryPieChart tests
- DailyBarChart tests
- PaymentMethodChart tests

# Day 5: Integration & Cleanup
- Run full test suite
- Fix any issues
- Code review
```

### Decision Points
- [ ] Approve overall strategy (Yes/No)
- [ ] Prioritize phases (reorder if needed)
- [ ] Allocate resources (who works on this?)
- [ ] Set timeline (when to start?)
- [ ] Define success criteria (what defines "done"?)

---

## Appendix

### Related Documents
- PRD: `.omc/prd.json`
- CLAUDE.md: `.claude/CLAUDE.md`
- Main AGENTS.md: `AGENTS.md`

### References
- [Riverpod v3 Documentation](https://riverpod.dev)
- [fl_chart Documentation](https://pub.dev/packages/fl_chart)
- [Drift Documentation](https://drift.simonbinder.eu)
- [Flutter Testing Best Practices](https://flutter.dev/docs/testing)

---

**Document Version**: 1.0
**Last Updated**: 2026-02-07
**Next Review**: After Phase 1 completion
