import { describe, it, expect, vi } from 'vitest'
import { screen } from '@testing-library/react'
import userEvent from '@testing-library/user-event'
import { render } from '../../test/utils'
import { Button } from '../Button'

describe('Button', () => {
  it('テキストが正しく表示される', () => {
    render(<Button>クリック</Button>)
    expect(screen.getByText('クリック')).toBeInTheDocument()
  })

  it('クリックイベントが発火する', async () => {
    const handleClick = vi.fn()
    const user = userEvent.setup()

    render(<Button onClick={handleClick}>クリック</Button>)

    await user.click(screen.getByText('クリック'))
    expect(handleClick).toHaveBeenCalledTimes(1)
  })

  it('primaryバリアントが適用される', () => {
    render(<Button variant="primary">ボタン</Button>)

    const button = screen.getByText('ボタン')
    expect(button).toHaveClass('bg-primary')
  })

  it('secondaryバリアントが適用される', () => {
    render(<Button variant="secondary">ボタン</Button>)

    const button = screen.getByText('ボタン')
    expect(button).toHaveClass('bg-neutral')
  })

  it('outlineバリアントが適用される', () => {
    render(<Button variant="outline">ボタン</Button>)

    const button = screen.getByText('ボタン')
    expect(button).toHaveClass('border-2')
    expect(button).toHaveClass('border-primary')
  })

  it('ローディング状態の時は「処理中...」と表示される', () => {
    render(<Button isLoading>ボタン</Button>)

    expect(screen.getByText('処理中...')).toBeInTheDocument()
    expect(screen.queryByText('ボタン')).not.toBeInTheDocument()
  })

  it('ローディング状態の時はクリックできない', async () => {
    const handleClick = vi.fn()
    const user = userEvent.setup()

    render(<Button isLoading onClick={handleClick}>ボタン</Button>)

    const button = screen.getByRole('button')
    await user.click(button)

    expect(handleClick).not.toHaveBeenCalled()
    expect(button).toBeDisabled()
  })

  it('disabled状態の時はクリックできない', async () => {
    const handleClick = vi.fn()
    const user = userEvent.setup()

    render(<Button disabled onClick={handleClick}>ボタン</Button>)

    const button = screen.getByRole('button')
    await user.click(button)

    expect(handleClick).not.toHaveBeenCalled()
    expect(button).toBeDisabled()
  })

  it('カスタムクラスが適用される', () => {
    render(<Button className="custom-class">ボタン</Button>)

    const button = screen.getByText('ボタン')
    expect(button).toHaveClass('custom-class')
  })

  it('HTMLボタン属性が正しく渡される', () => {
    render(<Button type="submit" data-testid="submit-btn">送信</Button>)

    const button = screen.getByTestId('submit-btn')
    expect(button).toHaveAttribute('type', 'submit')
  })
})
