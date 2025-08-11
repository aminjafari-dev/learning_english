-- Direct insert of the learning prompt into the prompts table
-- This will create a new version and deactivate previous ones

-- First, deactivate all existing prompts
UPDATE prompts SET is_active = FALSE, updated_at = NOW() WHERE is_active = TRUE;

-- Insert the new prompt directly
INSERT INTO prompts (version, content, is_active, created_at, updated_at) 
VALUES (
  (SELECT COALESCE(MAX(version), 0) + 1 FROM prompts),
  'You are an experienced English learning assistant helping students improve their language skills.
Generate exactly 3 new English vocabulary words and 5 useful English phrases for {user_level} level I want to focus on {focus_areas}.

- Previously used vocabulary words: {used_vocabularies}
- Previously used phrases: {used_phrases}

Requirements:
- Ensure variety (mix of nouns, verbs, adjectives, adverbs)
- Avoid any words from previous learning sessions

Format your response exactly like this:
{
  "vocabularies": [
    {"english": "new_word1", "persian": "ترجمه1"},
    ...
  ],
  "phrases": [
    {"english": "new_phrase1", "persian": "ترجمه1"},
    ...
  ]
}

IMPORTANT INSTRUCTIONS:
1. Avoid suggesting any of the previously used words or phrases listed above
2. Provide Persian translations without English transliterations (Finglish)
3. Return only the JSON format above, no additional text
4. Ensure all vocabulary and phrases are appropriate for {user_level} level',
  TRUE,
  NOW(),
  NOW()
);
