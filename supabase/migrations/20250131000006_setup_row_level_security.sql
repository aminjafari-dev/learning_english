-- Setup Row Level Security (RLS) for all tables
-- This migration enables RLS and creates security policies for data protection

-- ===== ROW LEVEL SECURITY (RLS) =====

-- Enable RLS on all tables
ALTER TABLE user_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE requests ENABLE ROW LEVEL SECURITY;
ALTER TABLE vocabularies ENABLE ROW LEVEL SECURITY;
ALTER TABLE phrases ENABLE ROW LEVEL SECURITY;

-- ===== RLS POLICIES =====

-- User profiles policies
DROP POLICY IF EXISTS "Users can view their own profile" ON user_profiles;
CREATE POLICY "Users can view their own profile" ON user_profiles
  FOR SELECT USING (auth.uid()::text = user_id);

DROP POLICY IF EXISTS "Users can insert their own profile" ON user_profiles;
CREATE POLICY "Users can insert their own profile" ON user_profiles
  FOR INSERT WITH CHECK (auth.uid()::text = user_id);

DROP POLICY IF EXISTS "Users can update their own profile" ON user_profiles;
CREATE POLICY "Users can update their own profile" ON user_profiles
  FOR UPDATE USING (auth.uid()::text = user_id);

-- Requests policies
DROP POLICY IF EXISTS "Users can access their own requests" ON requests;
CREATE POLICY "Users can access their own requests" ON requests
  FOR ALL USING (auth.uid()::text = user_id);

-- Vocabularies policies
DROP POLICY IF EXISTS "Users can access their own vocabularies" ON vocabularies;
CREATE POLICY "Users can access their own vocabularies" ON vocabularies
  FOR ALL USING (auth.uid()::text = user_id);

-- Phrases policies
DROP POLICY IF EXISTS "Users can access their own phrases" ON phrases;
CREATE POLICY "Users can access their own phrases" ON phrases
  FOR ALL USING (auth.uid()::text = user_id);

-- ===== SERVICE ROLE POLICIES =====
-- Allow the service role to access all data (for Edge Functions)

-- User profiles service role policy
DROP POLICY IF EXISTS "Service role can access all user profiles" ON user_profiles;
CREATE POLICY "Service role can access all user profiles" ON user_profiles
  FOR ALL USING (auth.role() = 'service_role');

-- Requests service role policy
DROP POLICY IF EXISTS "Service role can access all requests" ON requests;
CREATE POLICY "Service role can access all requests" ON requests
  FOR ALL USING (auth.role() = 'service_role');

-- Vocabularies service role policy
DROP POLICY IF EXISTS "Service role can access all vocabularies" ON vocabularies;
CREATE POLICY "Service role can access all vocabularies" ON vocabularies
  FOR ALL USING (auth.role() = 'service_role');

-- Phrases service role policy
DROP POLICY IF EXISTS "Service role can access all phrases" ON phrases;
CREATE POLICY "Service role can access all phrases" ON phrases
  FOR ALL USING (auth.role() = 'service_role');