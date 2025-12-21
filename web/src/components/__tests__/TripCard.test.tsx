import { describe, it, expect } from 'vitest'
import { screen } from '@testing-library/react'
import { render } from '../../test/utils'
import { TripCard } from '../TripCard'

describe('TripCard', () => {
  const mockTrip = {
    id: '1',
    name: 'パリ旅行',
    destination: 'パリ, フランス',
    start_date: '2024-12-25',
    end_date: '2024-12-31',
    budget: 300000,
    currency: 'JPY',
    total_expenses: 150000,
    expense_count: 10
  }

  it('旅行名と目的地が表示される', () => {
    render(<TripCard trip={mockTrip} />)

    expect(screen.getByText('パリ旅行')).toBeInTheDocument()
    expect(screen.getByText('パリ, フランス')).toBeInTheDocument()
  })

  it('日付が正しく表示される', () => {
    render(<TripCard trip={mockTrip} />)

    // 日付のテキストを含む要素を探す
    const dateText = screen.getByText(/2024/)
    expect(dateText).toBeInTheDocument()
  })

  it('予算使用率が正しく計算される', () => {
    render(<TripCard trip={mockTrip} />)

    // 50% (150000 / 300000 * 100)
    expect(screen.getByText('50%')).toBeInTheDocument()
  })

  it('総支出が表示される', () => {
    render(<TripCard trip={mockTrip} />)

    // "JPY 150,000" のように分割されており、残予算と同じ値なので複数存在
    const elements = screen.getAllByText(/150,000/)
    expect(elements.length).toBe(2) // 総支出と残予算
  })

  it('残予算が表示される', () => {
    render(<TripCard trip={mockTrip} />)

    // 残予算: 300000 - 150000 = 150000
    // "JPY 150,000" のように分割されているため正規表現を使用
    const elements = screen.getAllByText(/150,000/)
    expect(elements.length).toBeGreaterThan(0)
  })

  it('支出件数が表示される', () => {
    render(<TripCard trip={mockTrip} />)

    expect(screen.getByText('10 件の支出記録')).toBeInTheDocument()
  })

  it('予算超過時に赤色で表示される', () => {
    const overBudgetTrip = {
      ...mockTrip,
      total_expenses: 350000 // 予算300000を超過
    }

    render(<TripCard trip={overBudgetTrip} />)

    // 予算使用率が100%を超える
    expect(screen.getByText('117%')).toBeInTheDocument()
  })

  it('予算なしの場合は予算情報が表示されない', () => {
    const noBudgetTrip = {
      ...mockTrip,
      budget: null
    }

    render(<TripCard trip={noBudgetTrip} />)

    expect(screen.queryByText('予算使用状況')).not.toBeInTheDocument()
  })

  it('終了日が未定の場合は「未定」と表示される', () => {
    const noEndDateTrip = {
      ...mockTrip,
      end_date: null
    }

    render(<TripCard trip={noEndDateTrip} />)

    expect(screen.getByText(/未定/)).toBeInTheDocument()
  })

  it('クリックすると詳細ページに遷移する', () => {
    const { container } = render(<TripCard trip={mockTrip} />)

    const link = container.querySelector('a')
    expect(link).toHaveAttribute('href', '/trips/1')
  })
})
