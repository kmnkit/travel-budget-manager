import { ReactNode } from 'react'

interface AuthLayoutProps {
  children: ReactNode
  title: string
  subtitle?: string
}

export function AuthLayout({ children, title, subtitle }: AuthLayoutProps) {
  return (
    <div className="min-h-screen flex items-center justify-center bg-gradient-to-br from-neutral-light via-white to-primary-light/20 px-4">
      <div className="w-full max-w-md">
        {/* Logo/Header */}
        <div className="text-center mb-8">
          <div className="inline-flex items-center justify-center w-16 h-16 bg-primary rounded-2xl mb-4 shadow-lg">
            <span className="text-3xl">✈️</span>
          </div>
          <h1 className="text-3xl font-bold text-primary mb-2">
            {title}
          </h1>
          {subtitle && (
            <p className="text-neutral text-sm">
              {subtitle}
            </p>
          )}
        </div>

        {/* Auth Form Card */}
        <div className="bg-white rounded-2xl shadow-xl p-8 border border-gray-100">
          {children}
        </div>

        {/* Footer */}
        <p className="text-center text-neutral text-xs mt-6">
          Travel Expense Tracker © 2025
        </p>
      </div>
    </div>
  )
}
