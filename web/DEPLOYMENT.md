# Travel Expense Tracker - デプロイガイド

## 📋 前提条件

- **Node.js**: 18.x 以降
- **npm**: 9.x 以降
- **Supabase アカウント**: プロジェクト作成済み
- **Vercel アカウント**: （推奨）または Netlify

---

## 🚀 Vercel へのデプロイ

### 1. Vercel CLI インストール

```bash
npm install -g vercel
```

### 2. プロジェクトをリンク

```bash
cd web
vercel link
```

### 3. 環境変数を設定

Vercel ダッシュボードまたは CLI で環境変数を設定：

```bash
vercel env add VITE_SUPABASE_URL
# 値: https://qooygycznuptnlzxjfemg.supabase.co

vercel env add VITE_SUPABASE_ANON_KEY
# 値: your_supabase_anon_key
```

または、Vercel ダッシュボードで設定：
1. プロジェクトを選択
2. **Settings** > **Environment Variables**
3. 以下の変数を追加：
   - `VITE_SUPABASE_URL`
   - `VITE_SUPABASE_ANON_KEY`

### 4. デプロイ

```bash
# プレビューデプロイ
vercel

# 本番デプロイ
vercel --prod
```

### 5. カスタムドメイン設定（オプション）

Vercel ダッシュボード:
1. プロジェクトを選択
2. **Settings** > **Domains**
3. カスタムドメインを追加
4. DNS レコードを設定

---

## 🌐 Netlify へのデプロイ

### 1. Netlify CLI インストール

```bash
npm install -g netlify-cli
```

### 2. ログイン

```bash
netlify login
```

### 3. サイトを初期化

```bash
cd web
netlify init
```

### 4. ビルド設定

```bash
# Build command
npm run build

# Publish directory
dist

# Functions directory
(空欄)
```

### 5. 環境変数を設定

Netlify ダッシュボード:
1. **Site settings** > **Build & deploy** > **Environment**
2. 以下の変数を追加：
   - `VITE_SUPABASE_URL`
   - `VITE_SUPABASE_ANON_KEY`

### 6. デプロイ

```bash
# プレビューデプロイ
netlify deploy

# 本番デプロイ
netlify deploy --prod
```

---

## 🔧 その他のホスティングサービス

### Railway

```bash
# Railway CLI をインストール
npm install -g @railway/cli

# ログイン
railway login

# デプロイ
railway up
```

**環境変数**: Railway ダッシュボードで設定

### Render

1. [Render](https://render.com/) にアクセス
2. **New** > **Static Site**
3. GitHub リポジトリを接続
4. ビルド設定：
   - **Build Command**: `npm run build`
   - **Publish Directory**: `dist`
5. 環境変数を追加

---

## 📦 ビルド最適化

### 1. 依存関係の最適化

```bash
# 不要な依存関係を削除
npm prune --production
```

### 2. ビルドサイズの確認

```bash
npm run build

# ビルドサイズを分析
npx vite-bundle-visualizer
```

### 3. パフォーマンステスト

```bash
# Lighthouse でテスト
npx lighthouse https://your-app.vercel.app --view
```

---

## 🔒 セキュリティチェックリスト

- [ ] 環境変数が`.env`ファイルに保存されている（Git にコミットしない）
- [ ] Supabase RLS ポリシーが正しく設定されている
- [ ] CORS 設定が適切
- [ ] SSL/TLS が有効（HTTPSのみ）
- [ ] API キーが環境変数として管理されている

---

## 🐛 トラブルシューティング

### ビルドエラー: "Module not found"

```bash
# node_modules を削除して再インストール
rm -rf node_modules package-lock.json
npm install
npm run build
```

### Supabase 接続エラー

1. 環境変数が正しく設定されているか確認
2. Supabase URL が正しいか確認
3. Supabase Anon Key が正しいか確認
4. ブラウザの開発者ツールでネットワークエラーを確認

### 404 エラー（リロード時）

Vercel/Netlify で SPA のルーティングが正しく設定されているか確認：
- **Vercel**: `vercel.json` の `rewrites` 設定
- **Netlify**: `_redirects` ファイル

```
/*    /index.html   200
```

---

## 📊 デプロイ後のチェック

### 1. 機能テスト

- [ ] ログイン/サインアップ
- [ ] 旅行作成・編集・削除
- [ ] 支出記録
- [ ] レポート表示
- [ ] 検索・フィルター

### 2. パフォーマンステスト

```bash
# Lighthouse スコア
- Performance: 90+
- Accessibility: 90+
- Best Practices: 90+
- SEO: 90+
```

### 3. モバイル対応確認

- iOS Safari
- Android Chrome
- レスポンシブデザイン

---

## 🔄 継続的デプロイ（CI/CD）

### GitHub Actions

`.github/workflows/deploy.yml`:

```yaml
name: Deploy to Vercel

on:
  push:
    branches: [main]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-node@v3
        with:
          node-version: '18'
      - run: npm install
      - run: npm run build
      - run: npm run test:run
      - uses: amondnet/vercel-action@v25
        with:
          vercel-token: ${{ secrets.VERCEL_TOKEN }}
          vercel-org-id: ${{ secrets.VERCEL_ORG_ID }}
          vercel-project-id: ${{ secrets.VERCEL_PROJECT_ID }}
          vercel-args: '--prod'
```

---

## 📈 監視・分析

### Vercel Analytics

Vercel ダッシュボード:
1. **Analytics** タブ
2. トラフィック、パフォーマンス、エラーを監視

### Sentry (エラートラッキング)

```bash
npm install @sentry/react @sentry/vite-plugin
```

---

## 📝 デプロイチェックリスト

- [ ] 環境変数が設定されている
- [ ] ビルドが成功する
- [ ] テストが全てパスする
- [ ] Supabase RLS が有効
- [ ] HTTPS が有効
- [ ] カスタムドメインが設定されている（オプション）
- [ ] 監視ツールが設定されている（オプション）
- [ ] バックアップ戦略がある

---

**最終更新日**: 2025-12-21
**作成者**: Claude Code
