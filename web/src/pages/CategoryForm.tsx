import { useState, useEffect } from 'react'
import { useNavigate, useParams } from 'react-router-dom'
import { Layout } from '../components/Layout'
import { Input } from '../components/Input'
import { Button } from '../components/Button'
import { useAuth } from '../contexts/AuthContext'
import { supabase } from '../lib/supabase'
import toast from 'react-hot-toast'

// Common emoji icons for categories
const EMOJI_PRESETS = [
  '🍔', '🍕', '🍜', '🍱', '☕', '🍺', // Food & Drink
  '🚕', '🚌', '🚇', '✈️', '🚗', '⛽', // Transportation
  '🏨', '🏠', '🏖️', '🎪', '🎭', '🎨', // Accommodation & Entertainment
  '🛍️', '👕', '👟', '💄', '🎁', '📱', // Shopping
  '💊', '🏥', '💆', '🧘', '⚕️', '🩺', // Health
  '📚', '✏️', '🎓', '📖', '🖊️', '📝', // Education
  '💰', '💳', '💵', '🏦', '📊', '💸', // Finance
  '🎮', '🎬', '🎵', '🎤', '🎯', '⚽', // Entertainment & Sports
  '📌', '🔖', '⭐', '❤️', '✨', '🌟'  // Others
]

// Common colors for categories
const COLOR_PRESETS = [
  '#E63946', '#F77F00', '#FFB703', '#06D6A0', '#118AB2',
  '#073B4C', '#8338EC', '#FF006E', '#3A86FF', '#FB5607'
]

export function CategoryForm() {
  const { id } = useParams<{ id: string }>()
  const navigate = useNavigate()
  const { user } = useAuth()
  const [isLoading, setIsLoading] = useState(false)
  const isEditMode = !!id

  const [formData, setFormData] = useState({
    name: '',
    icon: '📌',
    color: '#E63946'
  })

  const [errors, setErrors] = useState<Record<string, string>>({})

  useEffect(() => {
    if (isEditMode && id && user) {
      fetchCategoryData()
    }
  }, [isEditMode, id, user])

  const fetchCategoryData = async () => {
    if (!id || !user) return

    try {
      const { data, error } = await supabase
        .from('categories')
        .select('*')
        .eq('id', id)
        .eq('user_id', user.id)
        .single()

      if (error) {
        console.error('Error fetching category:', error)
        toast.error('カテゴリーが見つかりません')
        navigate('/categories')
        return
      }

      setFormData({
        name: data.name,
        icon: data.icon || '📌',
        color: data.color || '#E63946'
      })
    } catch (error) {
      console.error('Error fetching category:', error)
      toast.error('エラーが発生しました')
    }
  }

  const handleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const { name, value } = e.target
    setFormData(prev => ({ ...prev, [name]: value }))

    if (errors[name]) {
      setErrors(prev => ({ ...prev, [name]: '' }))
    }
  }

  const validateForm = () => {
    const newErrors: Record<string, string> = {}

    if (!formData.name.trim()) {
      newErrors.name = 'カテゴリー名を入力してください'
    }

    setErrors(newErrors)
    return Object.keys(newErrors).length === 0
  }

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault()

    if (!validateForm()) {
      return
    }

    if (!user) {
      toast.error('ログインが必要です')
      navigate('/login')
      return
    }

    setIsLoading(true)

    try {
      const categoryData = {
        name: formData.name.trim(),
        icon: formData.icon || null,
        color: formData.color || null
      }

      if (isEditMode && id) {
        // Update existing category
        const { error } = await supabase
          .from('categories')
          .update(categoryData)
          .eq('id', id)
          .eq('user_id', user.id)

        if (error) {
          console.error('Error updating category:', error)
          toast.error('カテゴリーの更新に失敗しました')
          setIsLoading(false)
          return
        }

        toast.success('カテゴリーを更新しました！')
        navigate('/categories')
      } else {
        // Create new category
        const newCategoryData = {
          ...categoryData,
          user_id: user.id,
          is_default: false
        }

        const { error } = await supabase
          .from('categories')
          .insert([newCategoryData])

        if (error) {
          console.error('Error creating category:', error)
          toast.error('カテゴリーの作成に失敗しました')
          setIsLoading(false)
          return
        }

        toast.success('カテゴリーを作成しました！')
        navigate('/categories')
      }
    } catch (error) {
      console.error('Error saving category:', error)
      toast.error('エラーが発生しました')
      setIsLoading(false)
    }
  }

  const handleCancel = () => {
    navigate('/categories')
  }

  return (
    <Layout>
      <div className="max-w-2xl mx-auto">
        {/* Header */}
        <div className="mb-8">
          <h1 className="text-3xl font-bold text-neutral-dark mb-2">
            {isEditMode ? 'カテゴリーを編集' : 'カテゴリーを作成'}
          </h1>
          <p className="text-neutral">
            {isEditMode ? 'カテゴリーの詳細を更新してください' : 'カテゴリーの詳細を入力してください'}
          </p>
        </div>

        {/* Form */}
        <form onSubmit={handleSubmit} className="bg-white rounded-xl shadow-md p-8 space-y-6">
          {/* Category Name */}
          <Input
            type="text"
            name="name"
            label="カテゴリー名"
            placeholder="例: レストラン"
            value={formData.name}
            onChange={handleChange}
            error={errors.name}
            required
          />

          {/* Icon Selection */}
          <div>
            <label className="block text-sm font-medium text-neutral-dark mb-2">
              アイコン
            </label>
            <div className="mb-3">
              <Input
                type="text"
                name="icon"
                placeholder="絵文字を入力"
                value={formData.icon}
                onChange={handleChange}
                className="text-2xl"
              />
            </div>
            <div className="grid grid-cols-10 gap-2">
              {EMOJI_PRESETS.map((emoji) => (
                <button
                  key={emoji}
                  type="button"
                  onClick={() => setFormData(prev => ({ ...prev, icon: emoji }))}
                  className={`w-10 h-10 rounded-lg border-2 flex items-center justify-center text-xl transition-all ${
                    formData.icon === emoji
                      ? 'border-primary bg-primary/10'
                      : 'border-gray-200 hover:border-primary/50'
                  }`}
                >
                  {emoji}
                </button>
              ))}
            </div>
          </div>

          {/* Color Selection */}
          <div>
            <label className="block text-sm font-medium text-neutral-dark mb-2">
              カラー
            </label>
            <div className="mb-3">
              <Input
                type="color"
                name="color"
                value={formData.color}
                onChange={handleChange}
                className="h-12"
              />
            </div>
            <div className="flex gap-2">
              {COLOR_PRESETS.map((color) => (
                <button
                  key={color}
                  type="button"
                  onClick={() => setFormData(prev => ({ ...prev, color }))}
                  className={`w-10 h-10 rounded-lg border-2 transition-all ${
                    formData.color === color
                      ? 'border-neutral-dark scale-110'
                      : 'border-gray-300 hover:scale-105'
                  }`}
                  style={{ backgroundColor: color }}
                />
              ))}
            </div>
          </div>

          {/* Preview */}
          <div>
            <label className="block text-sm font-medium text-neutral-dark mb-2">
              プレビュー
            </label>
            <div className="flex items-center gap-4 p-6 border border-gray-200 rounded-lg bg-neutral-light">
              <div
                className="w-16 h-16 rounded-full flex items-center justify-center text-3xl"
                style={{
                  backgroundColor: formData.color ? `${formData.color}20` : '#F8B4B420'
                }}
              >
                {formData.icon}
              </div>
              <div>
                <h3 className="text-lg font-semibold text-neutral-dark">
                  {formData.name || 'カテゴリー名'}
                </h3>
                <p className="text-sm text-neutral">カスタムカテゴリー</p>
              </div>
            </div>
          </div>

          {/* Actions */}
          <div className="flex gap-4 pt-4">
            <Button
              type="button"
              variant="outline"
              onClick={handleCancel}
              className="flex-1"
            >
              キャンセル
            </Button>
            <Button
              type="submit"
              isLoading={isLoading}
              className="flex-1"
            >
              {isEditMode ? '更新' : '作成'}
            </Button>
          </div>
        </form>
      </div>
    </Layout>
  )
}
