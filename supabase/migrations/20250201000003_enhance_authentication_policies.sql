-- Enhance authentication policies and add policies for prompts table
-- This migration improves existing RLS policies and adds authentication for prompts

-- ===== ENHANCE EXISTING POLICIES =====

-- Add authentication check to existing policies
-- This ensures only authenticated users can access data

-- User profiles enhanced policies
DROP POLICY IF EXISTS "Users can view their own profile" ON user_profiles;
CREATE POLICY "Users can view their own profile" ON user_profiles
  FOR SELECT USING (
    auth.uid() IS NOT NULL AND 
    auth.uid()::text = user_id
  );

DROP POLICY IF EXISTS "Users can insert their own profile" ON user_profiles;
CREATE POLICY "Users can insert their own profile" ON user_profiles
  FOR INSERT WITH CHECK (
    auth.uid() IS NOT NULL AND 
    auth.uid()::text = user_id
  );

DROP POLICY IF EXISTS "Users can update their own profile" ON user_profiles;
CREATE POLICY "Users can update their own profile" ON user_profiles
  FOR UPDATE USING (
    auth.uid() IS NOT NULL AND 
    auth.uid()::text = user_id
  );

-- Requests enhanced policies
DROP POLICY IF EXISTS "Users can access their own requests" ON requests;
CREATE POLICY "Users can access their own requests" ON requests
  FOR ALL USING (
    auth.uid() IS NOT NULL AND 
    auth.uid()::text = user_id
  );

-- Vocabularies enhanced policies
DROP POLICY IF EXISTS "Users can access their own vocabularies" ON vocabularies;
CREATE POLICY "Users can access their own vocabularies" ON vocabularies
  FOR ALL USING (
    auth.uid() IS NOT NULL AND 
    auth.uid()::text = user_id
  );

-- Phrases enhanced policies
DROP POLICY IF EXISTS "Users can access their own phrases" ON phrases;
CREATE POLICY "Users can access their own phrases" ON phrases
  FOR ALL USING (
    auth.uid() IS NOT NULL AND 
    auth.uid()::text = user_id
  );

-- ===== PROMPTS TABLE POLICIES =====

-- Enable RLS on prompts table
ALTER TABLE prompts ENABLE ROW LEVEL SECURITY;

-- Prompts policies for authenticated users
-- Users can read active prompts (global system prompts)
DROP POLICY IF EXISTS "Users can read active prompts" ON prompts;
CREATE POLICY "Users can read active prompts" ON prompts
  FOR SELECT USING (
    auth.uid() IS NOT NULL AND 
    is_active = TRUE
  );

-- Service role policy for prompts (can manage all prompts)
DROP POLICY IF EXISTS "Service role can access all prompts" ON prompts;
CREATE POLICY "Service role can access all prompts" ON prompts
  FOR ALL USING (auth.role() = 'service_role');

-- ===== GRANTS FOR PROMPTS TABLE =====

-- Grant necessary permissions for prompts table
GRANT SELECT ON prompts TO authenticated;
GRANT ALL ON prompts TO service_role;
GRANT USAGE ON SEQUENCE prompts_id_seq TO service_role;

-- ===== AUTHENTICATION HELPER FUNCTIONS =====

-- Function to check if user is authenticated
CREATE OR REPLACE FUNCTION is_authenticated()
RETURNS BOOLEAN AS $$
BEGIN
  RETURN auth.uid() IS NOT NULL;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function to get current user ID
CREATE OR REPLACE FUNCTION get_current_user_id()
RETURNS TEXT AS $$
BEGIN
  RETURN auth.uid()::text;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function to validate user ownership
CREATE OR REPLACE FUNCTION validate_user_ownership(table_user_id TEXT)
RETURNS BOOLEAN AS $$
BEGIN
  RETURN auth.uid()::text = table_user_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ===== ENHANCED POLICIES WITH HELPER FUNCTIONS =====

-- Update policies to use helper functions for better readability
DROP POLICY IF EXISTS "Users can view their own profile" ON user_profiles;
CREATE POLICY "Users can view their own profile" ON user_profiles
  FOR SELECT USING (
    is_authenticated() AND 
    validate_user_ownership(user_id)
  );

DROP POLICY IF EXISTS "Users can insert their own profile" ON user_profiles;
CREATE POLICY "Users can insert their own profile" ON user_profiles
  FOR INSERT WITH CHECK (
    is_authenticated() AND 
    validate_user_ownership(user_id)
  );

DROP POLICY IF EXISTS "Users can update their own profile" ON user_profiles;
CREATE POLICY "Users can update their own profile" ON user_profiles
  FOR UPDATE USING (
    is_authenticated() AND 
    validate_user_ownership(user_id)
  );

-- ===== AUDIT LOGGING =====

-- Create audit log table for authentication events
CREATE TABLE IF NOT EXISTS auth_audit_log (
  id BIGSERIAL PRIMARY KEY,
  user_id TEXT NOT NULL,
  action TEXT NOT NULL,
  table_name TEXT,
  record_id TEXT,
  ip_address INET,
  user_agent TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Enable RLS on audit log
ALTER TABLE auth_audit_log ENABLE ROW LEVEL SECURITY;

-- Only service role can access audit log
CREATE POLICY "Service role can access audit log" ON auth_audit_log
  FOR ALL USING (auth.role() = 'service_role');

-- Grant permissions for audit log
GRANT ALL ON auth_audit_log TO service_role;
GRANT USAGE ON SEQUENCE auth_audit_log_id_seq TO service_role;

-- Function to log authentication events
CREATE OR REPLACE FUNCTION log_auth_event(
  p_action TEXT,
  p_table_name TEXT DEFAULT NULL,
  p_record_id TEXT DEFAULT NULL
)
RETURNS VOID AS $$
BEGIN
  INSERT INTO auth_audit_log (
    user_id,
    action,
    table_name,
    record_id,
    ip_address,
    user_agent
  ) VALUES (
    get_current_user_id(),
    p_action,
    p_table_name,
    p_record_id,
    inet_client_addr(),
    current_setting('request.headers', true)::json->>'user-agent'
  );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
