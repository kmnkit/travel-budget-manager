# Claude開発ガイド - Travel Expense Tracker

このドキュメントは、ClaudeがTravel Expense Trackerプロジェクトの開発タスクを実行する際のガイドラインです。

---

## 📌 プロジェクト概要

### プロジェクト名
**Travel Expense Tracker（旅行支出トラッカー）**

### プロジェクトの目的
海外旅行者が現地での支出を簡単に記録・管理できるクロスプラットフォームアプリケーションを開発する。

### 技術スタック
- **フロントエンド（Web）**: React + TypeScript + Tailwind CSS
- **フロントエンド（iOS）**: SwiftUI
- **フロントエンド（Android）**: Kotlin + Jetpack Compose
- **バックエンド**: Supabase (PostgreSQL)
- **OCR**: Tesseract.js (Web), ML Kit (Android), Vision Framework (iOS)

### MVP機能
1. 認証・アカウント管理
2. オンボーディング
3. 旅行管理
4. レシートOCR読み取り
5. 支出記録（手動・自動）
6. カテゴリー＆タグ
7. 予算管理
8. レポート・分析
9. データ同期（Supabase）

### デザインテーマ
**赤基調**の情熱的で使いやすいUI/UX

---

## 📋 重要ドキュメント

開発を開始する前に、必ず以下のドキュメントを確認してください：

1. **[PRD.md](./PRD.md)**: 製品要件定義書
   - 機能詳細、データモデル、UI/UX仕様が記載されています

2. **[TASK_PLAN.md](./TASK_PLAN.md)**: 開発タスクプラン
   - 13のフェーズに分かれた詳細なタスクリスト
   - 各フェーズで使用すべきツールの推奨
   - 進捗管理用チェックボックス

3. **[README.md](./README.md)**: プロジェクト概要
   - プロジェクトの全体像と開発ステータス

---

## 🎯 開発ガイドライン

### 1. タスクの開始前に必ず行うこと

#### ✅ PRDを読む
- 実装する機能の要件を **PRD.md** で確認
- データモデル、UI/UX仕様を理解

#### ✅ TASK_PLAN.mdを確認
- 現在のPhaseを確認
- 該当するタスクのチェックボックスを確認
- 推奨ツールを確認

#### ✅ 既存コードを理解
- 新しい機能を追加する前に、**Task (Explore agent)** で既存のコードパターンを理解
- 同様の機能が既に実装されていないか確認

### 2. コードの品質基準

#### 一貫性を保つ
- 既存のコードスタイルに従う
- ファイル命名規則を守る（例: `PascalCase.tsx`, `camelCase.ts`）
- ディレクトリ構造を維持

#### シンプルに保つ
- 過度な抽象化を避ける
- 必要最小限の実装
- コメントは自明でない部分のみ

#### 型安全性
- TypeScriptの型を適切に定義
- `any` の使用を避ける
- 必要に応じてカスタム型を定義

#### セキュリティ
- ユーザー入力は常にバリデーション
- SQLインジェクション、XSSなどの脆弱性に注意
- 環境変数を使用して機密情報を保護

### 3. デザインガイドライン

#### カラースキーム（PRD参照）
- **メインレッド**: `#E63946`
- **ダークレッド**: `#C1121F`
- **ライトレッド**: `#F8B4B4`
- **アクセントカラー**: ゴールド `#FFB703`, グリーン `#06D6A0`

#### コンポーネント設計
- shadcn/ui のコンポーネントを活用
- 再利用可能なコンポーネントを作成
- レスポンシブデザインを考慮

---

## 🔄 タスク実行フロー

### 標準的な開発フロー

すべてのタスクは、以下のステップに従って実行してください：

#### **ステップ1: 準備**
```
1. PRD.md で該当機能の要件を確認
2. TASK_PLAN.md で現在のタスクを確認
3. 必要に応じて Task (Explore) で既存コードを理解
```

#### **ステップ2: 計画**
```
1. 複雑な機能の場合、Task (Plan) で実装計画を立てる
2. 必要なファイル、コンポーネントをリストアップ
3. データフローを確認
```

#### **ステップ3: 実装**
```
1. Write tool で新規ファイルを作成
2. Edit tool で既存ファイルを修正
3. 段階的に実装（一度に全てではなく、小さく分割）
```

#### **ステップ4: 動作確認**
```
1. Bash tool で開発サーバーを起動（npm run dev）
2. ブラウザで動作確認
3. エラーがあれば修正
```

#### **ステップ5: コミット**
```
1. git add でファイルをステージング
2. Conventional Commits形式でコミット
3. git push でリモートにプッシュ
```

#### **ステップ6: 進捗更新**
```
1. TASK_PLAN.md のチェックボックスを更新
2. 完了したタスクを [x] にマーク
3. 次のタスクに進む
```

### フェーズごとの推奨フロー

#### Phase 0-1: セットアップ・バックエンド
- **主なツール**: `Bash`, `Write`
- **フロー**: 環境構築 → Supabase設定 → テーブル作成 → RLS設定

#### Phase 2-8: フロントエンド開発
- **主なツール**: `Task (Explore)`, `Write`, `Edit`, `Bash`
- **フロー**: コード理解 → コンポーネント作成 → 統合 → テスト → コミット

#### Phase 11: テスト
- **主なツール**: `Write`, `Bash`
- **フロー**: テスト作成 → 実行 → バグ修正 → 再実行

#### Phase 12: デプロイ
- **主なツール**: `Bash`, `Read`
- **フロー**: ビルド → デプロイ → 動作確認

---

## 📊 進捗管理

### TASK_PLAN.mdの更新ルール

#### 必須ルール
1. **タスク開始時**: チェックボックスを確認
2. **タスク完了時**: 必ず `[x]` にマーク
3. **区切りの良いタイミング**: Phaseごとにコミット

#### チェックボックスの意味
```markdown
- [ ] 未着手
- [x] 完了
```

#### 更新タイミング
- ✅ 各タスク完了直後
- ✅ Phaseの区切り
- ✅ 1日の作業終了時

### 進捗報告

開発タスクを実行した後は、以下の形式で簡潔に報告してください：

```markdown
## 完了したタスク
- [x] ログイン画面の作成
- [x] Supabase Auth の統合

## 次のタスク
- [ ] サインアップ画面の作成
- [ ] 認証状態の監視

## 所感・メモ
- shadcn/ui の Form コンポーネントが便利
- バリデーションは react-hook-form を使用
```

---

## 🛠️ ツール使用ガイド

### 基本ツール

#### Read - ファイルを読み込む
```
✅ 使う場面:
- 既存のコードを理解する
- エラーログを確認する
- 設定ファイルを確認する

❌ 避ける場面:
- ファイルを変更する場合（Edit を使う）
```

#### Write - 新しいファイルを作成する
```
✅ 使う場面:
- 新しいコンポーネントを作成
- 新しい設定ファイルを作成
- 新しいテストファイルを作成

❌ 避ける場面:
- 既存ファイルの修正（Edit を使う）
```

#### Edit - 既存ファイルを編集する
```
✅ 使う場面:
- コンポーネントに機能を追加
- バグを修正
- 既存の設定を更新

💡 ヒント:
- old_string は正確にコピー
- インデントに注意
```

#### Bash - コマンドを実行する
```
✅ 使う場面:
- npm コマンド実行
- git 操作
- 開発サーバー起動
- テスト実行

例:
npm install <package>
npm run dev
git add . && git commit -m "..."
```

#### Grep - コード検索
```
✅ 使う場面:
- 関数の使用箇所を探す
- エラーメッセージを検索
- 特定のパターンを探す

例:
pattern: "useAuth"
pattern: "TODO"
```

#### Glob - ファイル検索
```
✅ 使う場面:
- ファイルパターンで検索
- 特定の拡張子のファイルを探す

例:
pattern: "**/*.tsx"
pattern: "**/auth/*.ts"
```

### Subagent（Task tool）

#### Task (Explore agent)
```
✅ 使うべき場面:
- プロジェクト構造を理解したい
- 既存の実装パターンを学びたい
- 特定の機能がどこにあるか探したい
- 複数ファイルにまたがる実装を理解したい

❌ 使わない方が良い場面:
- 特定のファイルパスが分かっている
- 単純なファイル検索

例:
"認証フローの実装を調査してください"
"Supabaseクライアントの初期化方法を調べてください"
```

#### Task (Plan agent)
```
✅ 使うべき場面:
- 複雑な機能の実装計画を立てたい
- アーキテクチャの選択肢を検討したい
- 大規模なリファクタリングを計画したい

例:
"OCR機能の実装アプローチを計画してください"
"状態管理の設計を検討してください"
```

### ツール選択のフローチャート

```
新しいコンポーネントを作る
  → Write

既存のコンポーネントを修正
  → Edit

コードを理解したい
  → ファイルパスが分かる → Read
  → 場所が分からない → Task (Explore) または Grep/Glob

複雑な機能を実装
  → Task (Plan) で計画 → Write/Edit で実装

コマンド実行
  → Bash

検索
  → キーワード検索 → Grep
  → ファイル検索 → Glob
```

---

## 📝 コミット規約

### Conventional Commits形式

すべてのコミットは、以下の形式に従ってください：

```
<type>: <subject>

[optional body]

[optional footer]
```

### Type（必須）

| Type | 説明 | 例 |
|------|------|-----|
| `feat` | 新機能 | feat: レシートOCR機能を追加 |
| `fix` | バグ修正 | fix: 予算計算のバグを修正 |
| `refactor` | リファクタリング | refactor: 認証ロジックをカスタムフックに分離 |
| `style` | コードスタイルの変更 | style: Prettier でフォーマット |
| `test` | テスト追加・修正 | test: 認証フローのテストを追加 |
| `docs` | ドキュメント更新 | docs: README にセットアップ手順を追加 |
| `chore` | ビルド・設定の変更 | chore: Tailwind CSS をアップデート |
| `perf` | パフォーマンス改善 | perf: レポート集計を最適化 |

### Subject（必須）

- 50文字以内
- 命令形で記述（例: 「追加する」ではなく「追加」）
- 日本語でOK
- ピリオド不要

### Body（オプション）

- 何を変更したかではなく、**なぜ変更したか**を記述
- 72文字で改行

### Footer（オプション）

- Breaking Changes
- Issue参照（例: `Closes #123`）

### コミット例

```bash
# 良い例
git commit -m "feat: ログイン画面を追加"
git commit -m "fix: 予算超過時のアラートが表示されない問題を修正"
git commit -m "refactor: Supabaseクライアントを共通モジュールに分離"

# 悪い例
git commit -m "update"  # ❌ 何を更新したか不明
git commit -m "fix bug"  # ❌ どのバグか不明
git commit -m "いろいろ変更"  # ❌ 具体性がない
```

### コミットのタイミング

✅ **コミットすべきタイミング**:
- 1つの機能が完成したとき
- 1つのバグが修正されたとき
- 意味のある単位でまとまったとき

❌ **避けるべきコミット**:
- 動作しないコードのコミット
- 複数の無関係な変更を1つのコミットにまとめる
- コミットメッセージが不明瞭

---

## 💡 ベストプラクティス

### コーディングのベストプラクティス

#### 1. 段階的に実装する
```
❌ 悪い例:
- 一度に大きな機能を実装する
- 複数の無関係な変更を同時に行う

✅ 良い例:
- 小さな単位で実装
- 1つずつ動作確認
- 動いたらコミット
```

#### 2. 既存パターンに従う
```
❌ 悪い例:
- 独自のディレクトリ構造を作る
- 異なる命名規則を使う

✅ 良い例:
- Task (Explore) で既存パターンを理解
- 同じディレクトリ構造を維持
- 同じ命名規則を使用
```

#### 3. エラーハンドリング
```typescript
// ✅ 良い例
try {
  const { data, error } = await supabase.from('trips').select('*')
  if (error) throw error
  return data
} catch (error) {
  console.error('Error fetching trips:', error)
  toast.error('旅行の取得に失敗しました')
  return []
}

// ❌ 悪い例
const { data } = await supabase.from('trips').select('*')
return data  // エラーハンドリングなし
```

#### 4. 型定義
```typescript
// ✅ 良い例
interface Trip {
  id: string
  user_id: string
  name: string
  destination: string
  start_date: string
  end_date: string
  currency_code: string
  total_budget?: number
}

// ❌ 悪い例
const trip: any = {...}  // any を使わない
```

### Supabaseのベストプラクティス

#### 1. Row Level Security (RLS)
```sql
-- ✅ 必ずRLSポリシーを設定
ALTER TABLE trips ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can only access their own trips"
  ON trips
  FOR ALL
  USING (auth.uid() = user_id);
```

#### 2. クエリの最適化
```typescript
// ✅ 良い例: 必要なカラムだけ取得
const { data } = await supabase
  .from('trips')
  .select('id, name, start_date')
  .eq('user_id', userId)

// ❌ 悪い例: 全カラム取得
const { data } = await supabase
  .from('trips')
  .select('*')  // 不要なデータも取得してしまう
```

#### 3. リアルタイム同期
```typescript
// ✅ クリーンアップを忘れずに
useEffect(() => {
  const subscription = supabase
    .channel('trips')
    .on('postgres_changes', { event: '*', schema: 'public', table: 'trips' }, handler)
    .subscribe()

  return () => {
    subscription.unsubscribe()  // クリーンアップ
  }
}, [])
```

### パフォーマンスのベストプラクティス

#### 1. メモ化
```typescript
// ✅ 重い計算はメモ化
const totalExpense = useMemo(() => {
  return expenses.reduce((sum, exp) => sum + exp.amount, 0)
}, [expenses])

// ❌ 毎回再計算
const totalExpense = expenses.reduce((sum, exp) => sum + exp.amount, 0)
```

#### 2. 遅延ローディング
```typescript
// ✅ コード分割
const ReportPage = lazy(() => import('./pages/ReportPage'))

// Suspenseで囲む
<Suspense fallback={<Loading />}>
  <ReportPage />
</Suspense>
```

#### 3. 画像最適化
```typescript
// ✅ 適切なサイズと形式
<img
  src={optimizedUrl}
  loading="lazy"
  alt="Receipt"
  width={300}
  height={400}
/>
```

### セキュリティのベストプラクティス

#### 1. 入力バリデーション
```typescript
// ✅ 必ずバリデーション
const schema = z.object({
  name: z.string().min(1).max(100),
  budget: z.number().min(0),
  date: z.string().regex(/^\d{4}-\d{2}-\d{2}$/)
})

const result = schema.safeParse(input)
if (!result.success) {
  return { error: result.error }
}
```

#### 2. 環境変数
```typescript
// ✅ 環境変数で管理
const supabaseUrl = import.meta.env.VITE_SUPABASE_URL
const supabaseKey = import.meta.env.VITE_SUPABASE_ANON_KEY

// ❌ ハードコード
const supabaseUrl = "https://xxx.supabase.co"  // 絶対にしない
```

#### 3. XSS対策
```typescript
// ✅ React は自動的にエスケープ
<p>{userInput}</p>

// ❌ dangerouslySetInnerHTML は避ける
<p dangerouslySetInnerHTML={{__html: userInput}} />  // XSSリスク
```

### テストのベストプラクティス

#### 1. テストの構成
```typescript
describe('TripCard', () => {
  it('should display trip name', () => {
    render(<TripCard trip={mockTrip} />)
    expect(screen.getByText('パリ旅行')).toBeInTheDocument()
  })

  it('should display budget if provided', () => {
    render(<TripCard trip={mockTripWithBudget} />)
    expect(screen.getByText('¥100,000')).toBeInTheDocument()
  })
})
```

#### 2. モックの使用
```typescript
// ✅ Supabaseをモック
vi.mock('@supabase/supabase-js', () => ({
  createClient: () => ({
    from: () => ({
      select: () => ({ data: mockData, error: null })
    })
  })
}))
```

---

## ⚠️ よくあるエラーと対処法

### 1. ビルドエラー

**エラー**: `Module not found`
```bash
# 対処法
npm install  # 依存関係を再インストール
```

**エラー**: TypeScript型エラー
```bash
# 対処法
1. Read で該当ファイルの型定義を確認
2. Grep で型の使用箇所を検索
3. Edit で型定義を修正
```

### 2. Supabaseエラー

**エラー**: `Row level security policy violation`
```sql
-- 対処法: RLSポリシーを確認・修正
-- Supabase Studio > Authentication > Policies
```

**エラー**: `relation does not exist`
```bash
# 対処法: マイグレーションを実行
supabase db push
```

### 3. OCRエラー

**エラー**: OCRが正しく動作しない
```typescript
// 対処法
1. 画像の前処理を追加（グレースケール化、コントラスト調整）
2. Tesseract.js の言語設定を確認
3. 画像サイズを最適化
```

---

## 📚 参照リソース

### プロジェクトドキュメント
- [PRD.md](./PRD.md) - 製品要件定義書
- [TASK_PLAN.md](./TASK_PLAN.md) - 開発タスクプラン
- [README.md](./README.md) - プロジェクト概要

### 技術ドキュメント
- [React Documentation](https://react.dev/)
- [TypeScript Handbook](https://www.typescriptlang.org/docs/)
- [Tailwind CSS](https://tailwindcss.com/docs)
- [Supabase Documentation](https://supabase.com/docs)
- [shadcn/ui](https://ui.shadcn.com/)
- [Tesseract.js](https://tesseract.projectnaptha.com/)

### ツール
- [Conventional Commits](https://www.conventionalcommits.org/)
- [Supabase Studio](https://supabase.com/dashboard)

---

## 🎓 まとめ

### 開発を始める前に
1. ✅ PRD.md を読む
2. ✅ TASK_PLAN.md で現在のタスクを確認
3. ✅ Task (Explore) で既存コードを理解

### 開発中
1. ✅ 段階的に実装
2. ✅ 適切なツールを選択
3. ✅ 動作確認を頻繁に行う
4. ✅ 意味のある単位でコミット

### 開発後
1. ✅ TASK_PLAN.md のチェックボックスを更新
2. ✅ コミット＆プッシュ
3. ✅ 次のタスクに進む

---

**バージョン**: 1.0
**最終更新日**: 2025-12-21
**作成者**: Claude Code

