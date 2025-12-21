import { useState, useEffect } from 'react'
import { Link } from 'react-router-dom'
import { Layout } from '../components/Layout'
import { TripCard } from '../components/TripCard'
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
  created_at: string
}

type FilterType = 'all' | 'upcoming' | 'past' | 'ongoing'
type SortType = 'date-desc' | 'date-asc' | 'name' | 'budget'

export function TripList() {
  const { user } = useAuth()
  const [trips, setTrips] = useState<Trip[]>([])
  const [loading, setLoading] = useState(true)
  const [filter, setFilter] = useState<FilterType>('all')
  const [sortBy, setSortBy] = useState<SortType>('date-desc')
  const [searchQuery, setSearchQuery] = useState('')

  useEffect(() => {
    if (user) {
      fetchTrips()
    }
  }, [user])

  const fetchTrips = async () => {
    if (!user) return

    setLoading(true)

    try {
      const { data, error } = await supabase
        .from('trips')
        .select('*')
        .eq('user_id', user.id)
        .order('start_date', { ascending: false })

      if (error) {
        console.error('Error fetching trips:', error)
        toast.error('旅行の取得に失敗しました')
        return
      }

      setTrips(data || [])
    } catch (error) {
      console.error('Error fetching trips:', error)
      toast.error('エラーが発生しました')
    } finally {
      setLoading(false)
    }
  }

  // Calculate total expenses for each trip
  const tripsWithExpenses = trips.map(trip => {
    // TODO: Fetch actual expenses count and total
    // For now, returning trip as is
    return {
      ...trip,
      total_expenses: 0,
      expense_count: 0
    }
  })

  // Filter trips
  const filteredAndSortedTrips = tripsWithExpenses
    .filter(trip => {
      const today = new Date()
      today.setHours(0, 0, 0, 0)
      const startDate = new Date(trip.start_date)
      const endDate = trip.end_date ? new Date(trip.end_date) : null

      // Date filter
      let dateMatch = true
      if (filter === 'upcoming') {
        dateMatch = startDate > today
      } else if (filter === 'past') {
        dateMatch = endDate ? endDate < today : false
      } else if (filter === 'ongoing') {
        dateMatch = startDate <= today && (!endDate || endDate >= today)
      }

      // Search filter
      const searchMatch = searchQuery === '' ||
        trip.name.toLowerCase().includes(searchQuery.toLowerCase()) ||
        (trip.destination && trip.destination.toLowerCase().includes(searchQuery.toLowerCase()))

      return dateMatch && searchMatch
    })
    .sort((a, b) => {
      switch (sortBy) {
        case 'date-desc':
          return new Date(b.start_date).getTime() - new Date(a.start_date).getTime()
        case 'date-asc':
          return new Date(a.start_date).getTime() - new Date(b.start_date).getTime()
        case 'name':
          return a.name.localeCompare(b.name, 'ja')
        case 'budget':
          return (b.budget || 0) - (a.budget || 0)
        default:
          return 0
      }
    })

  const hasActiveFilters = filter !== 'all' || searchQuery !== '' || sortBy !== 'date-desc'

  const clearFilters = () => {
    setFilter('all')
    setSearchQuery('')
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

  return (
    <Layout>
      {/* Page Header */}
      <div className="mb-8">
        <div className="flex justify-between items-center mb-6">
          <div>
            <h1 className="text-3xl font-bold text-neutral-dark mb-2">
              マイトリップ
            </h1>
            <p className="text-neutral">
              旅行を管理して支出を記録しましょう
            </p>
          </div>

          <Link
            to="/trips/new"
            className="px-6 py-3 bg-primary text-white rounded-lg font-medium hover:bg-primary-dark shadow-md hover:shadow-lg transition-all duration-200"
          >
            + 新しい旅行
          </Link>
        </div>

        {/* Search Bar */}
        <div className="mb-4">
          <div className="relative">
            <input
              type="text"
              placeholder="旅行名や目的地で検索..."
              value={searchQuery}
              onChange={(e) => setSearchQuery(e.target.value)}
              className="w-full px-4 py-3 pl-12 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent"
            />
            <svg
              className="absolute left-4 top-1/2 transform -translate-y-1/2 w-5 h-5 text-neutral"
              fill="none"
              stroke="currentColor"
              viewBox="0 0 24 24"
            >
              <path
                strokeLinecap="round"
                strokeLinejoin="round"
                strokeWidth={2}
                d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"
              />
            </svg>
          </div>
        </div>

        {/* Filters and Sort */}
        <div className="flex flex-col sm:flex-row gap-4 items-start sm:items-center justify-between">
          <div className="flex gap-2 flex-wrap">
            <button
              onClick={() => setFilter('all')}
              className={`px-4 py-2 rounded-lg font-medium transition-colors ${
                filter === 'all'
                  ? 'bg-primary text-white'
                  : 'bg-white text-neutral-dark hover:bg-gray-100'
              }`}
            >
              すべて
            </button>
            <button
              onClick={() => setFilter('ongoing')}
              className={`px-4 py-2 rounded-lg font-medium transition-colors ${
                filter === 'ongoing'
                  ? 'bg-primary text-white'
                  : 'bg-white text-neutral-dark hover:bg-gray-100'
              }`}
            >
              進行中
            </button>
            <button
              onClick={() => setFilter('upcoming')}
              className={`px-4 py-2 rounded-lg font-medium transition-colors ${
                filter === 'upcoming'
                  ? 'bg-primary text-white'
                  : 'bg-white text-neutral-dark hover:bg-gray-100'
              }`}
            >
              予定
            </button>
            <button
              onClick={() => setFilter('past')}
              className={`px-4 py-2 rounded-lg font-medium transition-colors ${
                filter === 'past'
                  ? 'bg-primary text-white'
                  : 'bg-white text-neutral-dark hover:bg-gray-100'
              }`}
            >
              過去
            </button>
          </div>

          <div className="flex gap-2 items-center">
            <select
              value={sortBy}
              onChange={(e) => setSortBy(e.target.value as SortType)}
              className="px-4 py-2 border border-gray-300 rounded-lg bg-white text-neutral-dark focus:outline-none focus:ring-2 focus:ring-primary"
            >
              <option value="date-desc">日付が新しい順</option>
              <option value="date-asc">日付が古い順</option>
              <option value="name">名前順</option>
              <option value="budget">予算順</option>
            </select>

            {hasActiveFilters && (
              <button
                onClick={clearFilters}
                className="px-4 py-2 text-sm text-neutral hover:text-primary transition-colors"
              >
                フィルターをクリア
              </button>
            )}
          </div>
        </div>

        {/* Results count */}
        {searchQuery && (
          <p className="mt-4 text-sm text-neutral">
            {filteredAndSortedTrips.length}件の旅行が見つかりました
          </p>
        )}
      </div>

      {/* Trip Grid */}
      {filteredAndSortedTrips.length > 0 ? (
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          {filteredAndSortedTrips.map(trip => (
            <TripCard key={trip.id} trip={trip} />
          ))}
        </div>
      ) : (
        <div className="text-center py-16">
          <div className="text-6xl mb-4">✈️</div>
          <h3 className="text-xl font-semibold text-neutral-dark mb-2">
            {searchQuery || hasActiveFilters
              ? '条件に一致する旅行が見つかりません'
              : '旅行がまだありません'}
          </h3>
          <p className="text-neutral mb-6">
            {searchQuery || hasActiveFilters
              ? 'フィルターを変更するか、新しい旅行を作成してください'
              : '新しい旅行を作成して支出の記録を始めましょう'}
          </p>
          {hasActiveFilters ? (
            <button
              onClick={clearFilters}
              className="inline-block px-6 py-3 bg-white border-2 border-primary text-primary rounded-lg font-medium hover:bg-primary hover:text-white transition-all duration-200"
            >
              フィルターをクリア
            </button>
          ) : (
            <Link
              to="/trips/new"
              className="inline-block px-6 py-3 bg-primary text-white rounded-lg font-medium hover:bg-primary-dark shadow-md hover:shadow-lg transition-all duration-200"
            >
              最初の旅行を作成
            </Link>
          )}
        </div>
      )}
    </Layout>
  )
}
