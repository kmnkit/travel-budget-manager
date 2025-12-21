import { BrowserRouter as Router, Routes, Route, Navigate } from 'react-router-dom'
import { Toaster } from 'react-hot-toast'
import { AuthProvider } from './contexts/AuthContext'
import { PrivateRoute } from './components/PrivateRoute'
import { Login } from './pages/Login'
import { Signup } from './pages/Signup'
import { Onboarding } from './pages/Onboarding'
import { TripList } from './pages/TripList'
import { TripForm } from './pages/TripForm'
import { TripDetail } from './pages/TripDetail'
import { ExpenseForm } from './pages/ExpenseForm'
import { ExpenseDetail } from './pages/ExpenseDetail'
import { CategoryList } from './pages/CategoryList'
import { CategoryForm } from './pages/CategoryForm'
import { TripReport } from './pages/TripReport'

function App() {
  return (
    <Router>
      <AuthProvider>
        <Toaster position="top-right" />
        <Routes>
          {/* Public Auth Routes */}
          <Route path="/login" element={<Login />} />
          <Route path="/signup" element={<Signup />} />

          {/* Onboarding Route - Requires auth but not onboarding completion */}
          <Route
            path="/onboarding"
            element={
              <PrivateRoute requireOnboarding={false}>
                <Onboarding />
              </PrivateRoute>
            }
          />

          {/* Protected Routes - Require auth AND onboarding completion */}
          <Route
            path="/trips"
            element={
              <PrivateRoute>
                <TripList />
              </PrivateRoute>
            }
          />

          <Route
            path="/trips/new"
            element={
              <PrivateRoute>
                <TripForm />
              </PrivateRoute>
            }
          />

          <Route
            path="/trips/:id"
            element={
              <PrivateRoute>
                <TripDetail />
              </PrivateRoute>
            }
          />

          <Route
            path="/trips/:tripId/expenses/new"
            element={
              <PrivateRoute>
                <ExpenseForm />
              </PrivateRoute>
            }
          />

          <Route
            path="/trips/:tripId/expenses/:expenseId"
            element={
              <PrivateRoute>
                <ExpenseDetail />
              </PrivateRoute>
            }
          />

          <Route
            path="/trips/:tripId/expenses/:expenseId/edit"
            element={
              <PrivateRoute>
                <ExpenseForm />
              </PrivateRoute>
            }
          />

          <Route
            path="/trips/:id/edit"
            element={
              <PrivateRoute>
                <TripForm />
              </PrivateRoute>
            }
          />

          <Route
            path="/trips/:id/report"
            element={
              <PrivateRoute>
                <TripReport />
              </PrivateRoute>
            }
          />

          <Route
            path="/categories"
            element={
              <PrivateRoute>
                <CategoryList />
              </PrivateRoute>
            }
          />

          <Route
            path="/categories/new"
            element={
              <PrivateRoute>
                <CategoryForm />
              </PrivateRoute>
            }
          />

          <Route
            path="/categories/:id/edit"
            element={
              <PrivateRoute>
                <CategoryForm />
              </PrivateRoute>
            }
          />

          {/* TODO: Add more protected routes */}
          {/*
          <Route path="/profile" element={<PrivateRoute><Profile /></PrivateRoute>} />
          */}

          {/* Home Route - Redirect to trips if authenticated, otherwise login */}
          <Route path="/" element={<Navigate to="/trips" replace />} />
        </Routes>
      </AuthProvider>
    </Router>
  )
}

export default App
