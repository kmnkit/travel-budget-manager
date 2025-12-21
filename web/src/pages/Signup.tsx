import { useState } from 'react'
import { Link } from 'react-router-dom'
import { AuthLayout } from '../components/AuthLayout'
import { Input } from '../components/Input'
import { Button } from '../components/Button'

export function Signup() {
  const [formData, setFormData] = useState({
    displayName: '',
    email: '',
    password: '',
    confirmPassword: ''
  })
  const [isLoading, setIsLoading] = useState(false)
  const [errors, setErrors] = useState<Record<string, string>>({})

  const handleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const { name, value } = e.target
    setFormData(prev => ({ ...prev, [name]: value }))
    // Clear error when user starts typing
    if (errors[name]) {
      setErrors(prev => ({ ...prev, [name]: '' }))
    }
  }

  const validateForm = () => {
    const newErrors: Record<string, string> = {}

    if (!formData.displayName.trim()) {
      newErrors.displayName = '表示名を入力してください'
    }

    if (!formData.email.trim()) {
      newErrors.email = 'メールアドレスを入力してください'
    } else if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(formData.email)) {
      newErrors.email = '有効なメールアドレスを入力してください'
    }

    if (!formData.password) {
      newErrors.password = 'パスワードを入力してください'
    } else if (formData.password.length < 6) {
      newErrors.password = 'パスワードは6文字以上である必要があります'
    }

    if (formData.password !== formData.confirmPassword) {
      newErrors.confirmPassword = 'パスワードが一致しません'
    }

    setErrors(newErrors)
    return Object.keys(newErrors).length === 0
  }

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault()

    if (!validateForm()) {
      return
    }

    setIsLoading(true)

    // TODO: Implement Supabase authentication
    console.log('Signup:', formData)

    // Simulate API call
    setTimeout(() => {
      setIsLoading(false)
    }, 1000)
  }

  return (
    <AuthLayout
      title="アカウント作成"
      subtitle="旅行の支出管理を始めましょう"
    >
      <form onSubmit={handleSubmit} className="space-y-5">
        <Input
          type="text"
          name="displayName"
          label="表示名"
          placeholder="山田 太郎"
          value={formData.displayName}
          onChange={handleChange}
          error={errors.displayName}
          required
          autoComplete="name"
        />

        <Input
          type="email"
          name="email"
          label="メールアドレス"
          placeholder="your@email.com"
          value={formData.email}
          onChange={handleChange}
          error={errors.email}
          required
          autoComplete="email"
        />

        <Input
          type="password"
          name="password"
          label="パスワード"
          placeholder="••••••••"
          value={formData.password}
          onChange={handleChange}
          error={errors.password}
          required
          autoComplete="new-password"
        />

        <Input
          type="password"
          name="confirmPassword"
          label="パスワード（確認）"
          placeholder="••••••••"
          value={formData.confirmPassword}
          onChange={handleChange}
          error={errors.confirmPassword}
          required
          autoComplete="new-password"
        />

        <div className="pt-2">
          <label className="flex items-start gap-2 cursor-pointer">
            <input
              type="checkbox"
              required
              className="w-4 h-4 mt-1 rounded border-gray-300 text-primary focus:ring-primary"
            />
            <span className="text-sm text-neutral-dark">
              <Link to="/terms" className="text-primary hover:text-primary-dark">
                利用規約
              </Link>
              および
              <Link to="/privacy" className="text-primary hover:text-primary-dark">
                プライバシーポリシー
              </Link>
              に同意します
            </span>
          </label>
        </div>

        <Button type="submit" isLoading={isLoading}>
          アカウントを作成
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
            既にアカウントをお持ちですか？{' '}
            <Link
              to="/login"
              className="text-primary hover:text-primary-dark font-medium"
            >
              ログイン
            </Link>
          </p>
        </div>
      </form>
    </AuthLayout>
  )
}
