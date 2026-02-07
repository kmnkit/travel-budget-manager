# TripWallet v1.1.0 프로덕션 배포 준비 계획

## 현재 상태 요약

| 항목 | 상태 |
|------|------|
| **기본 기능 (v1.0)** | 완료 (38 tasks, 199+ tests) |
| **광고/프리미엄 (ads 브랜치)** | 구현 완료, 미머지 상태 |
| **iOS Fastlane** | 설정 완료 (beta/release lane) |
| **Android 서명** | keystore.properties 기반 설정 완료 |
| **App Store 메타데이터** | EN/KO 완료 |
| **광고 Unit ID** | 테스트 ID (프로덕션 ID 미설정) |
| **IAP 상품** | 코드 구현 완료, 스토어 등록 미완 |

---

## Phase 1: 코드 정리 및 테스트 안정화

### 1-1. 불필요 코드 제거
- `lib/features/monetization/` 폴더 삭제 (ads/premium과 중복)
- `test/features/monetization/` 폴더 삭제
- 사용되지 않는 import 정리

### 1-2. 실패 테스트 수정 (12건)
- 광고 통합 테스트 7건: Platform channel 모킹 수정
- 설정 화면 테스트 2건: Locale 변경 타이밍 이슈
- IAP 데이터소스 테스트 1건: InAppPurchase mock 설정
- Premium Provider 테스트 1건: Error handling mock
- Settings Premium 섹션 테스트 1건: Provider override 타이밍

### 1-3. 정적 분석 확인
```bash
flutter analyze   # 0 warnings 확인
flutter test      # 전체 테스트 통과 확인
```

---

## Phase 2: AdMob 프로덕션 설정

### 2-1. AdMob 콘솔 설정 (수동 작업)
**위치**: [AdMob Console](https://apps.admob.com) > 앱 > 앱 추가

| 항목 | Android | iOS |
|------|---------|-----|
| **앱 등록** | `com.kmnkit.trip_wallet` | `com.kmnkit.tripWallet` |
| **배너 광고 단위 1** | "홈 리스트 배너" | "홈 리스트 배너" |
| **배너 광고 단위 2** | "지출 리스트 배너" | "지출 리스트 배너" |

### 2-2. 코드에 프로덕션 ID 적용
- `lib/core/utils/ad_helper.dart`: 4개 placeholder → 실제 Ad Unit ID
- `android/app/src/main/AndroidManifest.xml`: AdMob App ID 교체
- `ios/Runner/Info.plist`: GADApplicationIdentifier 교체

### 2-3. 확인 방법
- Debug 모드: 테스트 광고 표시 (기존 테스트 ID 유지)
- Release 모드: 프로덕션 광고 표시
- `kDebugMode` 분기가 정상 작동하는지 실기기 확인

---

## Phase 3: IAP 상품 등록

### 3-1. Google Play Console (수동 작업)
**위치**: Google Play Console > 앱 > 수익 창출 > 인앱 상품

| 항목 | 값 |
|------|-----|
| **상품 ID** | `com.kmnkit.trip_wallet.remove_ads` |
| **상품 유형** | 비소모품 (Non-consumable) |
| **가격** | ₩3,900 (KRW) |
| **이름** | 광고 제거 (Remove Ads) |
| **설명** | 모든 광고를 영구적으로 제거합니다 |
| **상태** | 활성 |

### 3-2. App Store Connect (수동 작업)
**위치**: App Store Connect > 앱 > 기능 > 인앱 구입

| 항목 | 값 |
|------|-----|
| **참조 이름** | Remove Ads |
| **상품 ID** | `com.kmnkit.trip_wallet.remove_ads` |
| **유형** | 비소모성 (Non-consumable) |
| **가격** | Tier 4 ($3.99) 또는 ₩3,900 수동 지정 |
| **App Store 현지화** | EN: "Remove Ads" / KO: "광고 제거" |
| **심사 메모** | "이 인앱 구매는 앱 내 모든 배너 광고를 영구적으로 제거합니다" |

### 3-3. 확인 방법
- Android: Google Play 내부 테스트 트랙에서 구매 테스트
- iOS: Sandbox 테스터 계정으로 구매 테스트

---

## Phase 4: 버전 및 브랜치 관리

### 4-1. 버전 업데이트
```yaml
# pubspec.yaml
version: 1.1.0+2    # 광고/프리미엄 기능 추가 버전
```

### 4-2. 브랜치 머지 전략
```
ads → main (PR 생성 및 리뷰)
main → release/1.1.0 (릴리즈 브랜치 생성)
```

### 4-3. CHANGELOG 작성
```markdown
## v1.1.0
### 추가
- AdMob 배너 광고 통합 (홈 화면, 지출 목록)
- 프리미엄 구독 (광고 제거) 인앱 구매
- 프리미엄 화면 UI
- 설정 화면에 프리미엄 업그레이드 카드
- 18개 신규 번역 문자열 (EN/KO)

### 변경
- 홈 화면: 여행 카드 4개마다 광고 배너 삽입
- 지출 목록: 날짜 그룹 3개마다 광고 배너 삽입
- 설정 화면: 프리미엄 섹션 추가
```

---

## Phase 5: 실기기 테스트 (QA)

### 5-1. 테스트 매트릭스

| 테스트 항목 | Android | iOS |
|------------|---------|-----|
| 앱 실행 및 광고 로딩 | [ ] | [ ] |
| 홈 화면 배너 표시 (4개마다) | [ ] | [ ] |
| 지출 목록 배너 표시 (3개마다) | [ ] | [ ] |
| 광고 클릭 시 외부 브라우저 | [ ] | [ ] |
| 프리미엄 화면 진입 | [ ] | [ ] |
| IAP 가격 로딩 | [ ] | [ ] |
| IAP 구매 플로우 | [ ] | [ ] |
| 구매 후 광고 즉시 제거 | [ ] | [ ] |
| 앱 재시작 후 프리미엄 유지 | [ ] | [ ] |
| 구매 복원 기능 | [ ] | [ ] |
| 앱 재설치 후 구매 복원 | [ ] | [ ] |
| 네트워크 없이 앱 실행 | [ ] | [ ] |
| 광고 로딩 실패 시 레이아웃 | [ ] | [ ] |

### 5-2. 테스트 디바이스
- **Android**: 최소 API 24 (Android 7.0) + 최신 Android 14/15
- **iOS**: 최소 iOS 13 + 최신 iOS 17/18

### 5-3. 테스트 계정
- **Android**: Google Play 내부 테스트 트랙 + 라이선스 테스터
- **iOS**: App Store Connect Sandbox 테스터 계정

---

## Phase 6: 스토어 배포 준비

### 6-1. App Store (iOS)
**위치**: App Store Connect > 앱 > 새 버전

| 항목 | 작업 |
|------|------|
| **새 버전 생성** | 1.1.0 |
| **What's New (EN)** | "Added non-intrusive banner ads. Premium option to remove all ads." |
| **What's New (KO)** | "비방해적 배너 광고가 추가되었습니다. 프리미엄 옵션으로 모든 광고를 제거할 수 있습니다." |
| **스크린샷** | 기존 유지 (광고가 눈에 띄지 않음) 또는 프리미엄 화면 추가 |
| **개인정보 처리방침** | 광고 관련 데이터 수집 항목 업데이트 필요 |
| **App Privacy** | "Data Used to Track You" - 광고 ID 추가 |
| **인앱 구입 심사 메모** | Phase 3-2 참조 |

### 6-2. Google Play Store (Android)
**위치**: Google Play Console > 앱 > 프로덕션

| 항목 | 작업 |
|------|------|
| **새 릴리즈** | 1.1.0 (2) |
| **릴리즈 노트 (EN)** | "Added non-intrusive banner ads. Premium option to remove all ads." |
| **릴리즈 노트 (KO)** | "비방해적 배너 광고가 추가되었습니다. 프리미엄 옵션으로 모든 광고를 제거할 수 있습니다." |
| **콘텐츠 등급** | 재평가 필요 (광고 포함) |
| **광고 포함** | "예" 로 변경 |
| **데이터 안전 섹션** | 광고 ID 수집 추가 |

### 6-3. 개인정보 처리방침 업데이트
기존 개인정보 처리방침에 추가 필요:
- Google AdMob 사용 및 광고 ID 수집
- 인앱 구매 처리 (Apple/Google을 통한 결제)
- 광고 타겟팅 데이터 (AdMob 기본 정책)

---

## Phase 7: 빌드 및 업로드

### 7-1. iOS 빌드 & 업로드
```bash
# TestFlight 먼저 배포
cd ios && fastlane beta

# QA 완료 후 App Store 제출
cd ios && fastlane release
```

### 7-2. Android 빌드 & 업로드
```bash
# AAB 빌드 (릴리즈 서명)
flutter build appbundle --release

# Google Play Console에 수동 업로드
# 또는 fastlane 설정 후 자동화
```

### 7-3. Android Fastlane 설정 (선택)
현재 Android용 Fastlane이 없으므로, 필요시 추가:
- `android/fastlane/Appfile` + `Fastfile` 생성
- `supply` 액션으로 Play Console 업로드 자동화

---

## Phase 8: 출시 후 모니터링

### 8-1. 크래시 모니터링
- Firebase Crashlytics 도입 고려 (현재 미설정)
- 또는 Sentry Flutter SDK

### 8-2. 광고 수익 모니터링
- AdMob 대시보드에서 eCPM, 노출수, 클릭률 확인
- 광고 단위별 성과 비교 (홈 vs 지출 리스트)

### 8-3. IAP 모니터링
- App Store Connect / Google Play Console 매출 대시보드
- 전환율 추적 (무료 → 프리미엄)

---

## 작업 순서 요약 (의존성 기준)

```
Phase 1: 코드 정리 & 테스트 ─────────────────────┐
Phase 2: AdMob 설정 (수동 → 코드 적용) ──────────┤  ← 병렬 진행 가능
Phase 3: IAP 상품 등록 (수동) ────────────────────┘
                          │
                          ▼
Phase 4: 버전 업데이트 & 브랜치 머지
                          │
                          ▼
Phase 5: 실기기 QA (TestFlight + 내부 테스트)
                          │
                          ▼
Phase 6: 스토어 메타데이터 준비
                          │
                          ▼
Phase 7: 빌드 & 업로드
                          │
                          ▼
Phase 8: 출시 & 모니터링
```

> **Phase 1~3**은 병렬 진행 가능합니다.
> **Phase 2, 3**은 AdMob/App Store Connect에서의 수동 설정이 필요합니다.
