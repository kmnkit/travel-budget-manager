import { BrowserRouter as Router, Routes, Route, Navigate } from 'react-router-dom'
import { Toaster } from 'react-hot-toast'
import { AuthProvider } from './contexts/AuthContext'
import { PrivateRoute } from './components/PrivateRoute'
import { Login } from './pages/Login'
import { Signup } from './pages/Signup'
import { TripList } from './pages/TripList'

function App() {
  return (
    <Router>
      <AuthProvider>
        <Toaster position="top-right" />
        <Routes>
          {/* Public Auth Routes */}
          <Route path="/login" element={<Login />} />
          <Route path="/signup" element={<Signup />} />

          {/* Protected Routes */}
          <Route
            path="/trips"
            element={
              <PrivateRoute>
                <TripList />
              </PrivateRoute>
            }
          />

          {/* TODO: Add more protected routes */}
          {/*
          <Route path="/trips/:id" element={<PrivateRoute><TripDetail /></PrivateRoute>} />
          <Route path="/trips/new" element={<PrivateRoute><TripForm /></PrivateRoute>} />
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
