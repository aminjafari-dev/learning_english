-- Manual script to sync user profiles
-- Run this in the Supabase SQL Editor to create profiles for existing users

-- First, let's create the sync function if it doesn't exist
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
      -- Insert profile directly with enhanced fields
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
        user_record.user_id,
        user_record.full_name,
        user_record.email,
        'beginner', -- Default level
        '{}', -- Default empty focus areas
        'en', -- Default language
        'goldTheme', -- Default theme
        NOW(),
        NOW()
      );
      created_count := created_count + 1;
      RAISE NOTICE 'Created profile for user: %', user_record.user_id;
    EXCEPTION
      WHEN OTHERS THEN
        -- Log error but continue with other users
        RAISE NOTICE 'Failed to create profile for user %: %', user_record.user_id, SQLERRM;
    END;
  END LOOP;

  RETURN created_count;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Now run the sync function
SELECT sync_all_user_profiles() as profiles_created;

-- Show the results
SELECT 
  'Total users in auth.users' as description,
  COUNT(*) as count
FROM auth.users
UNION ALL
SELECT 
  'Total profiles in user_profiles' as description,
  COUNT(*) as count
FROM user_profiles
UNION ALL
SELECT 
  'Users without profiles' as description,
  COUNT(*) as count
FROM auth.users au
LEFT JOIN user_profiles up ON au.id::text = up.user_id
WHERE up.user_id IS NULL;
