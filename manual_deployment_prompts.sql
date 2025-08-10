-- Manual Deployment: Dynamic Prompts System
-- Run this script in your Supabase Dashboard SQL Editor
-- This creates the prompts table and seeds it with initial data

-- ===== PROMPTS TABLE =====
-- Stores versioned prompts for different types of learning interactions
CREATE TABLE IF NOT EXISTS prompts (
  id BIGSERIAL PRIMARY KEY,
  prompt_type TEXT NOT NULL, -- 'educational', 'conversation', 'practice', 'assessment'
  prompt_name TEXT NOT NULL, -- Descriptive name for the prompt
  version INTEGER NOT NULL DEFAULT 1,
  content TEXT NOT NULL, -- The actual prompt template
  variables JSONB DEFAULT '{}', -- Available variables: {userLevel}, {focusAreas}, {message}
  is_active BOOLEAN NOT NULL DEFAULT TRUE,
  is_latest BOOLEAN NOT NULL DEFAULT FALSE, -- Only one prompt per type should be latest
  created_by TEXT DEFAULT 'system',
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  
  -- Constraints
  CONSTRAINT prompts_type_check CHECK (prompt_type IN ('educational', 'conversation', 'practice', 'assessment')),
  CONSTRAINT prompts_content_check CHECK (length(content) > 10),
  CONSTRAINT prompts_version_check CHECK (version > 0),
  
  -- Unique constraint: only one latest prompt per type
  UNIQUE(prompt_type, is_latest) DEFERRABLE INITIALLY DEFERRED
);

-- ===== INDEXES =====
CREATE INDEX IF NOT EXISTS idx_prompts_type ON prompts(prompt_type);
CREATE INDEX IF NOT EXISTS idx_prompts_active ON prompts(is_active);
CREATE INDEX IF NOT EXISTS idx_prompts_latest ON prompts(is_latest);
CREATE INDEX IF NOT EXISTS idx_prompts_version ON prompts(version DESC);
CREATE INDEX IF NOT EXISTS idx_prompts_created_at ON prompts(created_at DESC);

-- ===== ROW LEVEL SECURITY =====
ALTER TABLE prompts ENABLE ROW LEVEL SECURITY;

-- Allow everyone to read active prompts (needed for Edge Functions)
DROP POLICY IF EXISTS "Anyone can read active prompts" ON prompts;
CREATE POLICY "Anyone can read active prompts" ON prompts
  FOR SELECT USING (is_active = true);

-- Allow service role to manage all prompts
DROP POLICY IF EXISTS "Service role can manage all prompts" ON prompts;
CREATE POLICY "Service role can manage all prompts" ON prompts
  FOR ALL USING (auth.role() = 'service_role');

-- ===== HELPER FUNCTIONS =====

-- Function to get the latest prompt for a specific type
CREATE OR REPLACE FUNCTION get_latest_prompt(p_prompt_type TEXT)
RETURNS JSON AS $$
DECLARE
  result JSON;
BEGIN
  SELECT json_build_object(
    'id', id,
    'promptType', prompt_type,
    'promptName', prompt_name,
    'version', version,
    'content', content,
    'variables', variables,
    'createdAt', created_at
  )
  FROM prompts
  WHERE prompt_type = p_prompt_type 
    AND is_active = true 
    AND is_latest = true
  LIMIT 1
  INTO result;
  
  RETURN COALESCE(result, json_build_object('error', 'No active prompt found for type: ' || p_prompt_type));
END;
$$ LANGUAGE plpgsql;

-- Function to create a new prompt version
CREATE OR REPLACE FUNCTION create_prompt_version(
  p_prompt_type TEXT,
  p_prompt_name TEXT,
  p_content TEXT,
  p_variables JSONB DEFAULT '{}',
  p_created_by TEXT DEFAULT 'system'
)
RETURNS JSON AS $$
DECLARE
  new_version INTEGER;
  new_prompt_id BIGINT;
  result JSON;
BEGIN
  -- Get the next version number
  SELECT COALESCE(MAX(version), 0) + 1 
  FROM prompts 
  WHERE prompt_type = p_prompt_type
  INTO new_version;
  
  -- Start transaction
  BEGIN
    -- Mark all existing prompts of this type as not latest
    UPDATE prompts 
    SET is_latest = false, updated_at = NOW()
    WHERE prompt_type = p_prompt_type AND is_latest = true;
    
    -- Insert the new prompt version
    INSERT INTO prompts (
      prompt_type, prompt_name, version, content, variables, 
      is_active, is_latest, created_by
    ) VALUES (
      p_prompt_type, p_prompt_name, new_version, p_content, p_variables,
      true, true, p_created_by
    ) RETURNING id INTO new_prompt_id;
    
    -- Return the created prompt info
    SELECT json_build_object(
      'id', new_prompt_id,
      'promptType', p_prompt_type,
      'promptName', p_prompt_name,
      'version', new_version,
      'content', p_content,
      'variables', p_variables,
      'message', 'Prompt version created successfully'
    ) INTO result;
    
    RETURN result;
  EXCEPTION
    WHEN OTHERS THEN
      -- Rollback and return error
      RETURN json_build_object('error', 'Failed to create prompt version: ' || SQLERRM);
  END;
END;
$$ LANGUAGE plpgsql;

-- Function to activate/deactivate a prompt version
CREATE OR REPLACE FUNCTION toggle_prompt_active(
  p_prompt_id BIGINT,
  p_is_active BOOLEAN DEFAULT true,
  p_set_as_latest BOOLEAN DEFAULT false
)
RETURNS JSON AS $$
DECLARE
  prompt_type_val TEXT;
  result JSON;
BEGIN
  -- Get the prompt type
  SELECT prompt_type FROM prompts WHERE id = p_prompt_id INTO prompt_type_val;
  
  IF prompt_type_val IS NULL THEN
    RETURN json_build_object('error', 'Prompt not found');
  END IF;
  
  BEGIN
    -- If setting as latest, mark others as not latest
    IF p_set_as_latest THEN
      UPDATE prompts 
      SET is_latest = false, updated_at = NOW()
      WHERE prompt_type = prompt_type_val AND is_latest = true AND id != p_prompt_id;
    END IF;
    
    -- Update the prompt
    UPDATE prompts 
    SET 
      is_active = p_is_active,
      is_latest = CASE WHEN p_set_as_latest THEN true ELSE is_latest END,
      updated_at = NOW()
    WHERE id = p_prompt_id;
    
    RETURN json_build_object('success', true, 'message', 'Prompt updated successfully');
  EXCEPTION
    WHEN OTHERS THEN
      RETURN json_build_object('error', 'Failed to update prompt: ' || SQLERRM);
  END;
END;
$$ LANGUAGE plpgsql;

-- ===== GRANTS =====
GRANT ALL ON prompts TO service_role;
GRANT USAGE ON SEQUENCE prompts_id_seq TO service_role;

-- Grant read access to authenticated users (optional, for admin interfaces)
GRANT SELECT ON prompts TO authenticated;

-- ===== SEED DATA =====
-- Insert default prompt versions for different interaction types

-- Educational prompt
INSERT INTO prompts (
  prompt_type, prompt_name, version, content, variables, is_active, is_latest, created_by
) VALUES (
  'educational',
  'Basic Educational Assistant',
  1,
  'You are an experienced English learning assistant helping students improve their language skills.

User Profile:
- English Level: {userLevel}
- Learning Focus: {focusAreas}

Instructions:
1. Provide helpful, educational responses appropriate for {userLevel} level
2. Focus on {focusAreas} topics when relevant
3. Use clear, simple language for beginners; more complex structures for advanced learners
4. When introducing new vocabulary or phrases, format them clearly:
   • Vocabulary: [word] - [definition/meaning]
   • Phrases: "[phrase]" - [meaning/usage]
5. Be encouraging and supportive in your teaching approach
6. Provide examples when explaining concepts
7. Always extract vocabulary and phrases for learning purposes

Student''s message: "{message}"

Please provide a helpful educational response with clear vocabulary and phrase extractions:',
  '{"userLevel": "string", "focusAreas": "array", "message": "string"}'::jsonb,
  true,
  true,
  'system'
);

-- Conversation prompt
INSERT INTO prompts (
  prompt_type, prompt_name, version, content, variables, is_active, is_latest, created_by
) VALUES (
  'conversation',
  'Natural Conversation Partner',
  1,
  'You are a friendly English conversation partner helping a {userLevel} level student practice English.

Focus areas: {focusAreas}

Guidelines:
- Keep responses natural and conversational
- Match the complexity to {userLevel} level
- Gently correct errors when helpful
- Ask follow-up questions to encourage more practice
- Include relevant vocabulary from focus areas: {focusAreas}
- Extract useful vocabulary and phrases for learning

Student says: "{message}"

Respond naturally while including educational content:',
  '{"userLevel": "string", "focusAreas": "array", "message": "string"}'::jsonb,
  true,
  true,
  'system'
);

-- Practice prompt
INSERT INTO prompts (
  prompt_type, prompt_name, version, content, variables, is_active, is_latest, created_by
) VALUES (
  'practice',
  'Structured Practice Session',
  1,
  'You are conducting a structured English practice session for a {userLevel} level student.

Focus areas: {focusAreas}

Session Guidelines:
- Create engaging practice exercises based on the student''s message
- Provide clear instructions and examples
- Adapt difficulty to {userLevel} level
- Focus on {focusAreas} skills
- Give constructive feedback
- Extract and highlight key vocabulary and phrases

Student''s practice request: "{message}"

Design an appropriate practice activity with clear learning objectives:',
  '{"userLevel": "string", "focusAreas": "array", "message": "string"}'::jsonb,
  true,
  true,
  'system'
);

-- Assessment prompt
INSERT INTO prompts (
  prompt_type, prompt_name, version, content, variables, is_active, is_latest, created_by
) VALUES (
  'assessment',
  'Learning Assessment Tool',
  1,
  'You are an English learning assessment tool evaluating a {userLevel} level student.

Focus areas: {focusAreas}

Assessment Guidelines:
- Analyze the student''s English usage in their message
- Provide constructive feedback appropriate for {userLevel} level
- Highlight strengths and areas for improvement
- Focus on {focusAreas} aspects
- Suggest specific learning activities
- Extract vocabulary and phrases for review

Student''s submission: "{message}"

Provide detailed assessment with actionable feedback:',
  '{"userLevel": "string", "focusAreas": "array", "message": "string"}'::jsonb,
  true,
  true,
  'system'
);

-- ===== VERIFICATION QUERY =====
-- Run this to verify everything was created successfully
SELECT 
  prompt_type,
  prompt_name,
  version,
  is_active,
  is_latest,
  created_at
FROM prompts 
ORDER BY prompt_type, version;

-- Test prompt fetching
SELECT get_latest_prompt('conversation');
SELECT get_latest_prompt('educational');
SELECT get_latest_prompt('practice');
SELECT get_latest_prompt('assessment');