import { useState, useEffect } from 'react'
import { useNavigate } from 'react-router-dom'
import { Layout } from '../components/Layout'
import { Button } from '../components/Button'
import { useAuth } from '../contexts/AuthContext'
import { supabase } from '../lib/supabase'
import toast from 'react-hot-toast'

interface Category {
  id: string
  user_id: string | null
  name: string
  icon: string | null
  color: string | null
  is_default: boolean
  created_at: string
}

export function CategoryList() {
  const navigate = useNavigate()
  const { user } = useAuth()
  const [categories, setCategories] = useState<Category[]>([])
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    if (user) {
      fetchCategories()
    }
  }, [user])

  const fetchCategories = async () => {
    if (!user) return

    setLoading(true)

    try {
      const { data, error } = await supabase
        .from('categories')
        .select('*')
        .or(`is_default.eq.true,user_id.eq.${user.id}`)
        .order('is_default', { ascending: false })
        .order('name')

      if (error) {
        console.error('Error fetching categories:', error)
        toast.error('カテゴリーの取得に失敗しました')
        return
      }

      setCategories(data || [])
    } catch (error) {
      console.error('Error fetching categories:', error)
      toast.error('エラーが発生しました')
    } finally {
      setLoading(false)
    }
  }

  const handleDelete = async (categoryId: string) => {
    if (!user) return

    const confirmed = window.confirm('このカテゴリーを削除してもよろしいですか？')
    if (!confirmed) return

    try {
      const { error } = await supabase
        .from('categories')
        .delete()
        .eq('id', categoryId)
        .eq('user_id', user.id)

      if (error) {
        console.error('Error deleting category:', error)
        toast.error('カテゴリーの削除に失敗しました')
        return
      }

      toast.success('カテゴリーを削除しました')
      fetchCategories()
    } catch (error) {
      console.error('Error deleting category:', error)
      toast.error('エラーが発生しました')
    }
  }

  const defaultCategories = categories.filter(cat => cat.is_default)
  const userCategories = categories.filter(cat => !cat.is_default)

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
      <div className="max-w-4xl mx-auto">
        {/* Header */}
        <div className="flex justify-between items-center mb-8">
          <div>
            <h1 className="text-3xl font-bold text-neutral-dark mb-2">
              カテゴリー管理
            </h1>
            <p className="text-neutral">
              支出カテゴリーを管理します
            </p>
          </div>
          <Button onClick={() => navigate('/categories/new')}>
            + カテゴリーを追加
          </Button>
        </div>

        {/* User Categories */}
        <div className="bg-white rounded-xl shadow-md p-6 mb-6">
          <h2 className="text-xl font-bold text-neutral-dark mb-4">
            マイカテゴリー
          </h2>

          {userCategories.length > 0 ? (
            <div className="space-y-3">
              {userCategories.map((category) => (
                <div
                  key={category.id}
                  className="flex items-center justify-between p-4 border border-gray-200 rounded-lg hover:border-primary/30 transition-colors"
                >
                  <div className="flex items-center gap-4">
                    <div
                      className="w-12 h-12 rounded-full flex items-center justify-center text-2xl"
                      style={{
                        backgroundColor: category.color
                          ? `${category.color}20`
                          : '#F8B4B4'
                      }}
                    >
                      {category.icon || '📌'}
                    </div>
                    <div>
                      <h3 className="font-semibold text-neutral-dark">
                        {category.name}
                      </h3>
                      <p className="text-sm text-neutral">
                        カスタムカテゴリー
                      </p>
                    </div>
                  </div>
                  <div className="flex gap-2">
                    <Button
                      variant="outline"
                      onClick={() => navigate(`/categories/${category.id}/edit`)}
                    >
                      編集
                    </Button>
                    <Button
                      variant="outline"
                      onClick={() => handleDelete(category.id)}
                      className="border-primary text-primary hover:bg-primary hover:text-white"
                    >
                      削除
                    </Button>
                  </div>
                </div>
              ))}
            </div>
          ) : (
            <div className="text-center py-12">
              <div className="text-6xl mb-4">📁</div>
              <h3 className="text-xl font-semibold text-neutral-dark mb-2">
                カスタムカテゴリーがありません
              </h3>
              <p className="text-neutral mb-6">
                独自のカテゴリーを作成して、支出を整理しましょう
              </p>
              <Button onClick={() => navigate('/categories/new')}>
                カテゴリーを追加
              </Button>
            </div>
          )}
        </div>

        {/* Default Categories */}
        <div className="bg-white rounded-xl shadow-md p-6">
          <h2 className="text-xl font-bold text-neutral-dark mb-4">
            デフォルトカテゴリー
          </h2>

          {defaultCategories.length > 0 ? (
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-3">
              {defaultCategories.map((category) => (
                <div
                  key={category.id}
                  className="flex items-center gap-3 p-4 border border-gray-200 rounded-lg"
                >
                  <div
                    className="w-10 h-10 rounded-full flex items-center justify-center text-xl"
                    style={{
                      backgroundColor: category.color
                        ? `${category.color}20`
                        : '#F8B4B4'
                    }}
                  >
                    {category.icon || '📌'}
                  </div>
                  <div className="flex-1">
                    <h3 className="font-medium text-neutral-dark text-sm">
                      {category.name}
                    </h3>
                  </div>
                </div>
              ))}
            </div>
          ) : (
            <p className="text-neutral text-center py-4">
              デフォルトカテゴリーがありません
            </p>
          )}
        </div>
      </div>
    </Layout>
  )
}
