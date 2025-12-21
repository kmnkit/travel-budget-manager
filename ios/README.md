# Travel Expense Tracker - iOS アプリ

SwiftUI で実装された旅行支出管理アプリの iOS 版です。

## 📋 必要環境

- **macOS**: 13.0 以降
- **Xcode**: 15.0 以降
- **Swift**: 5.9 以降
- **iOS**: 15.0 以降（最小対応バージョン）

## 🚀 セットアップ手順

### 1. プロジェクトを Xcode で開く

```bash
cd ios
open TravelExpense.xcodeproj
```

### 2. Swift Package Manager で依存関係を追加

Xcode で以下の手順で依存関係を追加：

1. **File > Add Packages...**
2. 以下の URL を入力：

```
https://github.com/supabase/supabase-swift
```

3. **Add Package** をクリック

### 3. Supabase 設定

`Info.plist` に以下のキーを追加：

```xml
<key>SUPABASE_URL</key>
<string>https://qooygcznuptnlzxjfemg.supabase.co</string>
<key>SUPABASE_ANON_KEY</key>
<string>YOUR_ANON_KEY_HERE</string>
```

**注意**: `SUPABASE_ANON_KEY` は実際の値に置き換えてください。

### 4. NFC 機能設定（ICカード読み取り用）

`Info.plist` に以下を追加：

```xml
<key>NFCReaderUsageDescription</key>
<string>交通カードの利用履歴を読み取るためにNFCを使用します</string>

<key>com.apple.developer.nfc.readersession.felica.systemcodes</key>
<array>
    <string>0003</string>  <!-- Suica/Pasmo -->
    <string>8008</string>  <!-- Octopus -->
</array>
```

**Capabilities** でNFCを有効化：

1. Xcode で **Signing & Capabilities** タブを開く
2. **+ Capability** をクリック
3. **Near Field Communication Tag Reading** を追加

### 5. ビルド & 実行

1. シミュレーターまたは実機を選択
2. **Product > Run** (⌘R)

**注意**: NFC 機能は実機でのみ動作します。

## 📁 プロジェクト構造

```
TravelExpense/
├── App/                    # アプリエントリーポイント
│   └── TravelExpenseApp.swift
├── Features/               # 機能別モジュール
│   ├── Auth/              # 認証機能
│   │   ├── AuthViewModel.swift
│   │   ├── LoginView.swift
│   │   └── SignUpView.swift
│   ├── Trip/              # 旅行管理
│   │   ├── TripViewModel.swift
│   │   └── TripListView.swift
│   └── Expense/           # 支出記録（未実装）
├── Core/                  # コア機能
│   ├── Supabase/          # Supabase統合
│   │   └── SupabaseManager.swift
│   └── NFC/               # NFC機能（未実装）
├── Models/                # データモデル
│   ├── Trip.swift
│   └── Expense.swift
└── Resources/             # リソース
```

## 🔑 主な機能

### ✅ 実装済み
- ログイン / サインアップ
- セッション管理
- 旅行一覧表示
- 検索・フィルター・ソート
- レスポンシブUI

### 🚧 未実装（Phase 9c以降）
- ICカード読み取り（NFC）
- 旅行作成・編集
- 支出記録
- レポート・分析
- カテゴリー管理

## 🎨 デザインシステム

### カラーパレット
- **Primary Red**: `#E63946`
- **Dark Red**: `#C1121F`
- **Accent Green**: `#06D6A0`

### コンポーネント
- `PrimaryButtonStyle`: メインアクション用ボタン
- `SecondaryButtonStyle`: サブアクション用ボタン
- `CustomTextFieldStyle`: 認証フォーム用テキストフィールド

## 🧪 テスト

```bash
# ユニットテスト実行
⌘U (Xcode)

# または CLI で
xcodebuild test -scheme TravelExpense -destination 'platform=iOS Simulator,name=iPhone 15'
```

## 📱 ビルド

### Debug ビルド
```bash
xcodebuild -scheme TravelExpense -configuration Debug
```

### Release ビルド
```bash
xcodebuild -scheme TravelExpense -configuration Release
```

## 🚀 App Store リリース

1. **Archive 作成**:
   - Product > Archive

2. **Validate App**:
   - Organizer で Archive を選択
   - Validate App をクリック

3. **Upload to App Store**:
   - Distribute App をクリック
   - App Store Connect を選択

## 🐛 トラブルシューティング

### ビルドエラー: "Module 'Supabase' not found"
```bash
# Swift Package Manager のキャッシュをクリア
File > Packages > Reset Package Caches
```

### Simulator で NFC が動作しない
NFC 機能は実機でのみ動作します。iPhone 7 以降の実機でテストしてください。

### ❌ "The network connection was lost" エラー

**症状**: ログイン時に "The connection was lost" エラーが表示される

**原因**: `Info.plist` が Xcode プロジェクトに正しく追加されていない

**解決方法**:

1. **Info.plist の存在確認**:
   ```bash
   ls -la TravelExpense/Resources/Info.plist
   ```

2. **Xcode で Info.plist を追加**:
   - プロジェクトナビゲーターで `Resources` フォルダを右クリック
   - "Add Files to "TravelExpense"..." を選択
   - `Info.plist` を選択
   - "Copy items if needed" をチェック
   - "Add" をクリック

3. **ターゲット設定を確認**:
   - Xcode でプロジェクトを選択
   - **TARGETS** → **TravelExpense** → **Build Settings**
   - "Info.plist File" を検索
   - 値が `TravelExpense/Resources/Info.plist` になっているか確認

4. **クリーンビルド**:
   ```
   Product > Clean Build Folder (⌘⇧K)
   ```
   その後、再ビルド (⌘B)

5. **設定値の確認**:
   `Info.plist` に以下が含まれているか確認：
   ```xml
   <key>SUPABASE_URL</key>
   <string>https://qooygcznuptnlzxjfemg.supabase.co</string>
   <key>SUPABASE_ANON_KEY</key>
   <string>eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...</string>
   ```

### Supabase 接続エラー
`Info.plist` の `SUPABASE_URL` と `SUPABASE_ANON_KEY` が正しいか確認してください。

## 📚 参考リソース

- [SwiftUI Documentation](https://developer.apple.com/documentation/swiftui)
- [Supabase Swift SDK](https://github.com/supabase/supabase-swift)
- [Core NFC](https://developer.apple.com/documentation/corenfc)
- [モバイル開発ガイド](../docs/mobile/MOBILE_DEVELOPMENT_GUIDE.md)

## 📄 ライセンス

MIT License

---

**開発開始日**: 2025-12-21
**Phase 9b 実装完了**: 基本認証・旅行一覧
**次のステップ**: Phase 9c - ICカード読み取り実装
