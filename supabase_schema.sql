-- Supabase Schema for Learning English App
-- This script creates all necessary tables for storing LearningRequestModel data
-- Run this script in your Supabase SQL Editor: https://supabase.com/dashboard/project/secsedrlvpifggleixfk

-- =====================================================
-- 1. CREATE MAIN LEARNING REQUESTS TABLE
-- =====================================================

-- Main learning requests table with all LearningRequestModel attributes
CREATE TABLE learning_requests (
  id BIGSERIAL PRIMARY KEY,
  request_id TEXT UNIQUE NOT NULL,
  user_id TEXT NOT NULL,
  user_level TEXT NOT NULL,
  focus_areas TEXT[] NOT NULL DEFAULT '{}',
  ai_provider TEXT NOT NULL,
  ai_model TEXT NOT NULL,
  total_tokens_used INTEGER NOT NULL DEFAULT 0,
  estimated_cost DECIMAL(10,6) NOT NULL DEFAULT 0.0,
  request_timestamp TIMESTAMPTZ NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  system_prompt TEXT NOT NULL,
  user_prompt TEXT NOT NULL,
  error_message TEXT,
  metadata JSONB
);

-- =====================================================
-- 2. CREATE RELATED TABLES FOR VOCABULARIES AND PHRASES
-- =====================================================

-- Vocabularies table with foreign key relationship
CREATE TABLE learning_request_vocabularies (
  id BIGSERIAL PRIMARY KEY,
  learning_request_id BIGINT REFERENCES learning_requests(id) ON DELETE CASCADE,
  english TEXT NOT NULL,
  persian TEXT NOT NULL,
  is_used BOOLEAN NOT NULL DEFAULT FALSE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Phrases table with foreign key relationship
CREATE TABLE learning_request_phrases (
  id BIGSERIAL PRIMARY KEY,
  learning_request_id BIGINT REFERENCES learning_requests(id) ON DELETE CASCADE,
  english TEXT NOT NULL,
  persian TEXT NOT NULL,
  is_used BOOLEAN NOT NULL DEFAULT FALSE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- =====================================================
-- 3. CREATE PERFORMANCE INDEXES
-- =====================================================

-- Indexes for optimal query performance
CREATE INDEX idx_learning_requests_user_id ON learning_requests(user_id);
CREATE INDEX idx_learning_requests_request_id ON learning_requests(request_id);
CREATE INDEX idx_learning_requests_created_at ON learning_requests(created_at DESC);
CREATE INDEX idx_vocabularies_learning_request_id ON learning_request_vocabularies(learning_request_id);
CREATE INDEX idx_phrases_learning_request_id ON learning_request_phrases(learning_request_id);

-- =====================================================
-- 4. ENABLE ROW LEVEL SECURITY (RLS)
-- =====================================================

-- Enable Row Level Security for all tables
ALTER TABLE learning_requests ENABLE ROW LEVEL SECURITY;
ALTER TABLE learning_request_vocabularies ENABLE ROW LEVEL SECURITY;
ALTER TABLE learning_request_phrases ENABLE ROW LEVEL SECURITY;

-- =====================================================
-- 5. CREATE RLS POLICIES FOR USER DATA ISOLATION
-- =====================================================

-- RLS policy for learning_requests: Users can only access their own requests
CREATE POLICY "Users can only access their own learning requests" ON learning_requests
  FOR ALL USING (auth.uid()::text = user_id);

-- RLS policy for vocabularies: Users can only access vocabularies from their own requests
CREATE POLICY "Users can only access their own vocabularies" ON learning_request_vocabularies
  FOR ALL USING (EXISTS (
    SELECT 1 FROM learning_requests 
    WHERE learning_requests.id = learning_request_vocabularies.learning_request_id 
    AND learning_requests.user_id = auth.uid()::text
  ));

-- RLS policy for phrases: Users can only access phrases from their own requests
CREATE POLICY "Users can only access their own phrases" ON learning_request_phrases
  FOR ALL USING (EXISTS (
    SELECT 1 FROM learning_requests 
    WHERE learning_requests.id = learning_request_phrases.learning_request_id 
    AND learning_requests.user_id = auth.uid()::text
  ));

-- =====================================================
-- 6. CREATE TEST DATA (OPTIONAL)
-- =====================================================

-- Insert sample learning request for testing
INSERT INTO learning_requests (
  request_id,
  user_id,
  user_level,
  focus_areas,
  ai_provider,
  ai_model,
  total_tokens_used,
  estimated_cost,
  request_timestamp,
  system_prompt,
  user_prompt,
  error_message,
  metadata
) VALUES (
  'test_request_001',
  'test_user_123',
  'intermediate',
  ARRAY['business', 'travel'],
  'gemini',
  'gemini-1.5-flash',
  150,
  0.003,
  NOW(),
  'You are an English teacher helping intermediate level students learn business and travel vocabulary.',
  'Please give me some business vocabulary words.',
  NULL,
  '{"source": "daily_lessons", "version": "1.0"}'::jsonb
);

-- Get the ID of the inserted request for related data
DO $$
DECLARE
  request_internal_id BIGINT;
BEGIN
  -- Get the internal ID of the test request
  SELECT id INTO request_internal_id 
  FROM learning_requests 
  WHERE request_id = 'test_request_001';

  -- Insert sample vocabularies
  INSERT INTO learning_request_vocabularies (
    learning_request_id,
    english,
    persian,
    is_used
  ) VALUES 
    (request_internal_id, 'meeting', 'جلسه', false),
    (request_internal_id, 'presentation', 'ارائه', false),
    (request_internal_id, 'deadline', 'مهلت', false),
    (request_internal_id, 'schedule', 'برنامه زمانی', false);

  -- Insert sample phrases
  INSERT INTO learning_request_phrases (
    learning_request_id,
    english,
    persian,
    is_used
  ) VALUES 
    (request_internal_id, 'Let''s schedule a meeting', 'بیایید جلسه‌ای تنظیم کنیم', false),
    (request_internal_id, 'The deadline is tomorrow', 'مهلت فردا است', false);
END $$;

-- =====================================================
-- 7. VERIFICATION QUERIES
-- =====================================================

-- Verify tables were created successfully
SELECT 
  schemaname,
  tablename,
  tableowner,
  tablespace,
  hasindexes,
  hasrules,
  hastriggers
FROM pg_tables 
WHERE schemaname = 'public' 
AND tablename IN ('learning_requests', 'learning_request_vocabularies', 'learning_request_phrases');

-- Verify indexes were created
SELECT 
  indexname,
  indexdef
FROM pg_indexes 
WHERE schemaname = 'public' 
AND tablename IN ('learning_requests', 'learning_request_vocabularies', 'learning_request_phrases');

-- Verify RLS is enabled
SELECT 
  schemaname,
  tablename,
  rowsecurity
FROM pg_tables 
WHERE schemaname = 'public' 
AND tablename IN ('learning_requests', 'learning_request_vocabularies', 'learning_request_phrases');

-- Verify test data was inserted
SELECT 
  lr.request_id,
  lr.user_id,
  lr.user_level,
  lr.focus_areas,
  lr.ai_provider,
  lr.ai_model,
  lr.total_tokens_used,
  lr.estimated_cost,
  COUNT(lrv.id) as vocabulary_count,
  COUNT(lrp.id) as phrase_count
FROM learning_requests lr
LEFT JOIN learning_request_vocabularies lrv ON lr.id = lrv.learning_request_id
LEFT JOIN learning_request_phrases lrp ON lr.id = lrp.learning_request_id
WHERE lr.request_id = 'test_request_001'
GROUP BY lr.id, lr.request_id, lr.user_id, lr.user_level, lr.focus_areas, lr.ai_provider, lr.ai_model, lr.total_tokens_used, lr.estimated_cost;

-- =====================================================
-- INSTRUCTIONS FOR USE:
-- 
-- 1. Go to https://supabase.com/dashboard/project/secsedrlvpifggleixfk
-- 2. Navigate to SQL Editor
-- 3. Copy and paste this entire script
-- 4. Click "Run" to execute
-- 5. Verify the results using the verification queries at the end
-- 
-- This will create:
-- - learning_requests table (main table with all LearningRequestModel attributes)
-- - learning_request_vocabularies table (vocabularies with foreign key)
-- - learning_request_phrases table (phrases with foreign key)
-- - Performance indexes for optimal queries
-- - Row Level Security policies for user data isolation
-- - Sample test data for verification
-- =====================================================