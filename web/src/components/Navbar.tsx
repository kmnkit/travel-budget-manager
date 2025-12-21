import { Link } from 'react-router-dom'
import { useAuth } from '../contexts/AuthContext'

export function Navbar() {
  const { user, signOut } = useAuth()

  const handleSignOut = async () => {
    try {
      await signOut()
    } catch (error) {
      console.error('Sign out error:', error)
    }
  }

  return (
    <nav className="bg-white border-b border-gray-200 sticky top-0 z-50">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="flex justify-between items-center h-16">
          {/* Logo & Brand */}
          <Link to="/trips" className="flex items-center gap-3">
            <div className="w-10 h-10 bg-primary rounded-lg flex items-center justify-center">
              <span className="text-xl">✈️</span>
            </div>
            <span className="text-xl font-bold text-primary hidden sm:block">
              Travel Expense Tracker
            </span>
          </Link>

          {/* Navigation Links */}
          <div className="flex items-center gap-6">
            <Link
              to="/trips"
              className="text-neutral-dark hover:text-primary font-medium transition-colors"
            >
              旅行
            </Link>
            <Link
              to="/profile"
              className="text-neutral-dark hover:text-primary font-medium transition-colors"
            >
              プロフィール
            </Link>

            {/* User Menu */}
            {user && (
              <div className="flex items-center gap-4">
                <span className="text-sm text-neutral-dark hidden md:block">
                  {user.email}
                </span>
                <button
                  onClick={handleSignOut}
                  className="px-4 py-2 text-sm font-medium text-primary hover:bg-primary-light/20 rounded-lg transition-colors"
                >
                  ログアウト
                </button>
              </div>
            )}
          </div>
        </div>
      </div>
    </nav>
  )
}
