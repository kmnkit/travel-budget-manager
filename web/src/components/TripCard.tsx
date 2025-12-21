import { Link } from 'react-router-dom'

interface Trip {
  id: string
  name: string
  destination: string | null
  start_date: string
  end_date: string | null
  budget: number | null
  currency: string
  total_expenses?: number
  expense_count?: number
}

interface TripCardProps {
  trip: Trip
}

export function TripCard({ trip }: TripCardProps) {
  const totalExpenses = trip.total_expenses || 0
  const budget = trip.budget || 0
  const budgetUsage = budget > 0 ? (totalExpenses / budget) * 100 : 0
  const remaining = budget - totalExpenses

  // Format dates
  const startDate = new Date(trip.start_date).toLocaleDateString('ja-JP', {
    year: 'numeric',
    month: 'short',
    day: 'numeric'
  })
  const endDate = trip.end_date
    ? new Date(trip.end_date).toLocaleDateString('ja-JP', {
        year: 'numeric',
        month: 'short',
        day: 'numeric'
      })
    : '未定'

  return (
    <Link
      to={`/trips/${trip.id}`}
      className="block bg-white rounded-xl shadow-md hover:shadow-xl transition-all duration-300 overflow-hidden border border-gray-100 hover:border-primary/30"
    >
      {/* Card Header */}
      <div className="bg-gradient-to-r from-primary to-primary-dark p-6 text-white">
        <h3 className="text-xl font-bold mb-1">{trip.name}</h3>
        <p className="text-primary-light flex items-center gap-2">
          <span>📍</span>
          <span>{trip.destination || '目的地未設定'}</span>
        </p>
      </div>

      {/* Card Body */}
      <div className="p-6 space-y-4">
        {/* Dates */}
        <div className="flex items-center gap-2 text-sm text-neutral-dark">
          <span>📅</span>
          <span>{startDate} - {endDate}</span>
        </div>

        {/* Budget Info */}
        {budget > 0 && (
          <div className="space-y-2">
            <div className="flex justify-between text-sm">
              <span className="text-neutral-dark">予算使用状況</span>
              <span className={`font-semibold ${budgetUsage > 100 ? 'text-primary' : 'text-neutral'}`}>
                {budgetUsage.toFixed(0)}%
              </span>
            </div>

            {/* Progress Bar */}
            <div className="w-full bg-gray-200 rounded-full h-2 overflow-hidden">
              <div
                className={`h-full transition-all duration-300 ${
                  budgetUsage > 100 ? 'bg-primary' : 'bg-neutral'
                }`}
                style={{ width: `${Math.min(budgetUsage, 100)}%` }}
              />
            </div>

            {/* Budget Numbers */}
            <div className="grid grid-cols-2 gap-4 pt-2">
              <div>
                <p className="text-xs text-neutral">総支出</p>
                <p className="text-lg font-bold text-neutral-dark">
                  {trip.currency} {totalExpenses.toLocaleString()}
                </p>
              </div>
              <div>
                <p className="text-xs text-neutral">残予算</p>
                <p className={`text-lg font-bold ${remaining < 0 ? 'text-primary' : 'text-neutral-dark'}`}>
                  {trip.currency} {remaining.toLocaleString()}
                </p>
              </div>
            </div>
          </div>
        )}

        {/* Expense Count */}
        {trip.expense_count !== undefined && (
          <div className="flex items-center gap-2 text-sm text-neutral-dark pt-2 border-t">
            <span>💰</span>
            <span>{trip.expense_count} 件の支出記録</span>
          </div>
        )}
      </div>
    </Link>
  )
}
