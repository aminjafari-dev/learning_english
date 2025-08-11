-- Create simplified prompts table with just version and content
-- This replaces the complex prompts system with a simple versioned prompt

-- Drop existing prompts table if it exists
DROP TABLE IF EXISTS prompts CASCADE;

-- Create simplified prompts table
CREATE TABLE IF NOT EXISTS prompts (
  id BIGSERIAL PRIMARY KEY,
  version INTEGER NOT NULL DEFAULT 1,
  content TEXT NOT NULL,
  is_active BOOLEAN NOT NULL DEFAULT TRUE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  
  -- Constraints
  CONSTRAINT prompts_content_check CHECK (length(content) > 0),
  CONSTRAINT prompts_version_check CHECK (version > 0)
);

-- Create indexes for performance
CREATE INDEX IF NOT EXISTS idx_prompts_version ON prompts(version DESC);
CREATE INDEX IF NOT EXISTS idx_prompts_active ON prompts(is_active);
CREATE INDEX IF NOT EXISTS idx_prompts_created_at ON prompts(created_at DESC);

-- Only allow one active prompt at a time
CREATE UNIQUE INDEX IF NOT EXISTS idx_prompts_active_unique ON prompts(is_active) WHERE is_active = TRUE;

-- Enable RLS
ALTER TABLE prompts ENABLE ROW LEVEL SECURITY;

-- Service role can access all prompts (for Edge Functions)
DROP POLICY IF EXISTS "Service role can access all prompts" ON prompts;
CREATE POLICY "Service role can access all prompts" ON prompts
  FOR ALL USING (auth.role() = 'service_role');

-- Users can read active prompts
DROP POLICY IF EXISTS "Users can read active prompts" ON prompts;
CREATE POLICY "Users can read active prompts" ON prompts
  FOR SELECT USING (is_active = TRUE);

-- Function to get the latest active prompt
CREATE OR REPLACE FUNCTION get_latest_prompt()
RETURNS TABLE(
  id BIGINT,
  version INTEGER,
  content TEXT,
  created_at TIMESTAMPTZ
) AS $$
BEGIN
  RETURN QUERY
  SELECT 
    p.id,
    p.version,
    p.content,
    p.created_at
  FROM prompts p
  WHERE p.is_active = TRUE
  ORDER BY p.version DESC, p.created_at DESC
  LIMIT 1;
END;
$$ LANGUAGE plpgsql;

-- Function to create a new prompt version
CREATE OR REPLACE FUNCTION create_new_prompt_version(
  p_content TEXT
)
RETURNS BIGINT AS $$
DECLARE
  new_version INTEGER;
  new_prompt_id BIGINT;
BEGIN
  -- Get the next version number
  SELECT COALESCE(MAX(version), 0) + 1 INTO new_version FROM prompts;
  
  -- Deactivate all existing prompts
  UPDATE prompts SET is_active = FALSE, updated_at = NOW();
  
  -- Insert new prompt
  INSERT INTO prompts (version, content, is_active)
  VALUES (new_version, p_content, TRUE)
  RETURNING id INTO new_prompt_id;
  
  RETURN new_prompt_id;
END;
$$ LANGUAGE plpgsql;

-- Grant permissions
GRANT ALL ON prompts TO service_role;
GRANT USAGE ON SEQUENCE prompts_id_seq TO service_role;
GRANT EXECUTE ON FUNCTION get_latest_prompt() TO service_role;
GRANT EXECUTE ON FUNCTION create_new_prompt_version(TEXT) TO service_role;