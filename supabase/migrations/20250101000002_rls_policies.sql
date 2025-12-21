-- Travel Expense Tracker - Row Level Security Policies
-- Author: Claude
-- Date: 2025-01-01

-- =====================================================
-- Enable RLS on all tables
-- =====================================================
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE trips ENABLE ROW LEVEL SECURITY;
ALTER TABLE expenses ENABLE ROW LEVEL SECURITY;
ALTER TABLE categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE tags ENABLE ROW LEVEL SECURITY;
ALTER TABLE expense_tags ENABLE ROW LEVEL SECURITY;
ALTER TABLE expense_images ENABLE ROW LEVEL SECURITY;
ALTER TABLE category_budgets ENABLE ROW LEVEL SECURITY;

-- =====================================================
-- Users Table Policies
-- =====================================================

-- Users can read their own data
CREATE POLICY "Users can view own profile"
ON users FOR SELECT
TO authenticated
USING (auth.uid() = id);

-- Users can insert their own data (handled by trigger)
CREATE POLICY "Users can insert own profile"
ON users FOR INSERT
TO authenticated
WITH CHECK (auth.uid() = id);

-- Users can update their own data
CREATE POLICY "Users can update own profile"
ON users FOR UPDATE
TO authenticated
USING (auth.uid() = id)
WITH CHECK (auth.uid() = id);

-- Users cannot delete their own data (cascade from auth.users)

-- =====================================================
-- Categories Table Policies
-- =====================================================

-- Everyone can read default categories
CREATE POLICY "Anyone can view default categories"
ON categories FOR SELECT
TO authenticated
USING (is_default = TRUE OR user_id = auth.uid());

-- Users can create their own custom categories
CREATE POLICY "Users can create own categories"
ON categories FOR INSERT
TO authenticated
WITH CHECK (user_id = auth.uid() AND is_default = FALSE);

-- Users can update their own custom categories
CREATE POLICY "Users can update own categories"
ON categories FOR UPDATE
TO authenticated
USING (user_id = auth.uid() AND is_default = FALSE)
WITH CHECK (user_id = auth.uid() AND is_default = FALSE);

-- Users can delete their own custom categories
CREATE POLICY "Users can delete own categories"
ON categories FOR DELETE
TO authenticated
USING (user_id = auth.uid() AND is_default = FALSE);

-- =====================================================
-- Trips Table Policies
-- =====================================================

-- Users can read their own trips
CREATE POLICY "Users can view own trips"
ON trips FOR SELECT
TO authenticated
USING (user_id = auth.uid());

-- Users can create their own trips
CREATE POLICY "Users can create own trips"
ON trips FOR INSERT
TO authenticated
WITH CHECK (user_id = auth.uid());

-- Users can update their own trips
CREATE POLICY "Users can update own trips"
ON trips FOR UPDATE
TO authenticated
USING (user_id = auth.uid())
WITH CHECK (user_id = auth.uid());

-- Users can delete their own trips
CREATE POLICY "Users can delete own trips"
ON trips FOR DELETE
TO authenticated
USING (user_id = auth.uid());

-- =====================================================
-- Expenses Table Policies
-- =====================================================

-- Users can read their own expenses
CREATE POLICY "Users can view own expenses"
ON expenses FOR SELECT
TO authenticated
USING (user_id = auth.uid());

-- Users can create expenses for their own trips
CREATE POLICY "Users can create own expenses"
ON expenses FOR INSERT
TO authenticated
WITH CHECK (
  user_id = auth.uid() AND
  EXISTS (
    SELECT 1 FROM trips
    WHERE trips.id = trip_id AND trips.user_id = auth.uid()
  )
);

-- Users can update their own expenses
CREATE POLICY "Users can update own expenses"
ON expenses FOR UPDATE
TO authenticated
USING (user_id = auth.uid())
WITH CHECK (
  user_id = auth.uid() AND
  EXISTS (
    SELECT 1 FROM trips
    WHERE trips.id = trip_id AND trips.user_id = auth.uid()
  )
);

-- Users can delete their own expenses
CREATE POLICY "Users can delete own expenses"
ON expenses FOR DELETE
TO authenticated
USING (user_id = auth.uid());

-- =====================================================
-- Expense Images Table Policies
-- =====================================================

-- Users can read images for their own expenses
CREATE POLICY "Users can view own expense images"
ON expense_images FOR SELECT
TO authenticated
USING (
  EXISTS (
    SELECT 1 FROM expenses
    WHERE expenses.id = expense_id AND expenses.user_id = auth.uid()
  )
);

-- Users can create images for their own expenses
CREATE POLICY "Users can create own expense images"
ON expense_images FOR INSERT
TO authenticated
WITH CHECK (
  EXISTS (
    SELECT 1 FROM expenses
    WHERE expenses.id = expense_id AND expenses.user_id = auth.uid()
  )
);

-- Users can update images for their own expenses
CREATE POLICY "Users can update own expense images"
ON expense_images FOR UPDATE
TO authenticated
USING (
  EXISTS (
    SELECT 1 FROM expenses
    WHERE expenses.id = expense_id AND expenses.user_id = auth.uid()
  )
)
WITH CHECK (
  EXISTS (
    SELECT 1 FROM expenses
    WHERE expenses.id = expense_id AND expenses.user_id = auth.uid()
  )
);

-- Users can delete images for their own expenses
CREATE POLICY "Users can delete own expense images"
ON expense_images FOR DELETE
TO authenticated
USING (
  EXISTS (
    SELECT 1 FROM expenses
    WHERE expenses.id = expense_id AND expenses.user_id = auth.uid()
  )
);

-- =====================================================
-- Tags Table Policies
-- =====================================================

-- Users can read their own tags
CREATE POLICY "Users can view own tags"
ON tags FOR SELECT
TO authenticated
USING (user_id = auth.uid());

-- Users can create their own tags
CREATE POLICY "Users can create own tags"
ON tags FOR INSERT
TO authenticated
WITH CHECK (user_id = auth.uid());

-- Users can update their own tags
CREATE POLICY "Users can update own tags"
ON tags FOR UPDATE
TO authenticated
USING (user_id = auth.uid())
WITH CHECK (user_id = auth.uid());

-- Users can delete their own tags
CREATE POLICY "Users can delete own tags"
ON tags FOR DELETE
TO authenticated
USING (user_id = auth.uid());

-- =====================================================
-- Expense Tags Table Policies
-- =====================================================

-- Users can read expense-tag relationships for their own expenses
CREATE POLICY "Users can view own expense tags"
ON expense_tags FOR SELECT
TO authenticated
USING (
  EXISTS (
    SELECT 1 FROM expenses
    WHERE expenses.id = expense_id AND expenses.user_id = auth.uid()
  )
);

-- Users can create expense-tag relationships for their own expenses
CREATE POLICY "Users can create own expense tags"
ON expense_tags FOR INSERT
TO authenticated
WITH CHECK (
  EXISTS (
    SELECT 1 FROM expenses
    WHERE expenses.id = expense_id AND expenses.user_id = auth.uid()
  ) AND
  EXISTS (
    SELECT 1 FROM tags
    WHERE tags.id = tag_id AND tags.user_id = auth.uid()
  )
);

-- Users can delete expense-tag relationships for their own expenses
CREATE POLICY "Users can delete own expense tags"
ON expense_tags FOR DELETE
TO authenticated
USING (
  EXISTS (
    SELECT 1 FROM expenses
    WHERE expenses.id = expense_id AND expenses.user_id = auth.uid()
  )
);

-- =====================================================
-- Category Budgets Table Policies
-- =====================================================

-- Users can read budgets for their own trips
CREATE POLICY "Users can view own category budgets"
ON category_budgets FOR SELECT
TO authenticated
USING (
  EXISTS (
    SELECT 1 FROM trips
    WHERE trips.id = trip_id AND trips.user_id = auth.uid()
  )
);

-- Users can create budgets for their own trips
CREATE POLICY "Users can create own category budgets"
ON category_budgets FOR INSERT
TO authenticated
WITH CHECK (
  EXISTS (
    SELECT 1 FROM trips
    WHERE trips.id = trip_id AND trips.user_id = auth.uid()
  )
);

-- Users can update budgets for their own trips
CREATE POLICY "Users can update own category budgets"
ON category_budgets FOR UPDATE
TO authenticated
USING (
  EXISTS (
    SELECT 1 FROM trips
    WHERE trips.id = trip_id AND trips.user_id = auth.uid()
  )
)
WITH CHECK (
  EXISTS (
    SELECT 1 FROM trips
    WHERE trips.id = trip_id AND trips.user_id = auth.uid()
  )
);

-- Users can delete budgets for their own trips
CREATE POLICY "Users can delete own category budgets"
ON category_budgets FOR DELETE
TO authenticated
USING (
  EXISTS (
    SELECT 1 FROM trips
    WHERE trips.id = trip_id AND trips.user_id = auth.uid()
  )
);

-- =====================================================
-- Comments
-- =====================================================
COMMENT ON POLICY "Users can view own profile" ON users IS 'ユーザーは自分のプロフィールのみ閲覧可能';
COMMENT ON POLICY "Anyone can view default categories" ON categories IS '全ユーザーがデフォルトカテゴリーを閲覧可能';
COMMENT ON POLICY "Users can view own trips" ON trips IS 'ユーザーは自分の旅行のみ閲覧可能';
COMMENT ON POLICY "Users can view own expenses" ON expenses IS 'ユーザーは自分の支出のみ閲覧可能';
