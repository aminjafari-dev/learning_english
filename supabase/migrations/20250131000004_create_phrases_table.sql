-- Create phrases table for storing phrases
-- This migration creates the phrases table extracted from learning conversations

-- ===== PHRASES TABLE =====
-- Stores phrases extracted from learning conversations
CREATE TABLE IF NOT EXISTS phrases (
  id BIGSERIAL PRIMARY KEY,
  request_id BIGINT REFERENCES requests(id) ON DELETE CASCADE,
  user_id TEXT NOT NULL,
  english TEXT NOT NULL,
  persian TEXT NOT NULL DEFAULT '',
  is_used BOOLEAN NOT NULL DEFAULT FALSE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  
  -- Constraints
  CONSTRAINT phrases_english_check CHECK (length(english) > 0),
  CONSTRAINT phrases_user_id_check CHECK (length(user_id) > 0),
  
  -- Prevent duplicate phrases for the same user
  UNIQUE(user_id, english)
);

-- ===== COMMENTS =====
-- Add comments for documentation
COMMENT ON TABLE phrases IS 'Stores phrases extracted from learning conversations';