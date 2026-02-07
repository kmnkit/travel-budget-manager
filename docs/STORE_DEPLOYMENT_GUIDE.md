# 스토어 배포 가이드 / Store Deployment Guide

## 📦 빌드 파일 위치

### Android (Google Play)
- **파일**: `build/app/outputs/bundle/release/app-release.aab`
- **크기**: 52.1MB
- **서명**: 키스토어로 서명 완료

### iOS (App Store)
- **파일**: `build/ios/ipa/*.ipa`
- **크기**: 28.4MB
- **서명**: Apple Developer 계정으로 서명 완료

---

## 🔑 Android 키스토어 정보 (중요!)

⚠️ **이 정보는 매우 중요합니다. 안전한 곳에 백업하세요!**

- **키스토어 파일**: `~/upload-keystore.jks`
- **비밀번호**: `390FKYojePzs0Pxl1rVr`
- **키 별칭**: `upload`
- **설정 파일**: `android/keystore.properties`

### 키스토어 백업 방법

```bash
# 키스토어 백업
cp ~/upload-keystore.jks ~/Dropbox/backups/trip-wallet-keystore.jks
# 또는
cp ~/upload-keystore.jks /path/to/secure/location/

# keystore.properties 백업
cp android/keystore.properties ~/Dropbox/backups/
```

**주의사항**:
- 키스토어를 분실하면 앱을 업데이트할 수 없습니다!
- Git에 커밋하지 마세요 (.gitignore에 포함되어 있음)
- 클라우드 스토리지에 암호화하여 백업하는 것을 권장합니다

---

## 📱 Google Play Console 업로드

### 1. Google Play Console 접속
- https://play.google.com/console 접속
- 개발자 계정 필요 (일회성 등록비 $25)

### 2. 새 앱 만들기
1. "앱 만들기" 클릭
2. 앱 이름: **마이트립월렛 - 여행 가계부** / **My Trip Wallet**
3. 기본 언어 선택
4. 앱/게임 선택
5. 무료/유료 선택

### 3. 스토어 설정 완료

#### 앱 액세스 권한
- 모든 기능에 제한 없이 액세스 가능

#### 광고
- 앱에 광고 포함 여부: **예** (Google AdMob 사용)

#### 콘텐츠 등급
- 설문지 작성 (여행 가계부 앱)
- 예상 등급: 만 3세 이상

#### 타겟층 및 콘텐츠
- 타겟 연령층: 전체
- 뉴스 앱: 아니오
- 앱 카테고리: **여행 및 지역정보**

#### 개인정보처리방침
- URL: `https://kmnkit.github.io/travel-budget-manager/privacy-policy`

### 4. 스토어 등록정보

#### 기본 정보 (한국어)
- **앱 이름**: 마이트립월렛 - 여행 가계부
- **간단한 설명** (80자):
  ```
  다중 통화를 지원하는 스마트한 여행 경비 관리 앱. 실시간 환율, 예산 추적, 시각적 통계 제공.
  ```
- **전체 설명**: `android/fastlane/metadata/android/ko-KR/full_description.txt` 참조

#### 그래픽 애셋
- **앱 아이콘**: 512 x 512 PNG (자동 생성됨)
- **스크린샷**: 최소 2개 (휴대전화)
  - `ios/fastlane/screenshots/ko/` 폴더의 이미지 사용 가능
  - 또는 Android 기기에서 직접 촬영
- **Feature Graphic** (선택사항): 1024 x 500 PNG

### 5. 앱 버전 업로드

#### 프로덕션 트랙
1. 프로덕션 → 새 버전 만들기
2. App Bundle 업로드: `build/app/outputs/bundle/release/app-release.aab`
3. 버전 이름 확인: 1.0.0
4. 출시 노트 작성:
   ```
   첫 번째 공식 출시!
   - 다중 통화 지원 (7개 통화)
   - 실시간 환율 업데이트
   - 여행별 예산 관리
   - 카테고리별 통계
   - 오프라인 우선 저장
   ```
5. 검토 → 출시 시작

---

## 🍎 App Store Connect 업로드

### 1. App Store Connect 접속
- https://appstoreconnect.apple.com 접속
- Apple Developer 계정 필요 (연간 $99)

### 2. 새 앱 만들기
1. "앱" → "+" → "새로운 앱"
2. 플랫폼: iOS
3. 이름: **My Trip Wallet**
4. 기본 언어: 한국어 또는 영어
5. 번들 ID: `com.kmnkit.tripWallet`
6. SKU: `trip-wallet-001`

### 3. 앱 정보

#### 기본 정보
- **부제**: 스마트한 여행 경비 관리 / Smart Travel Budget Manager
- **카테고리**: 여행 (기본), 금융 (보조)
- **연령 등급**: 4+

#### 개인정보 보호
- **개인정보 처리방침 URL**: `https://kmnkit.github.io/travel-budget-manager/privacy-policy`
- **데이터 수집**: 아니오 (로컬 저장만 사용)

### 4. 버전 정보

#### 스크린샷
- **6.5" Display**: `ios/fastlane/screenshots/ko/` 폴더 사용
- 최소 1개, 최대 10개

#### 설명 정보 (한국어)
- **이름**: 마이트립월렛 - 여행 가계부
- **부제**: 스마트한 여행 경비 관리
- **프로모션 텍스트**: `ios/fastlane/metadata/ko/promotional_text.txt` 참조
- **설명**: `ios/fastlane/metadata/ko/description.txt` 참조
- **키워드**: 여행,가계부,경비,예산,환율,통화,지출,관리,트립,월렛

#### 앱 미리보기 (선택사항)
- 30초 이내 데모 비디오

### 5. 빌드 업로드

#### 방법 1: Apple Transporter (권장)
1. App Store에서 "Transporter" 앱 다운로드
2. Transporter 실행
3. `build/ios/ipa/*.ipa` 파일 드래그 앤 드롭
4. "전송" 클릭
5. 처리 완료까지 10-30분 대기

#### 방법 2: xcrun altool (터미널)
```bash
xcrun altool --upload-app \
  --type ios \
  -f build/ios/ipa/*.ipa \
  --apiKey YOUR_API_KEY \
  --apiIssuer YOUR_ISSUER_ID
```

### 6. 빌드 선택 및 제출
1. App Store Connect에서 빌드가 처리될 때까지 대기
2. 버전 정보 → "빌드" → 처리된 빌드 선택
3. 수출 규정 준수: **아니오** (암호화 미사용)
4. 검토를 위해 제출
5. 심사 통과까지 1-3일 대기

---

## ✅ 체크리스트

### 제출 전 확인사항

#### 공통
- [ ] flutter analyze 통과 (경고 0개)
- [ ] flutter test 통과 (모든 테스트 성공)
- [ ] 개인정보 처리방침 URL 유효 확인
- [ ] 앱 아이콘 최종 확인
- [ ] 스크린샷 품질 확인
- [ ] 버전 번호 확인 (1.0.0)

#### Android
- [ ] 키스토어 백업 완료
- [ ] keystore.properties 안전한 곳에 저장
- [ ] AAB 파일 서명 확인
- [ ] Google Play Console 계정 준비
- [ ] 스토어 등록정보 작성 완료

#### iOS
- [ ] Apple Developer 계정 활성화
- [ ] IPA 서명 확인
- [ ] App Store Connect 정보 작성 완료
- [ ] 스크린샷 준비 완료
- [ ] TestFlight 테스트 (선택사항)

---

## 🔄 앱 업데이트 방법

### 버전 번호 업데이트

1. `pubspec.yaml` 수정:
   ```yaml
   version: 1.0.1+2  # 버전+빌드번호
   ```

2. 변경사항 커밋:
   ```bash
   git add pubspec.yaml
   git commit -m "chore: 버전 1.0.1로 업데이트"
   ```

### 빌드 및 업로드

```bash
# Android
flutter build appbundle --release

# iOS
flutter build ipa --release
```

**동일한 키스토어를 반드시 사용해야 합니다!**

---

## 📞 지원 및 문의

- **GitHub Issues**: https://github.com/kmnkit/travel-budget-manager/issues
- **이메일**: (필요시 추가)

---

## 📚 참고 자료

### 공식 문서
- [Flutter 배포 가이드](https://docs.flutter.dev/deployment)
- [Google Play Console 도움말](https://support.google.com/googleplay/android-developer)
- [App Store Connect 도움말](https://developer.apple.com/help/app-store-connect/)

### 추가 도구
- [Fastlane](https://fastlane.tools/) - 배포 자동화
- [Transporter](https://apps.apple.com/app/transporter/id1450874784) - iOS 업로드

---

**마지막 업데이트**: 2026-02-06
