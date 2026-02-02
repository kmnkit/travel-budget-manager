# TripWallet 트립월렛

여행 경비 관리를 위한 Flutter 앱 | A comprehensive travel expense management application

[![Flutter](https://img.shields.io/badge/Flutter-3.x-blue.svg)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.x-blue.svg)](https://dart.dev)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

## 프로젝트 소개

**TripWallet**은 여행 중 다양한 통화로 발생하는 경비를 체계적으로 관리할 수 있는 Flutter 모바일 앱입니다. 실시간 환율 연동, 예산 추적, 통계 분석 등의 기능을 통해 여행의 재정 계획을 효율적으로 수립하고 관리할 수 있습니다.

**주요 가치 제안:**
- 여러 통화를 자동으로 추적하고 변환
- 여행별 예산을 설정하고 실시간으로 모니터링
- 지출 카테고리별 통계 및 분석 제공
- 오프라인 환경에서도 사용 가능한 로컬 저장소
- 깔끔한 UI/UX로 직관적인 경비 관리

## 주요 기능

### 다중 통화 지원
- **7개 통화 지원**: KRW(한국), USD(미국), EUR(유럽), JPY(일본), GBP(영국), AUD(호주), CAD(캐나다)
- **이중 통화 표시**: 원래 금액 + 자동 환산 금액
- **4단계 환율 폴백 시스템**:
  1. 여행별 환율 사용
  2. 글로벌 환율 적용
  3. 역방향 환율(1/rate) 활용
  4. USD 피벗 환율 사용
- **듀얼 API 폴백**: open.er-api.com → 대체 API 자동 전환

### 경비 관리
- **8개 지출 카테고리**:
  - 식비 (Food) - 오렌지
  - 교통 (Transportation) - 파랑
  - 숙박 (Accommodation) - 보라
  - 엔터테인먼트 (Entertainment) - 노랑
  - 쇼핑 (Shopping) - 분홍
  - 액티비티 (Activities) - 청록
  - 통신 (Communication) - 남색
  - 기타 (Miscellaneous) - 회색

- **5개 결제 수단**:
  - 현금 (Cash)
  - 신용카드 (Credit Card)
  - 체크카드 (Debit Card)
  - 모바일 결제 (Mobile Payment)
  - 기타 (Other)

### 여행 관리
- 여행별 예산 설정 및 모니터링
- 여행 상태 추적 (예정, 진행중, 완료)
- 여행별 경비 그룹화 및 분석

### 예산 추적
- **4단계 예산 상태**:
  - 여유 상태: 50% 이상 남음
  - 경고 상태: 30-50% 남음
  - 한도 상태: 10% 이상 남음
  - 초과 상태: 예산 초과

- 실시간 예산 대비 현황 표시
- 예산 경고 알림

### 통계 및 분석
- **파이 차트**: 카테고리별 지출 비율 시각화
- **바 차트**: 날짜별 지출 추이 분석
- **결제 수단별 통계**: 결제 방식별 지출 분석
- 종합 통계 대시보드

### 국제화 (i18n)
- **한국어 (Korean)** / **영어 (English)** 지원
- 137개 이상의 번역 문자열
- ARB 기반 국제화 관리

## 기술 스택

| 영역 | 기술 |
|------|------|
| **프레임워크** | Flutter 3.x + Dart 3.x |
| **상태관리** | Riverpod v3 (NotifierProvider, StreamProvider) |
| **데이터베이스** | Drift 2.30.1 (SQLite) |
| **라우팅** | GoRouter 17.0.1 |
| **불변성** | Freezed v3 (코드 생성) |
| **차트/시각화** | fl_chart 1.1.1 |
| **다국어** | intl + ARB (137 문자열) |
| **HTTP 통신** | Dio 5.7.0 |
| **디자인** | Material Design 3 |
| **폰트** | Google Fonts (Lexend) |
| **로컬 저장소** | shared_preferences |
| **네트워크 감지** | connectivity_plus |

### 아키텍처

**Clean Architecture** 패턴 적용:
```
lib/
├── core/                      # 공통 코드
│   ├── constants/             # 상수 정의
│   ├── errors/                # 에러 처리 (Exceptions, Failures)
│   ├── extensions/            # Dart 확장 메서드
│   ├── network/               # HTTP 클라이언트
│   ├── router/                # 라우팅 설정 (GoRouter)
│   ├── theme/                 # 디자인 시스템 (색상, 타이포그래피)
│   └── utils/                 # 유틸리티 함수 (포맷팅 등)
│
├── features/                  # 기능별 모듈
│   ├── trip/                  # 여행 관리
│   │   ├── data/              # 데이터 레이어 (Drift, API)
│   │   ├── domain/            # 도메인 레이어 (엔티티, 유스케이스)
│   │   └── presentation/      # 프레젠테이션 레이어 (UI, 상태관리)
│   ├── expense/               # 경비 관리
│   ├── payment_method/        # 결제 수단 관리
│   ├── exchange_rate/         # 환율 관리
│   ├── budget/                # 예산 추적
│   ├── statistics/            # 통계 분석
│   └── settings/              # 설정
│
└── shared/                    # 공유 위젯 및 유틸리티
```

**의존성 방향**:
```
presentation → domain ← data
```

### 디자인 시스템

| 요소 | 값 |
|------|-----|
| **Primary Color** | Teal (#00897B) |
| **Border Radius** | 8px / 12px |
| **폰트** | Lexend (Google Fonts) |
| **Design System** | Material Design 3 |

## 프로젝트 구조

### 데이터베이스 스키마 (Drift)

**4개 테이블:**
- **Trips**: 여행 정보 (이름, 예산, 기간, 상태)
- **Expenses**: 경비 기록 (금액, 카테고리, 날짜, 여행ID)
- **PaymentMethods**: 결제 수단 (유형, 이름)
- **ExchangeRates**: 환율 정보 (통화쌍, 환율값, 캐시 시간)

### 기능 모듈

| 모듈 | 기능 |
|------|------|
| **Trip** | 여행 생성/편집/삭제, 여행 상태 관리, 상세 조회 |
| **Expense** | 경비 추가/편집/삭제, 카테고리/결제수단 선택 |
| **Payment Method** | 결제 수단 등록 및 관리 |
| **Exchange Rate** | 환율 조회 및 캐싱, 자동 변환 |
| **Budget** | 예산 설정, 실시간 모니터링, 상태 추적 |
| **Statistics** | 지출 통계, 차트 시각화 |
| **Settings** | 언어 설정, 앱 설정 |

## 시작하기

### 필수 요구사항

- **Flutter SDK**: 3.10.8 이상
- **Dart SDK**: 3.10.8 이상
- **Git**: 버전 관리용

### 설치

#### 1단계: 저장소 클론

```bash
git clone https://github.com/yourusername/trip-wallet.git
cd trip-wallet
```

#### 2단계: 의존성 설치

```bash
flutter pub get
```

#### 3단계: 코드 생성 실행

Drift, Freezed, Riverpod 코드 생성:

```bash
dart run build_runner build --delete-conflicting-outputs
```

#### 4단계: 국제화 생성

```bash
flutter gen-l10n
```

#### 5단계: 앱 실행

```bash
flutter run
```

### 주요 명령어

```bash
# 분석 및 린팅 (에러 0개여야 함)
flutter analyze

# 테스트 실행 (모든 테스트 통과해야 함)
flutter test

# 코드 생성 (Drift/Freezed 변경 후 필수)
dart run build_runner build --delete-conflicting-outputs

# 국제화 재생성 (ARB 파일 변경 후)
flutter gen-l10n

# 릴리스 빌드
flutter build apk   # Android
flutter build ios   # iOS
```

## 개발 가이드

### TDD(Test-Driven Development) 워크플로우

이 프로젝트는 **엄격한 TDD** 원칙을 따릅니다. 모든 코드 변경은 다음 사이클을 준수해야 합니다:

#### Red-Green-Refactor 사이클

```
1. RED (빨강)
   └─ 실패하는 테스트 작성 (기대 동작 정의)

2. GREEN (초록)
   └─ 테스트를 통과시키는 최소 코드 작성

3. REFACTOR (리팩토링)
   └─ 모든 테스트가 통과하는 상태에서 코드 품질 개선
```

#### 테스트 작성 규칙

| 계층 | 테스트 유형 | 필수 여부 |
|------|-----------|---------|
| **Domain** | Unit Test | 필수 |
| **Data** | Unit Test (Mocktail) | 필수 |
| **Presentation** | Unit Test | 권장 |
| **Custom Widget** | Widget Test | 필수 |

#### 커밋 전 필수 확인

```bash
flutter analyze   # 0개 경고
flutter test      # 모든 테스트 통과
```

### 코드 생성

**Drift 테이블이나 Freezed 모델을 변경한 후:**

```bash
dart run build_runner build --delete-conflicting-outputs
```

생성되는 파일:
- Drift: `*.g.dart` (DAO, 데이터베이스 클래스)
- Freezed: `*.freezed.dart` (불변 클래스)
- Riverpod: `*.g.dart` (프로바이더)

### 아키텍처 원칙

#### 계층 간 의존성 규칙

```
❌ domain/ → data/ 또는 presentation/
❌ presentation/ → data/
✅ presentation/ → domain/
✅ data/ → domain/ (인터페이스만)
```

#### 상태관리 (Riverpod v3)

**사용해야 할 것:**
- `NotifierProvider`: 상태 변경 로직이 있을 때
- `StreamProvider`: Drift `.watch()` 반응형 쿼리
- `FutureProvider.family`: 매개변수화된 비동기 작업

**피해야 할 것:**
- ❌ `StateProvider`: v3에서 제거됨
- ❌ `StateNotifier`: v3에서 제거됨

### Drift 데이터베이스 작업

#### 반응형 쿼리

```dart
// .watch()는 Stream<List<T>>를 반환
Stream<List<ExpenseData>> getAllExpenses() {
  return (select(expenses)).watch();
}
```

#### 테이블 변경

Drift 테이블 스키마를 변경한 후:

```bash
dart run build_runner build --delete-conflicting-outputs
```

#### Drift 주의사항

- `selectOnly()` + `intEnum`: 수동 캐스팅 필요
  ```dart
  final status = ExpenseStatus.values[int_value];
  ```
- 예산 계산: SQL SUM 사용
  ```dart
  final total = (select(expenses).sum(expenses.amount));
  ```

### 모킹 및 테스트

**mocktail 사용** (mockito 사용 금지):

```dart
import 'package:mocktail/mocktail.dart';

// Freezed 객체 모킹
when(() => mockRepo.getExpenses()).thenAnswer((_) => Future.value([]));

// 폴백 값 등록
registerFallbackValue(AsyncValue.data([]));
```

## 테스트

### 테스트 현황

- **전체 테스트**: 28개 Dart 파일
- **Unit Tests**: 도메인, 데이터, 프로바이더
- **Widget Tests**: 커스텀 위젯 및 UI 로직
- **Integration Tests**: 4개 파일 (엔드투엔드)
- **테스트 커버리지**: 주요 기능 100% 커버

### 테스트 실행

```bash
# 모든 테스트 실행
flutter test

# 특정 파일 테스트
flutter test test/features/expense/domain/usecases/add_expense_usecase_test.dart

# 상세 출력
flutter test -v

# 커버리지 보고서 생성
flutter test --coverage
```

### 테스트 파일 구조

```
test/
├── features/
│   ├── trip/
│   │   ├── domain/usecases/
│   │   ├── data/repositories/
│   │   └── presentation/providers/
│   ├── expense/
│   ├── payment_method/
│   ├── exchange_rate/
│   ├── budget/
│   └── statistics/
└── core/
    ├── utils/
    └── extensions/
```

## 빌드 및 배포

### Android 빌드

```bash
flutter build apk                 # APK 생성
flutter build appbundle          # Play Store용 AAB 생성
```

### iOS 빌드

```bash
flutter build ios                 # iOS 앱 생성
flutter build ipa                 # App Store용 IPA 생성
```

### 코드 서명

iOS 및 Android 코드 서명 설정은 각 플랫폼별 문서를 참고하세요:
- [iOS Code Signing](https://flutter.dev/docs/deployment/ios)
- [Android App Signing](https://flutter.dev/docs/deployment/android)

## API 및 외부 서비스

### 환율 API

**Primary**: open.er-api.com
```
GET https://open.er-api.com/v6/latest?base=USD
```

**Fallback**: api.exchangerate-api.com
```
GET https://api.exchangerate-api.com/v4/latest/USD
```

**캐시 전략**:
- 캐시 유지 기간: 24시간
- 요청 타임아웃: 5초
- 네트워크 오류 시 로컬 캐시 사용

### API 타임아웃

```dart
const Duration apiTimeout = Duration(seconds: 5);
```

## 국제화 (i18n)

### 지원 언어

- 🇰🇷 **한국어** (Korean)
- 🇺🇸 **영어** (English)

### ARB 파일 구조

```
lib/l10n/
├── app_en.arb    # 영어 기본 파일
└── app_ko.arb    # 한국어 번역
```

### 번역 추가

1. `lib/l10n/app_en.arb`에 새 문자열 추가
2. `lib/l10n/app_ko.arb`에 번역 추가
3. 코드 생성 실행:
   ```bash
   flutter gen-l10n
   ```
4. 코드에서 사용:
   ```dart
   Text(context.l10n.addExpense)
   ```

## 문제 해결

### 빌드 오류

#### 코드 생성 관련 오류
```bash
# 캐시 삭제 후 재생성
flutter clean
dart run build_runner clean
dart run build_runner build --delete-conflicting-outputs
```

#### Flutter 캐시 초기화
```bash
flutter clean
flutter pub get
dart run build_runner build --delete-conflicting-outputs
```

### 런타임 에러

#### 데이터베이스 관련
- Drift 테이블 변경 후 `build_runner` 실행 확인
- SQLite 캐시 삭제: 앱 재설치 후 테스트

#### UI 레이아웃 오류
- Material Design 3 적용 확인
- `surfaceVariant` 대신 `surfaceContainerHighest` 사용

### 환율 API 오류

**증상**: 환율을 불러올 수 없음

**원인**:
1. 네트워크 연결 끊김
2. API 서버 다운
3. API 할당량 초과

**해결책**:
1. 네트워크 연결 확인
2. 로컬 캐시된 환율 사용
3. 대체 API로 자동 전환

## 기여하기

### 기여 절차

1. 이 저장소를 포크합니다
2. 기능 브랜치를 생성합니다 (`git checkout -b feature/amazing-feature`)
3. 변경사항을 커밋합니다 (한국어 메시지)
   ```bash
   git commit -m "feat: 멋진 기능 추가"
   ```
4. 브랜치에 푸시합니다 (`git push origin feature/amazing-feature`)
5. Pull Request를 생성합니다

### 코드 기여 가이드

1. **TDD 준수**: 모든 코드는 테스트와 함께
2. **분석 통과**: `flutter analyze` 0 경고
3. **테스트 통과**: `flutter test` 모두 성공
4. **한국어 커밋**: 커밋 메시지는 한국어로
5. **Architect 검증**: PR 머지 전 아키텍처 검증

### 커밋 메시지 규칙

```
feat: 새로운 기능 추가
fix: 버그 수정
refactor: 코드 리팩토링
test: 테스트 추가/수정
docs: 문서 수정
```

## 라이선스

이 프로젝트는 **MIT License** 하에 배포됩니다. 자세한 내용은 [LICENSE](LICENSE) 파일을 참고하세요.

## 참고 자료

### 공식 문서
- [Flutter 공식 문서](https://flutter.dev)
- [Riverpod v3 문서](https://riverpod.dev)
- [Drift 데이터베이스](https://drift.simonbinder.eu)
- [GoRouter 라우팅](https://pub.dev/packages/go_router)

### 프로젝트 문서
- **PRD**: `.omc/prd.json` - 제품 요구사항 정의서
- **구현 계획**: `.omc/plans/stitch-design-implementation.md` - 단계별 개발 계획
- **에이전트 가이드**: `AGENTS.md` - 프로젝트 에이전트 정보
- **Stitch 디자인**: 프로젝트 ID `1536195772045761405`

## 연락처

질문이나 제안사항이 있으면 Issue를 등록해주세요.

---

**마지막 업데이트**: 2026년 2월 3일
**버전**: 1.0.0
**상태**: 프로덕션 준비 완료
