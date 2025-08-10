-- Create vocabularies table for storing vocabulary words
-- This migration creates the vocabularies table extracted from learning conversations

-- ===== VOCABULARIES TABLE =====
-- Stores vocabulary words extracted from learning conversations
CREATE TABLE IF NOT EXISTS vocabularies (
  id BIGSERIAL PRIMARY KEY,
  request_id BIGINT REFERENCES requests(id) ON DELETE CASCADE,
  user_id TEXT NOT NULL,
  english TEXT NOT NULL,
  persian TEXT NOT NULL DEFAULT '',
  is_used BOOLEAN NOT NULL DEFAULT FALSE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  
  -- Constraints
  CONSTRAINT vocabularies_english_check CHECK (length(english) > 0),
  CONSTRAINT vocabularies_user_id_check CHECK (length(user_id) > 0),
  
  -- Prevent duplicate vocabularies for the same user
  UNIQUE(user_id, english)
);

-- ===== COMMENTS =====
-- Add comments for documentation
COMMENT ON TABLE vocabularies IS 'Stores vocabulary words extracted from learning conversations';