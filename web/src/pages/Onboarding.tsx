import { useState } from 'react'
import { useNavigate } from 'react-router-dom'
import { Button } from '../components/Button'
import { useAuth } from '../contexts/AuthContext'
import { supabase } from '../lib/supabase'
import toast from 'react-hot-toast'

interface OnboardingSlide {
  title: string
  description: string
  emoji: string
}

const slides: OnboardingSlide[] = [
  {
    emoji: '✈️',
    title: 'Travel Expense Tracker へようこそ',
    description: '海外旅行での支出を簡単に記録・管理できるアプリです。レシートをスキャンして自動的に金額を読み取ることもできます。'
  },
  {
    emoji: '🗺️',
    title: '旅行ごとに支出を管理',
    description: '旅行ごとに支出を整理できます。予算を設定して、使いすぎを防ぎましょう。'
  },
  {
    emoji: '💰',
    title: 'カテゴリー別に分類',
    description: '食事、宿泊、交通など、カテゴリー別に支出を記録できます。どこにお金を使ったか一目瞭然です。'
  },
  {
    emoji: '📊',
    title: 'レポートで振り返り',
    description: '旅行の支出をグラフで可視化。予算との比較や、カテゴリー別の内訳を確認できます。'
  },
  {
    emoji: '🚀',
    title: 'さあ、始めましょう！',
    description: '最初の旅行を作成して、支出の記録を始めましょう。'
  }
]

export function Onboarding() {
  const [currentSlide, setCurrentSlide] = useState(0)
  const [isLoading, setIsLoading] = useState(false)
  const navigate = useNavigate()
  const { user, refreshOnboardingStatus } = useAuth()

  const isLastSlide = currentSlide === slides.length - 1

  const handleNext = () => {
    if (isLastSlide) {
      handleComplete()
    } else {
      setCurrentSlide(prev => prev + 1)
    }
  }

  const handlePrev = () => {
    if (currentSlide > 0) {
      setCurrentSlide(prev => prev - 1)
    }
  }

  const handleSkip = () => {
    handleComplete()
  }

  const handleComplete = async () => {
    setIsLoading(true)

    try {
      // Update user's onboarding_completed status
      if (user) {
        const { error } = await supabase
          .from('users')
          .update({ onboarding_completed: true })
          .eq('id', user.id)

        if (error) {
          console.error('Error updating onboarding status:', error)
          toast.error('エラーが発生しました')
          setIsLoading(false)
          return
        }

        // Refresh the onboarding status in AuthContext
        await refreshOnboardingStatus()
      }

      toast.success('ようこそ！さあ始めましょう 🎉')
      navigate('/trips')
    } catch (error) {
      console.error('Onboarding completion error:', error)
      toast.error('エラーが発生しました')
      setIsLoading(false)
    }
  }

  const slide = slides[currentSlide]

  return (
    <div className="min-h-screen flex items-center justify-center bg-gradient-to-br from-neutral-light via-white to-primary-light/20 px-4">
      <div className="w-full max-w-2xl">
        {/* Skip Button */}
        {!isLastSlide && (
          <div className="flex justify-end mb-4">
            <button
              onClick={handleSkip}
              className="text-neutral hover:text-neutral-dark transition-colors text-sm font-medium"
            >
              スキップ →
            </button>
          </div>
        )}

        {/* Slide Content */}
        <div className="bg-white rounded-2xl shadow-xl p-12 border border-gray-100">
          <div className="text-center space-y-6">
            {/* Emoji Icon */}
            <div className="text-8xl mb-6 animate-bounce-slow">
              {slide.emoji}
            </div>

            {/* Title */}
            <h1 className="text-3xl font-bold text-primary mb-4">
              {slide.title}
            </h1>

            {/* Description */}
            <p className="text-lg text-neutral-dark leading-relaxed max-w-lg mx-auto">
              {slide.description}
            </p>

            {/* Progress Dots */}
            <div className="flex justify-center gap-2 py-6">
              {slides.map((_, index) => (
                <button
                  key={index}
                  onClick={() => setCurrentSlide(index)}
                  className={`w-3 h-3 rounded-full transition-all duration-300 ${
                    index === currentSlide
                      ? 'bg-primary w-8'
                      : 'bg-gray-300 hover:bg-gray-400'
                  }`}
                  aria-label={`スライド ${index + 1} へ移動`}
                />
              ))}
            </div>

            {/* Navigation Buttons */}
            <div className="flex gap-4 pt-4">
              {currentSlide > 0 && (
                <Button
                  variant="outline"
                  onClick={handlePrev}
                  className="flex-1"
                >
                  ← 戻る
                </Button>
              )}

              <Button
                onClick={handleNext}
                isLoading={isLoading}
                className={currentSlide === 0 ? 'w-full' : 'flex-1'}
              >
                {isLastSlide ? '始める' : '次へ →'}
              </Button>
            </div>
          </div>
        </div>

        {/* Footer */}
        <p className="text-center text-neutral text-xs mt-6">
          {currentSlide + 1} / {slides.length}
        </p>
      </div>
    </div>
  )
}
