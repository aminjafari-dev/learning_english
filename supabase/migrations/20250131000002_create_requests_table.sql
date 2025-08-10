-- Create requests table for storing learning conversation data
-- This migration creates the main requests table with user separation

-- ===== MAIN REQUESTS TABLE =====
-- Stores complete learning conversation data with user separation
CREATE TABLE IF NOT EXISTS requests (
  id BIGSERIAL PRIMARY KEY,
  request_id TEXT UNIQUE NOT NULL,
  user_id TEXT NOT NULL,
  user_level TEXT NOT NULL CHECK (user_level IN ('beginner', 'elementary', 'intermediate', 'advanced')),
  focus_areas TEXT[] NOT NULL DEFAULT '{}',
  ai_provider TEXT NOT NULL DEFAULT 'gemini',
  ai_model TEXT NOT NULL DEFAULT 'gemini-1.5-flash',
  total_tokens_used INTEGER NOT NULL DEFAULT 0,
  estimated_cost DECIMAL(10,6) NOT NULL DEFAULT 0.0,
  request_timestamp TIMESTAMPTZ NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  system_prompt TEXT NOT NULL,
  user_prompt TEXT NOT NULL,
  ai_response TEXT NOT NULL DEFAULT '',
  error_message TEXT,
  metadata JSONB,
  
  -- Constraints
  CONSTRAINT requests_request_id_check CHECK (length(request_id) > 0),
  CONSTRAINT requests_user_id_check CHECK (length(user_id) > 0),
  CONSTRAINT requests_user_prompt_check CHECK (length(user_prompt) > 0),
  CONSTRAINT requests_tokens_check CHECK (total_tokens_used >= 0),
  CONSTRAINT requests_cost_check CHECK (estimated_cost >= 0)
);

-- ===== COMMENTS =====
-- Add comments for documentation
COMMENT ON TABLE requests IS 'Stores learning conversation requests and AI responses';