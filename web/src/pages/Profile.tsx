import { useState, useEffect } from 'react'
import { useNavigate } from 'react-router-dom'
import { Layout } from '../components/Layout'
import { Input } from '../components/Input'
import { Button } from '../components/Button'
import { useAuth } from '../contexts/AuthContext'
import { supabase } from '../lib/supabase'
import toast from 'react-hot-toast'

interface UserProfile {
  id: string
  email: string
  display_name: string | null
  onboarding_completed: boolean
  created_at: string
}

interface Stats {
  totalTrips: number
  totalExpenses: number
  totalAmount: number
  mostUsedCurrency: string
}

export function Profile() {
  const navigate = useNavigate()
  const { user, signOut } = useAuth()
  const [loading, setLoading] = useState(true)
  const [profile, setProfile] = useState<UserProfile | null>(null)
  const [stats, setStats] = useState<Stats>({
    totalTrips: 0,
    totalExpenses: 0,
    totalAmount: 0,
    mostUsedCurrency: 'JPY'
  })

  const [isEditingProfile, setIsEditingProfile] = useState(false)
  const [isChangingPassword, setIsChangingPassword] = useState(false)
  const [isSaving, setIsSaving] = useState(false)

  const [profileForm, setProfileForm] = useState({
    display_name: ''
  })

  const [passwordForm, setPasswordForm] = useState({
    currentPassword: '',
    newPassword: '',
    confirmPassword: ''
  })

  const [errors, setErrors] = useState<Record<string, string>>({})

  useEffect(() => {
    if (user) {
      fetchUserData()
    }
  }, [user])

  const fetchUserData = async () => {
    if (!user) return

    setLoading(true)

    try {
      // Fetch user profile
      const { data: profileData, error: profileError } = await supabase
        .from('users')
        .select('*')
        .eq('id', user.id)
        .single()

      if (profileError) {
        console.error('Error fetching profile:', profileError)
      } else if (profileData) {
        setProfile(profileData)
        setProfileForm({ display_name: profileData.display_name || '' })
      }

      // Fetch statistics
      const { data: tripsData } = await supabase
        .from('trips')
        .select('id, currency')
        .eq('user_id', user.id)

      const { data: expensesData } = await supabase
        .from('expenses')
        .select('amount, currency')
        .eq('user_id', user.id)

      const totalTrips = tripsData?.length || 0
      const totalExpenses = expensesData?.length || 0
      const totalAmount = expensesData?.reduce((sum, exp) => sum + exp.amount, 0) || 0

      // Find most used currency
      const currencyCount = new Map<string, number>()
      expensesData?.forEach(exp => {
        currencyCount.set(exp.currency, (currencyCount.get(exp.currency) || 0) + 1)
      })
      const mostUsedCurrency = Array.from(currencyCount.entries())
        .sort((a, b) => b[1] - a[1])[0]?.[0] || 'JPY'

      setStats({
        totalTrips,
        totalExpenses,
        totalAmount,
        mostUsedCurrency
      })
    } catch (error) {
      console.error('Error fetching user data:', error)
      toast.error('データの取得に失敗しました')
    } finally {
      setLoading(false)
    }
  }

  const handleProfileSubmit = async (e: React.FormEvent) => {
    e.preventDefault()

    if (!user) return

    setIsSaving(true)

    try {
      const { error } = await supabase
        .from('users')
        .update({
          display_name: profileForm.display_name.trim() || null
        })
        .eq('id', user.id)

      if (error) {
        console.error('Error updating profile:', error)
        toast.error('プロフィールの更新に失敗しました')
        setIsSaving(false)
        return
      }

      toast.success('プロフィールを更新しました')
      setIsEditingProfile(false)
      fetchUserData()
    } catch (error) {
      console.error('Error updating profile:', error)
      toast.error('エラーが発生しました')
    } finally {
      setIsSaving(false)
    }
  }

  const handlePasswordSubmit = async (e: React.FormEvent) => {
    e.preventDefault()

    const newErrors: Record<string, string> = {}

    if (passwordForm.newPassword.length < 6) {
      newErrors.newPassword = 'パスワードは6文字以上である必要があります'
    }

    if (passwordForm.newPassword !== passwordForm.confirmPassword) {
      newErrors.confirmPassword = 'パスワードが一致しません'
    }

    if (Object.keys(newErrors).length > 0) {
      setErrors(newErrors)
      return
    }

    setIsSaving(true)

    try {
      const { error } = await supabase.auth.updateUser({
        password: passwordForm.newPassword
      })

      if (error) {
        console.error('Error updating password:', error)
        toast.error('パスワードの変更に失敗しました')
        setIsSaving(false)
        return
      }

      toast.success('パスワードを変更しました')
      setIsChangingPassword(false)
      setPasswordForm({ currentPassword: '', newPassword: '', confirmPassword: '' })
      setErrors({})
    } catch (error) {
      console.error('Error updating password:', error)
      toast.error('エラーが発生しました')
    } finally {
      setIsSaving(false)
    }
  }

  const handleDeleteAccount = async () => {
    if (!user) return

    const confirmed = window.confirm(
      '本当にアカウントを削除しますか？この操作は取り消せません。すべての旅行と支出データが削除されます。'
    )
    if (!confirmed) return

    const doubleConfirm = window.confirm(
      '最終確認：本当にアカウントを削除しますか？'
    )
    if (!doubleConfirm) return

    try {
      // Delete user data (cascading deletes will handle trips, expenses, categories)
      const { error: deleteError } = await supabase
        .from('users')
        .delete()
        .eq('id', user.id)

      if (deleteError) {
        console.error('Error deleting user data:', deleteError)
        toast.error('アカウントの削除に失敗しました')
        return
      }

      // Sign out
      await signOut()
      toast.success('アカウントを削除しました')
      navigate('/login')
    } catch (error) {
      console.error('Error deleting account:', error)
      toast.error('エラーが発生しました')
    }
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
      <div className="max-w-4xl mx-auto">
        {/* Header */}
        <div className="mb-8">
          <h1 className="text-3xl font-bold text-neutral-dark mb-2">
            プロフィール
          </h1>
          <p className="text-neutral">
            アカウント情報と設定
          </p>
        </div>

        {/* User Info Card */}
        <div className="bg-white rounded-xl shadow-md p-6 mb-6">
          <div className="flex items-center gap-4 mb-6">
            <div className="w-20 h-20 bg-gradient-to-br from-primary to-primary-dark rounded-full flex items-center justify-center text-white text-3xl font-bold">
              {profile?.display_name?.[0]?.toUpperCase() || user?.email?.[0]?.toUpperCase() || '?'}
            </div>
            <div>
              <h2 className="text-2xl font-bold text-neutral-dark">
                {profile?.display_name || 'ユーザー'}
              </h2>
              <p className="text-neutral">{user?.email}</p>
              <p className="text-sm text-neutral mt-1">
                登録日: {profile?.created_at ? new Date(profile.created_at).toLocaleDateString('ja-JP') : 'N/A'}
              </p>
            </div>
          </div>

          {!isEditingProfile ? (
            <Button
              variant="outline"
              onClick={() => setIsEditingProfile(true)}
            >
              プロフィールを編集
            </Button>
          ) : (
            <form onSubmit={handleProfileSubmit} className="space-y-4">
              <Input
                type="text"
                label="表示名"
                placeholder="例: 山田太郎"
                value={profileForm.display_name}
                onChange={(e) => setProfileForm({ display_name: e.target.value })}
              />
              <div className="flex gap-2">
                <Button type="submit" isLoading={isSaving}>
                  保存
                </Button>
                <Button
                  type="button"
                  variant="outline"
                  onClick={() => {
                    setIsEditingProfile(false)
                    setProfileForm({ display_name: profile?.display_name || '' })
                  }}
                >
                  キャンセル
                </Button>
              </div>
            </form>
          )}
        </div>

        {/* Statistics Card */}
        <div className="bg-white rounded-xl shadow-md p-6 mb-6">
          <h3 className="text-xl font-bold text-neutral-dark mb-4">統計情報</h3>
          <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
            <div className="text-center p-4 bg-neutral-light rounded-lg">
              <p className="text-3xl font-bold text-primary">{stats.totalTrips}</p>
              <p className="text-sm text-neutral mt-1">旅行数</p>
            </div>
            <div className="text-center p-4 bg-neutral-light rounded-lg">
              <p className="text-3xl font-bold text-primary">{stats.totalExpenses}</p>
              <p className="text-sm text-neutral mt-1">支出記録</p>
            </div>
            <div className="text-center p-4 bg-neutral-light rounded-lg">
              <p className="text-3xl font-bold text-primary">
                {stats.mostUsedCurrency} {Math.round(stats.totalAmount).toLocaleString()}
              </p>
              <p className="text-sm text-neutral mt-1">総支出額</p>
            </div>
            <div className="text-center p-4 bg-neutral-light rounded-lg">
              <p className="text-3xl font-bold text-primary">
                {stats.totalExpenses > 0 ? Math.round(stats.totalAmount / stats.totalExpenses).toLocaleString() : 0}
              </p>
              <p className="text-sm text-neutral mt-1">平均支出額</p>
            </div>
          </div>
        </div>

        {/* Security Settings */}
        <div className="bg-white rounded-xl shadow-md p-6 mb-6">
          <h3 className="text-xl font-bold text-neutral-dark mb-4">セキュリティ</h3>

          {!isChangingPassword ? (
            <Button
              variant="outline"
              onClick={() => setIsChangingPassword(true)}
            >
              パスワードを変更
            </Button>
          ) : (
            <form onSubmit={handlePasswordSubmit} className="space-y-4">
              <Input
                type="password"
                label="新しいパスワード"
                placeholder="6文字以上"
                value={passwordForm.newPassword}
                onChange={(e) => {
                  setPasswordForm(prev => ({ ...prev, newPassword: e.target.value }))
                  setErrors(prev => ({ ...prev, newPassword: '' }))
                }}
                error={errors.newPassword}
              />
              <Input
                type="password"
                label="パスワード確認"
                placeholder="新しいパスワードを再入力"
                value={passwordForm.confirmPassword}
                onChange={(e) => {
                  setPasswordForm(prev => ({ ...prev, confirmPassword: e.target.value }))
                  setErrors(prev => ({ ...prev, confirmPassword: '' }))
                }}
                error={errors.confirmPassword}
              />
              <div className="flex gap-2">
                <Button type="submit" isLoading={isSaving}>
                  パスワードを変更
                </Button>
                <Button
                  type="button"
                  variant="outline"
                  onClick={() => {
                    setIsChangingPassword(false)
                    setPasswordForm({ currentPassword: '', newPassword: '', confirmPassword: '' })
                    setErrors({})
                  }}
                >
                  キャンセル
                </Button>
              </div>
            </form>
          )}
        </div>

        {/* Danger Zone */}
        <div className="bg-white rounded-xl shadow-md p-6 border-2 border-primary/20">
          <h3 className="text-xl font-bold text-primary mb-2">危険な操作</h3>
          <p className="text-neutral mb-4">
            アカウントを削除すると、すべてのデータが完全に削除されます。この操作は取り消せません。
          </p>
          <Button
            variant="outline"
            onClick={handleDeleteAccount}
            className="border-primary text-primary hover:bg-primary hover:text-white"
          >
            アカウントを削除
          </Button>
        </div>
      </div>
    </Layout>
  )
}
