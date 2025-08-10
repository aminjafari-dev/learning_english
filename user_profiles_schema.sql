-- User Profiles Table Schema for Supabase
-- This creates the user_profiles table to replace Firebase user storage

-- Create user_profiles table
CREATE TABLE IF NOT EXISTS user_profiles (
  id BIGSERIAL PRIMARY KEY,
  user_id TEXT UNIQUE NOT NULL,
  full_name TEXT,
  email TEXT,
  phone_number TEXT,
  date_of_birth DATE,
  language TEXT DEFAULT 'en',
  level TEXT,
  profile_image_url TEXT,
  theme TEXT DEFAULT 'goldTheme',
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_user_profiles_user_id ON user_profiles(user_id);
CREATE INDEX IF NOT EXISTS idx_user_profiles_level ON user_profiles(level);
CREATE INDEX IF NOT EXISTS idx_user_profiles_language ON user_profiles(language);

-- Enable Row Level Security
ALTER TABLE user_profiles ENABLE ROW LEVEL SECURITY;

-- Create RLS policies to ensure users can only access their own data
CREATE POLICY "Users can view their own profile" ON user_profiles
  FOR SELECT USING (auth.uid()::text = user_id);

CREATE POLICY "Users can insert their own profile" ON user_profiles
  FOR INSERT WITH CHECK (auth.uid()::text = user_id);

CREATE POLICY "Users can update their own profile" ON user_profiles
  FOR UPDATE USING (auth.uid()::text = user_id);

-- Grant access to authenticated users
GRANT SELECT, INSERT, UPDATE ON user_profiles TO authenticated;
GRANT USAGE, SELECT ON SEQUENCE user_profiles_id_seq TO authenticated;

-- Add comments for documentation
COMMENT ON TABLE user_profiles IS 'Stores user profile information including preferences and settings';
COMMENT ON COLUMN user_profiles.user_id IS 'Unique identifier from authentication system';
COMMENT ON COLUMN user_profiles.level IS 'English proficiency level (beginner, elementary, intermediate, advanced)';
COMMENT ON COLUMN user_profiles.language IS 'User interface language preference (en, fa)';
COMMENT ON COLUMN user_profiles.theme IS 'User interface theme preference';