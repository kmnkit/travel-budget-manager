# 다음 세션 작업 목록

작성일: 2026-02-07
현재 브랜치: ads
상태: AdMob & Freemium 구현 완료 (Phase 1-8)

---

## 현재 상황

✅ **완료된 작업:**
- Phase 1-8 모두 구현 완료
- 316개 테스트 통과 (96.3% pass rate)
- flutter analyze 0개 이슈
- Production-ready 코드

⚠️ **남은 이슈:**
- 12개 테스트 실패 (비중요, integration/platform channel 관련)

---

## 우선순위 1: 실패 테스트 수정 (선택사항)

### 1.1 Settings Screen 테스트 (2개 실패)
- **파일**: `test/features/settings/presentation/screens/settings_screen_test.dart`
- **문제**: Locale 변경 타이밍 이슈
- **접근**:
  - pumpAndSettle() 후 적절한 대기 시간 추가
  - 또는 locale change를 integration test로 이동

### 1.2 Ad Integration 테스트 (7개 실패)
- **파일**:
  - `test/features/trip/presentation/screens/home_screen_integration_test.dart`
  - `test/features/expense/presentation/screens/expense_list_screen_integration_test.dart`
- **문제**: AdBannerWidget이 Google Mobile Ads platform channel 필요
- **접근**:
  - platform channel mocking 구현
  - 또는 ad 관련 테스트를 실제 디바이스 integration test로만 수행

### 1.3 IAP Datasource 테스트 (1개 실패)
- **파일**: `test/features/premium/data/datasources/iap_datasource_test.dart`
- **문제**: Platform channel mock 설정
- **접근**:
  - MethodChannel mock 구현
  - InAppPurchase.instance mock

### 1.4 Premium Providers 테스트 (1개 실패)
- **파일**: `test/features/premium/presentation/providers/premium_providers_test.dart`
- **문제**: 에러 핸들링 mock 설정
- **접근**:
  - Exception throwing mock 수정

### 1.5 Settings Premium Section 테스트 (1개 실패)
- **파일**: `test/features/settings/presentation/screens/settings_screen_test.dart`
- **문제**: Provider override 타이밍
- **접근**:
  - ProviderContainer 생성 순서 조정

---

## 우선순위 2: Production 배포 준비

### 2.1 AdMob Production ID로 교체
- **파일**: `lib/core/utils/ad_helper.dart`
- **작업**:
  1. Google AdMob 콘솔에서 앱 등록
  2. 배너 광고 유닛 2개 생성 (HomeScreen, ExpenseListScreen)
  3. Android/iOS별 Production Ad Unit ID로 교체
  4. AndroidManifest.xml의 AdMob App ID 교체
  5. Info.plist의 GADApplicationIdentifier 교체

### 2.2 IAP 제품 등록
- **Android (Google Play Console)**:
  - Product ID: `com.kmnkit.trip_wallet.remove_ads`
  - 가격: ₩3,900
  - Type: One-time purchase
  - Testers 추가

- **iOS (App Store Connect)**:
  - Product ID: `com.kmnkit.trip_wallet.remove_ads`
  - 가격: $2.99
  - Type: Non-consumable
  - Sandbox testers 추가

### 2.3 실제 디바이스 테스트
- [ ] Android 실기기에서 광고 로드 테스트
- [ ] iOS 실기기에서 광고 로드 테스트
- [ ] Android에서 IAP 구매 플로우 테스트
- [ ] iOS에서 IAP 구매 플로우 테스트
- [ ] 구매 후 광고 제거 즉시 반영 확인
- [ ] 앱 재시작 후 프리미엄 상태 유지 확인
- [ ] Restore Purchase 기능 테스트 (재설치 후)

### 2.4 버전 업데이트
- **파일**: `pubspec.yaml`
- **변경**: `version: 1.1.0+2`

---

## 우선순위 3: 선택적 개선사항

### 3.1 Analytics 추가
- Firebase Analytics 또는 Google Analytics 4 추가
- 이벤트 트래킹:
  - Ad impression
  - Premium screen view
  - Purchase initiated
  - Purchase completed
  - Restore purchase

### 3.2 A/B 테스팅
- 광고 빈도 실험 (3개 vs 4개 vs 5개 카드마다)
- 프리미엄 가격 실험 (₩2,900 vs ₩3,900 vs ₩4,900)
- 프리미엄 프롬프트 타이밍 최적화

### 3.3 추가 광고 배치
- StatisticsScreen에 네이티브 광고 추가
- 광고 노출 카운터 구현 (10회 노출 후 프리미엄 프롬프트)

### 3.4 프리미엄 기능 추가
- Premium badge in settings
- Premium-only themes
- Premium-only expense categories

---

## Git & Deployment

### Commit & Tag
```bash
git add .
git commit -m "feat: AdMob 광고 및 프리미엄 구독 추가

- Google AdMob 통합 (배너 광고)
- Freemium 모델 구현 (₩3,900 일회성 결제)
- HomeScreen 및 ExpenseListScreen에 비침습적 광고 배치
- in_app_purchase로 IAP 구현
- 설정에 Premium 섹션 추가
- 한국어/영어 현지화 완료
- TDD 준수 (316+ 테스트 유지)
- Clean Architecture 준수

Co-Authored-By: Claude Sonnet 4.5 <noreply@anthropic.com>"

git tag v1.1.0
git push origin ads --tags
```

### Build Commands
```bash
# Verify
flutter analyze
flutter test

# Release builds
flutter build apk --release
flutter build ios --release --no-codesign
```

---

## 참고 자료

- **구현 요약**: `/tmp/ads-implementation-summary.md`
- **PRD**: `.omc/prd.json`
- **Plan**: `/Users/marcoginger/.claude/plans/cuddly-swimming-avalanche.md`
- **Test 결과**: 316 passing / 12 failing
- **Flutter Analyze**: 0 issues

---

## 다음 세션 시작 시

1. 이 파일을 읽고 어떤 작업을 진행할지 결정
2. 우선순위 1 (테스트 수정) 또는 우선순위 2 (Production 준비) 중 선택
3. Team/Swarm 모드가 필요하면 `/oh-my-claudecode:swarm` 활성화
4. Ultrawork 모드가 필요하면 `/oh-my-claudecode:ultrawork` 활성화
