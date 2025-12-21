# モバイルアプリ開発ガイド - Travel Expense Tracker

## 📱 プロジェクト概要

### アーキテクチャ

```
travel-budget-manager/
├── web/                    # React Webアプリ (完成)
├── ios/                    # iOS SwiftUIアプリ
│   ├── TravelExpense/
│   │   ├── App/           # アプリケーション層
│   │   ├── Features/      # 機能別モジュール
│   │   ├── Core/          # コア機能（Supabase, NFC）
│   │   ├── Models/        # データモデル
│   │   └── Resources/     # リソース（画像、色）
│   └── TravelExpense.xcodeproj
│
├── android/               # Android Kotlinアプリ
│   ├── app/
│   │   └── src/
│   │       └── main/
│   │           ├── java/com/travelexpense/
│   │           │   ├── ui/           # UI層 (Jetpack Compose)
│   │           │   ├── data/         # データ層 (Repository)
│   │           │   ├── domain/       # ドメイン層
│   │           │   └── nfc/          # NFC機能
│   │           └── res/
│   └── build.gradle
│
└── docs/mobile/           # モバイル開発ドキュメント
```

---

## 🎯 開発フェーズ

### Phase 9a: プロジェクトセットアップ

#### iOS (SwiftUI)
```bash
# Xcodeでプロジェクト作成
- Product Name: TravelExpense
- Organization: TravelExpenseTracker
- Interface: SwiftUI
- Language: Swift
- Minimum Deployment: iOS 15.0
```

**必要なライブラリ:**
```swift
// Package.swift dependencies
dependencies: [
    .package(url: "https://github.com/supabase/supabase-swift", from: "1.0.0"),
    .package(url: "https://github.com/Alamofire/Alamofire", from: "5.8.0")
]
```

#### Android (Kotlin + Jetpack Compose)
```kotlin
// build.gradle (Project)
buildscript {
    ext {
        kotlin_version = "1.9.0"
        compose_version = "1.5.0"
        supabase_version = "1.0.0"
    }
}

// build.gradle (Module:app)
dependencies {
    // Jetpack Compose
    implementation "androidx.compose.ui:ui:$compose_version"
    implementation "androidx.compose.material3:material3:1.1.0"

    // Supabase
    implementation "io.github.jan-tennert.supabase:postgrest-kt:$supabase_version"
    implementation "io.github.jan-tennert.supabase:auth-kt:$supabase_version"

    // NFC
    implementation "androidx.core:core-ktx:1.12.0"
}
```

---

## 🔧 Supabase統合

### 設定ファイル

#### iOS: `Config.plist`
```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN">
<plist version="1.0">
<dict>
    <key>SUPABASE_URL</key>
    <string>https://qooygcznuptnlzxjfemg.supabase.co</string>
    <key>SUPABASE_ANON_KEY</key>
    <string>YOUR_ANON_KEY_HERE</string>
</dict>
</plist>
```

#### Android: `local.properties`
```properties
SUPABASE_URL=https://qooygcznuptnlzxjfemg.supabase.co
SUPABASE_ANON_KEY=YOUR_ANON_KEY_HERE
```

### Supabaseクライアント初期化

#### iOS (Swift)
```swift
import Supabase

class SupabaseManager {
    static let shared = SupabaseManager()

    let client: SupabaseClient

    private init() {
        guard let url = Bundle.main.object(forInfoDictionaryKey: "SUPABASE_URL") as? String,
              let key = Bundle.main.object(forInfoDictionaryKey: "SUPABASE_ANON_KEY") as? String else {
            fatalError("Supabase configuration missing")
        }

        client = SupabaseClient(
            supabaseURL: URL(string: url)!,
            supabaseKey: key
        )
    }
}
```

#### Android (Kotlin)
```kotlin
import io.github.jan.supabase.createSupabaseClient
import io.github.jan.supabase.postgrest.Postgrest
import io.github.jan.supabase.auth.Auth

object SupabaseManager {
    val client = createSupabaseClient(
        supabaseUrl = BuildConfig.SUPABASE_URL,
        supabaseKey = BuildConfig.SUPABASE_ANON_KEY
    ) {
        install(Postgrest)
        install(Auth)
    }
}
```

---

## 💳 IC Card (NFC) 機能実装

### 対応カード・国

| 国 | カード名 | 技術 | 実装優先度 |
|----|---------|------|----------|
| 🇯🇵 日本 | Suica, Pasmo, ICOCA | FeliCa | ⭐⭐⭐ (Phase 9b) |
| 🇭🇰 香港 | Octopus Card | FeliCa | ⭐⭐⭐ (Phase 9b) |
| 🇹🇼 台湾 | EasyCard | FeliCa | ⭐⭐⭐ (Phase 9b) |
| 🇸🇬 シンガポール | EZ-Link | CEPAS | ⭐⭐ (Phase 9c) |
| 🇰🇷 韓国 | T-money | MIFARE | ⭐ (Phase 10) |

### iOS NFC実装

#### Info.plist設定
```xml
<key>NFCReaderUsageDescription</key>
<string>交通カードの利用履歴を読み取るためにNFCを使用します</string>

<key>com.apple.developer.nfc.readersession.felica.systemcodes</key>
<array>
    <string>0003</string>  <!-- Suica/Pasmo -->
    <string>8008</string>  <!-- Octopus -->
</array>
```

#### FeliCa読み取りコード
```swift
import CoreNFC

class ICCardReader: NSObject, NFCTagReaderSessionDelegate {
    var session: NFCTagReaderSession?
    var onComplete: (([TransactionHistory]) -> Void)?

    func startReading() {
        session = NFCTagReaderSession(
            pollingOption: .iso18092,
            delegate: self
        )
        session?.alertMessage = "カードをiPhoneの上部に近づけてください"
        session?.begin()
    }

    func tagReaderSession(_ session: NFCTagReaderSession, didDetect tags: [NFCTag]) {
        guard let tag = tags.first else { return }

        session.connect(to: tag) { error in
            if error != nil {
                session.invalidate(errorMessage: "接続に失敗しました")
                return
            }

            if case let .feliCa(feliCaTag) = tag {
                self.readFeliCa(tag: feliCaTag, session: session)
            }
        }
    }

    private func readFeliCa(tag: NFCFeliCaTag, session: NFCTagReaderSession) {
        // IDmを取得
        let idm = tag.currentIDm

        // Suica/Pasmoの履歴読み取り (サービスコード: 090F)
        let serviceCode: [UInt8] = [0x09, 0x0F]

        tag.readWithoutEncryption(
            serviceCodeList: [Data(serviceCode)],
            blockList: [
                NFCFeliCaReadWithoutEncryptionCommandPacket.Block(
                    blockNumber: 0,
                    blockType: .list
                )
            ]
        ) { status1, status2, blockData, error in
            if let data = blockData.first {
                let history = self.parseTransactionHistory(data: data)
                self.onComplete?(history)
                session.invalidate()
            }
        }
    }

    private func parseTransactionHistory(data: Data) -> [TransactionHistory] {
        var transactions: [TransactionHistory] = []

        // Suica/Pasmoのデータフォーマットをパース
        // 16バイトずつ処理
        let recordSize = 16
        for i in stride(from: 0, to: data.count, by: recordSize) {
            let record = data.subdata(in: i..<min(i + recordSize, data.count))

            // バイト0-1: 端末種別・処理
            // バイト2-3: 利用日付
            // バイト4-5: 入場駅コード
            // バイト6-7: 出場駅コード
            // バイト8-9: 残額
            // バイト10-11: 取引額

            if let transaction = parseRecord(record) {
                transactions.append(transaction)
            }
        }

        return transactions
    }

    private func parseRecord(_ data: Data) -> TransactionHistory? {
        guard data.count >= 16 else { return nil }

        // 日付パース (Suica形式: 2000年1月1日からの日数)
        let dateCode = UInt16(data[2]) << 8 | UInt16(data[3])
        let date = Calendar.current.date(
            byAdding: .day,
            value: Int(dateCode),
            to: Date(timeIntervalSince1970: 946684800) // 2000-01-01
        )!

        // 駅コード取得（生データとして保存）
        let entryCode = UInt16(data[4]) << 8 | UInt16(data[5])
        let exitCode = UInt16(data[6]) << 8 | UInt16(data[7])

        // 金額
        let amount = Int(UInt16(data[10]) << 8 | UInt16(data[11]))

        // 残高
        let balance = Int(UInt16(data[8]) << 8 | UInt16(data[9]))

        return TransactionHistory(
            date: date,
            entryCode: entryCode,
            exitCode: exitCode,
            amount: amount,
            balance: balance
        )
    }
}

struct TransactionHistory {
    let date: Date
    let entryCode: UInt16  // 生データとして保存
    let exitCode: UInt16   // 生データとして保存
    let amount: Int
    let balance: Int
}
```

### Android NFC実装

#### AndroidManifest.xml
```xml
<uses-permission android:name="android.permission.NFC" />

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

#### res/xml/nfc_tech_filter.xml
```xml
<resources>
    <tech-list>
        <tech>android.nfc.tech.NfcF</tech>
    </tech-list>
</resources>
```

#### FeliCa読み取りコード
```kotlin
import android.nfc.NfcAdapter
import android.nfc.Tag
import android.nfc.tech.NfcF

class ICCardReader(private val activity: Activity) {
    private val nfcAdapter: NfcAdapter? = NfcAdapter.getDefaultAdapter(activity)

    fun enableReaderMode(callback: (List<TransactionHistory>) -> Unit) {
        nfcAdapter?.enableReaderMode(
            activity,
            { tag -> readFeliCa(tag, callback) },
            NfcAdapter.FLAG_READER_NFC_F,
            null
        )
    }

    fun disableReaderMode() {
        nfcAdapter?.disableReaderMode(activity)
    }

    private fun readFeliCa(tag: Tag, callback: (List<TransactionHistory>) -> Unit) {
        val felica = NfcF.get(tag) ?: return

        try {
            felica.connect()

            // IDm取得
            val idm = felica.tag.id

            // Suica/Pasmo履歴読み取り (サービスコード: 090F)
            val serviceCode = byteArrayOf(0x09, 0x0F)

            // コマンド構築
            val command = buildReadCommand(idm, serviceCode)
            val response = felica.transceive(command)

            val history = parseTransactionHistory(response)
            callback(history)

            felica.close()
        } catch (e: Exception) {
            Log.e("ICCardReader", "Error reading card", e)
        }
    }

    private fun buildReadCommand(idm: ByteArray, serviceCode: ByteArray): ByteArray {
        // FeliCa Read Without Encryptionコマンド
        return byteArrayOf(
            0x06.toByte(),  // コマンドコード
            *idm,           // IDm (8バイト)
            0x01,           // サービス数
            *serviceCode,   // サービスコード
            0x01,           // ブロック数
            0x80.toByte(), 0x00  // ブロック番号
        )
    }

    private fun parseTransactionHistory(data: ByteArray): List<TransactionHistory> {
        val transactions = mutableListOf<TransactionHistory>()

        // レスポンス形式: [レスポンスコード(1) + IDm(8) + データ(N*16)]
        if (data.size < 10) return transactions

        val blockData = data.copyOfRange(10, data.size)

        for (i in blockData.indices step 16) {
            if (i + 16 > blockData.size) break

            val record = blockData.copyOfRange(i, i + 16)
            parseRecord(record)?.let { transactions.add(it) }
        }

        return transactions
    }

    private fun parseRecord(data: ByteArray): TransactionHistory? {
        if (data.size < 16) return null

        // 日付パース
        val dateCode = ((data[2].toInt() and 0xFF) shl 8) or (data[3].toInt() and 0xFF)
        val date = LocalDate.of(2000, 1, 1).plusDays(dateCode.toLong())

        // 駅コード（生データとして保存）
        val entryCode = ((data[4].toInt() and 0xFF) shl 8) or (data[5].toInt() and 0xFF)
        val exitCode = ((data[6].toInt() and 0xFF) shl 8) or (data[7].toInt() and 0xFF)

        // 残高
        val balance = ((data[8].toInt() and 0xFF) shl 8) or (data[9].toInt() and 0xFF)

        // 金額
        val amount = ((data[10].toInt() and 0xFF) shl 8) or (data[11].toInt() and 0xFF)

        return TransactionHistory(
            date = date,
            entryCode = entryCode,
            exitCode = exitCode,
            amount = amount,
            balance = balance
        )
    }
}

data class TransactionHistory(
    val date: LocalDate,
    val entryCode: Int,  // 生データとして保存
    val exitCode: Int,   // 生データとして保存
    val amount: Int,
    val balance: Int
)
```

---

## 💾 データ保存と表示

### 生データ保存アプローチ（推奨）

ICカードから読み取ったデータは**生データとして保存**し、ユーザーが必要に応じて編集できるようにします。

#### Expenseテーブル拡張

```typescript
// 既存のExpenseに追加するメタデータ
interface ExpenseMetadata {
  ic_card_transaction?: {
    entry_code: number     // 入場駅コード（生データ）
    exit_code: number      // 出場駅コード（生データ）
    balance: number        // カード残高
    card_type: string      // 'suica' | 'pasmo' | 'octopus' | 'easycard'
    raw_data?: string      // 完全な生データ（デバッグ用）
  }
}

// Expense作成時
const expense = {
  amount: transaction.amount,
  currency: 'JPY',
  category_id: transportCategoryId,
  description: '交通費（ICカード）',  // デフォルト
  notes: `区間: ${transaction.entryCode} → ${transaction.exitCode}`,
  expense_date: transaction.date,
  payment_method: 'IC Card',
  metadata: {
    ic_card_transaction: {
      entry_code: transaction.entryCode,
      exit_code: transaction.exitCode,
      balance: transaction.balance,
      card_type: 'suica'
    }
  }
}
```

#### UI表示例

```swift
// iOS - 支出詳細画面
struct ExpenseDetailView: View {
    let expense: Expense
    @State private var isEditing = false

    var body: some View {
        VStack(alignment: .leading) {
            // タイトル（ユーザー編集可能）
            if isEditing {
                TextField("説明", text: $expense.description)
            } else {
                Text(expense.description ?? "交通費（ICカード）")
                    .font(.headline)
            }

            // 生データ表示（編集前）
            if let icData = expense.metadata?.ic_card_transaction,
               expense.description == "交通費（ICカード）" {
                Text("区間: \(icData.entry_code) → \(icData.exit_code)")
                    .font(.caption)
                    .foregroundColor(.gray)

                Button("駅名を入力") {
                    isEditing = true
                }
            }

            // 金額
            Text("¥\(expense.amount)")
                .font(.title)

            // 残高表示
            if let balance = expense.metadata?.ic_card_transaction?.balance {
                Text("カード残高: ¥\(balance)")
                    .font(.caption)
            }
        }
    }
}
```

### 将来の拡張: 外部API連携（Phase 10+）

ユーザーフィードバックに基づいて、後から外部APIを追加可能：

```swift
// オプション: 駅名解決API
func resolveStationName(code: Int, country: String) async -> String? {
    // Google Places API、駅すぱあとAPI等
    let url = "https://api.example.com/station/\(country)/\(code)"
    // ... API呼び出し
    return stationName
}

// キャッシング
private var stationCache: [String: String] = [:]

func getStationDisplay(code: Int, country: String) async -> String {
    let key = "\(country)-\(code)"

    if let cached = stationCache[key] {
        return cached
    }

    if let resolved = await resolveStationName(code: code, country: country) {
        stationCache[key] = resolved
        return resolved
    }

    return "駅コード: \(code)"
}
```

---

## 🔄 重複処理ロジック

### 自動マージアルゴリズム

```swift
func detectDuplicate(
    scanned: TransactionHistory,
    existing: [Expense]
) -> Expense? {
    return existing.first { expense in
        // 同じ日付
        let sameDate = Calendar.current.isDate(
            expense.expenseDate,
            inSameDayAs: scanned.date
        )

        // 金額が近い (±10円の誤差許容)
        let similarAmount = abs(expense.amount - Double(scanned.amount)) < 10

        // カテゴリーが交通費
        let isTransportCategory = expense.category?.name == "交通費"

        // 時間的に近い (同じ日の±1時間)
        let timeDiff = abs(expense.expenseDate.timeIntervalSince(scanned.date))
        let withinTimeWindow = timeDiff < 3600

        return sameDate && similarAmount && (isTransportCategory || withinTimeWindow)
    }
}
```

---

## 🎨 UI/UX設計

### ICカードスキャン画面

```
┌─────────────────────────────┐
│  💳 ICカードをスキャン      │
├─────────────────────────────┤
│                             │
│     [カードアイコン]         │
│                             │
│  カードを端末に近づけてください │
│                             │
│  🇯🇵 Suica / Pasmo         │
│  🇭🇰 Octopus Card          │
│  🇹🇼 EasyCard              │
│                             │
│  [ スキャン開始 ]           │
│  [ キャンセル ]             │
│                             │
└─────────────────────────────┘
```

### スキャン結果画面（初回スキャン時）

```
┌─────────────────────────────┐
│  ✅ 15件の取引を読み取りました │
│  残高: ¥3,450               │
├─────────────────────────────┤
│  [ すべて(15) ][ 新規(12) ] │
│  [ 重複(3) ]                │
├─────────────────────────────┤
│  ☑️ 交通費（ICカード）      │
│     区間: 0305 → 0601       │
│     ¥220 | 12/21 14:23     │
├─────────────────────────────┤
│  ⚠️ 交通費（ICカード）(重複) │
│     区間: 0302 → 0401       │
│     ¥170 | 12/20 09:15     │
│     [既存データと統合]      │
├─────────────────────────────┤
│  [ 選択した12件を追加 ]     │
└─────────────────────────────┘
```

### 支出編集画面（ユーザーが駅名を入力）

```
┌─────────────────────────────┐
│  ✏️ 支出を編集              │
├─────────────────────────────┤
│  説明:                      │
│  [新宿駅 → 渋谷駅        ]  │
│                             │
│  金額: ¥220                 │
│  日付: 2025/12/21 14:23    │
│  カテゴリー: 交通費         │
│                             │
│  メモ:                      │
│  [山手線利用           ]    │
│                             │
│  元データ: 0305 → 0601      │
│  残高: ¥3,450               │
│                             │
│  [   保存   ]               │
└─────────────────────────────┘
```

---

## 📱 開発開始手順

### iOS

```bash
# 1. Xcodeでプロジェクト作成
open -a Xcode

# 2. Swift Package Managerで依存関係追加
# File > Add Packages
# https://github.com/supabase/supabase-swift

# 3. プロジェクト構造作成
cd ios/TravelExpense
mkdir -p {App,Features,Core,Models,Resources}
```

### Android

```bash
# 1. Android Studioでプロジェクト作成
# New Project > Empty Compose Activity

# 2. build.gradleに依存関係追加

# 3. プロジェクト構造作成
cd android/app/src/main/java/com/travelexpense
mkdir -p {ui,data,domain,nfc}
```

---

## 🧪 テストプラン

### NFC機能テスト

1. **実機テスト必須**
   - NFCはシミュレーターで動作しない
   - 実際のICカードで検証

2. **テストケース**
   - ✅ カード読み取り成功
   - ✅ 複数レコード読み取り
   - ✅ 重複検出
   - ✅ 異なる種類のカード (Suica, Pasmo, ICOCA)
   - ✅ エラーハンドリング (カード離れすぎ、通信エラー)

---

## 📝 次のステップ

1. ✅ **Phase 9a**: プロジェクトセットアップ
2. ⬜ **Phase 9b**: Supabase統合 + 基本画面
3. ⬜ **Phase 9c**: NFC機能実装 (日本)
4. ⬜ **Phase 9d**: 他国対応 (香港、台湾)
5. ⬜ **Phase 9e**: テスト・デバッグ

---

**バージョン**: 1.0
**最終更新**: 2025-12-21
**作成者**: Claude Code
