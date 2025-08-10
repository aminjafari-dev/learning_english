-- Create indexes for performance optimization
-- This migration creates all necessary indexes for better query performance

-- ===== INDEXES FOR PERFORMANCE =====

-- User profiles indexes
CREATE INDEX IF NOT EXISTS idx_user_profiles_user_id ON user_profiles(user_id);
CREATE INDEX IF NOT EXISTS idx_user_profiles_level ON user_profiles(level);
CREATE INDEX IF NOT EXISTS idx_user_profiles_language ON user_profiles(language);

-- Requests indexes
CREATE INDEX IF NOT EXISTS idx_requests_user_id ON requests(user_id);
CREATE INDEX IF NOT EXISTS idx_requests_request_id ON requests(request_id);
CREATE INDEX IF NOT EXISTS idx_requests_created_at ON requests(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_requests_user_level ON requests(user_level);
CREATE INDEX IF NOT EXISTS idx_requests_ai_provider ON requests(ai_provider);

-- Vocabularies indexes
CREATE INDEX IF NOT EXISTS idx_vocabularies_request_id ON vocabularies(request_id);
CREATE INDEX IF NOT EXISTS idx_vocabularies_user_id ON vocabularies(user_id);
CREATE INDEX IF NOT EXISTS idx_vocabularies_english ON vocabularies(english);
CREATE INDEX IF NOT EXISTS idx_vocabularies_is_used ON vocabularies(is_used);

-- Phrases indexes
CREATE INDEX IF NOT EXISTS idx_phrases_request_id ON phrases(request_id);
CREATE INDEX IF NOT EXISTS idx_phrases_user_id ON phrases(user_id);
CREATE INDEX IF NOT EXISTS idx_phrases_english ON phrases(english);
CREATE INDEX IF NOT EXISTS idx_phrases_is_used ON phrases(is_used);