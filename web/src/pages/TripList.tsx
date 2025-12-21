import { useState } from 'react'
import { Link } from 'react-router-dom'
import { Layout } from '../components/Layout'
import { TripCard } from '../components/TripCard'

// Mock data for development
const mockTrips = [
  {
    id: '1',
    name: 'パリ旅行',
    destination: 'パリ, フランス',
    start_date: '2025-03-15',
    end_date: '2025-03-22',
    budget: 300000,
    currency: '¥',
    total_expenses: 185000,
    expense_count: 24
  },
  {
    id: '2',
    name: '東京出張',
    destination: '東京, 日本',
    start_date: '2025-02-10',
    end_date: '2025-02-12',
    budget: 80000,
    currency: '¥',
    total_expenses: 65000,
    expense_count: 12
  },
  {
    id: '3',
    name: 'バリ島バケーション',
    destination: 'バリ, インドネシア',
    start_date: '2025-04-01',
    end_date: null,
    budget: 250000,
    currency: '¥',
    total_expenses: 0,
    expense_count: 0
  }
]

export function TripList() {
  const [trips] = useState(mockTrips)
  const [filter, setFilter] = useState<'all' | 'upcoming' | 'past'>('all')

  const filteredTrips = trips.filter(trip => {
    const today = new Date()
    const startDate = new Date(trip.start_date)
    const endDate = trip.end_date ? new Date(trip.end_date) : null

    if (filter === 'upcoming') {
      return startDate > today
    } else if (filter === 'past') {
      return endDate && endDate < today
    }
    return true
  })

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

        {/* Filters */}
        <div className="flex gap-2">
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
      </div>

      {/* Trip Grid */}
      {filteredTrips.length > 0 ? (
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          {filteredTrips.map(trip => (
            <TripCard key={trip.id} trip={trip} />
          ))}
        </div>
      ) : (
        <div className="text-center py-16">
          <div className="text-6xl mb-4">✈️</div>
          <h3 className="text-xl font-semibold text-neutral-dark mb-2">
            旅行が見つかりません
          </h3>
          <p className="text-neutral mb-6">
            新しい旅行を作成して支出の記録を始めましょう
          </p>
          <Link
            to="/trips/new"
            className="inline-block px-6 py-3 bg-primary text-white rounded-lg font-medium hover:bg-primary-dark shadow-md hover:shadow-lg transition-all duration-200"
          >
            最初の旅行を作成
          </Link>
        </div>
      )}
    </Layout>
  )
}
