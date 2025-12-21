import { useState, useEffect } from 'react'
import { useParams, useNavigate, Link } from 'react-router-dom'
import { Layout } from '../components/Layout'
import { Button } from '../components/Button'
import { useAuth } from '../contexts/AuthContext'
import { supabase } from '../lib/supabase'
import toast from 'react-hot-toast'

interface Trip {
  id: string
  user_id: string
  name: string
  destination: string | null
  start_date: string
  end_date: string | null
  budget: number | null
  currency: string
  description: string | null
  created_at: string
  updated_at: string
}

interface Expense {
  id: string
  trip_id: string
  amount: number
  currency: string
  category_id: string | null
  description: string | null
  expense_date: string
  location: string | null
}

export function TripDetail() {
  const { id } = useParams<{ id: string }>()
  const navigate = useNavigate()
  const { user } = useAuth()

  const [trip, setTrip] = useState<Trip | null>(null)
  const [expenses, setExpenses] = useState<Expense[]>([])
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    if (id && user) {
      fetchTripData()
    }
  }, [id, user])

  const fetchTripData = async () => {
    if (!id || !user) return

    setLoading(true)

    try {
      // Fetch trip details
      const { data: tripData, error: tripError } = await supabase
        .from('trips')
        .select('*')
        .eq('id', id)
        .eq('user_id', user.id)
        .single()

      if (tripError) {
        console.error('Error fetching trip:', tripError)
        toast.error('旅行が見つかりません')
        navigate('/trips')
        return
      }

      setTrip(tripData)

      // Fetch expenses
      const { data: expensesData, error: expensesError } = await supabase
        .from('expenses')
        .select('*')
        .eq('trip_id', id)
        .order('expense_date', { ascending: false })

      if (expensesError) {
        console.error('Error fetching expenses:', expensesError)
      } else {
        setExpenses(expensesData || [])
      }
    } catch (error) {
      console.error('Error fetching trip data:', error)
      toast.error('エラーが発生しました')
    } finally {
      setLoading(false)
    }
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

  if (!trip) {
    return (
      <Layout>
        <div className="text-center py-16">
          <h2 className="text-2xl font-bold text-neutral-dark mb-4">旅行が見つかりません</h2>
          <Link to="/trips" className="text-primary hover:underline">
            旅行一覧に戻る
          </Link>
        </div>
      </Layout>
    )
  }

  const totalExpenses = expenses.reduce((sum, exp) => sum + exp.amount, 0)
  const remaining = (trip.budget || 0) - totalExpenses
  const budgetUsage = trip.budget ? (totalExpenses / trip.budget) * 100 : 0

  // Format dates
  const startDate = new Date(trip.start_date).toLocaleDateString('ja-JP', {
    year: 'numeric',
    month: 'long',
    day: 'numeric'
  })
  const endDate = trip.end_date
    ? new Date(trip.end_date).toLocaleDateString('ja-JP', {
        year: 'numeric',
        month: 'long',
        day: 'numeric'
      })
    : '未定'

  return (
    <Layout>
      <div className="max-w-4xl mx-auto">
        {/* Header */}
        <div className="bg-gradient-to-r from-primary to-primary-dark rounded-xl p-8 text-white mb-6 shadow-lg">
          <div className="flex justify-between items-start mb-4">
            <div>
              <h1 className="text-3xl font-bold mb-2">{trip.name}</h1>
              {trip.destination && (
                <p className="text-primary-light flex items-center gap-2 text-lg">
                  <span>📍</span>
                  <span>{trip.destination}</span>
                </p>
              )}
            </div>
            <Button
              variant="outline"
              onClick={() => navigate(`/trips/${trip.id}/edit`)}
              className="bg-white/10 border-white/30 text-white hover:bg-white/20"
            >
              編集
            </Button>
          </div>

          <p className="text-primary-light">
            📅 {startDate} - {endDate}
          </p>
        </div>

        {/* Budget Summary */}
        {trip.budget && (
          <div className="bg-white rounded-xl shadow-md p-6 mb-6">
            <h2 className="text-xl font-bold text-neutral-dark mb-4">予算使用状況</h2>

            <div className="mb-4">
              <div className="flex justify-between text-sm mb-2">
                <span className="text-neutral">使用率</span>
                <span className={`font-semibold ${budgetUsage > 100 ? 'text-primary' : 'text-neutral'}`}>
                  {budgetUsage.toFixed(1)}%
                </span>
              </div>
              <div className="w-full bg-gray-200 rounded-full h-3 overflow-hidden">
                <div
                  className={`h-full transition-all duration-300 ${
                    budgetUsage > 100 ? 'bg-primary' : 'bg-neutral'
                  }`}
                  style={{ width: `${Math.min(budgetUsage, 100)}%` }}
                />
              </div>
            </div>

            <div className="grid grid-cols-3 gap-4">
              <div>
                <p className="text-sm text-neutral mb-1">総支出</p>
                <p className="text-2xl font-bold text-neutral-dark">
                  {trip.currency} {totalExpenses.toLocaleString()}
                </p>
              </div>
              <div>
                <p className="text-sm text-neutral mb-1">予算</p>
                <p className="text-2xl font-bold text-neutral-dark">
                  {trip.currency} {trip.budget.toLocaleString()}
                </p>
              </div>
              <div>
                <p className="text-sm text-neutral mb-1">残予算</p>
                <p className={`text-2xl font-bold ${remaining < 0 ? 'text-primary' : 'text-neutral-dark'}`}>
                  {trip.currency} {remaining.toLocaleString()}
                </p>
              </div>
            </div>
          </div>
        )}

        {/* Expenses Section */}
        <div className="bg-white rounded-xl shadow-md p-6">
          <div className="flex justify-between items-center mb-6">
            <h2 className="text-xl font-bold text-neutral-dark">支出記録</h2>
            <div className="flex gap-2">
              <Button
                variant="outline"
                onClick={() => navigate(`/trips/${trip.id}/report`)}
              >
                📊 レポート
              </Button>
              <Button onClick={() => navigate(`/trips/${trip.id}/expenses/new`)}>
                + 支出を追加
              </Button>
            </div>
          </div>

          {expenses.length > 0 ? (
            <div className="space-y-3">
              {expenses.map((expense) => (
                <div
                  key={expense.id}
                  className="flex justify-between items-center p-4 border border-gray-200 rounded-lg hover:border-primary/30 transition-colors cursor-pointer"
                  onClick={() => navigate(`/trips/${trip.id}/expenses/${expense.id}`)}
                >
                  <div>
                    <p className="font-semibold text-neutral-dark">
                      {expense.description || '支出'}
                    </p>
                    <p className="text-sm text-neutral">
                      {new Date(expense.expense_date).toLocaleDateString('ja-JP')}
                      {expense.location && ` • ${expense.location}`}
                    </p>
                  </div>
                  <p className="text-lg font-bold text-neutral-dark">
                    {expense.currency} {expense.amount.toLocaleString()}
                  </p>
                </div>
              ))}
            </div>
          ) : (
            <div className="text-center py-12">
              <div className="text-6xl mb-4">💰</div>
              <h3 className="text-xl font-semibold text-neutral-dark mb-2">
                まだ支出がありません
              </h3>
              <p className="text-neutral mb-6">
                最初の支出を記録してみましょう
              </p>
              <Button onClick={() => navigate(`/trips/${trip.id}/expenses/new`)}>
                支出を追加
              </Button>
            </div>
          )}
        </div>
      </div>
    </Layout>
  )
}
