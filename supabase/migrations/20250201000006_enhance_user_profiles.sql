-- Enhance user_profiles table with focus areas and better constraints
-- This migration adds focus_areas field and improves the existing structure

-- ===== ADD FOCUS AREAS COLUMN =====
-- Add focus_areas column to store user's learning focus areas
ALTER TABLE user_profiles 
ADD COLUMN IF NOT EXISTS focus_areas TEXT[] DEFAULT '{}';

-- ===== ADD CONSTRAINTS =====
-- Add constraint to ensure level is one of the valid values
ALTER TABLE user_profiles 
DROP CONSTRAINT IF EXISTS user_profiles_level_check;

ALTER TABLE user_profiles 
ADD CONSTRAINT user_profiles_level_check 
CHECK (level IS NULL OR level IN ('beginner', 'elementary', 'intermediate', 'advanced'));

-- Add constraint to ensure language is one of the valid values
ALTER TABLE user_profiles 
DROP CONSTRAINT IF EXISTS user_profiles_language_check;

ALTER TABLE user_profiles 
ADD CONSTRAINT user_profiles_language_check 
CHECK (language IN ('en', 'fa'));

-- Add constraint to ensure theme is one of the valid values
ALTER TABLE user_profiles 
DROP CONSTRAINT IF EXISTS user_profiles_theme_check;

ALTER TABLE user_profiles 
ADD CONSTRAINT user_profiles_theme_check 
CHECK (theme IN ('goldTheme', 'blueTheme', 'greenTheme', 'purpleTheme'));

-- ===== UPDATE COMMENTS =====
COMMENT ON COLUMN user_profiles.focus_areas IS 'Array of learning focus areas (e.g., ["grammar", "vocabulary", "speaking", "listening"])';
COMMENT ON COLUMN user_profiles.level IS 'English proficiency level (beginner, elementary, intermediate, advanced)';
COMMENT ON COLUMN user_profiles.language IS 'User interface language preference (en, fa)';
COMMENT ON COLUMN user_profiles.theme IS 'User interface theme preference (goldTheme, blueTheme, greenTheme, purpleTheme)';

-- ===== CREATE ENHANCED PROFILE FUNCTIONS =====

-- Function to create a complete user profile with all fields
CREATE OR REPLACE FUNCTION create_complete_user_profile(
  p_user_id TEXT,
  p_full_name TEXT DEFAULT NULL,
  p_email TEXT DEFAULT NULL,
  p_level TEXT DEFAULT NULL,
  p_focus_areas TEXT[] DEFAULT '{}',
  p_language TEXT DEFAULT 'en',
  p_theme TEXT DEFAULT 'goldTheme'
)
RETURNS BIGINT AS $$
DECLARE
  profile_id BIGINT;
BEGIN
  -- Check if profile already exists
  IF EXISTS (SELECT 1 FROM user_profiles WHERE user_id = p_user_id) THEN
    RAISE EXCEPTION 'User profile already exists for user_id: %', p_user_id;
  END IF;

  -- Insert new user profile with all fields
  INSERT INTO user_profiles (
    user_id,
    full_name,
    email,
    level,
    focus_areas,
    language,
    theme,
    created_at,
    updated_at
  ) VALUES (
    p_user_id,
    p_full_name,
    p_email,
    p_level,
    p_focus_areas,
    p_language,
    p_theme,
    NOW(),
    NOW()
  ) RETURNING id INTO profile_id;

  RETURN profile_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function to update user profile with focus areas and level
CREATE OR REPLACE FUNCTION update_user_profile(
  p_user_id TEXT,
  p_full_name TEXT DEFAULT NULL,
  p_email TEXT DEFAULT NULL,
  p_level TEXT DEFAULT NULL,
  p_focus_areas TEXT[] DEFAULT NULL,
  p_language TEXT DEFAULT NULL,
  p_theme TEXT DEFAULT NULL
)
RETURNS BIGINT AS $$
DECLARE
  profile_id BIGINT;
  update_data JSONB := '{}';
BEGIN
  -- Build update data dynamically
  IF p_full_name IS NOT NULL THEN
    update_data := update_data || jsonb_build_object('full_name', p_full_name);
  END IF;
  
  IF p_email IS NOT NULL THEN
    update_data := update_data || jsonb_build_object('email', p_email);
  END IF;
  
  IF p_level IS NOT NULL THEN
    update_data := update_data || jsonb_build_object('level', p_level);
  END IF;
  
  IF p_focus_areas IS NOT NULL THEN
    update_data := update_data || jsonb_build_object('focus_areas', p_focus_areas);
  END IF;
  
  IF p_language IS NOT NULL THEN
    update_data := update_data || jsonb_build_object('language', p_language);
  END IF;
  
  IF p_theme IS NOT NULL THEN
    update_data := update_data || jsonb_build_object('theme', p_theme);
  END IF;
  
  -- Add updated_at timestamp
  update_data := update_data || jsonb_build_object('updated_at', NOW());

  -- Update the profile
  UPDATE user_profiles 
  SET 
    full_name = COALESCE(p_full_name, full_name),
    email = COALESCE(p_email, email),
    level = COALESCE(p_level, level),
    focus_areas = COALESCE(p_focus_areas, focus_areas),
    language = COALESCE(p_language, language),
    theme = COALESCE(p_theme, theme),
    updated_at = NOW()
  WHERE user_id = p_user_id
  RETURNING id INTO profile_id;

  IF profile_id IS NULL THEN
    RAISE EXCEPTION 'User profile not found for user_id: %', p_user_id;
  END IF;

  RETURN profile_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ===== GRANT PERMISSIONS =====
GRANT EXECUTE ON FUNCTION create_complete_user_profile(TEXT, TEXT, TEXT, TEXT, TEXT[], TEXT, TEXT) TO service_role;
GRANT EXECUTE ON FUNCTION update_user_profile(TEXT, TEXT, TEXT, TEXT, TEXT[], TEXT, TEXT) TO service_role;

-- ===== COMMENTS =====
COMMENT ON FUNCTION create_complete_user_profile(TEXT, TEXT, TEXT, TEXT, TEXT[], TEXT, TEXT) IS 'Creates a complete user profile with all fields including focus areas and level';
COMMENT ON FUNCTION update_user_profile(TEXT, TEXT, TEXT, TEXT, TEXT[], TEXT, TEXT) IS 'Updates user profile with focus areas, level, and other fields';

