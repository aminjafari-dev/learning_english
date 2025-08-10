-- Create helper functions for learning statistics and data retrieval
-- This migration creates useful functions for the learning English app

-- ===== HELPFUL FUNCTIONS =====

-- Function to get user learning statistics
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