-- Create user_profiles table for storing user profile information
-- This migration creates the user profiles table with preferences and settings

-- ===== USER PROFILES TABLE =====
-- Stores user profile information including preferences and settings
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

-- ===== COMMENTS =====
-- Add comments for documentation
COMMENT ON TABLE user_profiles IS 'Stores user profile information including preferences and settings';
COMMENT ON COLUMN user_profiles.user_id IS 'Unique identifier from authentication system';
COMMENT ON COLUMN user_profiles.level IS 'English proficiency level (beginner, elementary, intermediate, advanced)';
COMMENT ON COLUMN user_profiles.language IS 'User interface language preference (en, fa)';
COMMENT ON COLUMN user_profiles.theme IS 'User interface theme preference';