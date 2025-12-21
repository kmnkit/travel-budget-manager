import { useState } from 'react'
import { useNavigate } from 'react-router-dom'
import { Layout } from '../components/Layout'
import { Input } from '../components/Input'
import { Button } from '../components/Button'
import { useAuth } from '../contexts/AuthContext'
import { supabase } from '../lib/supabase'
import toast from 'react-hot-toast'

export function TripForm() {
  const navigate = useNavigate()
  const { user } = useAuth()
  const [isLoading, setIsLoading] = useState(false)

  const [formData, setFormData] = useState({
    name: '',
    destination: '',
    start_date: '',
    end_date: '',
    budget: '',
    currency: 'JPY',
    description: ''
  })

  const [errors, setErrors] = useState<Record<string, string>>({})

  const handleChange = (e: React.ChangeEvent<HTMLInputElement | HTMLTextAreaElement | HTMLSelectElement>) => {
    const { name, value } = e.target
    setFormData(prev => ({ ...prev, [name]: value }))

    // Clear error when user starts typing
    if (errors[name]) {
      setErrors(prev => ({ ...prev, [name]: '' }))
    }
  }

  const validateForm = () => {
    const newErrors: Record<string, string> = {}

    if (!formData.name.trim()) {
      newErrors.name = '旅行名を入力してください'
    }

    if (!formData.start_date) {
      newErrors.start_date = '開始日を選択してください'
    }

    if (formData.end_date && formData.start_date) {
      const start = new Date(formData.start_date)
      const end = new Date(formData.end_date)
      if (end < start) {
        newErrors.end_date = '終了日は開始日以降である必要があります'
      }
    }

    if (formData.budget && parseFloat(formData.budget) < 0) {
      newErrors.budget = '予算は0以上である必要があります'
    }

    setErrors(newErrors)
    return Object.keys(newErrors).length === 0
  }

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault()

    if (!validateForm()) {
      return
    }

    if (!user) {
      toast.error('ログインが必要です')
      navigate('/login')
      return
    }

    setIsLoading(true)

    try {
      const tripData = {
        user_id: user.id,
        name: formData.name.trim(),
        destination: formData.destination.trim() || null,
        start_date: formData.start_date,
        end_date: formData.end_date || null,
        budget: formData.budget ? parseFloat(formData.budget) : null,
        currency: formData.currency,
        description: formData.description.trim() || null
      }

      const { data, error } = await supabase
        .from('trips')
        .insert([tripData])
        .select()
        .single()

      if (error) {
        console.error('Error creating trip:', error)
        toast.error('旅行の作成に失敗しました')
        setIsLoading(false)
        return
      }

      toast.success('旅行を作成しました！')
      navigate(`/trips/${data.id}`)
    } catch (error) {
      console.error('Error creating trip:', error)
      toast.error('エラーが発生しました')
      setIsLoading(false)
    }
  }

  const handleCancel = () => {
    navigate('/trips')
  }

  return (
    <Layout>
      <div className="max-w-2xl mx-auto">
        {/* Header */}
        <div className="mb-8">
          <h1 className="text-3xl font-bold text-neutral-dark mb-2">
            新しい旅行を作成
          </h1>
          <p className="text-neutral">
            旅行の詳細を入力して、支出の記録を始めましょう
          </p>
        </div>

        {/* Form */}
        <form onSubmit={handleSubmit} className="bg-white rounded-xl shadow-md p-8 space-y-6">
          {/* Trip Name */}
          <Input
            type="text"
            name="name"
            label="旅行名"
            placeholder="例: パリ旅行"
            value={formData.name}
            onChange={handleChange}
            error={errors.name}
            required
          />

          {/* Destination */}
          <Input
            type="text"
            name="destination"
            label="目的地（オプション）"
            placeholder="例: パリ, フランス"
            value={formData.destination}
            onChange={handleChange}
            error={errors.destination}
          />

          {/* Dates */}
          <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
            <Input
              type="date"
              name="start_date"
              label="開始日"
              value={formData.start_date}
              onChange={handleChange}
              error={errors.start_date}
              required
            />

            <Input
              type="date"
              name="end_date"
              label="終了日（オプション）"
              value={formData.end_date}
              onChange={handleChange}
              error={errors.end_date}
            />
          </div>

          {/* Budget and Currency */}
          <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
            <Input
              type="number"
              name="budget"
              label="予算（オプション）"
              placeholder="100000"
              value={formData.budget}
              onChange={handleChange}
              error={errors.budget}
              min="0"
              step="0.01"
            />

            <div>
              <label className="block text-sm font-medium text-neutral-dark mb-2">
                通貨
              </label>
              <select
                name="currency"
                value={formData.currency}
                onChange={handleChange}
                className="w-full px-4 py-3 rounded-lg border border-gray-300 focus:outline-none focus:ring-2 focus:ring-primary/50 transition-all duration-200"
              >
                <option value="JPY">¥ 日本円 (JPY)</option>
                <option value="USD">$ 米ドル (USD)</option>
                <option value="EUR">€ ユーロ (EUR)</option>
                <option value="GBP">£ ポンド (GBP)</option>
                <option value="AUD">A$ 豪ドル (AUD)</option>
                <option value="CNY">¥ 人民元 (CNY)</option>
                <option value="KRW">₩ ウォン (KRW)</option>
                <option value="THB">฿ バーツ (THB)</option>
              </select>
            </div>
          </div>

          {/* Description */}
          <div>
            <label className="block text-sm font-medium text-neutral-dark mb-2">
              メモ（オプション）
            </label>
            <textarea
              name="description"
              value={formData.description}
              onChange={handleChange}
              placeholder="この旅行について..."
              rows={4}
              className="w-full px-4 py-3 rounded-lg border border-gray-300 focus:outline-none focus:ring-2 focus:ring-primary/50 transition-all duration-200 resize-none"
            />
          </div>

          {/* Actions */}
          <div className="flex gap-4 pt-4">
            <Button
              type="button"
              variant="outline"
              onClick={handleCancel}
              className="flex-1"
            >
              キャンセル
            </Button>
            <Button
              type="submit"
              isLoading={isLoading}
              className="flex-1"
            >
              作成
            </Button>
          </div>
        </form>
      </div>
    </Layout>
  )
}
