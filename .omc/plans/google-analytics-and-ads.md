# Google Analytics & AdMob Integration Plan

## 1. 요구사항 요약

### 1.1 프로젝트 컨텍스트
- **앱**: TripWallet - 여행 가계부 앱 (Flutter)
- **현재 상태**: Production-ready (199+ tests passing)
- **아키텍처**: Clean Architecture (domain/data/presentation)
- **상태관리**: Riverpod v3
- **지원 언어**: Korean/English (intl + ARB)

### 1.2 목표
1. **Google Analytics (Firebase Analytics GA4)**: 사용자 행동 분석을 통한 UX 개선
2. **Google AdMob**: 수익화를 위한 광고 통합
3. **개인정보 보호 규정 준수**: GDPR, 한국 개인정보보호법, Apple ATT

### 1.3 수집 가능/불가 데이터 정의

| 수집 가능 (익명) | 수집 불가 (개인정보) |
|-----------------|-------------------|
| screen_view (화면 조회) | 사용자 이름, 이메일 |
| 버튼 클릭 이벤트 | 실제 지출 금액 |
| 기능 사용 빈도 | 예산 정보 |
| 앱 성능 데이터 (crash, ANR) | 여행 목적지 |
| 언어/통화 설정 (익명) | 결제 수단 상세 정보 |
| 기기 유형, OS 버전 | 위치 정보 |

---

## 2. 수락 기준 (Acceptance Criteria)

### 2.1 개인정보 동의 관리 (Consent Management)
- [ ] 앱 최초 실행 시 동의 화면 표시 **(온보딩 이전에 표시)**
- [ ] 동의 화면에 데이터 수집 범위 명확히 안내
- [ ] 동의/거부 선택에 따른 분기 처리
- [ ] 동의 상태 SharedPreferences에 영구 저장
- [ ] 설정 화면에서 언제든 동의 철회 가능
- [ ] **동의 철회 시 기존 수집 데이터 삭제 요청 안내**
- [ ] Apple ATT (App Tracking Transparency) 다이얼로그 iOS에서 표시
- [ ] 한국어/영어 번역 완료

### 2.2 Google Analytics 통합
- [ ] Firebase 프로젝트 연동 (iOS/Android)
- [ ] 핵심 이벤트 자동 로깅:
  - `screen_view`: 모든 화면 전환
  - `app_open`: 앱 실행
  - `app_update`: 앱 업데이트 후 첫 실행
- [ ] 커스텀 이벤트 로깅 (동의 시에만):
  - `trip_created`: 여행 생성 (count만, 세부정보 없음)
  - `expense_added`: 지출 추가 (category만, 금액 없음)
  - `feature_used`: 기능 사용 (통계 조회, 환율 확인 등)
- [ ] 사용자 속성 설정 (익명):
  - `preferred_currency`: 기본 통화
  - `app_language`: 앱 언어
- [ ] 동의 거부 시 Analytics 완전 비활성화

### 2.3 AdMob 광고 통합
- [ ] AdMob 앱 등록 (iOS/Android)
- [ ] Banner Ad 구현:
  - 홈 화면 하단 (`home_screen.dart`)
  - 지출 목록 화면 하단
- [ ] Interstitial Ad 구현:
  - 여행 완료 시 표시 (빈도 제한: 3회 중 1회)
- [ ] Native Ad 구현 (선택):
  - 통계 화면 콘텐츠 사이
- [ ] 동의 거부 시 개인화되지 않은 광고 표시 또는 광고 비표시
- [ ] 테스트 광고 모드 지원 (debug build)

### 2.4 A/B 테스트 구조
- [ ] Firebase Remote Config 연동
- [ ] 광고 위치 변형 (variant) 정의
- [ ] 광고 노출/클릭 이벤트 로깅

### 2.5 테스트
- [ ] 동의 흐름 단위 테스트
- [ ] Analytics 서비스 단위 테스트 (mock)
- [ ] AdMob 위젯 테스트 (mock)
- [ ] 동의 상태별 분기 통합 테스트

---

## 3. 구현 단계 (Implementation Steps)

### Phase 1: 기반 설정 (Foundation)

#### Task 1.1: Firebase 프로젝트 설정
**파일**: `android/app/google-services.json`, `ios/Runner/GoogleService-Info.plist`, `ios/Runner/Info.plist`

1. Firebase Console에서 프로젝트 생성
2. iOS/Android 앱 등록
3. 설정 파일 다운로드 및 배치
4. iOS Info.plist에 ATT 설명 추가:
   ```xml
   <key>NSUserTrackingUsageDescription</key>
   <string>이 앱은 맞춤 광고와 서비스 개선을 위해 사용자 활동을 추적합니다.</string>
   ```

#### Task 1.2: 의존성 추가
**파일**: `pubspec.yaml`

```yaml
dependencies:
  firebase_core: ^3.8.1
  firebase_analytics: ^11.4.1
  google_mobile_ads: ^6.0.0
  firebase_remote_config: ^5.3.1
  app_tracking_transparency: ^2.0.6
```

#### Task 1.3: Firebase 초기화
**파일**: `lib/main.dart`

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const ProviderScope(child: TripWalletApp()));
}
```

---

### Phase 2: 동의 관리 Feature 구현

#### Task 2.1: Domain Layer
**디렉토리**: `lib/features/consent/domain/`

| 파일 | 설명 |
|-----|------|
| `entities/consent_status.dart` | Freezed 엔티티: analyticsConsent, personalizedAdsConsent, attStatus |
| `repositories/consent_repository.dart` | 추상 인터페이스 |

```dart
// consent_status.dart
@freezed
class ConsentStatus with _$ConsentStatus {
  const factory ConsentStatus({
    required bool analyticsConsent,
    required bool personalizedAdsConsent,
    required bool attGranted, // iOS only
    required DateTime? consentDate,
  }) = _ConsentStatus;
}
```

#### Task 2.2: Data Layer
**디렉토리**: `lib/features/consent/data/`

| 파일 | 설명 |
|-----|------|
| `datasources/consent_local_datasource.dart` | SharedPreferences 저장/조회 |
| `repositories/consent_repository_impl.dart` | 구현체 |

#### Task 2.3: Presentation Layer - Providers
**디렉토리**: `lib/features/consent/presentation/providers/`

| 파일 | 설명 |
|-----|------|
| `consent_providers.dart` | consentStatusProvider, consentNotifierProvider |

#### Task 2.4: Presentation Layer - Consent Screen
**디렉토리**: `lib/features/consent/presentation/screens/`

| 파일 | 설명 |
|-----|------|
| `consent_screen.dart` | 동의 화면 UI (체크박스, 설명, 버튼) |

**UI 요소:**
- 앱 로고 및 환영 메시지
- 데이터 수집 범위 설명 (수집 항목 목록)
- 개인정보 처리방침 링크
- Analytics 동의 체크박스 (필수 아님)
- 맞춤 광고 동의 체크박스 (필수 아님)
- "모두 동의" 버튼
- "선택 동의" 버튼
- "동의 없이 계속" 버튼

#### Task 2.5: iOS ATT 다이얼로그 통합
**파일**: `lib/features/consent/presentation/screens/consent_screen.dart`

```dart
// iOS에서만 ATT 다이얼로그 표시
if (Platform.isIOS) {
  final status = await AppTrackingTransparency.requestTrackingAuthorization();
  // status에 따른 처리
}
```

#### Task 2.6: 라우터 및 앱 플로우 업데이트
**파일**: `lib/core/router/app_router.dart`, `lib/app.dart`

**중요: 동의 → 온보딩 순서**

동의 화면은 온보딩 **이전에** 표시되어야 합니다. 이유:
1. 온보딩 중에도 Analytics 이벤트가 발생할 수 있음
2. GDPR/개인정보보호법 요구사항: 데이터 수집 전 동의 필요
3. 사용자 경험: 앱 사용 시작 전 개인정보 설정 완료

**앱 플로우:**
```
앱 시작 → 동의 상태 확인 → 동의 미완료? → 동의 화면 → 온보딩 → 홈
                          ↓
                       동의 완료? → 온보딩 상태 확인 → 온보딩 미완료? → 온보딩 → 홈
                                                     ↓
                                                  온보딩 완료? → 홈
```

**app.dart 수정 방향:**

현재 `app.dart`는 3개의 MaterialApp 분기가 있습니다:
1. Loading 상태 (line 20-40)
2. Onboarding 미완료 상태 (line 44-66)
3. Main app (line 72-92의 `_buildMainApp`)

수정 후:
1. Loading 상태 - 동의 + 온보딩 상태 동시 로드
2. 동의 미완료 상태 - ConsentScreen 표시
3. 온보딩 미완료 상태 - OnboardingScreen 표시
4. Main app - 기존과 동일

```dart
// app.dart 수정 개요
class TripWalletApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final consentAsync = ref.watch(consentCompletedProvider);
    final onboardingAsync = ref.watch(onboardingCompletedProvider);
    final locale = ref.watch(localeProvider);

    // 1. Loading 상태
    if (consentAsync.isLoading || onboardingAsync.isLoading) {
      return _buildLoadingApp(locale);
    }

    // 2. 동의 미완료 → 동의 화면
    final consentCompleted = consentAsync.valueOrNull ?? false;
    if (!consentCompleted) {
      return _buildConsentApp(ref, locale);
    }

    // 3. 온보딩 미완료 → 온보딩 화면
    final onboardingCompleted = onboardingAsync.valueOrNull ?? false;
    if (!onboardingCompleted) {
      return _buildOnboardingApp(ref, locale);
    }

    // 4. Main app
    return _buildMainApp(ref, locale);
  }
}
```

---

### Phase 3: Analytics Feature 구현

#### Task 3.1: Domain Layer
**디렉토리**: `lib/features/analytics/domain/`

| 파일 | 설명 |
|-----|------|
| `repositories/analytics_repository.dart` | 추상 인터페이스 |

```dart
abstract class AnalyticsRepository {
  Future<void> logScreenView(String screenName);
  Future<void> logEvent(String name, Map<String, Object>? parameters);
  Future<void> setUserProperty(String name, String value);
  Future<void> setAnalyticsEnabled(bool enabled);
}
```

#### Task 3.2: Data Layer
**디렉토리**: `lib/features/analytics/data/`

| 파일 | 설명 |
|-----|------|
| `repositories/analytics_repository_impl.dart` | Firebase Analytics 래퍼 |

**개인정보 보호 필터 구현:**
```dart
// 금지된 파라미터 필터링
const _forbiddenParams = ['amount', 'budget', 'destination', 'location'];

Future<void> logEvent(String name, Map<String, Object>? parameters) async {
  if (!_isEnabled) return;

  final sanitized = parameters?.entries
    .where((e) => !_forbiddenParams.contains(e.key))
    .toMap();

  await _analytics.logEvent(name: name, parameters: sanitized);
}
```

#### Task 3.3: Presentation Layer - Providers
**디렉토리**: `lib/features/analytics/presentation/providers/`

| 파일 | 설명 |
|-----|------|
| `analytics_providers.dart` | analyticsRepositoryProvider |

#### Task 3.4: Analytics Observer 구현
**파일**: `lib/features/analytics/presentation/observers/analytics_route_observer.dart`

**주의: GoRouter는 NavigatorObserver를 직접 사용합니다.**

```dart
class AnalyticsRouteObserver extends NavigatorObserver {
  final AnalyticsRepository _analytics;

  AnalyticsRouteObserver(this._analytics);

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    _logScreenView(route);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (newRoute != null) _logScreenView(newRoute);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    if (previousRoute != null) _logScreenView(previousRoute);
  }

  void _logScreenView(Route<dynamic> route) {
    final screenName = route.settings.name;
    if (screenName != null) {
      _analytics.logScreenView(screenName);
    }
  }
}
```

#### Task 3.5: 앱에 Observer 연결
**파일**: `lib/app.dart`, `lib/core/router/app_router.dart`

**GoRouter에 observer 추가하는 올바른 방법:**

```dart
// app_router.dart
final routerProvider = Provider<GoRouter>((ref) {
  final analyticsRepository = ref.watch(analyticsRepositoryProvider);

  return GoRouter(
    initialLocation: '/',
    observers: [
      AnalyticsRouteObserver(analyticsRepository),
    ],
    routes: [
      // ... routes
    ],
  );
});
```

**모든 MaterialApp 인스턴스에 observer 설정 필요:**

`app.dart`에는 여러 `MaterialApp` 인스턴스가 있으므로, 각각에 observer 설정이 필요합니다:

1. **Loading MaterialApp** (line 20-40): observer 불필요 (정적 화면)
2. **Consent MaterialApp** (새로 추가): 별도 observer 또는 생략 가능
3. **Onboarding MaterialApp** (line 44-66): onboarding 이벤트 로깅 필요 시 observer 추가
4. **Main MaterialApp.router** (line 75-91): GoRouter의 observers 파라미터 사용

```dart
// Onboarding MaterialApp에 observer 추가
MaterialApp(
  navigatorObservers: [
    AnalyticsRouteObserver(ref.read(analyticsRepositoryProvider)),
  ],
  // ...
)

// Main MaterialApp.router는 GoRouter 설정에서 처리됨
```

---

### Phase 4: AdMob Feature 구현

#### Task 4.1: Domain Layer
**디렉토리**: `lib/features/ads/domain/`

| 파일 | 설명 |
|-----|------|
| `entities/ad_unit.dart` | 광고 유닛 ID 관리 |
| `repositories/ad_repository.dart` | 추상 인터페이스 |

#### Task 4.2: Data Layer
**디렉토리**: `lib/features/ads/data/`

| 파일 | 설명 |
|-----|------|
| `repositories/ad_repository_impl.dart` | AdMob 래퍼 |

**동의 상태에 따른 처리:**
```dart
Future<void> initialize() async {
  final consent = await _consentRepository.getConsentStatus();

  final requestConfig = RequestConfiguration(
    tagForChildDirectedTreatment: TagForChildDirectedTreatment.unspecified,
    maxAdContentRating: MaxAdContentRating.g,
  );

  await MobileAds.instance.updateRequestConfiguration(requestConfig);

  // 비개인화 광고 설정 (동의 없는 경우)
  if (!consent.personalizedAdsConsent) {
    // GDPR/CCPA non-personalized ads
  }
}
```

#### Task 4.3: Presentation Layer - Widgets
**디렉토리**: `lib/features/ads/presentation/widgets/`

| 파일 | 설명 |
|-----|------|
| `banner_ad_widget.dart` | 배너 광고 위젯 |
| `interstitial_ad_manager.dart` | 전면 광고 관리자 |
| `native_ad_widget.dart` | 네이티브 광고 위젯 (선택) |

**Banner Ad 위젯:**
```dart
class BannerAdWidget extends ConsumerStatefulWidget {
  final AdSize adSize;

  @override
  Widget build(BuildContext context) {
    final consentAsync = ref.watch(consentStatusProvider);

    return consentAsync.when(
      data: (consent) {
        // 올바른 필드명 사용: personalizedAdsConsent
        if (!consent.personalizedAdsConsent) {
          // 비개인화 광고 표시 또는 숨김 처리
          return const SizedBox.shrink();
        }
        return _buildBannerAd();
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}
```

#### Task 4.4: 광고 위치 통합
**수정 파일**:
- `lib/features/trip/presentation/screens/home_screen.dart` - 하단 배너 **(NOTE: trip_list_screen.dart 아님)**
- `lib/features/expense/presentation/screens/expense_list_screen.dart` - 하단 배너
- `lib/features/trip/presentation/screens/trip_detail_screen.dart` - 여행 완료 시 전면 광고

---

### Phase 5: 설정 화면 업데이트

#### Task 5.1: 개인정보 설정 섹션 추가
**파일**: `lib/features/settings/presentation/screens/settings_screen.dart`

추가할 UI 요소:
- "개인정보 및 데이터" 섹션
- Analytics 동의 토글 스위치
- 맞춤 광고 동의 토글 스위치
- "데이터 수집 정책 보기" 버튼
- "동의 초기화" 버튼

#### Task 5.2: 동의 철회 시 데이터 삭제 안내
**파일**: `lib/features/settings/presentation/screens/settings_screen.dart`

**GDPR 요구사항: 동의 철회 시 데이터 삭제**

동의 철회 시 다음 처리 필요:
1. Analytics 즉시 비활성화
2. Firebase Analytics 데이터 삭제 요청 안내 (수동 프로세스)
3. 로컬 수집 데이터 삭제

```dart
Future<void> _handleConsentWithdrawal(WidgetRef ref) async {
  // 1. Analytics 비활성화
  await ref.read(analyticsRepositoryProvider).setAnalyticsEnabled(false);

  // 2. 사용자에게 데이터 삭제 요청 방법 안내
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(l10n.dataDeleteTitle),
      content: Text(l10n.dataDeleteDescription),
      // Firebase 콘솔에서 데이터 삭제 요청 방법 또는
      // 앱 내 데이터 삭제 요청 이메일 링크 제공
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.understood),
        ),
      ],
    ),
  );

  // 3. 동의 상태 업데이트
  await ref.read(consentRepositoryProvider).updateConsent(
    analyticsConsent: false,
    personalizedAdsConsent: false,
  );
}
```

---

### Phase 6: A/B 테스트 구조 (선택)

#### Task 6.1: Remote Config 설정
**파일**: `lib/features/ads/data/repositories/remote_config_repository.dart`

```dart
class RemoteConfigRepository {
  Future<String> getAdPlacementVariant() async {
    await FirebaseRemoteConfig.instance.fetchAndActivate();
    return FirebaseRemoteConfig.instance.getString('ad_placement_variant');
  }
}
```

#### Task 6.2: A/B 테스트 이벤트 로깅
**파일**: 각 광고 위젯에서 노출/클릭 이벤트 로깅

---

### Phase 7: 국제화 (i18n)

#### Task 7.1: ARB 파일 업데이트
**파일**: `lib/l10n/app_en.arb`, `lib/l10n/app_ko.arb`

추가할 문자열:
```json
{
  "consentTitle": "Welcome to TripWallet",
  "consentDescription": "We collect anonymous usage data to improve the app.",
  "consentAnalytics": "Allow usage analytics",
  "consentAds": "Allow personalized ads",
  "consentAcceptAll": "Accept All",
  "consentAcceptSelected": "Accept Selected",
  "consentSkip": "Continue without consent",
  "privacyPolicy": "Privacy Policy",
  "settingsPrivacy": "Privacy & Data",
  "settingsAnalyticsToggle": "Usage Analytics",
  "settingsAdsToggle": "Personalized Ads",
  "dataDeleteTitle": "Data Deletion",
  "dataDeleteDescription": "Your analytics data collection has been disabled. To request deletion of previously collected data, please contact us at support@tripwallet.app or visit Firebase console settings.",
  "understood": "Understood"
}
```

---

### Phase 8: 테스트

#### Task 8.1: Domain Layer 테스트
**디렉토리**: `test/features/consent/domain/`, `test/features/analytics/domain/`

#### Task 8.2: Data Layer 테스트
**디렉토리**: `test/features/consent/data/`, `test/features/analytics/data/`, `test/features/ads/data/`

Mock 대상:
- SharedPreferences
- FirebaseAnalytics
- MobileAds

#### Task 8.3: Presentation Layer 테스트
**디렉토리**: `test/features/consent/presentation/`, `test/features/ads/presentation/`

테스트 시나리오:
- 동의 화면 렌더링
- 체크박스 상태 변경
- 동의 버튼 클릭 시 저장
- 광고 위젯 동의 상태별 표시/숨김

#### Task 8.4: 통합 테스트
**파일**: `integration_test/consent_flow_test.dart`

시나리오:
1. 앱 최초 실행 → 동의 화면 표시 (온보딩 이전)
2. 동의 선택 → 온보딩 화면 이동
3. 온보딩 완료 → 홈 화면 이동
4. 앱 재실행 → 동의 화면 스킵, 홈으로 직행
5. 설정에서 동의 철회 → 광고 숨김, 데이터 삭제 안내 표시

---

## 4. 리스크 식별 및 완화 방안

### 4.1 기술적 리스크

| 리스크 | 영향 | 완화 방안 |
|-------|-----|----------|
| Firebase 초기화 실패 | 앱 크래시 | try-catch로 감싸고 graceful degradation |
| AdMob 광고 로드 실패 | 빈 공간 표시 | SizedBox.shrink()로 대체, 재시도 로직 |
| ATT 거부 시 처리 | iOS 광고 수익 감소 | 비개인화 광고 폴백 |
| 네트워크 오류 | Analytics 이벤트 손실 | Firebase 자체 오프라인 캐싱 활용 |

### 4.2 규정 준수 리스크

| 리스크 | 영향 | 완화 방안 |
|-------|-----|----------|
| GDPR 위반 | 법적 제재, 앱 삭제 | 동의 없이 절대 데이터 수집 안 함 |
| 개인정보보호법 위반 | 법적 제재 | 수집 항목 최소화, 명확한 고지 |
| Apple ATT 미준수 | 앱스토어 리젝 | iOS 14.5+ ATT 다이얼로그 필수 표시 |
| 민감 데이터 수집 | 신뢰도 하락 | 금액, 위치 정보 절대 수집 금지 |

### 4.3 비즈니스 리스크

| 리스크 | 영향 | 완화 방안 |
|-------|-----|----------|
| 높은 동의 거부율 | 수익 감소 | 투명한 설명, 동의 장점 안내 |
| 광고로 인한 UX 저하 | 사용자 이탈 | 비침습적 위치, 빈도 제한 |
| A/B 테스트 오류 | 잘못된 의사결정 | 충분한 샘플 크기 확보 후 판단 |

---

## 5. 검증 단계 (Verification)

### 5.1 코드 품질 검증
```bash
flutter analyze   # 0 warnings 확인
flutter test      # 모든 테스트 통과 확인
```

### 5.2 기능 검증 체크리스트

**동의 관리:**
- [ ] 앱 최초 실행 시 동의 화면 표시됨 (온보딩 이전)
- [ ] 동의 선택 후 상태가 저장됨
- [ ] 동의 완료 후 온보딩 화면으로 이동
- [ ] 앱 재실행 시 동의 화면 스킵됨
- [ ] 설정에서 동의 변경 가능
- [ ] 동의 철회 시 데이터 삭제 안내 표시
- [ ] iOS에서 ATT 다이얼로그 표시됨

**Analytics:**
- [ ] 동의 시 screen_view 이벤트 전송됨
- [ ] 커스텀 이벤트 전송됨 (Firebase DebugView 확인)
- [ ] 동의 거부 시 이벤트 전송 안 됨
- [ ] 금액/위치 등 민감 정보 전송 안 됨

**AdMob:**
- [ ] 테스트 광고 표시됨 (debug mode)
- [ ] 배너 광고 올바른 위치에 표시됨
- [ ] 전면 광고 빈도 제한 동작함
- [ ] 동의 거부 시 광고 비표시 또는 비개인화 광고 표시

**국제화:**
- [ ] 한국어 동의 화면 정상 표시
- [ ] 영어 동의 화면 정상 표시

### 5.3 개인정보 보호 최종 확인
- [ ] 수집되는 모든 이벤트에 개인 식별 정보 없음
- [ ] 금액, 예산, 위치 정보 파라미터 없음
- [ ] 동의 없이는 어떤 추적도 발생하지 않음

---

## 6. 파일 구조 요약

```
lib/
├── features/
│   ├── consent/                    # 새 feature
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── consent_local_datasource.dart
│   │   │   └── repositories/
│   │   │       └── consent_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── consent_status.dart
│   │   │   └── repositories/
│   │   │       └── consent_repository.dart
│   │   └── presentation/
│   │       ├── providers/
│   │       │   └── consent_providers.dart
│   │       └── screens/
│   │           └── consent_screen.dart
│   │
│   ├── analytics/                  # 새 feature
│   │   ├── data/
│   │   │   └── repositories/
│   │   │       └── analytics_repository_impl.dart
│   │   ├── domain/
│   │   │   └── repositories/
│   │   │       └── analytics_repository.dart
│   │   └── presentation/
│   │       ├── observers/
│   │       │   └── analytics_route_observer.dart
│   │       └── providers/
│   │           └── analytics_providers.dart
│   │
│   ├── ads/                        # 새 feature
│   │   ├── data/
│   │   │   └── repositories/
│   │   │       ├── ad_repository_impl.dart
│   │   │       └── remote_config_repository.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── ad_unit.dart
│   │   │   └── repositories/
│   │   │       └── ad_repository.dart
│   │   └── presentation/
│   │       ├── providers/
│   │       │   └── ad_providers.dart
│   │       └── widgets/
│   │           ├── banner_ad_widget.dart
│   │           ├── interstitial_ad_manager.dart
│   │           └── native_ad_widget.dart
│   │
│   └── settings/                   # 수정
│       └── presentation/
│           └── screens/
│               └── settings_screen.dart  # 개인정보 섹션 추가
│
├── core/
│   └── router/
│       └── app_router.dart         # 동의 화면 라우트 추가, observer 설정
│
└── l10n/
    ├── app_en.arb                  # 영어 문자열 추가
    └── app_ko.arb                  # 한국어 문자열 추가

test/
├── features/
│   ├── consent/                    # 새 테스트
│   ├── analytics/                  # 새 테스트
│   └── ads/                        # 새 테스트

integration_test/
└── consent_flow_test.dart          # 새 통합 테스트
```

---

## 7. 예상 작업량

| Phase | 예상 시간 | 난이도 |
|-------|----------|-------|
| Phase 1: 기반 설정 | 2시간 | 낮음 |
| Phase 2: 동의 관리 | 4시간 | 중간 |
| Phase 3: Analytics | 3시간 | 중간 |
| Phase 4: AdMob | 4시간 | 중간 |
| Phase 5: 설정 업데이트 | 1.5시간 | 낮음 |
| Phase 6: A/B 테스트 | 2시간 | 중간 |
| Phase 7: 국제화 | 1시간 | 낮음 |
| Phase 8: 테스트 | 4시간 | 중간 |
| **총계** | **21.5시간** | - |

---

## 8. 의존성 관계

```
Phase 1 (기반 설정)
    ↓
Phase 2 (동의 관리) ←────────────────┐
    ↓                               │
Phase 3 (Analytics) ───depends on───┘
    ↓                               │
Phase 4 (AdMob) ───────depends on───┘
    ↓
Phase 5 (설정 업데이트)
    ↓
Phase 6 (A/B 테스트) - optional
    ↓
Phase 7 (국제화) - can run parallel with Phase 3-6
    ↓
Phase 8 (테스트) - after all phases
```

---

## 9. 중요 제약 사항 (MUST NOT)

### 절대 수집하지 않는 데이터:
1. **금액 정보**: expense.amount, trip.budget 등
2. **위치 정보**: trip.destination, 좌표 등
3. **개인 식별 정보**: 이름, 이메일, 전화번호
4. **금융 정보**: 결제 카드 번호, 계좌 정보
5. **여행 상세 정보**: 여행 이름, 메모 내용

### 코드에서 강제하는 방법:
```dart
// analytics_repository_impl.dart
const _blockedParameterKeys = [
  'amount', 'budget', 'destination', 'location',
  'name', 'email', 'phone', 'card', 'account',
  'trip_name', 'memo', 'note', 'title'  // title 추가 (여행 제목도 개인정보 가능)
];

Map<String, Object>? _sanitizeParameters(Map<String, Object>? params) {
  if (params == null) return null;
  return Map.fromEntries(
    params.entries.where((e) => !_blockedParameterKeys.contains(e.key))
  );
}
```

---

**PLAN_READY: .omc/plans/google-analytics-and-ads.md**
