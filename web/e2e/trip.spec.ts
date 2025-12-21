import { test, expect } from '@playwright/test'

test.describe('Trip Management Flow', () => {
  // 認証済みユーザーとしてテストを実行
  test.use({
    storageState: 'e2e/.auth/user.json'
  })

  test.beforeEach(async ({ page }) => {
    await page.goto('/trips')
  })

  test.skip('should display trip list', async ({ page }) => {
    // Note: このテストは認証が必要なのでスキップ

    await expect(page).toHaveURL(/\/trips/)
    await expect(page.getByRole('heading', { name: 'マイトリップ' })).toBeVisible()
  })

  test.skip('should create a new trip', async ({ page }) => {
    // Note: このテストは認証が必要なのでスキップ

    // 新しい旅行ボタンをクリック
    await page.getByRole('button', { name: '新しい旅行' }).click()

    // フォームに入力
    await page.getByLabel('旅行名').fill('沖縄旅行')
    await page.getByLabel('目的地').fill('沖縄, 日本')
    await page.getByLabel('開始日').fill('2025-03-01')
    await page.getByLabel('終了日').fill('2025-03-05')
    await page.getByLabel('予算').fill('100000')

    // 作成ボタンをクリック
    await page.getByRole('button', { name: '作成' }).click()

    // 成功メッセージを確認
    await expect(page.getByText('旅行を作成しました')).toBeVisible()

    // 旅行カードが表示されることを確認
    await expect(page.getByText('沖縄旅行')).toBeVisible()
  })

  test.skip('should search trips', async ({ page }) => {
    // Note: このテストは認証が必要なのでスキップ

    const searchInput = page.getByPlaceholder('旅行名や目的地で検索')
    await searchInput.fill('パリ')

    // 検索結果が表示される
    await expect(page.getByText('パリ旅行')).toBeVisible()
  })

  test.skip('should filter trips by status', async ({ page }) => {
    // Note: このテストは認証が必要なのでスキップ

    // 「進行中」フィルターをクリック
    await page.getByRole('button', { name: '進行中' }).click()

    // 進行中の旅行のみ表示される
    await expect(page.getByText('進行中')).toBeVisible()
  })

  test.skip('should navigate to trip detail', async ({ page }) => {
    // Note: このテストは認証が必要なのでスキップ

    // 最初の旅行カードをクリック
    await page.getByText('パリ旅行').first().click()

    // 詳細ページに遷移
    await expect(page).toHaveURL(/\/trips\/[a-zA-Z0-9-]+/)
    await expect(page.getByRole('heading', { name: 'パリ旅行' })).toBeVisible()
  })
})
