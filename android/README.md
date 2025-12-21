# Travel Expense Tracker - Android アプリ

Kotlin + Jetpack Compose で実装された旅行支出管理アプリの Android 版です。

## 📋 必要環境

- **JDK**: 17 以降
- **Android Studio**: Hedgehog (2023.1.1) 以降
- **Kotlin**: 1.9 以降
- **最小 Android SDK**: API 26 (Android 8.0)
- **ターゲット SDK**: API 34 (Android 14)

## 🚀 セットアップ手順

### 1. Android Studio でプロジェクトを開く

```bash
# Android Studio で以下のフォルダを開く
File > Open > android/
```

### 2. 依存関係の追加

`build.gradle (Module: app)` に以下の依存関係を追加：

```kotlin
dependencies {
    // Jetpack Compose
    implementation("androidx.compose.ui:ui:1.5.4")
    implementation("androidx.compose.material3:material3:1.1.2")
    implementation("androidx.activity:activity-compose:1.8.2")
    implementation("androidx.lifecycle:lifecycle-viewmodel-compose:2.7.0")

    // Supabase
    implementation("io.github.jan-tennert.supabase:postgrest-kt:1.4.7")
    implementation("io.github.jan-tennert.supabase:gotrue-kt:1.4.7")
    implementation("io.ktor:ktor-client-android:2.3.7")

    // Kotlinx Serialization
    implementation("org.jetbrains.kotlinx:kotlinx-serialization-json:1.6.2")

    // Coroutines
    implementation("org.jetbrains.kotlinx:kotlinx-coroutines-android:1.7.3")
}
```

`build.gradle (Project)` にプラグインを追加：

```kotlin
plugins {
    id("org.jetbrains.kotlin.plugin.serialization") version "1.9.21" apply false
}
```

`build.gradle (Module: app)` にプラグインを適用：

```kotlin
plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
    id("org.jetbrains.kotlin.plugin.serialization")
}
```

### 3. Supabase 設定

`local.properties` に以下を追加：

```properties
SUPABASE_URL=https://qooygcznuptnlzxjfemg.supabase.co
SUPABASE_ANON_KEY=YOUR_ANON_KEY_HERE
```

`build.gradle (Module: app)` で環境変数を読み込み：

```kotlin
android {
    defaultConfig {
        // ...

        val properties = Properties()
        properties.load(project.rootProject.file("local.properties").inputStream())

        buildConfigField("String", "SUPABASE_URL", "\"${properties.getProperty("SUPABASE_URL")}\"")
        buildConfigField("String", "SUPABASE_ANON_KEY", "\"${properties.getProperty("SUPABASE_ANON_KEY")}\"")
    }

    buildFeatures {
        buildConfig = true
    }
}
```

**注意**: `local.properties` は Git にコミットしないでください（`.gitignore` に追加済み）。

### 4. NFC 機能設定（ICカード読み取り用）

`AndroidManifest.xml` に以下を追加：

```xml
<uses-permission android:name="android.permission.NFC" />
<uses-feature android:name="android.hardware.nfc" android:required="false" />

<application>
    <activity android:name=".MainActivity">
        <intent-filter>
            <action android:name="android.nfc.action.TECH_DISCOVERED" />
        </intent-filter>

        <meta-data
            android:name="android.nfc.action.TECH_DISCOVERED"
            android:resource="@xml/nfc_tech_filter" />
    </activity>
</application>
```

`res/xml/nfc_tech_filter.xml` を作成：

```xml
<resources>
    <tech-list>
        <tech>android.nfc.tech.NfcF</tech>
    </tech-list>
</resources>
```

### 5. Sync & Build

```bash
# Gradle Sync
./gradlew sync

# ビルド
./gradlew assembleDebug
```

### 6. 実行

1. エミュレーターまたは実機を接続
2. **Run > Run 'app'** をクリック

**注意**: NFC 機能は実機でのみ動作します。

## 📁 プロジェクト構造

```
app/src/main/java/com/travelexpense/
├── ui/                         # UI層（Jetpack Compose）
│   ├── auth/                   # 認証画面
│   │   ├── AuthViewModel.kt
│   │   ├── LoginScreen.kt
│   │   └── SignUpScreen.kt
│   ├── trip/                   # 旅行管理
│   │   ├── TripViewModel.kt
│   │   └── TripListScreen.kt
│   └── theme/                  # テーマ設定
├── data/                       # データ層
│   ├── model/                  # データモデル
│   │   ├── Trip.kt
│   │   └── Expense.kt
│   ├── supabase/               # Supabase統合
│   │   └── SupabaseClient.kt
│   └── repository/             # リポジトリ（未実装）
├── domain/                     # ドメイン層（未実装）
│   └── usecase/
└── nfc/                        # NFC機能（未実装）
```

## 🔑 主な機能

### ✅ 実装済み
- ログイン / サインアップ
- セッション管理
- 旅行一覧表示
- 検索・フィルター・ソート
- Material Design 3 UI

### 🚧 未実装（Phase 9c以降）
- ICカード読み取り（NFC）
- 旅行作成・編集
- 支出記録
- レポート・分析
- カテゴリー管理
- オフライン対応（Room Database）

## 🎨 デザインシステム

### カラーパレット
- **Primary Red**: `Color(0xFFE63946)`
- **Dark Red**: `Color(0xFFC1121F)`
- **Accent Green**: `Color(0xFF06D6A0)`

### Material Design 3
- テーマ: Material You 対応
- コンポーネント: Material3 ライブラリを使用

## 🧪 テスト

### ユニットテスト
```bash
./gradlew test
```

### インストゥルメンテーションテスト
```bash
./gradlew connectedAndroidTest
```

## 📱 ビルド

### Debug ビルド
```bash
./gradlew assembleDebug
```

### Release ビルド
```bash
./gradlew assembleRelease
```

### AAB (Android App Bundle)
```bash
./gradlew bundleRelease
```

## 🔑 署名設定（リリース用）

`keystore.properties` を作成：

```properties
storeFile=/path/to/keystore.jks
storePassword=YOUR_STORE_PASSWORD
keyAlias=YOUR_KEY_ALIAS
keyPassword=YOUR_KEY_PASSWORD
```

`build.gradle (Module: app)` で署名設定：

```kotlin
android {
    signingConfigs {
        create("release") {
            val keystorePropertiesFile = rootProject.file("keystore.properties")
            val keystoreProperties = Properties()
            keystoreProperties.load(keystorePropertiesFile.inputStream())

            storeFile = file(keystoreProperties["storeFile"] as String)
            storePassword = keystoreProperties["storePassword"] as String
            keyAlias = keystoreProperties["keyAlias"] as String
            keyPassword = keystoreProperties["keyPassword"] as String
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
            // ...
        }
    }
}
```

## 🚀 Google Play リリース

1. **AAB 作成**:
   ```bash
   ./gradlew bundleRelease
   ```

2. **AAB ファイルの場所**:
   ```
   app/build/outputs/bundle/release/app-release.aab
   ```

3. **Google Play Console にアップロード**:
   - [Google Play Console](https://play.google.com/console) にアクセス
   - アプリを選択 > リリース > 製品版
   - AAB をアップロード

## 🐛 トラブルシューティング

### ビルドエラー: "Unresolved reference: Supabase"
```bash
# Gradle キャッシュをクリア
./gradlew clean
./gradlew --refresh-dependencies
```

### Supabase 接続エラー
`local.properties` の `SUPABASE_URL` と `SUPABASE_ANON_KEY` が正しいか確認してください。

### NFC が動作しない
- NFC 対応の実機でテストしていますか？
- 設定 > 接続 > NFC が有効になっていますか？
- `AndroidManifest.xml` の NFC パーミッションを確認してください

### Compose プレビューが表示されない
```bash
# Android Studio を再起動
# File > Invalidate Caches / Restart
```

## 📚 参考リソース

- [Jetpack Compose Documentation](https://developer.android.com/jetpack/compose)
- [Material Design 3](https://m3.material.io/)
- [Supabase Kotlin SDK](https://github.com/supabase-community/supabase-kt)
- [NFC Basics](https://developer.android.com/guide/topics/connectivity/nfc)
- [モバイル開発ガイド](../docs/mobile/MOBILE_DEVELOPMENT_GUIDE.md)

## 📄 ライセンス

MIT License

---

**開発開始日**: 2025-12-21
**Phase 9b 実装完了**: 基本認証・旅行一覧
**次のステップ**: Phase 9c - ICカード読み取り実装
