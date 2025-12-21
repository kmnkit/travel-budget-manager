# Supabase Database Setup

このディレクトリには、Travel Expense Tracker アプリケーションのデータベーススキーマとマイグレーションファイルが含まれています。

## 📁 ディレクトリ構成

```
supabase/
├── migrations/
│   ├── 20250101000001_initial_schema.sql      # 初期スキーマ（テーブル作成）
│   ├── 20250101000002_rls_policies.sql        # Row Level Security ポリシー
│   └── 20250101000003_functions_and_triggers.sql  # データベース関数とトリガー
└── README.md
```

## 🚀 セットアップ方法

### 方法1: Supabase Dashboard を使用

1. [Supabase Dashboard](https://app.supabase.com) にログイン
2. プロジェクトを選択
3. 左サイドバーから「SQL Editor」を選択
4. 以下の順序でSQLファイルを実行:
   - `20250101000001_initial_schema.sql`
   - `20250101000002_rls_policies.sql`
   - `20250101000003_functions_and_triggers.sql`

### 方法2: Supabase CLI を使用（推奨）

#### 1. Supabase CLI のインストール

```bash
npm install -g supabase
```

#### 2. Supabase プロジェクトにリンク

```bash
# プロジェクトルートで実行
supabase link --project-ref <your-project-ref>
```

Project Reference は Supabase Dashboard の Project Settings → General で確認できます。

#### 3. マイグレーションの適用

```bash
# すべてのマイグレーションを適用
supabase db push

# または、個別のマイグレーションを適用
supabase db push --include-all
```

#### 4. マイグレーションの確認

```bash
# リモートデータベースの状態を確認
supabase db remote commit

# ローカルとリモートの差分を確認
supabase db diff
```

### 方法3: psql を使用

```bash
# 環境変数を設定
export DATABASE_URL="postgresql://postgres:[password]@db.[project-ref].supabase.co:5432/postgres"

# マイグレーションを実行
psql $DATABASE_URL < supabase/migrations/20250101000001_initial_schema.sql
psql $DATABASE_URL < supabase/migrations/20250101000002_rls_policies.sql
psql $DATABASE_URL < supabase/migrations/20250101000003_functions_and_triggers.sql
```

## 📊 データベーススキーマ概要

### テーブル一覧

1. **users** - ユーザー情報
2. **trips** - 旅行情報
3. **expenses** - 支出記録
4. **categories** - カテゴリー（デフォルト + カスタム）
5. **tags** - タグ
6. **expense_tags** - 支出とタグの関連（多対多）
7. **expense_images** - レシート画像
8. **category_budgets** - カテゴリー別予算

### 主要な関数

- `handle_new_user()` - 新規ユーザー登録時に自動的にプロフィールを作成
- `calculate_trip_total_expenses(trip_uuid)` - 旅行の総支出を計算
- `calculate_category_expenses(trip_uuid, category_uuid)` - カテゴリー別支出を計算
- `get_daily_expenses(trip_uuid)` - 日別支出を取得
- `get_category_breakdown(trip_uuid)` - カテゴリー別内訳を取得
- `calculate_budget_usage(trip_uuid)` - 予算使用状況を計算

### ビュー

- `trip_summary` - 旅行の概要情報（支出合計、残予算等）

## 🔒 Row Level Security (RLS)

すべてのテーブルに RLS が有効化されています。主なポリシー:

- ユーザーは自分のデータのみアクセス可能
- デフォルトカテゴリーは全ユーザーが閲覧可能
- 支出は、所有する旅行に紐づいているもののみアクセス可能

## 📦 ストレージバケット

以下のストレージバケットを手動で作成する必要があります:

### 1. receipt-images (プライベート)

レシート画像を保存するバケット。

**作成手順**:
1. Supabase Dashboard → Storage → Create bucket
2. Name: `receipt-images`
3. Public: オフ

**RLS ポリシー設定**:
```sql
-- ユーザーは自分の画像のみアップロード可能
CREATE POLICY "Users can upload their own receipt images"
ON storage.objects FOR INSERT
TO authenticated
WITH CHECK (
  bucket_id = 'receipt-images' AND
  auth.uid()::text = (storage.foldername(name))[1]
);

-- ユーザーは自分の画像のみ閲覧可能
CREATE POLICY "Users can view their own receipt images"
ON storage.objects FOR SELECT
TO authenticated
USING (
  bucket_id = 'receipt-images' AND
  auth.uid()::text = (storage.foldername(name))[1]
);

-- ユーザーは自分の画像のみ削除可能
CREATE POLICY "Users can delete their own receipt images"
ON storage.objects FOR DELETE
TO authenticated
USING (
  bucket_id = 'receipt-images' AND
  auth.uid()::text = (storage.foldername(name))[1]
);
```

### 2. profile-images (パブリック)

プロフィール画像を保存するバケット。

**作成手順**:
1. Supabase Dashboard → Storage → Create bucket
2. Name: `profile-images`
3. Public: オン

### 3. trip-covers (パブリック)

旅行カバー画像を保存するバケット。

**作成手順**:
1. Supabase Dashboard → Storage → Create bucket
2. Name: `trip-covers`
3. Public: オン

## 🧪 テスト

マイグレーション適用後、以下のクエリでデータベースの状態を確認できます:

```sql
-- すべてのテーブルを確認
SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'public'
ORDER BY table_name;

-- デフォルトカテゴリーを確認
SELECT * FROM categories WHERE is_default = TRUE;

-- RLS が有効化されているか確認
SELECT schemaname, tablename, rowsecurity
FROM pg_tables
WHERE schemaname = 'public';

-- 関数の一覧を確認
SELECT routine_name
FROM information_schema.routines
WHERE routine_schema = 'public'
ORDER BY routine_name;
```

## 🔄 マイグレーションの追加

新しいマイグレーションを追加する場合:

```bash
# 新しいマイグレーションファイルを作成
supabase migration new <migration_name>

# 例:
supabase migration new add_user_preferences
```

ファイル名は `YYYYMMDDHHMMSS_<migration_name>.sql` の形式で作成されます。

## 📚 参考リンク

- [Supabase Database Migrations](https://supabase.com/docs/guides/cli/local-development#database-migrations)
- [Row Level Security](https://supabase.com/docs/guides/auth/row-level-security)
- [Supabase Storage](https://supabase.com/docs/guides/storage)
- [PostgreSQL Documentation](https://www.postgresql.org/docs/)
