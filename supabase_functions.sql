-- ===== SUPABASE FUNCTIONS FOR DAILY LESSONS =====
-- These functions encapsulate complex business logic for retrieving vocabularies and phrases
-- Call these functions instead of making multiple queries from the client

-- ===== 1. GET USER LEARNING REQUESTS WITH CONTENT =====
-- This function replaces the complex join query in getUserLearningRequests()
CREATE OR REPLACE FUNCTION get_user_learning_requests_with_content(
  p_user_id TEXT,
  p_limit INTEGER DEFAULT 50,
  p_offset INTEGER DEFAULT 0
)
RETURNS TABLE (
  request_id TEXT,
  user_id TEXT,
  user_level TEXT,
  focus_areas TEXT[],
  ai_provider TEXT,
  ai_model TEXT,
  total_tokens_used INTEGER,
  estimated_cost DECIMAL(10,6),
  request_timestamp TIMESTAMPTZ,
  created_at TIMESTAMPTZ,
  system_prompt TEXT,
  user_prompt TEXT,
  error_message TEXT,
  metadata JSONB,
  vocabularies JSONB,
  phrases JSONB
)
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  RETURN QUERY
  SELECT 
    lr.request_id,
    lr.user_id,
    lr.user_level,
    lr.focus_areas,
    lr.ai_provider,
    lr.ai_model,
    lr.total_tokens_used,
    lr.estimated_cost,
    lr.request_timestamp,
    lr.created_at,
    lr.system_prompt,
    lr.user_prompt,
    lr.error_message,
    lr.metadata,
    COALESCE(
      (
        SELECT jsonb_agg(
          jsonb_build_object(
            'id', lrv.id,
            'english', lrv.english,
            'persian', lrv.persian,
            'is_used', lrv.is_used,
            'created_at', lrv.created_at
          )
        )
        FROM learning_request_vocabularies lrv
        WHERE lrv.learning_request_id = lr.id
      ),
      '[]'::jsonb
    ) as vocabularies,
    COALESCE(
      (
        SELECT jsonb_agg(
          jsonb_build_object(
            'id', lrp.id,
            'english', lrp.english,
            'persian', lrp.persian,
            'is_used', lrp.is_used,
            'created_at', lrp.created_at
          )
        )
        FROM learning_request_phrases lrp
        WHERE lrp.learning_request_id = lr.id
      ),
      '[]'::jsonb
    ) as phrases
  FROM learning_requests lr
  WHERE lr.user_id = p_user_id
  ORDER BY lr.created_at DESC
  LIMIT p_limit
  OFFSET p_offset;
END;
$$;

-- ===== 2. GET USER VOCABULARIES FLATTENED =====
-- This function returns all vocabularies from all user requests as a flat list
CREATE OR REPLACE FUNCTION get_user_vocabularies_flattened(
  p_user_id TEXT
)
RETURNS TABLE (
  english TEXT,
  persian TEXT,
  is_used BOOLEAN,
  created_at TIMESTAMPTZ,
  request_id TEXT,
  user_level TEXT,
  focus_areas TEXT[]
)
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  RETURN QUERY
  SELECT 
    lrv.english,
    lrv.persian,
    lrv.is_used,
    lrv.created_at,
    lr.request_id,
    lr.user_level,
    lr.focus_areas
  FROM learning_request_vocabularies lrv
  INNER JOIN learning_requests lr ON lrv.learning_request_id = lr.id
  WHERE lr.user_id = p_user_id
  ORDER BY lrv.created_at DESC;
END;
$$;

-- ===== 3. GET USER PHRASES FLATTENED =====
-- This function returns all phrases from all user requests as a flat list
CREATE OR REPLACE FUNCTION get_user_phrases_flattened(
  p_user_id TEXT
)
RETURNS TABLE (
  english TEXT,
  persian TEXT,
  is_used BOOLEAN,
  created_at TIMESTAMPTZ,
  request_id TEXT,
  user_level TEXT,
  focus_areas TEXT[]
)
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  RETURN QUERY
  SELECT 
    lrp.english,
    lrp.persian,
    lrp.is_used,
    lrp.created_at,
    lr.request_id,
    lr.user_level,
    lr.focus_areas
  FROM learning_request_phrases lrp
  INNER JOIN learning_requests lr ON lrp.learning_request_id = lr.id
  WHERE lr.user_id = p_user_id
  ORDER BY lrp.created_at DESC;
END;
$$;

-- ===== 4. GET USER LEARNING STATISTICS =====
-- This function calculates comprehensive learning statistics
CREATE OR REPLACE FUNCTION get_user_learning_statistics(
  p_user_id TEXT
)
RETURNS TABLE (
  total_requests INTEGER,
  total_vocabularies INTEGER,
  total_phrases INTEGER,
  total_tokens_used INTEGER,
  total_cost_usd DECIMAL(10,6),
  unique_levels INTEGER,
  unique_focus_areas INTEGER,
  avg_vocabularies_per_request DECIMAL(5,2),
  avg_phrases_per_request DECIMAL(5,2),
  first_request_date TIMESTAMPTZ,
  last_request_date TIMESTAMPTZ,
  provider_usage JSONB,
  level_distribution JSONB,
  focus_area_distribution JSONB
)
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_total_requests INTEGER;
  v_total_vocabularies INTEGER;
  v_total_phrases INTEGER;
  v_total_tokens INTEGER;
  v_total_cost DECIMAL(10,6);
  v_unique_levels INTEGER;
  v_unique_focus_areas INTEGER;
  v_avg_vocab DECIMAL(5,2);
  v_avg_phrases DECIMAL(5,2);
  v_first_date TIMESTAMPTZ;
  v_last_date TIMESTAMPTZ;
  v_provider_usage JSONB;
  v_level_dist JSONB;
  v_focus_dist JSONB;
BEGIN
  -- Get basic counts
  SELECT 
    COUNT(*),
    SUM(total_tokens_used),
    SUM(estimated_cost),
    COUNT(DISTINCT user_level),
    MIN(created_at),
    MAX(created_at)
  INTO 
    v_total_requests,
    v_total_tokens,
    v_total_cost,
    v_unique_levels,
    v_first_date,
    v_last_date
  FROM learning_requests
  WHERE user_id = p_user_id;

  -- Count vocabularies and phrases
  SELECT COUNT(*) INTO v_total_vocabularies
  FROM learning_request_vocabularies lrv
  INNER JOIN learning_requests lr ON lrv.learning_request_id = lr.id
  WHERE lr.user_id = p_user_id;

  SELECT COUNT(*) INTO v_total_phrases
  FROM learning_request_phrases lrp
  INNER JOIN learning_requests lr ON lrp.learning_request_id = lr.id
  WHERE lr.user_id = p_user_id;

  -- Calculate averages
  IF v_total_requests > 0 THEN
    v_avg_vocab := v_total_vocabularies::DECIMAL / v_total_requests;
    v_avg_phrases := v_total_phrases::DECIMAL / v_total_requests;
  ELSE
    v_avg_vocab := 0;
    v_avg_phrases := 0;
  END IF;

  -- Count unique focus areas
  SELECT COUNT(DISTINCT unnest(focus_areas))
  INTO v_unique_focus_areas
  FROM learning_requests
  WHERE user_id = p_user_id;

  -- Get provider usage distribution
  SELECT jsonb_object_agg(ai_provider, provider_count)
  INTO v_provider_usage
  FROM (
    SELECT ai_provider, COUNT(*) as provider_count
    FROM learning_requests
    WHERE user_id = p_user_id
    GROUP BY ai_provider
  ) provider_stats;

  -- Get level distribution
  SELECT jsonb_object_agg(user_level, level_count)
  INTO v_level_dist
  FROM (
    SELECT user_level, COUNT(*) as level_count
    FROM learning_requests
    WHERE user_id = p_user_id
    GROUP BY user_level
  ) level_stats;

  -- Get focus area distribution
  SELECT jsonb_object_agg(focus_area, focus_count)
  INTO v_focus_dist
  FROM (
    SELECT unnest(focus_areas) as focus_area, COUNT(*) as focus_count
    FROM learning_requests
    WHERE user_id = p_user_id
    GROUP BY unnest(focus_areas)
  ) focus_stats;

  -- Return the results
  RETURN QUERY
  SELECT 
    COALESCE(v_total_requests, 0) as total_requests,
    COALESCE(v_total_vocabularies, 0) as total_vocabularies,
    COALESCE(v_total_phrases, 0) as total_phrases,
    COALESCE(v_total_tokens, 0) as total_tokens_used,
    COALESCE(v_total_cost, 0.0) as total_cost_usd,
    COALESCE(v_unique_levels, 0) as unique_levels,
    COALESCE(v_unique_focus_areas, 0) as unique_focus_areas,
    COALESCE(v_avg_vocab, 0.0) as avg_vocabularies_per_request,
    COALESCE(v_avg_phrases, 0.0) as avg_phrases_per_request,
    v_first_date as first_request_date,
    v_last_date as last_request_date,
    COALESCE(v_provider_usage, '{}'::jsonb) as provider_usage,
    COALESCE(v_level_dist, '{}'::jsonb) as level_distribution,
    COALESCE(v_focus_dist, '{}'::jsonb) as focus_area_distribution;
END;
$$;

-- ===== 5. SAVE LEARNING REQUEST WITH CONTENT =====
-- This function handles the complete save operation atomically
CREATE OR REPLACE FUNCTION save_learning_request_with_content(
  p_request_id TEXT,
  p_user_id TEXT,
  p_user_level TEXT,
  p_focus_areas TEXT[],
  p_ai_provider TEXT,
  p_ai_model TEXT,
  p_total_tokens_used INTEGER,
  p_estimated_cost DECIMAL(10,6),
  p_request_timestamp TIMESTAMPTZ,
  p_system_prompt TEXT,
  p_user_prompt TEXT,
  p_error_message TEXT DEFAULT NULL,
  p_metadata JSONB DEFAULT NULL,
  p_vocabularies JSONB DEFAULT '[]'::jsonb,
  p_phrases JSONB DEFAULT '[]'::jsonb
)
RETURNS TEXT
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_learning_request_id BIGINT;
  v_vocab JSONB;
  v_phrase JSONB;
BEGIN
  -- Insert the main learning request
  INSERT INTO learning_requests (
    request_id, user_id, user_level, focus_areas, ai_provider, ai_model,
    total_tokens_used, estimated_cost, request_timestamp, system_prompt,
    user_prompt, error_message, metadata
  )
  VALUES (
    p_request_id, p_user_id, p_user_level, p_focus_areas, p_ai_provider, p_ai_model,
    p_total_tokens_used, p_estimated_cost, p_request_timestamp, p_system_prompt,
    p_user_prompt, p_error_message, p_metadata
  )
  RETURNING id INTO v_learning_request_id;

  -- Insert vocabularies
  FOR v_vocab IN SELECT * FROM jsonb_array_elements(p_vocabularies)
  LOOP
    INSERT INTO learning_request_vocabularies (
      learning_request_id, english, persian, is_used
    )
    VALUES (
      v_learning_request_id,
      v_vocab->>'english',
      v_vocab->>'persian',
      COALESCE((v_vocab->>'is_used')::boolean, false)
    );
  END LOOP;

  -- Insert phrases
  FOR v_phrase IN SELECT * FROM jsonb_array_elements(p_phrases)
  LOOP
    INSERT INTO learning_request_phrases (
      learning_request_id, english, persian, is_used
    )
    VALUES (
      v_learning_request_id,
      v_phrase->>'english',
      v_phrase->>'persian',
      COALESCE((v_phrase->>'is_used')::boolean, false)
    );
  END LOOP;

  RETURN p_request_id;
END;
$$;

-- ===== 6. GET RECENT LEARNING CONTENT =====
-- This function gets recent vocabularies and phrases for quick access
CREATE OR REPLACE FUNCTION get_recent_learning_content(
  p_user_id TEXT,
  p_days_back INTEGER DEFAULT 7,
  p_vocab_limit INTEGER DEFAULT 20,
  p_phrase_limit INTEGER DEFAULT 10
)
RETURNS TABLE (
  vocabularies JSONB,
  phrases JSONB,
  total_vocab_count INTEGER,
  total_phrase_count INTEGER
)
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_cutoff_date TIMESTAMPTZ;
  v_vocabularies JSONB;
  v_phrases JSONB;
  v_total_vocab INTEGER;
  v_total_phrase INTEGER;
BEGIN
  v_cutoff_date := NOW() - (p_days_back || ' days')::INTERVAL;

  -- Get recent vocabularies
  SELECT jsonb_agg(
    jsonb_build_object(
      'english', lrv.english,
      'persian', lrv.persian,
      'is_used', lrv.is_used,
      'created_at', lrv.created_at,
      'user_level', lr.user_level,
      'focus_areas', lr.focus_areas
    )
  )
  INTO v_vocabularies
  FROM (
    SELECT lrv.*, lr.user_level, lr.focus_areas
    FROM learning_request_vocabularies lrv
    INNER JOIN learning_requests lr ON lrv.learning_request_id = lr.id
    WHERE lr.user_id = p_user_id
    AND lr.created_at >= v_cutoff_date
    ORDER BY lrv.created_at DESC
    LIMIT p_vocab_limit
  ) recent_vocab;

  -- Get recent phrases
  SELECT jsonb_agg(
    jsonb_build_object(
      'english', lrp.english,
      'persian', lrp.persian,
      'is_used', lrp.is_used,
      'created_at', lrp.created_at,
      'user_level', lr.user_level,
      'focus_areas', lr.focus_areas
    )
  )
  INTO v_phrases
  FROM (
    SELECT lrp.*, lr.user_level, lr.focus_areas
    FROM learning_request_phrases lrp
    INNER JOIN learning_requests lr ON lrp.learning_request_id = lr.id
    WHERE lr.user_id = p_user_id
    AND lr.created_at >= v_cutoff_date
    ORDER BY lrp.created_at DESC
    LIMIT p_phrase_limit
  ) recent_phrases;

  -- Get total counts
  SELECT COUNT(*)
  INTO v_total_vocab
  FROM learning_request_vocabularies lrv
  INNER JOIN learning_requests lr ON lrv.learning_request_id = lr.id
  WHERE lr.user_id = p_user_id
  AND lr.created_at >= v_cutoff_date;

  SELECT COUNT(*)
  INTO v_total_phrase
  FROM learning_request_phrases lrp
  INNER JOIN learning_requests lr ON lrp.learning_request_id = lr.id
  WHERE lr.user_id = p_user_id
  AND lr.created_at >= v_cutoff_date;

  RETURN QUERY
  SELECT 
    COALESCE(v_vocabularies, '[]'::jsonb) as vocabularies,
    COALESCE(v_phrases, '[]'::jsonb) as phrases,
    COALESCE(v_total_vocab, 0) as total_vocab_count,
    COALESCE(v_total_phrase, 0) as total_phrase_count;
END;
$$;

-- ===== GRANTS AND PERMISSIONS =====
-- Grant execute permissions to authenticated users
GRANT EXECUTE ON FUNCTION get_user_learning_requests_with_content(TEXT, INTEGER, INTEGER) TO authenticated;
GRANT EXECUTE ON FUNCTION get_user_vocabularies_flattened(TEXT) TO authenticated;
GRANT EXECUTE ON FUNCTION get_user_phrases_flattened(TEXT) TO authenticated;
GRANT EXECUTE ON FUNCTION get_user_learning_statistics(TEXT) TO authenticated;
GRANT EXECUTE ON FUNCTION save_learning_request_with_content(TEXT, TEXT, TEXT, TEXT[], TEXT, TEXT, INTEGER, DECIMAL, TIMESTAMPTZ, TEXT, TEXT, TEXT, JSONB, JSONB, JSONB) TO authenticated;
GRANT EXECUTE ON FUNCTION get_recent_learning_content(TEXT, INTEGER, INTEGER, INTEGER) TO authenticated;

-- ===== USAGE EXAMPLES =====
-- 
-- 1. Get user learning requests with content:
-- SELECT * FROM get_user_learning_requests_with_content('user123', 20, 0);
--
-- 2. Get user vocabularies:
-- SELECT * FROM get_user_vocabularies_flattened('user123');
--
-- 3. Get user phrases:
-- SELECT * FROM get_user_phrases_flattened('user123');
--
-- 4. Get learning statistics:
-- SELECT * FROM get_user_learning_statistics('user123');
--
-- 5. Save learning request with content:
-- SELECT save_learning_request_with_content(
--   'req_123', 'user123', 'intermediate', ARRAY['business', 'travel'],
--   'openai', 'gpt-3.5-turbo', 150, 0.003, NOW(),
--   'System prompt here', 'User prompt here', NULL, '{"source": "daily_lessons"}'::jsonb,
--   '[{"english": "hello", "persian": "سلام", "is_used": false}]'::jsonb,
--   '[{"english": "how are you", "persian": "چطوری", "is_used": false}]'::jsonb
-- );
--
-- 6. Get recent learning content:
-- SELECT * FROM get_recent_learning_content('user123', 7, 20, 10);