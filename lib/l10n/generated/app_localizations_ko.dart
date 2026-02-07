// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => '트립월렛';

  @override
  String get save => '저장';

  @override
  String get cancel => '취소';

  @override
  String get delete => '삭제';

  @override
  String get edit => '수정';

  @override
  String get add => '추가';

  @override
  String get retry => '재시도';

  @override
  String get settings => '설정';

  @override
  String get loading => '로딩 중';

  @override
  String get trips => '여행';

  @override
  String get expenses => '지출';

  @override
  String get exchangeRates => '환율';

  @override
  String get statistics => '통계';

  @override
  String get tripTitle => '여행 제목';

  @override
  String get baseCurrency => '기본 통화';

  @override
  String get budgetAmount => '예산';

  @override
  String get startDate => '시작일';

  @override
  String get endDate => '종료일';

  @override
  String get addTrip => '여행 추가';

  @override
  String get editTrip => '여행 수정';

  @override
  String get deleteTrip => '여행 삭제';

  @override
  String get tripTitleHint => '예: 도쿄 여행';

  @override
  String get tripNotFound => '여행을 찾을 수 없습니다';

  @override
  String get tripLoadFailed => '여행 정보를 불러올 수 없습니다';

  @override
  String get tripCreateSuccess => '여행이 생성되었습니다';

  @override
  String tripCreateFailed(String error) {
    return '여행 생성 실패: $error';
  }

  @override
  String get tripUpdateSuccess => '여행이 수정되었습니다';

  @override
  String tripUpdateFailed(String error) {
    return '여행 수정 실패: $error';
  }

  @override
  String tripDeleteConfirm(String tripTitle) {
    return '$tripTitle을(를) 삭제하시겠습니까?\n모든 지출 기록도 함께 삭제됩니다.';
  }

  @override
  String get tripDeleteSuccess => '여행이 삭제되었습니다';

  @override
  String get tripDeleteFailed => '여행 삭제 실패';

  @override
  String get noTrips => '여행을 추가해보세요!';

  @override
  String get noTripsDescription => '새로운 여행을 계획하고 예산을 관리하세요';

  @override
  String get tripStatusUpcoming => '예정';

  @override
  String get tripStatusOngoing => '진행중';

  @override
  String get tripStatusCompleted => '완료';

  @override
  String get error => '오류';

  @override
  String get amount => '금액';

  @override
  String get memo => '메모';

  @override
  String get memoOptional => '메모 (선택)';

  @override
  String get memoHint => '메모를 입력하세요';

  @override
  String get category => '카테고리';

  @override
  String get paymentMethod => '지불수단';

  @override
  String get date => '날짜';

  @override
  String get addExpense => '지출 추가';

  @override
  String get editExpense => '지출 수정';

  @override
  String get deleteExpense => '지출 삭제';

  @override
  String get noExpenses => '지출을 기록해보세요!';

  @override
  String get expenseLoadFailed => '지출 목록을 불러올 수 없습니다';

  @override
  String get expenseListLoadFailed => '지출 목록을 불러올 수 없습니다';

  @override
  String get expenseCreateSuccess => '지출이 추가되었습니다';

  @override
  String expenseCreateFailed(String error) {
    return '저장 실패: $error';
  }

  @override
  String get expenseUpdateSuccess => '지출이 수정되었습니다';

  @override
  String get expenseUpdateFailed => '지출 수정 실패';

  @override
  String expenseDeleteConfirm(String item) {
    return '$item을(를) 삭제하시겠습니까?';
  }

  @override
  String get expenseDeleteSuccess => '지출이 삭제되었습니다';

  @override
  String get expenseDeleteFailed => '지출 삭제 실패';

  @override
  String get categoryRequired => '카테고리를 선택해주세요';

  @override
  String get paymentMethodRequired => '지불수단을 선택해주세요';

  @override
  String get enterValidAmount => '올바른 금액을 입력해주세요';

  @override
  String get conversionInProgress => '환율 변환 중입니다. 잠시만 기다려주세요';

  @override
  String get noPaymentMethods => '지불수단이 없습니다. 먼저 지불수단을 추가해주세요.';

  @override
  String get categoryFood => '식비';

  @override
  String get categoryTransport => '교통';

  @override
  String get categoryAccommodation => '숙박';

  @override
  String get categoryShopping => '쇼핑';

  @override
  String get categoryEntertainment => '오락';

  @override
  String get categorySightseeing => '관광';

  @override
  String get categoryCommunication => '통신';

  @override
  String get categoryOther => '기타';

  @override
  String get paymentMethods => '지불수단 관리';

  @override
  String get addPaymentMethod => '지불수단 추가';

  @override
  String get editPaymentMethod => '지불수단 수정';

  @override
  String get deletePaymentMethod => '지불수단 삭제';

  @override
  String get paymentMethodName => '지불수단 이름';

  @override
  String get defaultPayment => '기본';

  @override
  String get setAsDefault => '기본으로 설정';

  @override
  String get paymentMethodAdded => '지불수단이 추가되었습니다';

  @override
  String get paymentMethodUpdated => '지불수단이 수정되었습니다';

  @override
  String get paymentMethodDeleted => '지불수단이 삭제되었습니다';

  @override
  String paymentMethodDeleteConfirm(String name) {
    return '$name을(를) 삭제하시겠습니까?';
  }

  @override
  String paymentMethodSetDefault(String name) {
    return '$name을(를) 기본 지불수단으로 설정했습니다';
  }

  @override
  String paymentMethodAddFailed(String error) {
    return '추가 실패: $error';
  }

  @override
  String paymentMethodUpdateFailed(String error) {
    return '수정 실패: $error';
  }

  @override
  String paymentMethodDeleteFailed(String error) {
    return '삭제 실패: $error';
  }

  @override
  String paymentMethodSetDefaultFailed(String error) {
    return '설정 실패: $error';
  }

  @override
  String paymentMethodLoadFailed(String error) {
    return '지불수단 로드 실패: $error';
  }

  @override
  String get noPaymentMethodsAvailable => '지불수단이 없습니다';

  @override
  String get paymentCash => '현금';

  @override
  String get paymentCreditCard => '신용카드';

  @override
  String get paymentDebitCard => '체크카드';

  @override
  String get paymentTransitCard => '교통카드';

  @override
  String get paymentOther => '기타';

  @override
  String get budget => '예산';

  @override
  String get total => '합계';

  @override
  String get remaining => '잔액';

  @override
  String get used => '사용';

  @override
  String get budgetComfortable => '여유';

  @override
  String get budgetCaution => '주의';

  @override
  String get budgetWarning => '경고';

  @override
  String get budgetExceeded => '초과';

  @override
  String get autoRate => '자동';

  @override
  String get manualRate => '수동';

  @override
  String get refreshRate => '환율 새로고침';

  @override
  String get lastUpdated => '마지막 업데이트';

  @override
  String get noExchangeRates => '등록된 환율이 없습니다';

  @override
  String exchangeRateLoadFailed(String error) {
    return '환율 정보를 불러올 수 없습니다\n$error';
  }

  @override
  String get exchangeRateRefreshHint => '환율을 가져오려면 새로고침 버튼을 눌러주세요';

  @override
  String get exchangeRateLoading => '환율 정보를 불러오는 중...';

  @override
  String get noData => '데이터가 없습니다';

  @override
  String get noExpenseData => '지출 데이터가 없습니다';

  @override
  String get noExpenseDataInPeriod => '선택한 기간에 지출 내역이 없습니다';

  @override
  String statisticsLoadFailed(String error) {
    return '통계 데이터를 불러올 수 없습니다\n$error';
  }

  @override
  String get statisticsCalculating => '통계를 계산하는 중...';

  @override
  String get periodAll => '전체';

  @override
  String get periodWeek => '이번 주';

  @override
  String get periodMonth => '이번 달';

  @override
  String get periodCustom => '직접 설정';

  @override
  String get budgetForecast => '예산 예측';

  @override
  String get budgetBurndownChart => '예산 소진 차트';

  @override
  String get projectedTotal => '예상 총 지출';

  @override
  String get dailySpending => '일일 지출';

  @override
  String get daysUntilExhaustion => '예산 소진까지';

  @override
  String daysUntilExhaustionValue(int days) {
    return '$days일';
  }

  @override
  String get budgetSufficient => '예산 충분';

  @override
  String get forecastStatusOnTrack => '순조로움';

  @override
  String get forecastStatusAtRisk => '주의 필요';

  @override
  String get forecastStatusOverBudget => '초과 예상';

  @override
  String get forecastStatusExhausted => '예산 소진';

  @override
  String get actualSpending => '실제 지출';

  @override
  String get projectedSpending => '예측';

  @override
  String get budgetLimit => '예산 한도';

  @override
  String get bestCase => '최선';

  @override
  String get worstCase => '최악';

  @override
  String get confidenceInterval => '신뢰구간';

  @override
  String get noBudgetSet => '예산이 설정되지 않았습니다';

  @override
  String get overallSpendingTrend => '전체 지출 추세:';

  @override
  String get spendingVelocity => '지출 속도';

  @override
  String get dailyAverage => '일평균';

  @override
  String get weeklyAverage => '주평균';

  @override
  String get velocityStable => '안정';

  @override
  String get velocityIncreasing => '증가 중';

  @override
  String get velocityDecreasing => '감소 중';

  @override
  String accelerationLabel(String status) {
    return '가속도: $status';
  }

  @override
  String periodLabel(String period) {
    return '기간: $period';
  }

  @override
  String get periodComparison => '기간 비교';

  @override
  String get noComparisonData => '비교할 데이터가 없습니다';

  @override
  String get categoryAnalysis => '카테고리 분석';

  @override
  String get noCategoryData => '카테고리 데이터가 없습니다';

  @override
  String get smartInsights => '스마트 인사이트';

  @override
  String confidenceLabel(String value) {
    return '신뢰도: $value';
  }

  @override
  String get dailyExpenses => '일별 지출';

  @override
  String get expensesByCategory => '카테고리별 지출';

  @override
  String get expensesByPaymentMethod => '결제 수단별 지출';

  @override
  String get totalExpense => '총 지출';

  @override
  String get thisWeekVsLastWeek => '이번 주 vs 지난 주';

  @override
  String get dashboardEdit => '대시보드 편집';

  @override
  String get resetToDefault => '기본값 복원';

  @override
  String get widgetCategoryPieChart => '카테고리별 지출';

  @override
  String get widgetDailyBarChart => '일별 지출';

  @override
  String get widgetPaymentMethodChart => '결제 수단별 지출';

  @override
  String get widgetTrendIndicator => '지출 트렌드';

  @override
  String get widgetSpendingVelocity => '지출 속도';

  @override
  String get widgetPeriodComparison => '기간 비교';

  @override
  String get widgetCategoryInsights => '카테고리 인사이트';

  @override
  String get widgetSmartInsights => '스마트 인사이트';

  @override
  String get widgetBudgetForecast => '예산 예측';

  @override
  String get widgetBudgetBurndown => '예산 소진율';

  @override
  String get allCategories => '전체';

  @override
  String get sortByDate => '최신순';

  @override
  String get sortByAmount => '금액순';

  @override
  String get selectDefaultCurrency => '기본 통화 선택';

  @override
  String get totalBalance => '총 잔액';

  @override
  String get filterAllTrips => '모든 여행';

  @override
  String get filterActive => '진행중';

  @override
  String get filterPast => '완료';

  @override
  String get clearAllFilters => '전체 초기화';

  @override
  String get filterByCategory => '카테고리';

  @override
  String get filterByPaymentMethod => '결제 수단';

  @override
  String get language => '언어';

  @override
  String get languageKorean => '한국어';

  @override
  String get languageEnglish => 'English';

  @override
  String get defaultCurrency => '기본 통화';

  @override
  String get general => '일반';

  @override
  String get data => '데이터';

  @override
  String get info => '정보';

  @override
  String get version => '버전';

  @override
  String get backup => '백업';

  @override
  String get restore => '복원';

  @override
  String get privacyPolicy => '개인정보 처리방침';

  @override
  String get licenses => '오픈소스 라이선스';

  @override
  String get comingSoon => '준비 중';

  @override
  String get validationTitleRequired => '제목을 입력해주세요';

  @override
  String get validationTitleTooLong => '제목은 100자 이하여야 합니다';

  @override
  String get validationBudgetRequired => '예산을 입력하세요';

  @override
  String get validationBudgetPositive => '예산은 0보다 커야 합니다';

  @override
  String get validationEndDateAfterStart => '종료일은 시작일 이후여야 합니다';

  @override
  String get validationAmountPositive => '금액은 0보다 커야 합니다';

  @override
  String get validationCategoryRequired => '카테고리를 선택해주세요';

  @override
  String get validationPaymentRequired => '지불수단을 선택해주세요';

  @override
  String get enterTripTitle => '여행 제목을 입력하세요';

  @override
  String get enterBudget => '예산을 입력하세요';

  @override
  String get enterAmountGreaterThanZero => '0보다 큰 금액을 입력하세요';

  @override
  String get networkError => '네트워크 오류가 발생했습니다';

  @override
  String get offlineMode => '오프라인';

  @override
  String get loadFailed => '로드 실패';

  @override
  String get saveFailed => '저장 실패';

  @override
  String get unknownError => '알 수 없는 오류가 발생했습니다';

  @override
  String get exportReport => '보고서 내보내기';

  @override
  String get generatePdf => 'PDF 생성';

  @override
  String get generatingPdf => 'PDF 생성 중...';

  @override
  String get shareReport => '공유하기';

  @override
  String get pdfGenerated => 'PDF가 생성되었습니다';

  @override
  String get exportFailed => '내보내기 실패';

  @override
  String get tripReport => '여행 보고서';

  @override
  String get summary => '요약';

  @override
  String get expenseList => '지출 목록';

  @override
  String get charts => '차트';

  @override
  String get insights => '인사이트';

  @override
  String get onboardingWelcomeTitle => '트립월렛에 오신 것을 환영합니다';

  @override
  String get onboardingWelcomeDescription => '다양한 통화로 여행 경비를 관리하는 스마트한 여행 동반자';

  @override
  String get onboardingFeaturesTitle => '지출을 기록하세요';

  @override
  String get onboardingFeaturesDescription =>
      '어떤 통화로든 지출을 기록하고 자동으로 환산하세요. 유형과 지불수단별로 분류할 수 있습니다.';

  @override
  String get onboardingGetStartedTitle => '시작할 준비가 되셨나요?';

  @override
  String get onboardingGetStartedDescription =>
      '첫 번째 여행을 만들고 오늘부터 여행 예산을 관리해보세요!';

  @override
  String get onboardingSkip => '건너뛰기';

  @override
  String get onboardingNext => '다음';

  @override
  String get onboardingGetStarted => '시작하기';

  @override
  String get consentTitle => '개인정보 보호 및 데이터 처리';

  @override
  String get consentDescription =>
      'TripWallet은 모든 데이터를 기기에 로컬로 저장합니다. 개인정보를 수집하거나 전송하지 않습니다. 아래 개인정보 처리방침을 검토해 주세요.';

  @override
  String get consentAccept => '동의합니다';

  @override
  String get consentDecline => '동의하지 않습니다';

  @override
  String get consentViewFullPolicy => '전체 개인정보 처리방침 보기';

  @override
  String get consentDeclineTitle => '동의 필요';

  @override
  String get consentDeclineMessage =>
      'TripWallet은 여행 데이터를 기기에 로컬로 처리하기 위해 동의가 필요합니다. 개인정보 처리방침을 검토하신 후 동의해 주세요.';

  @override
  String get consentDeclineUnderstand => '이해했습니다';

  @override
  String get consentStatus => '개인정보 동의 상태';

  @override
  String consentAcceptedOn(String date) {
    return '$date에 동의함';
  }

  @override
  String get consentNotGiven => '아직 동의하지 않음';

  @override
  String get consentSaveError => '동의 저장에 실패했습니다. 다시 시도해주세요.';

  @override
  String get premium => '프리미엄';

  @override
  String get premiumTitle => '트립월렛 프리미엄';

  @override
  String get unlockPremium => '프리미엄 기능 잠금 해제';

  @override
  String get premiumSubtitle => '광고 없는 환경과 더 많은 기능을 즐기세요';

  @override
  String get upgradeToPremium => '프리미엄으로 업그레이드';

  @override
  String get restorePurchase => '구매 복원';

  @override
  String get premiumFeatureAdFree => '광고 없는 환경';

  @override
  String get premiumFeatureAnalytics => '고급 분석';

  @override
  String get premiumFeatureReports => '맞춤형 보고서';

  @override
  String get premiumFeatureSupport => '우선 지원';

  @override
  String get premiumFeatureExports => '무제한 내보내기';

  @override
  String premiumPrice(String price) {
    return '연 $price';
  }

  @override
  String get premiumBestValue => '최고의 가치';

  @override
  String get premiumAutoRenewDisclaimers => '구독은 취소하지 않는 한 자동으로 갱신됩니다';

  @override
  String get premiumPurchaseSuccess => '업그레이드해주셔서 감사합니다!';

  @override
  String get premiumPurchaseFailed => '구매에 실패했습니다. 다시 시도해주세요.';

  @override
  String get premiumRestoreSuccess => '이전 구매가 복원되었습니다';

  @override
  String get premiumRestoreFailed => '구매 복원에 실패했습니다';

  @override
  String get premiumAlreadyOwned => '이미 보유한 기능입니다';

  @override
  String get whatIncluded => '포함된 기능';

  @override
  String get oneYearSubscription => '1년 구독';

  @override
  String get later => '나중에';

  @override
  String get upgrade => '업그레이드';

  @override
  String get ads => '광고';

  @override
  String get adFree => '광고 없음';

  @override
  String get upgradeForAdFree => '프리미엄으로 업그레이드하여 광고 제거';

  @override
  String get ad => '광고';

  @override
  String get premiumActive => '프리미엄 활성화';

  @override
  String get removeAds => '광고 제거';

  @override
  String get adFreeExperience => '광고 없는 경험을 즐기세요';

  @override
  String get supportDevelopment => '개발을 지원하세요';

  @override
  String get thankYouForSupport => '지원해주셔서 감사합니다!';

  @override
  String get maybeLater => '나중에';

  @override
  String get upgradeNow => '지금 업그레이드';

  @override
  String get oneTimePurchase => '일회성 구매';

  @override
  String get featureAdFree => '광고 없는 경험';

  @override
  String get featureSupportDev => '지속적인 개발 지원';

  @override
  String get featurePremiumBadge => '설정에서 프리미엄 배지';

  @override
  String get purchaseSuccess => '구매 완료! 지원해주셔서 감사합니다.';

  @override
  String get purchaseFailed => '구매에 실패했습니다. 다시 시도해주세요.';

  @override
  String get purchaseRestored => '구매를 성공적으로 복원했습니다';
}
