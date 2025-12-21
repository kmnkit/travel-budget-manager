# Supabase セットアップガイド

このドキュメントでは、Travel Expense Tracker アプリケーションで使用する Supabase プロジェクトのセットアップ手順を説明します。

## 📋 前提条件

- Supabase アカウント（未作成の場合は [https://supabase.com](https://supabase.com) で作成）
- メールアドレスの確認完了

## 🚀 セットアップ手順

### 1. Supabase プロジェクトの作成

1. [Supabase Dashboard](https://app.supabase.com) にログイン
2. 「New Project」をクリック
3. プロジェクト情報を入力:
   - **Name**: `travel-expense-tracker` (または任意の名前)
   - **Database Password**: 強力なパスワードを生成・保存
   - **Region**: `Northeast Asia (Tokyo)` (日本からのアクセスが多い場合)
   - **Pricing Plan**: `Free` (MVPフェーズ)
4. 「Create new project」をクリック

### 2. API キーの取得

プロジェクト作成後（約2分）:

1. 左サイドバーの「Project Settings」→「API」に移動
2. 以下の情報をコピー:
   - **Project URL**: `https://xxxxxxxxxxxxx.supabase.co`
   - **anon public**: `eyJhbGc...` (公開キー)
   - **service_role**: `eyJhbGc...` (サービスキー、サーバー側のみで使用)

### 3. 環境変数の設定

1. プロジェクトルートに `.env` ファイルを作成:
   ```bash
   cp .env.example .env
   ```

2. `.env` ファイルを編集し、取得した値を設定:
   ```env
   VITE_SUPABASE_URL=https://xxxxxxxxxxxxx.supabase.co
   VITE_SUPABASE_ANON_KEY=eyJhbGc...
   ```

3. `.env` ファイルが `.gitignore` に含まれていることを確認

### 4. データベーススキーマの作成

データベーススキーマは Phase 1 で SQL マイグレーションファイルを使用して作成します。

スキーマには以下のテーブルが含まれます:
- `users` - ユーザー情報
- `trips` - 旅行情報
- `expenses` - 支出記録
- `categories` - カテゴリー
- `tags` - タグ
- `expense_tags` - 支出とタグの関連
- `expense_images` - レシート画像
- `category_budgets` - カテゴリー別予算

### 5. Row Level Security (RLS) の設定

Phase 1 でデータベーススキーマ作成時に、各テーブルに適切な RLS ポリシーを設定します。

基本方針:
- ユーザーは自分のデータのみアクセス可能
- 認証されていないユーザーはデータにアクセス不可
- `user_id` カラムを使用してデータを分離

### 6. Storage バケットの作成

レシート画像を保存するためのストレージバケットを作成します (Phase 1 で実施):

1. Supabase Dashboard の「Storage」セクションに移動
2. 「Create bucket」をクリック
3. Bucket 設定:
   - **Name**: `receipt-images`
   - **Public bucket**: オフ (認証されたユーザーのみアクセス)
4. RLS ポリシーを設定してユーザーが自分の画像のみアクセス可能にする

## ✅ 確認事項

セットアップ完了後、以下を確認:

- [ ] Supabase プロジェクトが作成済み
- [ ] Project URL と anon key を取得済み
- [ ] `.env` ファイルに環境変数を設定済み
- [ ] `.env` が `.gitignore` に含まれている

## 🔗 参考リンク

- [Supabase 公式ドキュメント](https://supabase.com/docs)
- [Supabase JavaScript Client](https://supabase.com/docs/reference/javascript/introduction)
- [Row Level Security](https://supabase.com/docs/guides/auth/row-level-security)

## ⚠️ 注意事項

- **service_role key は絶対に公開しないこと** (サーバーサイドのみで使用)
- **anon key は公開されても安全** (RLS で保護されている)
- 本番環境では環境変数を適切に管理すること (Vercel, Netlify など)
