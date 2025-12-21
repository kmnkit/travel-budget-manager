export const mockTrip = {
  id: '1',
  user_id: 'user-1',
  name: 'パリ旅行',
  destination: 'パリ, フランス',
  start_date: '2024-12-25',
  end_date: '2024-12-31',
  budget: 300000,
  currency: 'JPY',
  created_at: '2024-12-01T00:00:00Z'
}

export const mockTrips = [
  mockTrip,
  {
    id: '2',
    user_id: 'user-1',
    name: '東京出張',
    destination: '東京, 日本',
    start_date: '2025-01-15',
    end_date: '2025-01-20',
    budget: 100000,
    currency: 'JPY',
    created_at: '2024-12-05T00:00:00Z'
  },
  {
    id: '3',
    user_id: 'user-1',
    name: 'バリ島バケーション',
    destination: 'バリ島, インドネシア',
    start_date: '2025-03-01',
    end_date: '2025-03-10',
    budget: 250000,
    currency: 'JPY',
    created_at: '2024-12-10T00:00:00Z'
  }
]

export const mockCategory = {
  id: 'cat-1',
  name: '食事',
  color: '#FF6B6B',
  icon: '🍽️',
  user_id: 'user-1',
  is_default: true,
  created_at: '2024-12-01T00:00:00Z'
}

export const mockCategories = [
  mockCategory,
  {
    id: 'cat-2',
    name: '交通費',
    color: '#4ECDC4',
    icon: '🚗',
    user_id: 'user-1',
    is_default: true,
    created_at: '2024-12-01T00:00:00Z'
  },
  {
    id: 'cat-3',
    name: '宿泊',
    color: '#95E1D3',
    icon: '🏨',
    user_id: 'user-1',
    is_default: true,
    created_at: '2024-12-01T00:00:00Z'
  }
]

export const mockExpense = {
  id: 'exp-1',
  trip_id: '1',
  category_id: 'cat-1',
  amount: 3500,
  currency: 'JPY',
  description: 'ランチ',
  notes: 'カフェでサンドイッチ',
  expense_date: '2024-12-25',
  location: 'パリ',
  payment_method: 'クレジットカード',
  created_at: '2024-12-25T12:00:00Z'
}

export const mockExpenses = [
  mockExpense,
  {
    id: 'exp-2',
    trip_id: '1',
    category_id: 'cat-2',
    amount: 1500,
    currency: 'JPY',
    description: 'メトロ',
    notes: null,
    expense_date: '2024-12-25',
    location: 'パリ',
    payment_method: '現金',
    created_at: '2024-12-25T09:00:00Z'
  },
  {
    id: 'exp-3',
    trip_id: '1',
    category_id: 'cat-3',
    amount: 15000,
    currency: 'JPY',
    description: 'ホテル宿泊',
    notes: '1泊分',
    expense_date: '2024-12-25',
    location: 'パリ',
    payment_method: 'クレジットカード',
    created_at: '2024-12-25T15:00:00Z'
  }
]

export const mockUser = {
  id: 'user-1',
  email: 'test@example.com',
  created_at: '2024-11-01T00:00:00Z'
}

export const mockSession = {
  access_token: 'mock-access-token',
  refresh_token: 'mock-refresh-token',
  expires_in: 3600,
  token_type: 'bearer',
  user: mockUser
}
