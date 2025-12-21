import { BrowserRouter as Router, Routes, Route } from 'react-router-dom'
import { Toaster } from 'react-hot-toast'

function App() {
  return (
    <Router>
      <div className="min-h-screen bg-neutral-light">
        <Toaster position="top-right" />
        <Routes>
          <Route path="/" element={
            <div className="flex items-center justify-center min-h-screen">
              <div className="text-center">
                <h1 className="text-4xl font-bold text-primary mb-4">
                  Travel Expense Tracker
                </h1>
                <p className="text-neutral-dark text-lg">
                  旅行支出トラッカー
                </p>
                <p className="text-neutral mt-2">
                  開発中...
                </p>
              </div>
            </div>
          } />
        </Routes>
      </div>
    </Router>
  )
}

export default App
