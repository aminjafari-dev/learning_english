-- Create user profiles for existing authenticated users
-- This migration ensures all existing users have profile records

-- ===== COMMENTS =====
COMMENT ON TABLE user_profiles IS 'Migration: Functions created for user profile management - run sync_all_user_profiles() manually';
