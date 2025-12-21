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
  categories?: {
    id: string
    name: string
    icon: string | null
  }
}

interface Category {
  id: string
  name: string
  icon: string | null
}

type ExpenseSortType = 'date-desc' | 'date-asc' | 'amount-desc' | 'amount-asc'

export function TripDetail() {
  const { id } = useParams<{ id: string }>()
  const navigate = useNavigate()
  const { user } = useAuth()

  const [trip, setTrip] = useState<Trip | null>(null)
  const [expenses, setExpenses] = useState<Expense[]>([])
  const [categories, setCategories] = useState<Category[]>([])
  const [loading, setLoading] = useState(true)

  // Filter and sort states
  const [searchQuery, setSearchQuery] = useState('')
  const [selectedCategory, setSelectedCategory] = useState<string>('all')
  const [sortBy, setSortBy] = useState<ExpenseSortType>('date-desc')
  const [minAmount, setMinAmount] = useState('')
  const [maxAmount, setMaxAmount] = useState('')

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

      // Fetch expenses with categories
      const { data: expensesData, error: expensesError } = await supabase
        .from('expenses')
        .select(`
          *,
          categories (
            id,
            name,
            icon
          )
        `)
        .eq('trip_id', id)
        .order('expense_date', { ascending: false })

      if (expensesError) {
        console.error('Error fetching expenses:', expensesError)
      } else {
        setExpenses(expensesData || [])
      }

      // Fetch categories for filter
      const { data: categoriesData } = await supabase
        .from('categories')
        .select('id, name, icon')
        .or(`is_default.eq.true,user_id.eq.${user.id}`)
        .order('name')

      if (categoriesData) {
        setCategories(categoriesData)
      }
    } catch (error) {
      console.error('Error fetching trip data:', error)
      toast.error('エラーが発生しました')
    } finally {
      setLoading(false)
    }
  }

  // Filter and sort expenses
  const filteredAndSortedExpenses = expenses
    .filter(expense => {
      // Search filter
      const searchMatch = searchQuery === '' ||
        (expense.description && expense.description.toLowerCase().includes(searchQuery.toLowerCase())) ||
        (expense.location && expense.location.toLowerCase().includes(searchQuery.toLowerCase()))

      // Category filter
      const categoryMatch = selectedCategory === 'all' ||
        expense.category_id === selectedCategory ||
        (selectedCategory === 'uncategorized' && !expense.category_id)

      // Amount range filter
      const min = minAmount ? parseFloat(minAmount) : 0
      const max = maxAmount ? parseFloat(maxAmount) : Infinity
      const amountMatch = expense.amount >= min && expense.amount <= max

      return searchMatch && categoryMatch && amountMatch
    })
    .sort((a, b) => {
      switch (sortBy) {
        case 'date-desc':
          return new Date(b.expense_date).getTime() - new Date(a.expense_date).getTime()
        case 'date-asc':
          return new Date(a.expense_date).getTime() - new Date(b.expense_date).getTime()
        case 'amount-desc':
          return b.amount - a.amount
        case 'amount-asc':
          return a.amount - b.amount
        default:
          return 0
      }
    })

  const totalExpenses = expenses.reduce((sum, exp) => sum + exp.amount, 0)
  const filteredTotal = filteredAndSortedExpenses.reduce((sum, exp) => sum + exp.amount, 0)
  const hasActiveFilters = searchQuery !== '' || selectedCategory !== 'all' || minAmount !== '' || maxAmount !== ''

  const clearFilters = () => {
    setSearchQuery('')
    setSelectedCategory('all')
    setMinAmount('')
    setMaxAmount('')
    setSortBy('date-desc')
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

          {expenses.length > 0 && (
            <>
              {/* Search and Filters */}
              <div className="mb-6 space-y-4">
                {/* Search Bar */}
                <div className="relative">
                  <input
                    type="text"
                    placeholder="説明や場所で検索..."
                    value={searchQuery}
                    onChange={(e) => setSearchQuery(e.target.value)}
                    className="w-full px-4 py-2 pl-10 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent"
                  />
                  <svg
                    className="absolute left-3 top-1/2 transform -translate-y-1/2 w-5 h-5 text-neutral"
                    fill="none"
                    stroke="currentColor"
                    viewBox="0 0 24 24"
                  >
                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
                  </svg>
                </div>

                {/* Filters Row */}
                <div className="flex flex-col sm:flex-row gap-3">
                  {/* Category Filter */}
                  <select
                    value={selectedCategory}
                    onChange={(e) => setSelectedCategory(e.target.value)}
                    className="px-4 py-2 border border-gray-300 rounded-lg bg-white focus:outline-none focus:ring-2 focus:ring-primary"
                  >
                    <option value="all">すべてのカテゴリー</option>
                    <option value="uncategorized">未分類</option>
                    {categories.map(cat => (
                      <option key={cat.id} value={cat.id}>
                        {cat.icon} {cat.name}
                      </option>
                    ))}
                  </select>

                  {/* Amount Range */}
                  <div className="flex gap-2 items-center">
                    <input
                      type="number"
                      placeholder="最小金額"
                      value={minAmount}
                      onChange={(e) => setMinAmount(e.target.value)}
                      className="w-28 px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary"
                    />
                    <span className="text-neutral">〜</span>
                    <input
                      type="number"
                      placeholder="最大金額"
                      value={maxAmount}
                      onChange={(e) => setMaxAmount(e.target.value)}
                      className="w-28 px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary"
                    />
                  </div>

                  {/* Sort */}
                  <select
                    value={sortBy}
                    onChange={(e) => setSortBy(e.target.value as ExpenseSortType)}
                    className="px-4 py-2 border border-gray-300 rounded-lg bg-white focus:outline-none focus:ring-2 focus:ring-primary"
                  >
                    <option value="date-desc">日付が新しい順</option>
                    <option value="date-asc">日付が古い順</option>
                    <option value="amount-desc">金額が高い順</option>
                    <option value="amount-asc">金額が低い順</option>
                  </select>

                  {hasActiveFilters && (
                    <button
                      onClick={clearFilters}
                      className="px-4 py-2 text-sm text-neutral hover:text-primary transition-colors whitespace-nowrap"
                    >
                      クリア
                    </button>
                  )}
                </div>

                {/* Results Summary */}
                <div className="flex justify-between items-center text-sm">
                  <span className="text-neutral">
                    {filteredAndSortedExpenses.length}件の支出
                    {hasActiveFilters && ` (全${expenses.length}件中)`}
                  </span>
                  {hasActiveFilters && (
                    <span className="text-neutral">
                      表示中の合計: {trip.currency} {filteredTotal.toLocaleString()}
                    </span>
                  )}
                </div>
              </div>
            </>
          )}

          {filteredAndSortedExpenses.length > 0 ? (
            <div className="space-y-3">
              {filteredAndSortedExpenses.map((expense) => (
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
          ) : expenses.length > 0 ? (
            <div className="text-center py-12">
              <div className="text-6xl mb-4">🔍</div>
              <h3 className="text-xl font-semibold text-neutral-dark mb-2">
                条件に一致する支出が見つかりません
              </h3>
              <p className="text-neutral mb-6">
                フィルターを変更してみてください
              </p>
              <button
                onClick={clearFilters}
                className="px-6 py-3 bg-white border-2 border-primary text-primary rounded-lg font-medium hover:bg-primary hover:text-white transition-all"
              >
                フィルターをクリア
              </button>
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
