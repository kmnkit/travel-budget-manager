-- Travel Expense Tracker - Database Functions and Triggers
-- Author: Claude
-- Date: 2025-01-01

-- =====================================================
-- Function: Auto-create user profile on signup
-- =====================================================
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.users (id, email, display_name, onboarding_completed)
  VALUES (
    NEW.id,
    NEW.email,
    COALESCE(NEW.raw_user_meta_data->>'display_name', split_part(NEW.email, '@', 1)),
    FALSE
  );
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Create trigger to auto-create user profile when auth.users is inserted
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- =====================================================
-- Function: Calculate trip total expenses
-- =====================================================
CREATE OR REPLACE FUNCTION public.calculate_trip_total_expenses(trip_uuid UUID)
RETURNS DECIMAL AS $$
DECLARE
  total DECIMAL;
BEGIN
  SELECT COALESCE(SUM(amount), 0)
  INTO total
  FROM expenses
  WHERE trip_id = trip_uuid;

  RETURN total;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

COMMENT ON FUNCTION public.calculate_trip_total_expenses IS '指定された旅行の総支出を計算';

-- =====================================================
-- Function: Calculate category expenses for a trip
-- =====================================================
CREATE OR REPLACE FUNCTION public.calculate_category_expenses(
  trip_uuid UUID,
  category_uuid UUID
)
RETURNS DECIMAL AS $$
DECLARE
  total DECIMAL;
BEGIN
  SELECT COALESCE(SUM(amount), 0)
  INTO total
  FROM expenses
  WHERE trip_id = trip_uuid AND category_id = category_uuid;

  RETURN total;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

COMMENT ON FUNCTION public.calculate_category_expenses IS '指定された旅行とカテゴリーの支出を計算';

-- =====================================================
-- Function: Get daily expenses for a trip
-- =====================================================
CREATE OR REPLACE FUNCTION public.get_daily_expenses(trip_uuid UUID)
RETURNS TABLE (
  expense_date DATE,
  total_amount DECIMAL,
  expense_count INTEGER
) AS $$
BEGIN
  RETURN QUERY
  SELECT
    e.expense_date,
    SUM(e.amount) as total_amount,
    COUNT(e.id)::INTEGER as expense_count
  FROM expenses e
  WHERE e.trip_id = trip_uuid
  GROUP BY e.expense_date
  ORDER BY e.expense_date DESC;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

COMMENT ON FUNCTION public.get_daily_expenses IS '指定された旅行の日別支出を取得';

-- =====================================================
-- Function: Get category breakdown for a trip
-- =====================================================
CREATE OR REPLACE FUNCTION public.get_category_breakdown(trip_uuid UUID)
RETURNS TABLE (
  category_id UUID,
  category_name TEXT,
  category_icon TEXT,
  category_color TEXT,
  total_amount DECIMAL,
  expense_count INTEGER,
  budget_amount DECIMAL,
  budget_usage_percentage DECIMAL
) AS $$
BEGIN
  RETURN QUERY
  SELECT
    c.id as category_id,
    c.name as category_name,
    c.icon as category_icon,
    c.color as category_color,
    COALESCE(SUM(e.amount), 0) as total_amount,
    COUNT(e.id)::INTEGER as expense_count,
    cb.budget_amount,
    CASE
      WHEN cb.budget_amount > 0 THEN
        ROUND((COALESCE(SUM(e.amount), 0) / cb.budget_amount * 100), 2)
      ELSE
        0
    END as budget_usage_percentage
  FROM categories c
  LEFT JOIN expenses e ON e.category_id = c.id AND e.trip_id = trip_uuid
  LEFT JOIN category_budgets cb ON cb.category_id = c.id AND cb.trip_id = trip_uuid
  WHERE c.is_default = TRUE OR c.user_id IN (
    SELECT user_id FROM trips WHERE id = trip_uuid
  )
  GROUP BY c.id, c.name, c.icon, c.color, cb.budget_amount
  HAVING COUNT(e.id) > 0 OR cb.budget_amount IS NOT NULL
  ORDER BY total_amount DESC;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

COMMENT ON FUNCTION public.get_category_breakdown IS '指定された旅行のカテゴリー別内訳を取得';

-- =====================================================
-- Function: Calculate budget usage percentage
-- =====================================================
CREATE OR REPLACE FUNCTION public.calculate_budget_usage(trip_uuid UUID)
RETURNS TABLE (
  total_budget DECIMAL,
  total_expenses DECIMAL,
  remaining_budget DECIMAL,
  usage_percentage DECIMAL
) AS $$
BEGIN
  RETURN QUERY
  SELECT
    t.budget as total_budget,
    COALESCE(SUM(e.amount), 0) as total_expenses,
    COALESCE(t.budget - SUM(e.amount), t.budget) as remaining_budget,
    CASE
      WHEN t.budget > 0 THEN
        ROUND((COALESCE(SUM(e.amount), 0) / t.budget * 100), 2)
      ELSE
        0
    END as usage_percentage
  FROM trips t
  LEFT JOIN expenses e ON e.trip_id = t.id
  WHERE t.id = trip_uuid
  GROUP BY t.id, t.budget;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

COMMENT ON FUNCTION public.calculate_budget_usage IS '指定された旅行の予算使用状況を計算';

-- =====================================================
-- View: Trip Summary
-- =====================================================
CREATE OR REPLACE VIEW trip_summary AS
SELECT
  t.id,
  t.user_id,
  t.name,
  t.destination,
  t.start_date,
  t.end_date,
  t.budget,
  t.currency,
  t.description,
  COALESCE(SUM(e.amount), 0) as total_expenses,
  COALESCE(t.budget - SUM(e.amount), t.budget) as remaining_budget,
  COUNT(DISTINCT e.id) as expense_count,
  CASE
    WHEN t.budget > 0 THEN
      ROUND((COALESCE(SUM(e.amount), 0) / t.budget * 100), 2)
    ELSE
      0
  END as budget_usage_percentage,
  t.created_at,
  t.updated_at
FROM trips t
LEFT JOIN expenses e ON e.trip_id = t.id
GROUP BY t.id, t.user_id, t.name, t.destination, t.start_date,
         t.end_date, t.budget, t.currency, t.description,
         t.created_at, t.updated_at;

COMMENT ON VIEW trip_summary IS '旅行の概要情報（支出合計、残予算等）を表示するビュー';

-- =====================================================
-- Storage Configuration (to be applied in Supabase Dashboard)
-- =====================================================

-- Note: Storage buckets and policies must be created manually in Supabase Dashboard
-- or using the Supabase CLI. The following is documentation for reference:

/*
-- Create storage buckets:
1. receipt-images (private)
2. profile-images (public)
3. trip-covers (public)

-- Storage policies for receipt-images bucket:
CREATE POLICY "Users can upload their own receipt images"
ON storage.objects FOR INSERT
TO authenticated
WITH CHECK (
  bucket_id = 'receipt-images' AND
  auth.uid()::text = (storage.foldername(name))[1]
);

CREATE POLICY "Users can view their own receipt images"
ON storage.objects FOR SELECT
TO authenticated
USING (
  bucket_id = 'receipt-images' AND
  auth.uid()::text = (storage.foldername(name))[1]
);

CREATE POLICY "Users can delete their own receipt images"
ON storage.objects FOR DELETE
TO authenticated
USING (
  bucket_id = 'receipt-images' AND
  auth.uid()::text = (storage.foldername(name))[1]
);
*/
