-- Migration: Rename tables to simpler names
-- Renames learning_requests to requests, learning_request_vocabularies to vocabularies, learning_request_phrases to phrases

-- ===== RENAME TABLES =====

-- Drop existing policies first
DROP POLICY IF EXISTS "Users can access their own learning requests" ON learning_requests;
DROP POLICY IF EXISTS "Service role can access all learning requests" ON learning_requests;
DROP POLICY IF EXISTS "Users can access their own vocabularies" ON learning_request_vocabularies;
DROP POLICY IF EXISTS "Service role can access all vocabularies" ON learning_request_vocabularies;
DROP POLICY IF EXISTS "Users can access their own phrases" ON learning_request_phrases;
DROP POLICY IF EXISTS "Service role can access all phrases" ON learning_request_phrases;

-- Rename tables
ALTER TABLE learning_requests RENAME TO requests;
ALTER TABLE learning_request_vocabularies RENAME TO vocabularies;
ALTER TABLE learning_request_phrases RENAME TO phrases;

-- ===== UPDATE FOREIGN KEY REFERENCES =====

-- Update vocabulary table foreign key constraint name
ALTER TABLE vocabularies RENAME CONSTRAINT learning_request_vocabularies_learning_request_id_fkey TO vocabularies_request_id_fkey;

-- Update phrase table foreign key constraint name  
ALTER TABLE phrases RENAME CONSTRAINT learning_request_phrases_learning_request_id_fkey TO phrases_request_id_fkey;

-- Rename foreign key column for clarity
ALTER TABLE vocabularies RENAME COLUMN learning_request_id TO request_id;
ALTER TABLE phrases RENAME COLUMN learning_request_id TO request_id;

-- ===== UPDATE INDEXES =====

-- Requests indexes (rename existing ones)
DROP INDEX IF EXISTS idx_learning_requests_user_id;
DROP INDEX IF EXISTS idx_learning_requests_request_id;
DROP INDEX IF EXISTS idx_learning_requests_created_at;
DROP INDEX IF EXISTS idx_learning_requests_user_level;
DROP INDEX IF EXISTS idx_learning_requests_ai_provider;

CREATE INDEX IF NOT EXISTS idx_requests_user_id ON requests(user_id);
CREATE INDEX IF NOT EXISTS idx_requests_request_id ON requests(request_id);
CREATE INDEX IF NOT EXISTS idx_requests_created_at ON requests(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_requests_user_level ON requests(user_level);
CREATE INDEX IF NOT EXISTS idx_requests_ai_provider ON requests(ai_provider);

-- Vocabularies indexes
DROP INDEX IF EXISTS idx_vocabularies_learning_request_id;
DROP INDEX IF EXISTS idx_vocabularies_user_id;
DROP INDEX IF EXISTS idx_vocabularies_english;
DROP INDEX IF EXISTS idx_vocabularies_is_used;

CREATE INDEX IF NOT EXISTS idx_vocabularies_request_id ON vocabularies(request_id);
CREATE INDEX IF NOT EXISTS idx_vocabularies_user_id ON vocabularies(user_id);
CREATE INDEX IF NOT EXISTS idx_vocabularies_english ON vocabularies(english);
CREATE INDEX IF NOT EXISTS idx_vocabularies_is_used ON vocabularies(is_used);

-- Phrases indexes
DROP INDEX IF EXISTS idx_phrases_learning_request_id;
DROP INDEX IF EXISTS idx_phrases_user_id;
DROP INDEX IF EXISTS idx_phrases_english;
DROP INDEX IF EXISTS idx_phrases_is_used;

CREATE INDEX IF NOT EXISTS idx_phrases_request_id ON phrases(request_id);
CREATE INDEX IF NOT EXISTS idx_phrases_user_id ON phrases(user_id);
CREATE INDEX IF NOT EXISTS idx_phrases_english ON phrases(english);
CREATE INDEX IF NOT EXISTS idx_phrases_is_used ON phrases(is_used);

-- ===== RECREATE RLS POLICIES =====

-- Requests policies
CREATE POLICY "Users can access their own requests" ON requests
  FOR ALL USING (auth.uid()::text = user_id);

CREATE POLICY "Service role can access all requests" ON requests
  FOR ALL USING (auth.role() = 'service_role');

-- Vocabularies policies
CREATE POLICY "Users can access their own vocabularies" ON vocabularies
  FOR ALL USING (auth.uid()::text = user_id);

CREATE POLICY "Service role can access all vocabularies" ON vocabularies
  FOR ALL USING (auth.role() = 'service_role');

-- Phrases policies
CREATE POLICY "Users can access their own phrases" ON phrases
  FOR ALL USING (auth.uid()::text = user_id);

CREATE POLICY "Service role can access all phrases" ON phrases
  FOR ALL USING (auth.role() = 'service_role');

-- ===== UPDATE FUNCTIONS =====

-- Drop and recreate the statistics function with new table names
DROP FUNCTION IF EXISTS get_user_learning_statistics(TEXT);

CREATE OR REPLACE FUNCTION get_user_learning_statistics(p_user_id TEXT)
RETURNS JSON AS $$
DECLARE
  result JSON;
BEGIN
  SELECT json_build_object(
    'totalRequests', (
      SELECT COUNT(*) FROM requests WHERE user_id = p_user_id
    ),
    'totalTokensUsed', (
      SELECT COALESCE(SUM(total_tokens_used), 0) FROM requests WHERE user_id = p_user_id
    ),
    'totalCostUsd', (
      SELECT COALESCE(SUM(estimated_cost), 0) FROM requests WHERE user_id = p_user_id
    ),
    'totalVocabularies', (
      SELECT COUNT(*) FROM vocabularies WHERE user_id = p_user_id
    ),
    'totalPhrases', (
      SELECT COUNT(*) FROM phrases WHERE user_id = p_user_id
    ),
    'lastRequestAt', (
      SELECT MAX(created_at) FROM requests WHERE user_id = p_user_id
    )
  ) INTO result;
  
  RETURN result;
END;
$$ LANGUAGE plpgsql;

-- Drop and recreate the recent conversations function with new table names
DROP FUNCTION IF EXISTS get_recent_learning_conversations(TEXT, INTEGER);

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
      'requestId', r.request_id,
      'userId', r.user_id,
      'userLevel', r.user_level,
      'focusAreas', r.focus_areas,
      'aiProvider', r.ai_provider,
      'aiModel', r.ai_model,
      'totalTokensUsed', r.total_tokens_used,
      'estimatedCost', r.estimated_cost,
      'requestTimestamp', r.request_timestamp,
      'createdAt', r.created_at,
      'systemPrompt', r.system_prompt,
      'userPrompt', r.user_prompt,
      'aiResponse', r.ai_response,
      'errorMessage', r.error_message,
      'metadata', r.metadata,
      'vocabularies', COALESCE(v.vocabularies, '[]'::json),
      'phrases', COALESCE(p.phrases, '[]'::json)
    ) ORDER BY r.created_at DESC
  )
  FROM requests r
  LEFT JOIN (
    SELECT 
      request_id,
      json_agg(json_build_object(
        'english', english,
        'persian', persian,
        'isUsed', is_used
      )) as vocabularies
    FROM vocabularies
    WHERE user_id = p_user_id
    GROUP BY request_id
  ) v ON r.id = v.request_id
  LEFT JOIN (
    SELECT 
      request_id,
      json_agg(json_build_object(
        'english', english,
        'persian', persian,
        'isUsed', is_used
      )) as phrases
    FROM phrases
    WHERE user_id = p_user_id
    GROUP BY request_id
  ) p ON r.id = p.request_id
  WHERE r.user_id = p_user_id
  ORDER BY r.created_at DESC
  LIMIT p_limit
  INTO result;
  
  RETURN COALESCE(result, '[]'::json);
END;
$$ LANGUAGE plpgsql;

-- ===== UPDATE GRANTS =====
-- Grant necessary permissions for the service role

GRANT ALL ON requests TO service_role;
GRANT ALL ON vocabularies TO service_role;
GRANT ALL ON phrases TO service_role;
GRANT USAGE ON SEQUENCE requests_id_seq TO service_role;
GRANT USAGE ON SEQUENCE vocabularies_id_seq TO service_role;
GRANT USAGE ON SEQUENCE phrases_id_seq TO service_role;