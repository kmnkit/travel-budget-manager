# 📱 Travel Expense Tracker - モバイルアプリ

## プロジェクト構成

```
travel-budget-manager/
├── ios/                 # iOS SwiftUIアプリ
├── android/             # Android Kotlin + Jetpack Composeアプリ
├── web/                 # Reactウェブアプリ (完成)
└── docs/mobile/         # モバイル開発ドキュメント
```

## 開発状況

| プラットフォーム | 状態 | 進捗 |
|----------------|------|------|
| 🌐 Web | ✅ 完成 | 100% |
| 📱 iOS | 🚧 開発中 | 0% |
| 🤖 Android | 🚧 開発中 | 0% |

## 主な機能

### Webアプリ (完成)
- ✅ 認証・アカウント管理
- ✅ オンボーディング
- ✅ 旅行管理 (CRUD)
- ✅ 支出記録 (CRUD)
- ✅ カテゴリー管理
- ✅ レポート・分析 (チャート)
- ✅ プロフィール・設定
- ✅ 検索・フィルター・ソート

### モバイルアプリ (予定)
- ⬜ すべてのWeb機能
- ⬜ **ICカード読み取り** (Suica, Pasmo, Octopus等)
- ⬜ プッシュ通知
- ⬜ オフライン対応
- ⬜ カメラ統合 (レシート撮影)
- ⬜ 位置情報連携

## 💳 ICカード対応

### Phase 9b対応カード
- 🇯🇵 **日本**: Suica, Pasmo, ICOCA, Kitaca, TOICA, manaca, SUGOCA, nimoca, はやかけん
- 🇭🇰 **香港**: Octopus Card (八達通)
- 🇹🇼 **台湾**: EasyCard (悠遊卡)

### 将来対応予定 (Phase 10)
- 🇸🇬 **シンガポール**: EZ-Link
- 🇰🇷 **韓国**: T-money
- 🇬🇧 **イギリス**: Oyster Card

## 技術スタック

### iOS
- **言語**: Swift 5.9+
- **UI**: SwiftUI
- **最小バージョン**: iOS 15.0
- **ライブラリ**:
  - Supabase Swift SDK
  - Core NFC (FeliCa読み取り)
  - Alamofire (ネットワーキング)

### Android
- **言語**: Kotlin 1.9+
- **UI**: Jetpack Compose
- **最小SDK**: API 26 (Android 8.0)
- **ライブラリ**:
  - Supabase Kotlin SDK
  - NFC API (FeliCa読み取り)
  - Retrofit (ネットワーキング)
  - Room (ローカルDB)

## セットアップ

### iOS

```bash
# 必要な環境
- macOS 13.0以降
- Xcode 15.0以降
- CocoaPods または Swift Package Manager

# セットアップ手順
cd ios
open TravelExpense.xcodeproj

# または
cd ios
pod install
open TravelExpense.xcworkspace
```

### Android

```bash
# 必要な環境
- JDK 17以降
- Android Studio Hedgehog以降
- Android SDK API 34

# セットアップ手順
# Android Studioで開く
# File > Open > android/
```

## 開発ガイド

詳細な開発ガイドは以下を参照してください：

- **[モバイル開発ガイド](./docs/mobile/MOBILE_DEVELOPMENT_GUIDE.md)**
  - アーキテクチャ
  - Supabase統合
  - NFC実装詳細
  - UI/UX設計
  - テストプラン

- **[PRD](./PRD.md)**
  - 製品要件定義
  - データモデル
  - 機能仕様

- **[TASK_PLAN](./TASK_PLAN.md)**
  - 開発タスク詳細
  - フェーズ別実装計画

## 🚀 デプロイ

### iOS App Store
```bash
# ビルド番号更新
agvtool next-version -all

# Archive作成
xcodebuild archive \
  -scheme TravelExpense \
  -archivePath build/TravelExpense.xcarchive

# App Store Connect へアップロード
xcodebuild -exportArchive \
  -archivePath build/TravelExpense.xcarchive \
  -exportPath build/ \
  -exportOptionsPlist ExportOptions.plist
```

### Google Play
```bash
# リリースビルド
cd android
./gradlew bundleRelease

# AABファイル生成
# app/build/outputs/bundle/release/app-release.aab
```

## 📝 ライセンス

MIT License

## 👥 開発チーム

- **プロジェクトリード**: Claude Code
- **バックエンド**: Supabase
- **デザイン**: Tailwind CSS / Material Design 3

---

**最終更新**: 2025-12-21
