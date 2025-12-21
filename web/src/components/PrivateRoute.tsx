import { Navigate, useLocation } from 'react-router-dom'
import { useAuth } from '../contexts/AuthContext'

interface PrivateRouteProps {
  children: React.ReactNode
  requireOnboarding?: boolean
}

export function PrivateRoute({ children, requireOnboarding = true }: PrivateRouteProps) {
  const { user, loading, onboardingCompleted } = useAuth()
  const location = useLocation()

  if (loading) {
    return (
      <div className="min-h-screen flex items-center justify-center bg-neutral-light">
        <div className="text-center">
          <div className="w-16 h-16 border-4 border-primary border-t-transparent rounded-full animate-spin mx-auto mb-4" />
          <p className="text-neutral-dark">読み込み中...</p>
        </div>
      </div>
    )
  }

  if (!user) {
    return <Navigate to="/login" state={{ from: location }} replace />
  }

  // Redirect to onboarding if not completed and onboarding is required
  if (requireOnboarding && !onboardingCompleted && location.pathname !== '/onboarding') {
    return <Navigate to="/onboarding" replace />
  }

  return <>{children}</>
}
