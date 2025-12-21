import { useState } from 'react'
import { Link } from 'react-router-dom'
import { AuthLayout } from '../components/AuthLayout'
import { Input } from '../components/Input'
import { Button } from '../components/Button'

export function Login() {
  const [email, setEmail] = useState('')
  const [password, setPassword] = useState('')
  const [isLoading, setIsLoading] = useState(false)
  const [error, setError] = useState('')

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault()
    setError('')
    setIsLoading(true)

    // TODO: Implement Supabase authentication
    console.log('Login:', { email, password })

    // Simulate API call
    setTimeout(() => {
      setIsLoading(false)
    }, 1000)
  }

  return (
    <AuthLayout
      title="Travel Expense Tracker"
      subtitle="旅行の支出を簡単に管理"
    >
      <form onSubmit={handleSubmit} className="space-y-5">
        {error && (
          <div className="p-3 bg-primary-light/30 border border-primary rounded-lg">
            <p className="text-sm text-primary">{error}</p>
          </div>
        )}

        <Input
          type="email"
          label="メールアドレス"
          placeholder="your@email.com"
          value={email}
          onChange={(e) => setEmail(e.target.value)}
          required
          autoComplete="email"
        />

        <Input
          type="password"
          label="パスワード"
          placeholder="••••••••"
          value={password}
          onChange={(e) => setPassword(e.target.value)}
          required
          autoComplete="current-password"
        />

        <div className="flex items-center justify-between text-sm">
          <label className="flex items-center gap-2 cursor-pointer">
            <input
              type="checkbox"
              className="w-4 h-4 rounded border-gray-300 text-primary focus:ring-primary"
            />
            <span className="text-neutral-dark">ログイン状態を保持</span>
          </label>

          <Link
            to="/forgot-password"
            className="text-primary hover:text-primary-dark font-medium"
          >
            パスワードを忘れた
          </Link>
        </div>

        <Button type="submit" isLoading={isLoading}>
          ログイン
        </Button>

        <div className="relative my-6">
          <div className="absolute inset-0 flex items-center">
            <div className="w-full border-t border-gray-300"></div>
          </div>
          <div className="relative flex justify-center text-sm">
            <span className="px-4 bg-white text-neutral">または</span>
          </div>
        </div>

        <div className="text-center">
          <p className="text-neutral-dark text-sm">
            アカウントをお持ちでないですか？{' '}
            <Link
              to="/signup"
              className="text-primary hover:text-primary-dark font-medium"
            >
              新規登録
            </Link>
          </p>
        </div>
      </form>
    </AuthLayout>
  )
}
