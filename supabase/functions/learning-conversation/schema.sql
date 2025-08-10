-- schema.sql
-- Database schema for learning conversation system
-- Creates tables for storing learning requests, vocabularies, and phrases

-- ===== MAIN LEARNING REQUESTS TABLE =====
-- Stores complete learning conversation data with user separation
CREATE TABLE IF NOT EXISTS learning_requests (
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
  CONSTRAINT learning_requests_request_id_check CHECK (length(request_id) > 0),
  CONSTRAINT learning_requests_user_id_check CHECK (length(user_id) > 0),
  CONSTRAINT learning_requests_user_prompt_check CHECK (length(user_prompt) > 0),
  CONSTRAINT learning_requests_tokens_check CHECK (total_tokens_used >= 0),
  CONSTRAINT learning_requests_cost_check CHECK (estimated_cost >= 0)
);

-- ===== VOCABULARIES TABLE =====
-- Stores vocabulary words extracted from learning conversations
CREATE TABLE IF NOT EXISTS learning_request_vocabularies (
  id BIGSERIAL PRIMARY KEY,
  learning_request_id BIGINT REFERENCES learning_requests(id) ON DELETE CASCADE,
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

-- ===== PHRASES TABLE =====
-- Stores phrases extracted from learning conversations
CREATE TABLE IF NOT EXISTS learning_request_phrases (
  id BIGSERIAL PRIMARY KEY,
  learning_request_id BIGINT REFERENCES learning_requests(id) ON DELETE CASCADE,
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

-- ===== INDEXES FOR PERFORMANCE =====

-- Learning requests indexes
CREATE INDEX IF NOT EXISTS idx_learning_requests_user_id ON learning_requests(user_id);
CREATE INDEX IF NOT EXISTS idx_learning_requests_request_id ON learning_requests(request_id);
CREATE INDEX IF NOT EXISTS idx_learning_requests_created_at ON learning_requests(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_learning_requests_user_level ON learning_requests(user_level);
CREATE INDEX IF NOT EXISTS idx_learning_requests_ai_provider ON learning_requests(ai_provider);

-- Vocabularies indexes
CREATE INDEX IF NOT EXISTS idx_vocabularies_learning_request_id ON learning_request_vocabularies(learning_request_id);
CREATE INDEX IF NOT EXISTS idx_vocabularies_user_id ON learning_request_vocabularies(user_id);
CREATE INDEX IF NOT EXISTS idx_vocabularies_english ON learning_request_vocabularies(english);
CREATE INDEX IF NOT EXISTS idx_vocabularies_is_used ON learning_request_vocabularies(is_used);

-- Phrases indexes
CREATE INDEX IF NOT EXISTS idx_phrases_learning_request_id ON learning_request_phrases(learning_request_id);
CREATE INDEX IF NOT EXISTS idx_phrases_user_id ON learning_request_phrases(user_id);
CREATE INDEX IF NOT EXISTS idx_phrases_english ON learning_request_phrases(english);
CREATE INDEX IF NOT EXISTS idx_phrases_is_used ON learning_request_phrases(is_used);

-- ===== ROW LEVEL SECURITY (RLS) =====

-- Enable RLS on all tables
ALTER TABLE learning_requests ENABLE ROW LEVEL SECURITY;
ALTER TABLE learning_request_vocabularies ENABLE ROW LEVEL SECURITY;
ALTER TABLE learning_request_phrases ENABLE ROW LEVEL SECURITY;

-- ===== RLS POLICIES =====

-- Learning requests policies
DROP POLICY IF EXISTS "Users can access their own learning requests" ON learning_requests;
CREATE POLICY "Users can access their own learning requests" ON learning_requests
  FOR ALL USING (auth.uid()::text = user_id);

-- Vocabularies policies
DROP POLICY IF EXISTS "Users can access their own vocabularies" ON learning_request_vocabularies;
CREATE POLICY "Users can access their own vocabularies" ON learning_request_vocabularies
  FOR ALL USING (auth.uid()::text = user_id);

-- Phrases policies
DROP POLICY IF EXISTS "Users can access their own phrases" ON learning_request_phrases;
CREATE POLICY "Users can access their own phrases" ON learning_request_phrases
  FOR ALL USING (auth.uid()::text = user_id);

-- ===== SERVICE ROLE POLICIES =====
-- Allow the service role to access all data (for Edge Functions)

-- Learning requests service role policy
DROP POLICY IF EXISTS "Service role can access all learning requests" ON learning_requests;
CREATE POLICY "Service role can access all learning requests" ON learning_requests
  FOR ALL USING (auth.role() = 'service_role');

-- Vocabularies service role policy
DROP POLICY IF EXISTS "Service role can access all vocabularies" ON learning_request_vocabularies;
CREATE POLICY "Service role can access all vocabularies" ON learning_request_vocabularies
  FOR ALL USING (auth.role() = 'service_role');

-- Phrases service role policy
DROP POLICY IF EXISTS "Service role can access all phrases" ON learning_request_phrases;
CREATE POLICY "Service role can access all phrases" ON learning_request_phrases
  FOR ALL USING (auth.role() = 'service_role');

-- ===== HELPFUL FUNCTIONS =====

-- Function to get user learning statistics
CREATE OR REPLACE FUNCTION get_user_learning_statistics(p_user_id TEXT)
RETURNS JSON AS $$
DECLARE
  result JSON;
BEGIN
  SELECT json_build_object(
    'totalRequests', (
      SELECT COUNT(*) FROM learning_requests WHERE user_id = p_user_id
    ),
    'totalTokensUsed', (
      SELECT COALESCE(SUM(total_tokens_used), 0) FROM learning_requests WHERE user_id = p_user_id
    ),
    'totalCostUsd', (
      SELECT COALESCE(SUM(estimated_cost), 0) FROM learning_requests WHERE user_id = p_user_id
    ),
    'totalVocabularies', (
      SELECT COUNT(*) FROM learning_request_vocabularies WHERE user_id = p_user_id
    ),
    'totalPhrases', (
      SELECT COUNT(*) FROM learning_request_phrases WHERE user_id = p_user_id
    ),
    'lastRequestAt', (
      SELECT MAX(created_at) FROM learning_requests WHERE user_id = p_user_id
    )
  ) INTO result;
  
  RETURN result;
END;
$$ LANGUAGE plpgsql;

-- Function to get recent learning conversations with content
CREATE OR REPLACE FUNCTION get_recent_learning_conversations(
  p_user_id TEXT,
  p_limit INTEGER DEFAULT 10
)
RETURNS JSON AS $$
DECLARE
  result JSON;
BEGIN
  SELECT json_agg(
    json_build_object(
      'requestId', lr.request_id,
      'userId', lr.user_id,
      'userLevel', lr.user_level,
      'focusAreas', lr.focus_areas,
      'aiProvider', lr.ai_provider,
      'aiModel', lr.ai_model,
      'totalTokensUsed', lr.total_tokens_used,
      'estimatedCost', lr.estimated_cost,
      'requestTimestamp', lr.request_timestamp,
      'createdAt', lr.created_at,
      'systemPrompt', lr.system_prompt,
      'userPrompt', lr.user_prompt,
      'aiResponse', lr.ai_response,
      'errorMessage', lr.error_message,
      'metadata', lr.metadata,
      'vocabularies', COALESCE(v.vocabularies, '[]'::json),
      'phrases', COALESCE(p.phrases, '[]'::json)
    ) ORDER BY lr.created_at DESC
  )
  FROM learning_requests lr
  LEFT JOIN (
    SELECT 
      learning_request_id,
      json_agg(json_build_object(
        'english', english,
        'persian', persian,
        'isUsed', is_used
      )) as vocabularies
    FROM learning_request_vocabularies
    WHERE user_id = p_user_id
    GROUP BY learning_request_id
  ) v ON lr.id = v.learning_request_id
  LEFT JOIN (
    SELECT 
      learning_request_id,
      json_agg(json_build_object(
        'english', english,
        'persian', persian,
        'isUsed', is_used
      )) as phrases
    FROM learning_request_phrases
    WHERE user_id = p_user_id
    GROUP BY learning_request_id
  ) p ON lr.id = p.learning_request_id
  WHERE lr.user_id = p_user_id
  ORDER BY lr.created_at DESC
  LIMIT p_limit
  INTO result;
  
  RETURN COALESCE(result, '[]'::json);
END;
$$ LANGUAGE plpgsql;

-- ===== EXAMPLE DATA (FOR TESTING) =====
-- Uncomment to insert sample data for testing

/*
-- Sample learning request
INSERT INTO learning_requests (
  request_id, user_id, user_level, focus_areas, ai_provider, ai_model,
  total_tokens_used, estimated_cost, request_timestamp, system_prompt,
  user_prompt, ai_response, metadata
) VALUES (
  'req_test_user_' || extract(epoch from now()),
  'test_user_123',
  'intermediate',
  ARRAY['conversation', 'vocabulary'],
  'gemini',
  'gemini-1.5-flash',
  150,
  0.000225,
  NOW(),
  'You are an English learning assistant...',
  'Hello, can you help me practice English?',
  'Hello! I''d be happy to help you practice English. What would you like to focus on today?',
  '{"messageType": "conversation", "extractedContentCount": {"vocabularies": 2, "phrases": 1}}'::jsonb
);

-- Sample vocabulary
INSERT INTO learning_request_vocabularies (
  learning_request_id, user_id, english, persian, is_used
) VALUES (
  (SELECT id FROM learning_requests WHERE user_id = 'test_user_123' LIMIT 1),
  'test_user_123',
  'practice',
  'تمرین',
  false
);

-- Sample phrase
INSERT INTO learning_request_phrases (
  learning_request_id, user_id, english, persian, is_used
) VALUES (
  (SELECT id FROM learning_requests WHERE user_id = 'test_user_123' LIMIT 1),
  'test_user_123',
  'I''d be happy to help',
  'خوشحال می‌شوم کمک کنم',
  false
);
*/

-- ===== GRANTS =====
-- Grant necessary permissions for the service role

GRANT ALL ON learning_requests TO service_role;
GRANT ALL ON learning_request_vocabularies TO service_role;
GRANT ALL ON learning_request_phrases TO service_role;
GRANT USAGE ON SEQUENCE learning_requests_id_seq TO service_role;
GRANT USAGE ON SEQUENCE learning_request_vocabularies_id_seq TO service_role;
GRANT USAGE ON SEQUENCE learning_request_phrases_id_seq TO service_role;