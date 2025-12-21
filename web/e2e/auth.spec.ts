import { test, expect } from '@playwright/test'

test.describe('Authentication Flow', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto('/')
  })

  test('should display login page', async ({ page }) => {
    await expect(page).toHaveTitle(/Travel Expense Tracker/)
    await expect(page.getByRole('heading', { name: 'ログイン' })).toBeVisible()
  })

  test('should show validation errors for empty login', async ({ page }) => {
    const submitButton = page.getByRole('button', { name: 'ログイン' })
    await submitButton.click()

    // バリデーションエラーが表示されることを確認
    await expect(page.getByText(/メールアドレス/)).toBeVisible()
  })

  test('should navigate to signup page', async ({ page }) => {
    const signupLink = page.getByRole('link', { name: /アカウント作成/ })
    await signupLink.click()

    await expect(page).toHaveURL(/\/signup/)
    await expect(page.getByRole('heading', { name: 'サインアップ' })).toBeVisible()
  })

  test.skip('should login with valid credentials', async ({ page }) => {
    // Note: このテストは実際のSupabase接続が必要なのでスキップ
    // CI/CDでは環境変数を設定して実行可能

    await page.getByLabel('メールアドレス').fill('test@example.com')
    await page.getByLabel('パスワード').fill('password123')
    await page.getByRole('button', { name: 'ログイン' }).click()

    // ログイン成功後、ダッシュボードに遷移
    await expect(page).toHaveURL(/\/trips/)
    await expect(page.getByRole('heading', { name: 'マイトリップ' })).toBeVisible()
  })

  test.skip('should signup with valid information', async ({ page }) => {
    // Note: このテストは実際のSupabase接続が必要なのでスキップ

    await page.goto('/signup')

    await page.getByLabel('メールアドレス').fill('newuser@example.com')
    await page.getByLabel('パスワード').fill('password123')
    await page.getByRole('button', { name: 'アカウント作成' }).click()

    // サインアップ成功後、ダッシュボードに遷移
    await expect(page).toHaveURL(/\/trips/)
  })
})
