import { useState, useEffect } from 'react'
import { useParams, useNavigate } from 'react-router-dom'
import { Layout } from '../components/Layout'
import { Input } from '../components/Input'
import { Button } from '../components/Button'
import { ReceiptScanner } from '../components/ReceiptScanner'
import { useAuth } from '../contexts/AuthContext'
import { supabase } from '../lib/supabase'
import { OCRResult } from '../lib/ocr'
import toast from 'react-hot-toast'

interface Category {
  id: string
  name: string
  icon: string | null
  color: string | null
  is_default: boolean
}

export function ExpenseForm() {
  const { tripId, expenseId } = useParams<{ tripId: string; expenseId?: string }>()
  const navigate = useNavigate()
  const { user } = useAuth()
  const [isLoading, setIsLoading] = useState(false)
  const [categories, setCategories] = useState<Category[]>([])
  const [tripCurrency, setTripCurrency] = useState('JPY')
  const [showScanner, setShowScanner] = useState(false)
  const isEditMode = !!expenseId

  const [formData, setFormData] = useState({
    amount: '',
    currency: 'JPY',
    category_id: '',
    description: '',
    expense_date: new Date().toISOString().split('T')[0],
    location: '',
    payment_method: '',
    notes: ''
  })

  const [errors, setErrors] = useState<Record<string, string>>({})

  useEffect(() => {
    if (tripId && user) {
      fetchTripCurrency()
      fetchCategories()
      if (isEditMode && expenseId) {
        fetchExpenseData()
      }
    }
  }, [tripId, user, isEditMode, expenseId])

  const fetchTripCurrency = async () => {
    if (!tripId || !user) return

    try {
      const { data, error } = await supabase
        .from('trips')
        .select('currency')
        .eq('id', tripId)
        .eq('user_id', user.id)
        .single()

      if (error) {
        console.error('Error fetching trip:', error)
        return
      }

      setTripCurrency(data.currency)
      setFormData(prev => ({ ...prev, currency: data.currency }))
    } catch (error) {
      console.error('Error fetching trip currency:', error)
    }
  }

  const fetchCategories = async () => {
    if (!user) return

    try {
      const { data, error } = await supabase
        .from('categories')
        .select('*')
        .or(`is_default.eq.true,user_id.eq.${user.id}`)
        .order('is_default', { ascending: false })
        .order('name')

      if (error) {
        console.error('Error fetching categories:', error)
        return
      }

      setCategories(data || [])
    } catch (error) {
      console.error('Error fetching categories:', error)
    }
  }

  const fetchExpenseData = async () => {
    if (!expenseId || !user) return

    try {
      const { data, error } = await supabase
        .from('expenses')
        .select('*')
        .eq('id', expenseId)
        .eq('user_id', user.id)
        .single()

      if (error) {
        console.error('Error fetching expense:', error)
        toast.error('支出が見つかりません')
        navigate(`/trips/${tripId}`)
        return
      }

      // Pre-populate form with existing data
      setFormData({
        amount: data.amount.toString(),
        currency: data.currency,
        category_id: data.category_id || '',
        description: data.description || '',
        expense_date: data.expense_date,
        location: data.location || '',
        payment_method: data.payment_method || '',
        notes: data.notes || ''
      })
    } catch (error) {
      console.error('Error fetching expense:', error)
      toast.error('エラーが発生しました')
    }
  }

  const handleChange = (e: React.ChangeEvent<HTMLInputElement | HTMLTextAreaElement | HTMLSelectElement>) => {
    const { name, value } = e.target
    setFormData(prev => ({ ...prev, [name]: value }))

    if (errors[name]) {
      setErrors(prev => ({ ...prev, [name]: '' }))
    }
  }

  const validateForm = () => {
    const newErrors: Record<string, string> = {}

    if (!formData.amount || parseFloat(formData.amount) <= 0) {
      newErrors.amount = '金額を入力してください（0より大きい値）'
    }

    if (!formData.expense_date) {
      newErrors.expense_date = '日付を選択してください'
    }

    setErrors(newErrors)
    return Object.keys(newErrors).length === 0
  }

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault()

    if (!validateForm()) {
      return
    }

    if (!user || !tripId) {
      toast.error('ログインが必要です')
      navigate('/login')
      return
    }

    setIsLoading(true)

    try {
      const expenseData = {
        amount: parseFloat(formData.amount),
        currency: formData.currency,
        category_id: formData.category_id || null,
        description: formData.description.trim() || null,
        expense_date: formData.expense_date,
        location: formData.location.trim() || null,
        payment_method: formData.payment_method || null,
        notes: formData.notes.trim() || null
      }

      if (isEditMode && expenseId) {
        // Update existing expense
        const { error } = await supabase
          .from('expenses')
          .update(expenseData)
          .eq('id', expenseId)
          .eq('user_id', user.id)

        if (error) {
          console.error('Error updating expense:', error)
          toast.error('支出の更新に失敗しました')
          setIsLoading(false)
          return
        }

        toast.success('支出を更新しました！')
        navigate(`/trips/${tripId}/expenses/${expenseId}`)
      } else {
        // Create new expense
        const newExpenseData = {
          ...expenseData,
          trip_id: tripId,
          user_id: user.id
        }

        const { error } = await supabase
          .from('expenses')
          .insert([newExpenseData])

        if (error) {
          console.error('Error creating expense:', error)
          toast.error('支出の記録に失敗しました')
          setIsLoading(false)
          return
        }

        toast.success('支出を記録しました！')
        navigate(`/trips/${tripId}`)
      }
    } catch (error) {
      console.error('Error saving expense:', error)
      toast.error('エラーが発生しました')
      setIsLoading(false)
    }
  }

  const handleCancel = () => {
    if (isEditMode && expenseId) {
      navigate(`/trips/${tripId}/expenses/${expenseId}`)
    } else {
      navigate(`/trips/${tripId}`)
    }
  }

  const handleOCRResult = (result: OCRResult) => {
    // OCR結果をフォームに反映
    if (result.amount) {
      setFormData(prev => ({ ...prev, amount: result.amount!.toString() }))
    }

    if (result.date) {
      setFormData(prev => ({ ...prev, expense_date: result.date! }))
    }

    // OCRで読み取ったテキストをメモに追加（オプション）
    if (result.text && result.confidence > 70) {
      const extractedInfo = `[OCR読み取り結果]\n${result.text.slice(0, 200)}`
      setFormData(prev => ({
        ...prev,
        notes: prev.notes ? `${prev.notes}\n\n${extractedInfo}` : extractedInfo
      }))
    }

    toast.success(
      result.amount
        ? `金額 ${result.amount} を検出しました`
        : 'レシートを読み取りました（金額は手動で入力してください）'
    )
  }

  return (
    <Layout>
      <div className="max-w-2xl mx-auto">
        {/* Header */}
        <div className="mb-8">
          <h1 className="text-3xl font-bold text-neutral-dark mb-2">
            {isEditMode ? '支出を編集' : '支出を記録'}
          </h1>
          <p className="text-neutral">
            {isEditMode ? '支出の詳細を更新してください' : '支出の詳細を入力してください'}
          </p>
        </div>

        {/* OCR Scanner Button */}
        {!isEditMode && (
          <div className="mb-6">
            <Button
              type="button"
              variant="outline"
              onClick={() => setShowScanner(true)}
              className="w-full flex items-center justify-center gap-2 py-4 border-2 border-dashed border-primary/30 hover:border-primary/50 hover:bg-primary/5"
            >
              <svg className="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M3 9a2 2 0 012-2h.93a2 2 0 001.664-.89l.812-1.22A2 2 0 0110.07 4h3.86a2 2 0 011.664.89l.812 1.22A2 2 0 0018.07 7H19a2 2 0 012 2v9a2 2 0 01-2 2H5a2 2 0 01-2-2V9z" />
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M15 13a3 3 0 11-6 0 3 3 0 016 0z" />
              </svg>
              <span className="font-semibold">レシートをスキャン</span>
            </Button>
            <p className="text-sm text-neutral text-center mt-2">
              カメラで撮影またはギャラリーから選択
            </p>
          </div>
        )}

        {/* Form */}
        <form onSubmit={handleSubmit} className="bg-white rounded-xl shadow-md p-8 space-y-6">
          {/* Amount and Currency */}
          <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
            <Input
              type="number"
              name="amount"
              label="金額"
              placeholder="1000"
              value={formData.amount}
              onChange={handleChange}
              error={errors.amount}
              required
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

          {/* Category */}
          <div>
            <label className="block text-sm font-medium text-neutral-dark mb-2">
              カテゴリー（オプション）
            </label>
            <select
              name="category_id"
              value={formData.category_id}
              onChange={handleChange}
              className="w-full px-4 py-3 rounded-lg border border-gray-300 focus:outline-none focus:ring-2 focus:ring-primary/50 transition-all duration-200"
            >
              <option value="">カテゴリーなし</option>
              {categories.map((category) => (
                <option key={category.id} value={category.id}>
                  {category.icon} {category.name}
                </option>
              ))}
            </select>
          </div>

          {/* Description */}
          <Input
            type="text"
            name="description"
            label="説明（オプション）"
            placeholder="例: ランチ"
            value={formData.description}
            onChange={handleChange}
          />

          {/* Date and Location */}
          <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
            <Input
              type="date"
              name="expense_date"
              label="日付"
              value={formData.expense_date}
              onChange={handleChange}
              error={errors.expense_date}
              required
            />

            <Input
              type="text"
              name="location"
              label="場所（オプション）"
              placeholder="例: エッフェル塔近くのカフェ"
              value={formData.location}
              onChange={handleChange}
            />
          </div>

          {/* Payment Method */}
          <div>
            <label className="block text-sm font-medium text-neutral-dark mb-2">
              支払い方法（オプション）
            </label>
            <select
              name="payment_method"
              value={formData.payment_method}
              onChange={handleChange}
              className="w-full px-4 py-3 rounded-lg border border-gray-300 focus:outline-none focus:ring-2 focus:ring-primary/50 transition-all duration-200"
            >
              <option value="">選択してください</option>
              <option value="cash">現金</option>
              <option value="credit_card">クレジットカード</option>
              <option value="debit_card">デビットカード</option>
              <option value="mobile_payment">モバイル決済</option>
              <option value="other">その他</option>
            </select>
          </div>

          {/* Notes */}
          <div>
            <label className="block text-sm font-medium text-neutral-dark mb-2">
              メモ（オプション）
            </label>
            <textarea
              name="notes"
              value={formData.notes}
              onChange={handleChange}
              placeholder="追加情報があれば..."
              rows={3}
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
              {isEditMode ? '更新' : '記録'}
            </Button>
          </div>
        </form>

        {/* Receipt Scanner Modal */}
        {showScanner && (
          <ReceiptScanner
            onScanComplete={handleOCRResult}
            onClose={() => setShowScanner(false)}
          />
        )}
      </div>
    </Layout>
  )
}
