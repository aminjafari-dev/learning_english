-- Create functions for user profile management
-- This provides functions to create and manage user profiles

-- ===== FUNCTION TO CREATE USER PROFILE =====
-- This function creates a user profile for a given user ID
CREATE OR REPLACE FUNCTION create_user_profile(
  p_user_id TEXT,
  p_full_name TEXT DEFAULT NULL,
  p_email TEXT DEFAULT NULL
)
RETURNS BIGINT AS $$
DECLARE
  profile_id BIGINT;
BEGIN
  -- Check if profile already exists
  IF EXISTS (SELECT 1 FROM user_profiles WHERE user_id = p_user_id) THEN
    RAISE EXCEPTION 'User profile already exists for user_id: %', p_user_id;
  END IF;

  -- Insert new user profile
  INSERT INTO user_profiles (
    user_id,
    full_name,
    email,
    created_at,
    updated_at
  ) VALUES (
    p_user_id,
    p_full_name,
    p_email,
    NOW(),
    NOW()
  ) RETURNING id INTO profile_id;

  RETURN profile_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ===== FUNCTION TO GET OR CREATE USER PROFILE =====
-- This function gets an existing profile or creates a new one
CREATE OR REPLACE FUNCTION get_or_create_user_profile(
  p_user_id TEXT,
  p_full_name TEXT DEFAULT NULL,
  p_email TEXT DEFAULT NULL
)
RETURNS BIGINT AS $$
DECLARE
  profile_id BIGINT;
BEGIN
  -- Try to get existing profile
  SELECT id INTO profile_id FROM user_profiles WHERE user_id = p_user_id;
  
  -- If profile doesn't exist, create it
  IF profile_id IS NULL THEN
    profile_id := create_user_profile(p_user_id, p_full_name, p_email);
  END IF;

  RETURN profile_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ===== FUNCTION TO SYNC ALL USERS =====
-- This function creates profiles for all users who don't have one
CREATE OR REPLACE FUNCTION sync_all_user_profiles()
RETURNS INTEGER AS $$
DECLARE
  created_count INTEGER := 0;
  user_record RECORD;
BEGIN
  -- Loop through all users in auth.users who don't have profiles
  FOR user_record IN 
    SELECT 
      au.id::text as user_id,
      COALESCE(
        au.raw_user_meta_data->>'full_name',
        au.raw_user_meta_data->>'name',
        au.raw_user_meta_data->>'display_name'
      ) as full_name,
      au.email
    FROM auth.users au
    LEFT JOIN user_profiles up ON au.id::text = up.user_id
    WHERE up.user_id IS NULL
      AND au.id IS NOT NULL
  LOOP
    BEGIN
      PERFORM create_user_profile(
        user_record.user_id,
        user_record.full_name,
        user_record.email
      );
      created_count := created_count + 1;
    EXCEPTION
      WHEN OTHERS THEN
        -- Log error but continue with other users
        RAISE NOTICE 'Failed to create profile for user %: %', user_record.user_id, SQLERRM;
    END;
  END LOOP;

  RETURN created_count;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ===== GRANT PERMISSIONS =====
-- Grant permissions to service role for Edge Functions
GRANT EXECUTE ON FUNCTION create_user_profile(TEXT, TEXT, TEXT) TO service_role;
GRANT EXECUTE ON FUNCTION get_or_create_user_profile(TEXT, TEXT, TEXT) TO service_role;
GRANT EXECUTE ON FUNCTION sync_all_user_profiles() TO service_role;

-- ===== COMMENTS =====
COMMENT ON FUNCTION create_user_profile(TEXT, TEXT, TEXT) IS 'Creates a new user profile for the given user ID';
COMMENT ON FUNCTION get_or_create_user_profile(TEXT, TEXT, TEXT) IS 'Gets existing profile or creates a new one for the given user ID';
COMMENT ON FUNCTION sync_all_user_profiles() IS 'Creates profiles for all users who don''t have one yet';
