// services/prompt.ts
// Simplified prompt service with dynamic variable replacement

import type { PromptConfig, VocabularyData, PhraseData } from '../types.ts';
import type { DatabaseService } from './database.ts';

/**
 * Interface for dynamic prompt variables
 */
interface PromptVariables {
  user_level: string;
  focus_areas: string;
  used_vocabularies: string;
  used_phrases: string;
}

/**
 * Fallback prompt template for when database prompt is not available
 */
const FALLBACK_PROMPT = `Generate exactly 3 new English vocabulary words and 5 useful English phrases for {user_level} level I want to focus on {focus_areas}.

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
4. Ensure all vocabulary and phrases are appropriate for {user_level} level`;

/**
 * Creates a learning prompt with dynamic variables replacement
 * @param config - Prompt configuration with user level and focus areas
 * @param databaseService - Database service for fetching prompts
 * @param usedVocabularies - Previously used vocabulary words
 * @param usedPhrases - Previously used phrases
 * @returns Promise with formatted prompt string
 */
export async function createLearningPrompt(
  config: PromptConfig, 
  databaseService: DatabaseService,
  usedVocabularies: string[] = [],
  usedPhrases: string[] = []
): Promise<string> {
  console.log('🎯 [PROMPT] Creating learning prompt for:', config);
  console.log('📚 [PROMPT] Used vocabularies count:', usedVocabularies.length);
  console.log('💬 [PROMPT] Used phrases count:', usedPhrases.length);
  
  try {
    // Try to fetch prompt from database
    const promptData = await databaseService.getLatestPrompt();
    
    let promptTemplate: string;
    
    if (promptData && promptData.content) {
      console.log(`✅ [PROMPT] Using database prompt version: ${promptData.version}`);
      promptTemplate = promptData.content;
    } else {
      console.log('⚠️ [PROMPT] No database prompt found, using fallback');
      promptTemplate = FALLBACK_PROMPT;
    }
    
    // Prepare variables for replacement
    const variables: PromptVariables = {
      user_level: config.userLevel,
      focus_areas: config.focusAreas.join(', '),
      used_vocabularies: usedVocabularies.length > 0 ? usedVocabularies.join(', ') : 'None',
      used_phrases: usedPhrases.length > 0 ? usedPhrases.join(', ') : 'None'
    };
    
    // Replace variables in the prompt template
    const processedPrompt = replacePromptVariables(promptTemplate, variables);
    
    console.log('✅ [PROMPT] Learning prompt created successfully');
    console.log('📝 [PROMPT] Variables replaced:', Object.keys(variables).join(', '));
    
    return processedPrompt;
    
  } catch (error) {
    console.error('❌ [PROMPT] Error creating learning prompt:', error);
    
    // Use fallback prompt on error with variables
    console.log('🔄 [PROMPT] Using fallback prompt due to error');
    const variables: PromptVariables = {
      user_level: config.userLevel,
      focus_areas: config.focusAreas.join(', '),
      used_vocabularies: usedVocabularies.length > 0 ? usedVocabularies.join(', ') : 'None',
      used_phrases: usedPhrases.length > 0 ? usedPhrases.join(', ') : 'None'
    };
    
    return replacePromptVariables(FALLBACK_PROMPT, variables);
  }
}

/**
 * Replaces variables in a prompt template with actual values
 * @param template - The prompt template with {variable} placeholders
 * @param variables - Object containing variable values
 * @returns Processed prompt with variables replaced
 */
function replacePromptVariables(template: string, variables: PromptVariables): string {
  let processedPrompt = template;
  
  // Replace each variable in the template
  Object.entries(variables).forEach(([key, value]) => {
    const placeholder = `{${key}}`;
    processedPrompt = processedPrompt.replace(new RegExp(placeholder, 'g'), value);
  });
  
  return processedPrompt;
}

/**
 * Extracts vocabulary and phrases from AI response JSON
 * Expects structured JSON response with vocabularies and phrases arrays
 * @param responseText - The AI response text (should be JSON)
 * @param userLevel - User's English level for appropriate difficulty
 * @returns Object with extracted vocabularies and phrases with Persian translations
 */
export function extractLearningContent(
  responseText: string, 
  userLevel: string
): { vocabularies: VocabularyData[]; phrases: PhraseData[] } {
  console.log(`🔍 [EXTRACTION] Starting JSON content extraction for ${userLevel} level`);
  
  try {
    // Try to parse as JSON first
    const cleanedResponse = responseText.trim();
    
    // Extract JSON from response if it's wrapped in other text
    let jsonMatch = cleanedResponse.match(/\{[\s\S]*\}/);
    if (!jsonMatch) {
      console.log('⚠️ [EXTRACTION] No JSON found in response, trying fallback extraction');
      return extractFallbackContent(responseText, userLevel);
    }
    
    const jsonText = jsonMatch[0];
    const parsedResponse = JSON.parse(jsonText);
    
    const vocabularies: VocabularyData[] = [];
    const phrases: PhraseData[] = [];
    
    // Extract vocabularies from JSON
    if (parsedResponse.vocabularies && Array.isArray(parsedResponse.vocabularies)) {
      for (const vocab of parsedResponse.vocabularies) {
        if (vocab.english && vocab.persian) {
          vocabularies.push({
            english: vocab.english.toLowerCase().trim(),
            persian: vocab.persian.trim(),
            isUsed: false
          });
        }
      }
    }
    
    // Extract phrases from JSON
    if (parsedResponse.phrases && Array.isArray(parsedResponse.phrases)) {
      for (const phrase of parsedResponse.phrases) {
        if (phrase.english && phrase.persian) {
          phrases.push({
            english: phrase.english.trim(),
            persian: phrase.persian.trim(),
            isUsed: false
          });
        }
      }
    }
    
    console.log(`✅ [EXTRACTION] Extracted ${vocabularies.length} vocabularies, ${phrases.length} phrases from JSON`);
    return { vocabularies, phrases };
    
  } catch (error) {
    console.error('❌ [EXTRACTION] Failed to parse JSON response:', error);
    console.log('🔄 [EXTRACTION] Falling back to pattern-based extraction');
    return extractFallbackContent(responseText, userLevel);
  }
}

/**
 * Fallback content extraction when JSON parsing fails
 * @private
 */
function extractFallbackContent(responseText: string, userLevel: string): { vocabularies: VocabularyData[]; phrases: PhraseData[] } {
  const vocabularies: VocabularyData[] = [];
  const phrases: PhraseData[] = [];
  
  // Try to extract structured vocabulary patterns
  const vocabMatches = responseText.match(/"english":\s*"([^"]+)"[^}]*"persian":\s*"([^"]+)"/g);
  if (vocabMatches) {
    for (const match of vocabMatches.slice(0, 5)) { // Limit to 5
      const englishMatch = match.match(/"english":\s*"([^"]+)"/);
      const persianMatch = match.match(/"persian":\s*"([^"]+)"/);
      
      if (englishMatch && persianMatch) {
        vocabularies.push({
          english: englishMatch[1].toLowerCase().trim(),
          persian: persianMatch[1].trim(),
          isUsed: false
        });
      }
    }
  }
  
  // If still no content, use basic word extraction
  if (vocabularies.length === 0) {
    const words = responseText.toLowerCase()
      .replace(/[^\w\s]/g, ' ')
      .split(/\s+/)
      .filter(word => word.length > 4 && !isCommonWord(word))
      .slice(0, 3);
    
    for (const word of words) {
      vocabularies.push({
        english: word,
        persian: generateBasicTranslation(word),
        isUsed: false
      });
    }
  }
  
  console.log(`⚠️ [EXTRACTION] Fallback extraction: ${vocabularies.length} vocabularies, ${phrases.length} phrases`);
  return { vocabularies, phrases };
}

/**
 * Generates basic Persian translations for common words
 * @private
 */
function generateBasicTranslation(text: string): string {
  const translations: Record<string, string> = {
    'practice': 'تمرین',
    'learn': 'یاد گرفتن',
    'understand': 'درک کردن',
    'speak': 'صحبت کردن',
    'language': 'زبان',
    'english': 'انگلیسی',
    'conversation': 'مکالمه',
    'vocabulary': 'واژگان',
    'grammar': 'گرامر',
    'pronunciation': 'تلفظ',
    'education': 'آموزش',
    'student': 'دانش آموز',
    'teacher': 'معلم',
    'lesson': 'درس',
    'exercise': 'تمرین'
  };
  
  const lowerText = text.toLowerCase().trim();
  return translations[lowerText] || 'ترجمه در دسترس نیست';
}

/**
 * Checks if a word is too common to be considered learning vocabulary
 * @private
 */
function isCommonWord(word: string): boolean {
  const commonWords = new Set([
    'the', 'and', 'for', 'are', 'but', 'not', 'you', 'all', 'can', 'had', 'her', 'was', 'one', 
    'our', 'out', 'day', 'get', 'has', 'him', 'his', 'how', 'its', 'may', 'new', 'now', 'old', 
    'see', 'two', 'who', 'boy', 'did', 'man', 'men', 'put', 'say', 'she', 'too', 'use', 'that',
    'with', 'have', 'this', 'will', 'your', 'from', 'they', 'know', 'want', 'been', 'good',
    'much', 'some', 'time', 'very', 'when', 'come', 'here', 'just', 'like', 'long', 'make',
    'many', 'over', 'such', 'take', 'than', 'them', 'well', 'were', 'what', 'would', 'more'
  ]);
  
  return commonWords.has(word.toLowerCase());
}