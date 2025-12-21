-- Travel Expense Tracker - Initial Database Schema
-- Author: Claude
-- Date: 2025-01-01

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- =====================================================
-- Users Table
-- =====================================================
CREATE TABLE IF NOT EXISTS users (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  email TEXT NOT NULL UNIQUE,
  display_name TEXT,
  profile_image_url TEXT,
  onboarding_completed BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Create index on email for faster lookups
CREATE INDEX idx_users_email ON users(email);

-- Create trigger to auto-update updated_at
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER users_updated_at
BEFORE UPDATE ON users
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();

-- =====================================================
-- Categories Table
-- =====================================================
CREATE TABLE IF NOT EXISTS categories (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  icon TEXT,
  color TEXT,
  is_default BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),

  -- Ensure category names are unique per user (or globally for defaults)
  CONSTRAINT unique_category_per_user UNIQUE NULLS NOT DISTINCT (user_id, name)
);

-- Create indexes
CREATE INDEX idx_categories_user_id ON categories(user_id);
CREATE INDEX idx_categories_is_default ON categories(is_default);

-- Create trigger to auto-update updated_at
CREATE TRIGGER categories_updated_at
BEFORE UPDATE ON categories
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();

-- =====================================================
-- Trips Table
-- =====================================================
CREATE TABLE IF NOT EXISTS trips (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  destination TEXT,
  start_date DATE NOT NULL,
  end_date DATE,
  budget DECIMAL(12, 2),
  currency TEXT NOT NULL DEFAULT 'JPY',
  description TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),

  -- Ensure end_date is after start_date
  CONSTRAINT check_trip_dates CHECK (end_date IS NULL OR end_date >= start_date)
);

-- Create indexes
CREATE INDEX idx_trips_user_id ON trips(user_id);
CREATE INDEX idx_trips_start_date ON trips(start_date DESC);

-- Create trigger to auto-update updated_at
CREATE TRIGGER trips_updated_at
BEFORE UPDATE ON trips
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();

-- =====================================================
-- Expenses Table
-- =====================================================
CREATE TABLE IF NOT EXISTS expenses (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  trip_id UUID NOT NULL REFERENCES trips(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  amount DECIMAL(12, 2) NOT NULL,
  currency TEXT NOT NULL DEFAULT 'JPY',
  category_id UUID REFERENCES categories(id) ON DELETE SET NULL,
  payment_method TEXT,
  description TEXT,
  expense_date DATE NOT NULL,
  location TEXT,
  notes TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),

  -- Ensure amount is positive
  CONSTRAINT check_expense_amount CHECK (amount >= 0)
);

-- Create indexes
CREATE INDEX idx_expenses_trip_id ON expenses(trip_id);
CREATE INDEX idx_expenses_user_id ON expenses(user_id);
CREATE INDEX idx_expenses_category_id ON expenses(category_id);
CREATE INDEX idx_expenses_expense_date ON expenses(expense_date DESC);

-- Create trigger to auto-update updated_at
CREATE TRIGGER expenses_updated_at
BEFORE UPDATE ON expenses
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();

-- =====================================================
-- Expense Images Table
-- =====================================================
CREATE TABLE IF NOT EXISTS expense_images (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  expense_id UUID NOT NULL REFERENCES expenses(id) ON DELETE CASCADE,
  image_url TEXT NOT NULL,
  thumbnail_url TEXT,
  ocr_text TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Create indexes
CREATE INDEX idx_expense_images_expense_id ON expense_images(expense_id);

-- Create trigger to auto-update updated_at
CREATE TRIGGER expense_images_updated_at
BEFORE UPDATE ON expense_images
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();

-- =====================================================
-- Tags Table
-- =====================================================
CREATE TABLE IF NOT EXISTS tags (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  color TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),

  -- Ensure tag names are unique per user
  CONSTRAINT unique_tag_per_user UNIQUE (user_id, name)
);

-- Create indexes
CREATE INDEX idx_tags_user_id ON tags(user_id);

-- Create trigger to auto-update updated_at
CREATE TRIGGER tags_updated_at
BEFORE UPDATE ON tags
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();

-- =====================================================
-- Expense Tags Table (Many-to-Many)
-- =====================================================
CREATE TABLE IF NOT EXISTS expense_tags (
  expense_id UUID NOT NULL REFERENCES expenses(id) ON DELETE CASCADE,
  tag_id UUID NOT NULL REFERENCES tags(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ DEFAULT NOW(),

  PRIMARY KEY (expense_id, tag_id)
);

-- Create indexes
CREATE INDEX idx_expense_tags_expense_id ON expense_tags(expense_id);
CREATE INDEX idx_expense_tags_tag_id ON expense_tags(tag_id);

-- =====================================================
-- Category Budgets Table
-- =====================================================
CREATE TABLE IF NOT EXISTS category_budgets (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  trip_id UUID NOT NULL REFERENCES trips(id) ON DELETE CASCADE,
  category_id UUID NOT NULL REFERENCES categories(id) ON DELETE CASCADE,
  budget_amount DECIMAL(12, 2) NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),

  -- Ensure one budget per category per trip
  CONSTRAINT unique_category_budget_per_trip UNIQUE (trip_id, category_id),
  -- Ensure budget amount is positive
  CONSTRAINT check_budget_amount CHECK (budget_amount >= 0)
);

-- Create indexes
CREATE INDEX idx_category_budgets_trip_id ON category_budgets(trip_id);
CREATE INDEX idx_category_budgets_category_id ON category_budgets(category_id);

-- Create trigger to auto-update updated_at
CREATE TRIGGER category_budgets_updated_at
BEFORE UPDATE ON category_budgets
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();

-- =====================================================
-- Seed Default Categories
-- =====================================================
INSERT INTO categories (id, user_id, name, icon, color, is_default) VALUES
  (uuid_generate_v4(), NULL, '食事', '🍽️', '#E63946', TRUE),
  (uuid_generate_v4(), NULL, '宿泊', '🏨', '#F77F00', TRUE),
  (uuid_generate_v4(), NULL, '交通', '🚆', '#FCA311', TRUE),
  (uuid_generate_v4(), NULL, 'アクティビティ・観光', '🎭', '#457B9D', TRUE),
  (uuid_generate_v4(), NULL, 'ショッピング', '🛍️', '#C1121F', TRUE),
  (uuid_generate_v4(), NULL, '医療・健康', '💊', '#1D3557', TRUE),
  (uuid_generate_v4(), NULL, '通信', '📱', '#14213D', TRUE),
  (uuid_generate_v4(), NULL, 'チケット', '🎫', '#2A9D8F', TRUE),
  (uuid_generate_v4(), NULL, 'その他', '💰', '#6C757D', TRUE)
ON CONFLICT DO NOTHING;

-- =====================================================
-- Comments
-- =====================================================
COMMENT ON TABLE users IS 'ユーザー情報を格納するテーブル';
COMMENT ON TABLE trips IS '旅行情報を格納するテーブル';
COMMENT ON TABLE expenses IS '支出記録を格納するテーブル';
COMMENT ON TABLE categories IS 'カテゴリー情報を格納するテーブル';
COMMENT ON TABLE tags IS 'タグ情報を格納するテーブル';
COMMENT ON TABLE expense_tags IS '支出とタグの関連を格納するテーブル';
COMMENT ON TABLE expense_images IS 'レシート画像情報を格納するテーブル';
COMMENT ON TABLE category_budgets IS 'カテゴリー別予算を格納するテーブル';
