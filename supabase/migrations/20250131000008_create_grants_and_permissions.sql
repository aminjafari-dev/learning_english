-- Create grants and permissions for all tables
-- This migration sets up proper access permissions for authenticated users and service roles

-- ===== GRANTS =====
-- Grant necessary permissions

-- User profiles grants
GRANT SELECT, INSERT, UPDATE ON user_profiles TO authenticated;
GRANT USAGE, SELECT ON SEQUENCE user_profiles_id_seq TO authenticated;
GRANT ALL ON user_profiles TO service_role;
GRANT USAGE ON SEQUENCE user_profiles_id_seq TO service_role;

-- Learning data grants for service role
GRANT ALL ON requests TO service_role;
GRANT ALL ON vocabularies TO service_role;
GRANT ALL ON phrases TO service_role;
GRANT USAGE ON SEQUENCE requests_id_seq TO service_role;
GRANT USAGE ON SEQUENCE vocabularies_id_seq TO service_role;
GRANT USAGE ON SEQUENCE phrases_id_seq TO service_role;