import { BrowserRouter as Router, Routes, Route, Navigate } from 'react-router-dom'
import { Toaster } from 'react-hot-toast'
import { AuthProvider } from './contexts/AuthContext'
import { Login } from './pages/Login'
import { Signup } from './pages/Signup'

function App() {
  return (
    <Router>
      <AuthProvider>
        <Toaster position="top-right" />
        <Routes>
          {/* Auth Routes */}
          <Route path="/login" element={<Login />} />
          <Route path="/signup" element={<Signup />} />

          {/* Temporary Home Route - Redirect to login for now */}
          <Route path="/" element={<Navigate to="/login" replace />} />

          {/* TODO: Add protected routes for authenticated users */}
          {/*
          <Route path="/dashboard" element={<Dashboard />} />
          <Route path="/trips" element={<TripList />} />
          <Route path="/trips/:id" element={<TripDetail />} />
          */}
        </Routes>
      </AuthProvider>
    </Router>
  )
}

export default App
