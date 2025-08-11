-- Insert the fixed prompt into the simplified prompts table

-- Insert the learning prompt with dynamic variables
INSERT INTO prompts (version, content, is_active) VALUES (
  1,
  'Generate exactly 3 new English vocabulary words and 5 useful English phrases for {user_level} level I want to focus on {focus_areas}.

- Previously used vocabulary words: {used_vocabularies}
- Previously used phrases: {used_phrases}

Requirements:
- Ensure variety (mix of nouns, verbs, adjectives, adverbs)
- Avoid any words from previous learning sessions

Format your response exactly like this:
{
  "vocabularies": [
    {"english": "new_word1", "persian": "ترجمه1"},
    {"english": "new_word2", "persian": "ترجمه2"}
  ],
  "phrases": [
    {"english": "new_phrase1", "persian": "ترجمه1"},
    {"english": "new_phrase2", "persian": "ترجمه2"}
  ]
}

IMPORTANT INSTRUCTIONS:
1. Avoid suggesting any of the previously used words or phrases listed above
2. Provide Persian translations without English transliterations (Finglish)
3. Return only the JSON format above, no additional text
4. Ensure all vocabulary and phrases are appropriate for {user_level} level',
  TRUE
) ON CONFLICT DO NOTHING;