import { useState, useEffect } from 'react'
import { useParams, useNavigate } from 'react-router-dom'
import { Layout } from '../components/Layout'
import { Button } from '../components/Button'
import { useAuth } from '../contexts/AuthContext'
import { supabase } from '../lib/supabase'
import toast from 'react-hot-toast'
import {
  PieChart,
  Pie,
  Cell,
  BarChart,
  Bar,
  LineChart,
  Line,
  XAxis,
  YAxis,
  CartesianGrid,
  Tooltip,
  Legend,
  ResponsiveContainer
} from 'recharts'

interface Trip {
  id: string
  name: string
  destination: string | null
  start_date: string
  end_date: string | null
  budget: number | null
  currency: string
}

interface Expense {
  id: string
  amount: number
  currency: string
  category_id: string | null
  expense_date: string
  categories?: {
    id: string
    name: string
    icon: string | null
    color: string | null
  }
}

interface CategoryData {
  name: string
  value: number
  color: string
  icon: string
}

interface DailyData {
  date: string
  amount: number
}

const COLORS = ['#E63946', '#F77F00', '#FFB703', '#06D6A0', '#118AB2', '#073B4C', '#8338EC', '#FF006E', '#3A86FF', '#FB5607']

export function TripReport() {
  const { id } = useParams<{ id: string }>()
  const navigate = useNavigate()
  const { user } = useAuth()

  const [trip, setTrip] = useState<Trip | null>(null)
  const [expenses, setExpenses] = useState<Expense[]>([])
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    if (id && user) {
      fetchData()
    }
  }, [id, user])

  const fetchData = async () => {
    if (!id || !user) return

    setLoading(true)

    try {
      // Fetch trip
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

      // Fetch expenses with categories
      const { data: expensesData, error: expensesError } = await supabase
        .from('expenses')
        .select(`
          *,
          categories (
            id,
            name,
            icon,
            color
          )
        `)
        .eq('trip_id', id)
        .order('expense_date', { ascending: true })

      if (expensesError) {
        console.error('Error fetching expenses:', expensesError)
      } else {
        setExpenses(expensesData || [])
      }
    } catch (error) {
      console.error('Error fetching data:', error)
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
          <Button onClick={() => navigate('/trips')}>旅行一覧に戻る</Button>
        </div>
      </Layout>
    )
  }

  // Calculate statistics
  const totalExpenses = expenses.reduce((sum, exp) => sum + exp.amount, 0)
  const averagePerExpense = expenses.length > 0 ? totalExpenses / expenses.length : 0

  const tripDays = trip.end_date
    ? Math.ceil((new Date(trip.end_date).getTime() - new Date(trip.start_date).getTime()) / (1000 * 60 * 60 * 24)) + 1
    : 1
  const averagePerDay = tripDays > 0 ? totalExpenses / tripDays : totalExpenses

  const budgetUsage = trip.budget ? (totalExpenses / trip.budget) * 100 : 0
  const remaining = (trip.budget || 0) - totalExpenses

  // Category breakdown
  const categoryMap = new Map<string, CategoryData>()
  let uncategorizedAmount = 0

  expenses.forEach(expense => {
    if (expense.categories) {
      const categoryName = expense.categories.name
      const existing = categoryMap.get(categoryName)

      if (existing) {
        existing.value += expense.amount
      } else {
        categoryMap.set(categoryName, {
          name: categoryName,
          value: expense.amount,
          color: expense.categories.color || COLORS[categoryMap.size % COLORS.length],
          icon: expense.categories.icon || '📌'
        })
      }
    } else {
      uncategorizedAmount += expense.amount
    }
  })

  if (uncategorizedAmount > 0) {
    categoryMap.set('未分類', {
      name: '未分類',
      value: uncategorizedAmount,
      color: '#9CA3AF',
      icon: '📋'
    })
  }

  const categoryData = Array.from(categoryMap.values()).sort((a, b) => b.value - a.value)

  // Daily spending
  const dailyMap = new Map<string, number>()

  expenses.forEach(expense => {
    const date = expense.expense_date
    const existing = dailyMap.get(date)
    dailyMap.set(date, (existing || 0) + expense.amount)
  })

  const dailyData: DailyData[] = Array.from(dailyMap.entries())
    .map(([date, amount]) => ({
      date: new Date(date).toLocaleDateString('ja-JP', { month: 'short', day: 'numeric' }),
      amount
    }))
    .sort((a, b) => new Date(a.date).getTime() - new Date(b.date).getTime())

  return (
    <Layout>
      <div className="max-w-6xl mx-auto">
        {/* Header */}
        <div className="mb-8">
          <button
            onClick={() => navigate(`/trips/${id}`)}
            className="flex items-center gap-2 text-neutral hover:text-neutral-dark transition-colors mb-4"
          >
            <span>←</span>
            <span>旅行詳細に戻る</span>
          </button>
          <h1 className="text-3xl font-bold text-neutral-dark mb-2">
            {trip.name} - レポート
          </h1>
          <p className="text-neutral">
            支出の分析とインサイト
          </p>
        </div>

        {/* Summary Statistics */}
        <div className="grid grid-cols-1 md:grid-cols-4 gap-4 mb-6">
          <div className="bg-white rounded-xl shadow-md p-6">
            <p className="text-sm text-neutral mb-1">総支出</p>
            <p className="text-2xl font-bold text-neutral-dark">
              {trip.currency} {totalExpenses.toLocaleString()}
            </p>
          </div>
          <div className="bg-white rounded-xl shadow-md p-6">
            <p className="text-sm text-neutral mb-1">1日平均</p>
            <p className="text-2xl font-bold text-neutral-dark">
              {trip.currency} {Math.round(averagePerDay).toLocaleString()}
            </p>
          </div>
          <div className="bg-white rounded-xl shadow-md p-6">
            <p className="text-sm text-neutral mb-1">支出回数</p>
            <p className="text-2xl font-bold text-neutral-dark">
              {expenses.length}回
            </p>
          </div>
          <div className="bg-white rounded-xl shadow-md p-6">
            <p className="text-sm text-neutral mb-1">予算使用率</p>
            <p className={`text-2xl font-bold ${budgetUsage > 100 ? 'text-primary' : 'text-neutral-dark'}`}>
              {trip.budget ? `${budgetUsage.toFixed(1)}%` : 'N/A'}
            </p>
          </div>
        </div>

        {expenses.length === 0 ? (
          <div className="bg-white rounded-xl shadow-md p-12 text-center">
            <div className="text-6xl mb-4">📊</div>
            <h3 className="text-xl font-semibold text-neutral-dark mb-2">
              まだ支出がありません
            </h3>
            <p className="text-neutral mb-6">
              支出を記録すると、詳細な分析が表示されます
            </p>
            <Button onClick={() => navigate(`/trips/${id}/expenses/new`)}>
              支出を追加
            </Button>
          </div>
        ) : (
          <>
            {/* Charts Grid */}
            <div className="grid grid-cols-1 lg:grid-cols-2 gap-6 mb-6">
              {/* Category Breakdown - Pie Chart */}
              <div className="bg-white rounded-xl shadow-md p-6">
                <h2 className="text-xl font-bold text-neutral-dark mb-4">
                  カテゴリー別内訳
                </h2>
                <ResponsiveContainer width="100%" height={300}>
                  <PieChart>
                    <Pie
                      data={categoryData}
                      cx="50%"
                      cy="50%"
                      labelLine={false}
                      label={({ name, percent }) => `${name} (${(percent * 100).toFixed(0)}%)`}
                      outerRadius={80}
                      fill="#8884d8"
                      dataKey="value"
                    >
                      {categoryData.map((entry, index) => (
                        <Cell key={`cell-${index}`} fill={entry.color} />
                      ))}
                    </Pie>
                    <Tooltip
                      formatter={(value: number) => `${trip.currency} ${value.toLocaleString()}`}
                    />
                  </PieChart>
                </ResponsiveContainer>
              </div>

              {/* Category Amounts - Bar Chart */}
              <div className="bg-white rounded-xl shadow-md p-6">
                <h2 className="text-xl font-bold text-neutral-dark mb-4">
                  カテゴリー別支出額
                </h2>
                <ResponsiveContainer width="100%" height={300}>
                  <BarChart data={categoryData}>
                    <CartesianGrid strokeDasharray="3 3" />
                    <XAxis dataKey="name" />
                    <YAxis />
                    <Tooltip
                      formatter={(value: number) => `${trip.currency} ${value.toLocaleString()}`}
                    />
                    <Bar dataKey="value" fill="#E63946" />
                  </BarChart>
                </ResponsiveContainer>
              </div>
            </div>

            {/* Daily Spending Trend */}
            {dailyData.length > 0 && (
              <div className="bg-white rounded-xl shadow-md p-6 mb-6">
                <h2 className="text-xl font-bold text-neutral-dark mb-4">
                  日別支出トレンド
                </h2>
                <ResponsiveContainer width="100%" height={300}>
                  <LineChart data={dailyData}>
                    <CartesianGrid strokeDasharray="3 3" />
                    <XAxis dataKey="date" />
                    <YAxis />
                    <Tooltip
                      formatter={(value: number) => `${trip.currency} ${value.toLocaleString()}`}
                    />
                    <Legend />
                    <Line
                      type="monotone"
                      dataKey="amount"
                      stroke="#E63946"
                      strokeWidth={2}
                      name="支出額"
                    />
                  </LineChart>
                </ResponsiveContainer>
              </div>
            )}

            {/* Category Details Table */}
            <div className="bg-white rounded-xl shadow-md p-6">
              <h2 className="text-xl font-bold text-neutral-dark mb-4">
                カテゴリー詳細
              </h2>
              <div className="overflow-x-auto">
                <table className="w-full">
                  <thead>
                    <tr className="border-b border-gray-200">
                      <th className="text-left py-3 px-4 text-sm font-semibold text-neutral-dark">
                        カテゴリー
                      </th>
                      <th className="text-right py-3 px-4 text-sm font-semibold text-neutral-dark">
                        支出額
                      </th>
                      <th className="text-right py-3 px-4 text-sm font-semibold text-neutral-dark">
                        割合
                      </th>
                      <th className="text-right py-3 px-4 text-sm font-semibold text-neutral-dark">
                        回数
                      </th>
                    </tr>
                  </thead>
                  <tbody>
                    {categoryData.map((category) => {
                      const categoryExpenses = expenses.filter(
                        exp => exp.categories?.name === category.name || (!exp.categories && category.name === '未分類')
                      )
                      const percentage = (category.value / totalExpenses) * 100

                      return (
                        <tr key={category.name} className="border-b border-gray-100 hover:bg-neutral-light/50">
                          <td className="py-3 px-4">
                            <div className="flex items-center gap-2">
                              <span className="text-xl">{category.icon}</span>
                              <span className="font-medium text-neutral-dark">{category.name}</span>
                            </div>
                          </td>
                          <td className="py-3 px-4 text-right font-semibold text-neutral-dark">
                            {trip.currency} {category.value.toLocaleString()}
                          </td>
                          <td className="py-3 px-4 text-right text-neutral">
                            {percentage.toFixed(1)}%
                          </td>
                          <td className="py-3 px-4 text-right text-neutral">
                            {categoryExpenses.length}回
                          </td>
                        </tr>
                      )
                    })}
                  </tbody>
                  <tfoot>
                    <tr className="border-t-2 border-gray-300 font-bold">
                      <td className="py-3 px-4 text-neutral-dark">合計</td>
                      <td className="py-3 px-4 text-right text-neutral-dark">
                        {trip.currency} {totalExpenses.toLocaleString()}
                      </td>
                      <td className="py-3 px-4 text-right text-neutral-dark">100%</td>
                      <td className="py-3 px-4 text-right text-neutral-dark">{expenses.length}回</td>
                    </tr>
                  </tfoot>
                </table>
              </div>
            </div>
          </>
        )}
      </div>
    </Layout>
  )
}
