-- Create user_profiles table for storing user learning preferences and levels
-- This table stores user-specific information for the learning English app

CREATE TABLE IF NOT EXISTS user_profiles (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id TEXT UNIQUE NOT NULL, -- This should match auth.users.id
  email TEXT,
  full_name TEXT,
  user_level TEXT NOT NULL DEFAULT 'intermediate' CHECK (user_level IN ('beginner', 'elementary', 'intermediate', 'advanced')),
  focus_areas TEXT[] DEFAULT '{}',
  preferred_language TEXT DEFAULT 'persian',
  daily_goal_minutes INTEGER DEFAULT 30,
  streak_count INTEGER DEFAULT 0,
  total_study_time INTEGER DEFAULT 0, -- in minutes
  last_activity_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  
  -- Constraints
  CONSTRAINT user_profiles_user_id_check CHECK (length(user_id) > 0),
  CONSTRAINT user_profiles_daily_goal_check CHECK (daily_goal_minutes > 0),
  CONSTRAINT user_profiles_streak_check CHECK (streak_count >= 0),
  CONSTRAINT user_profiles_study_time_check CHECK (total_study_time >= 0)
);

-- Create indexes for performance
CREATE INDEX IF NOT EXISTS idx_user_profiles_user_id ON user_profiles(user_id);
CREATE INDEX IF NOT EXISTS idx_user_profiles_user_level ON user_profiles(user_level);
CREATE INDEX IF NOT EXISTS idx_user_profiles_last_activity ON user_profiles(last_activity_at);

-- Enable Row Level Security
ALTER TABLE user_profiles ENABLE ROW LEVEL SECURITY;

-- Create RLS policies
DROP POLICY IF EXISTS "Users can view their own profile" ON user_profiles;
CREATE POLICY "Users can view their own profile" ON user_profiles
  FOR SELECT USING (auth.uid()::text = user_id);

DROP POLICY IF EXISTS "Users can update their own profile" ON user_profiles;
CREATE POLICY "Users can update their own profile" ON user_profiles
  FOR UPDATE USING (auth.uid()::text = user_id);

DROP POLICY IF EXISTS "Users can insert their own profile" ON user_profiles;
CREATE POLICY "Users can insert their own profile" ON user_profiles
  FOR INSERT WITH CHECK (auth.uid()::text = user_id);

-- Service role can access all profiles (for functions)
DROP POLICY IF EXISTS "Service role can access all profiles" ON user_profiles;
CREATE POLICY "Service role can access all profiles" ON user_profiles
  FOR ALL USING (auth.role() = 'service_role');

-- Grant permissions
GRANT ALL ON user_profiles TO service_role;
GRANT SELECT, INSERT, UPDATE ON user_profiles TO authenticated;

-- Function to automatically update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger for updated_at
DROP TRIGGER IF EXISTS update_user_profiles_updated_at ON user_profiles;
CREATE TRIGGER update_user_profiles_updated_at
  BEFORE UPDATE ON user_profiles
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- Insert default profile for the current user (if needed)
-- This can be uncommented and used with a specific user_id when testing
/*
INSERT INTO user_profiles (user_id, email, full_name, user_level, focus_areas)
VALUES (
  'XOW6UUO5BZODonmCpPXn7lomNXl1',
  'user@example.com',
  'Test User',
  'intermediate',
  ARRAY['Travel English']
) ON CONFLICT (user_id) DO NOTHING;
*/
