import { useState, useEffect } from 'react'
import { useParams, useNavigate, Link } from 'react-router-dom'
import { Layout } from '../components/Layout'
import { Button } from '../components/Button'
import { useAuth } from '../contexts/AuthContext'
import { supabase } from '../lib/supabase'
import toast from 'react-hot-toast'

interface Expense {
  id: string
  trip_id: string
  user_id: string
  amount: number
  currency: string
  category_id: string | null
  description: string | null
  expense_date: string
  location: string | null
  payment_method: string | null
  notes: string | null
  receipt_image_url: string | null
  created_at: string
  updated_at: string
}

interface Category {
  id: string
  name: string
  icon: string | null
  color: string | null
}

export function ExpenseDetail() {
  const { tripId, expenseId } = useParams<{ tripId: string; expenseId: string }>()
  const navigate = useNavigate()
  const { user } = useAuth()

  const [expense, setExpense] = useState<Expense | null>(null)
  const [category, setCategory] = useState<Category | null>(null)
  const [loading, setLoading] = useState(true)
  const [isDeleting, setIsDeleting] = useState(false)

  useEffect(() => {
    if (expenseId && user) {
      fetchExpenseData()
    }
  }, [expenseId, user])

  const fetchExpenseData = async () => {
    if (!expenseId || !user) return

    setLoading(true)

    try {
      // Fetch expense details
      const { data: expenseData, error: expenseError } = await supabase
        .from('expenses')
        .select('*')
        .eq('id', expenseId)
        .eq('user_id', user.id)
        .single()

      if (expenseError) {
        console.error('Error fetching expense:', expenseError)
        toast.error('支出が見つかりません')
        navigate(`/trips/${tripId}`)
        return
      }

      setExpense(expenseData)

      // Fetch category if exists
      if (expenseData.category_id) {
        const { data: categoryData, error: categoryError } = await supabase
          .from('categories')
          .select('*')
          .eq('id', expenseData.category_id)
          .single()

        if (!categoryError && categoryData) {
          setCategory(categoryData)
        }
      }
    } catch (error) {
      console.error('Error fetching expense data:', error)
      toast.error('エラーが発生しました')
    } finally {
      setLoading(false)
    }
  }

  const handleDelete = async () => {
    if (!expense || !user) return

    const confirmed = window.confirm('この支出を削除してもよろしいですか？')
    if (!confirmed) return

    setIsDeleting(true)

    try {
      const { error } = await supabase
        .from('expenses')
        .delete()
        .eq('id', expense.id)
        .eq('user_id', user.id)

      if (error) {
        console.error('Error deleting expense:', error)
        toast.error('支出の削除に失敗しました')
        setIsDeleting(false)
        return
      }

      toast.success('支出を削除しました')
      navigate(`/trips/${tripId}`)
    } catch (error) {
      console.error('Error deleting expense:', error)
      toast.error('エラーが発生しました')
      setIsDeleting(false)
    }
  }

  const formatPaymentMethod = (method: string | null) => {
    if (!method) return '未設定'
    const methods: Record<string, string> = {
      cash: '現金',
      credit_card: 'クレジットカード',
      debit_card: 'デビットカード',
      mobile_payment: 'モバイル決済',
      other: 'その他'
    }
    return methods[method] || method
  }

  if (loading) {
    return (
      <Layout>
        <div className="flex items-center justify-center py-16">
          <div className="w-16 h-16 border-4 border-primary border-t-transparent rounded-full animate-spin" />
        </div>
      </Layout>
    )
  }

  if (!expense) {
    return (
      <Layout>
        <div className="text-center py-16">
          <h2 className="text-2xl font-bold text-neutral-dark mb-4">支出が見つかりません</h2>
          <Link to={`/trips/${tripId}`} className="text-primary hover:underline">
            旅行詳細に戻る
          </Link>
        </div>
      </Layout>
    )
  }

  const expenseDate = new Date(expense.expense_date).toLocaleDateString('ja-JP', {
    year: 'numeric',
    month: 'long',
    day: 'numeric',
    weekday: 'short'
  })

  return (
    <Layout>
      <div className="max-w-3xl mx-auto">
        {/* Back Button */}
        <div className="mb-6">
          <button
            onClick={() => navigate(`/trips/${tripId}`)}
            className="flex items-center gap-2 text-neutral hover:text-neutral-dark transition-colors"
          >
            <span>←</span>
            <span>旅行詳細に戻る</span>
          </button>
        </div>

        {/* Main Card */}
        <div className="bg-white rounded-xl shadow-md overflow-hidden">
          {/* Header */}
          <div className="bg-gradient-to-r from-primary to-primary-dark p-6 text-white">
            <div className="flex justify-between items-start">
              <div className="flex-1">
                <h1 className="text-2xl font-bold mb-2">
                  {expense.description || '支出'}
                </h1>
                <p className="text-primary-light text-sm">
                  📅 {expenseDate}
                </p>
              </div>
              <div className="text-right">
                <p className="text-3xl font-bold">
                  {expense.currency} {expense.amount.toLocaleString()}
                </p>
              </div>
            </div>
          </div>

          {/* Details */}
          <div className="p-6 space-y-6">
            {/* Category */}
            {category && (
              <div>
                <h3 className="text-sm font-medium text-neutral mb-2">カテゴリー</h3>
                <div className="flex items-center gap-2">
                  <span className="text-2xl">{category.icon}</span>
                  <span className="text-lg text-neutral-dark">{category.name}</span>
                </div>
              </div>
            )}

            {/* Location */}
            {expense.location && (
              <div>
                <h3 className="text-sm font-medium text-neutral mb-2">場所</h3>
                <p className="text-neutral-dark flex items-center gap-2">
                  <span>📍</span>
                  <span>{expense.location}</span>
                </p>
              </div>
            )}

            {/* Payment Method */}
            <div>
              <h3 className="text-sm font-medium text-neutral mb-2">支払い方法</h3>
              <p className="text-neutral-dark">{formatPaymentMethod(expense.payment_method)}</p>
            </div>

            {/* Notes */}
            {expense.notes && (
              <div>
                <h3 className="text-sm font-medium text-neutral mb-2">メモ</h3>
                <p className="text-neutral-dark whitespace-pre-wrap">{expense.notes}</p>
              </div>
            )}

            {/* Receipt Image Placeholder */}
            {expense.receipt_image_url && (
              <div>
                <h3 className="text-sm font-medium text-neutral mb-2">レシート画像</h3>
                <img
                  src={expense.receipt_image_url}
                  alt="Receipt"
                  className="w-full max-w-md rounded-lg border border-gray-200"
                />
              </div>
            )}

            {/* Metadata */}
            <div className="pt-4 border-t border-gray-200">
              <p className="text-xs text-neutral">
                作成日時: {new Date(expense.created_at).toLocaleString('ja-JP')}
              </p>
              {expense.updated_at !== expense.created_at && (
                <p className="text-xs text-neutral mt-1">
                  更新日時: {new Date(expense.updated_at).toLocaleString('ja-JP')}
                </p>
              )}
            </div>
          </div>

          {/* Actions */}
          <div className="p-6 bg-neutral-light border-t border-gray-200 flex gap-4">
            <Button
              variant="outline"
              onClick={() => navigate(`/trips/${tripId}/expenses/${expenseId}/edit`)}
              className="flex-1"
            >
              編集
            </Button>
            <Button
              variant="outline"
              onClick={handleDelete}
              isLoading={isDeleting}
              className="flex-1 border-primary text-primary hover:bg-primary hover:text-white"
            >
              削除
            </Button>
          </div>
        </div>
      </div>
    </Layout>
  )
}
