// services/prompt.ts
// Dynamic prompt generation service using database prompts with vocabulary and phrase extraction

import type { PromptConfig, VocabularyData, PhraseData } from '../types.ts';
import type { DatabaseService } from './database.ts';

/**
 * Determines the appropriate prompt type based on focus areas
 * @param focusAreas - User's learning focus areas
 * @returns Prompt type identifier
 */
export function determinePromptType(focusAreas: string[]): 'educational' | 'conversation' | 'practice' | 'assessment' {
  const focusAreasText = focusAreas.join(' ').toLowerCase();
  
  // Educational focus areas - direct learning content
  const educationalFocusAreas = [
    'grammar', 'vocabulary', 'pronunciation', 'spelling', 'writing', 'reading',
    'tenses', 'prepositions', 'articles', 'syntax', 'phonetics'
  ];
  
  // Practice focus areas - exercise and drilling
  const practiceFocusAreas = [
    'practice', 'exercise', 'drill', 'quiz', 'test', 'challenge',
    'repetition', 'training', 'workout'
  ];
  
  // Assessment focus areas - evaluation and feedback
  const assessmentFocusAreas = [
    'assessment', 'evaluation', 'feedback', 'review', 'check', 'correct',
    'analyze', 'score', 'rate'
  ];
  
  // Check for specific types based on focus areas
  if (educationalFocusAreas.some(area => focusAreasText.includes(area))) {
    return 'educational';
  }
  
  if (practiceFocusAreas.some(area => focusAreasText.includes(area))) {
    return 'practice';
  }
  
  if (assessmentFocusAreas.some(area => focusAreasText.includes(area))) {
    return 'assessment';
  }
  
  // Default to conversation for general learning
  return 'conversation';
}

/**
 * Creates a learning prompt by fetching the latest version from database
 * @param config - Prompt configuration with user level and focus areas
 * @param databaseService - Database service instance for fetching prompts
 * @returns Formatted prompt string for AI API
 */
export async function createLearningPrompt(
  config: PromptConfig, 
  databaseService: DatabaseService
): Promise<string> {
  const { userLevel, focusAreas } = config;
  
  // Determine the appropriate prompt type based on focus areas
  const promptType = determinePromptType(focusAreas);
  console.log(`🎯 [PROMPT] Determined prompt type: ${promptType} for focus areas: ${focusAreas.join(', ')}`);
  
  try {
    // Fetch the latest prompt from database
    let promptData = await databaseService.getLatestPrompt(promptType);
    
    if (!promptData) {
      console.log(`⚠️ [PROMPT] No prompt found for type ${promptType}, falling back to conversation`);
      // Fallback to conversation prompt if specific type not found
      const fallbackPrompt = await databaseService.getLatestPrompt('conversation');
      
      if (!fallbackPrompt) {
        throw new Error('No prompts available in database');
      }
      
      promptData = fallbackPrompt;
    }
    
    console.log(`✅ [PROMPT] Using prompt: ${promptData.promptName} v${promptData.version}`);
    
    // Prepare variables for template substitution
    const variables = {
      userLevel,
      focusAreas: focusAreas.join(', '),
      learningObjective: `Generate personalized English learning content for ${userLevel} level focusing on ${focusAreas.join(', ')}`,
    };
    
    // Process the prompt template with variables
    const processedPrompt = databaseService.processPromptTemplate(promptData.content, variables);
    
    return processedPrompt;
    
  } catch (error) {
    console.error('❌ [PROMPT] Failed to fetch prompt from database:', error);
    
    // Ultimate fallback - use a basic hardcoded prompt
    console.log('🔄 [PROMPT] Using emergency fallback prompt');
    return `You are an English learning assistant. Generate personalized learning content for a ${userLevel} level learner focusing on ${focusAreas.join(', ')}. 

Create educational content including vocabulary, phrases, and explanations appropriate for their level. Include both English content and Persian translations where helpful.`;
  }
}

/**
 * Extracts vocabulary and phrases from AI response text
 * Supports parsing AI-generated content with Persian translations
 * @param responseText - The AI response text
 * @param userLevel - User's English level for appropriate difficulty
 * @returns Object with extracted vocabularies and phrases with Persian translations
 */
export function extractLearningContent(
  responseText: string, 
  userLevel: string
): { vocabularies: VocabularyData[]; phrases: PhraseData[] } {
  const vocabularies: VocabularyData[] = [];
  const phrases: PhraseData[] = [];

  console.log(`🔍 [EXTRACTION] Starting content extraction for ${userLevel} level`);

  // First, try to extract structured vocabulary from AI response
  const structuredVocab = extractStructuredVocabulary(responseText);
  vocabularies.push(...structuredVocab);
  
  // Extract structured phrases from AI response
  const structuredPhrases = extractStructuredPhrases(responseText);
  phrases.push(...structuredPhrases);

  // If no structured content found, fall back to pattern-based extraction
  if (vocabularies.length === 0) {
    const fallbackVocab = extractFallbackVocabulary(responseText, userLevel);
    vocabularies.push(...fallbackVocab);
  }

  if (phrases.length === 0) {
    const fallbackPhrases = extractFallbackPhrases(responseText);
    phrases.push(...fallbackPhrases);
  }

  console.log(`✅ [EXTRACTION] Extracted ${vocabularies.length} vocabularies, ${phrases.length} phrases`);
  return { vocabularies, phrases };
}

/**
 * Extracts vocabulary from structured AI response patterns
 * Looks for patterns like: "Vocabulary: word - Persian translation"
 * @private
 */
function extractStructuredVocabulary(responseText: string): VocabularyData[] {
  const vocabularies: VocabularyData[] = [];
  
  // Pattern 1: "Vocabulary: word - translation" or "• word - translation"
  const vocabPatterns = [
    /(?:Vocabulary|vocabulary):\s*([a-zA-Z\s]+?)\s*-\s*([^\n\r,;]+)/gi,
    /•\s*([a-zA-Z\s]+?)\s*-\s*([^\n\r,;]+)/gi,
    /\*\s*([a-zA-Z\s]+?)\s*-\s*([^\n\r,;]+)/gi,
    /(\w+)\s*\(([^)]+)\)/gi, // word (translation)
  ];

  for (const pattern of vocabPatterns) {
    let match;
    while ((match = pattern.exec(responseText)) !== null && vocabularies.length < 15) {
      const english = match[1].trim().toLowerCase();
      const persian = match[2].trim();
      
      // Skip if already exists or is too short
      if (english.length > 2 && persian.length > 0 && 
          !vocabularies.some(v => v.english === english)) {
        vocabularies.push({
          english,
          persian,
          isUsed: false,
        });
      }
    }
  }

  return vocabularies;
}

/**
 * Extracts phrases from structured AI response patterns
 * Looks for patterns like: "Phrases: "phrase" - Persian translation"
 * @private
 */
function extractStructuredPhrases(responseText: string): PhraseData[] {
  const phrases: PhraseData[] = [];
  
  // Pattern for structured phrases: "phrase" - translation
  const phrasePatterns = [
    /(?:Phrases?|phrase):\s*"([^"]+)"\s*-\s*([^\n\r,;]+)/gi,
    /"([^"]+)"\s*-\s*([^\n\r,;]+)/gi,
    /•\s*"([^"]+)"\s*-\s*([^\n\r,;]+)/gi,
    /\*\s*"([^"]+)"\s*-\s*([^\n\r,;]+)/gi,
  ];

  for (const pattern of phrasePatterns) {
    let match;
    while ((match = pattern.exec(responseText)) !== null && phrases.length < 10) {
      const english = match[1].trim();
      const persian = match[2].trim();
      
      // Skip if already exists or is too short
      if (english.length > 4 && persian.length > 0 && 
          !phrases.some(p => p.english === english)) {
        phrases.push({
          english,
          persian,
          isUsed: false,
        });
      }
    }
  }

  return phrases;
}

/**
 * Fallback vocabulary extraction when no structured content is found
 * @private
 */
function extractFallbackVocabulary(responseText: string, userLevel: string): VocabularyData[] {
  const vocabularies: VocabularyData[] = [];
  
  // Look for words that might be new vocabulary (longer words, less common)
  const words = responseText.toLowerCase()
    .replace(/[^\w\s]/g, ' ')
    .split(/\s+/)
    .filter(word => word.length > 4 && !isCommonWord(word));

  // Extract unique vocabulary words
  const uniqueWords = [...new Set(words)].slice(0, 8); // Limit to 8 words
  
  for (const word of uniqueWords) {
    vocabularies.push({
      english: word,
      persian: generateBasicTranslation(word), // Basic translation attempt
      isUsed: false,
    });
  }

  return vocabularies;
}

/**
 * Fallback phrase extraction when no structured content is found
 * @private
 */
function extractFallbackPhrases(responseText: string): PhraseData[] {
  const phrases: PhraseData[] = [];
  
  // Extract phrases (pattern matching for quoted text or common phrase patterns)
  const phrasePatterns = [
    /"([^"]+)"/g, // Quoted phrases
    /\b(how to [^.!?]+)/gi, // "how to" phrases
    /\b(would you like to [^.!?]+)/gi, // Polite phrases
    /\b(let me [^.!?]+)/gi, // Helpful phrases
    /\b(i would [^.!?]+)/gi, // Common expressions
  ];

  for (const pattern of phrasePatterns) {
    let match;
    while ((match = pattern.exec(responseText)) !== null && phrases.length < 6) {
      const phrase = match[1].trim();
      if (phrase.length > 5 && phrase.split(' ').length >= 2) {
        phrases.push({
          english: phrase,
          persian: generateBasicTranslation(phrase), // Basic translation attempt
          isUsed: false,
        });
      }
    }
  }

  return phrases;
}

/**
 * Generates basic Persian translations for common words/phrases
 * This is a simple dictionary lookup for common terms
 * @private
 */
function generateBasicTranslation(text: string): string {
  const translations: Record<string, string> = {
    // Common vocabulary
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
    'fluent': 'روان',
    'beginner': 'مبتدی',
    'intermediate': 'متوسط',
    'advanced': 'پیشرفته',
    'education': 'آموزش',
    'student': 'دانش آموز',
    'teacher': 'معلم',
    'lesson': 'درس',
    'exercise': 'تمرین',
    'example': 'مثال',
    'question': 'سوال',
    'answer': 'پاسخ',
    'correct': 'درست',
    'mistake': 'اشتباه',
    'improvement': 'بهبود',
    
    // Common phrases
    'how to': 'چگونه',
    'would you like': 'آیا دوست داری',
    'let me': 'اجازه بده',
    'i would': 'من می‌خواهم',
    'please help': 'لطفا کمک کن',
    'thank you': 'متشکرم',
    'you\'re welcome': 'خواهش می‌کنم',
    'excuse me': 'ببخشید',
    'i\'m sorry': 'متأسفم',
    'good morning': 'صبح بخیر',
    'good evening': 'عصر بخیر',
    'how are you': 'حال شما چطور است',
    'nice to meet you': 'از ملاقات شما خوشحالم',
  };
  
  const lowerText = text.toLowerCase().trim();
  
  // Check for exact matches first
  if (translations[lowerText]) {
    return translations[lowerText];
  }
  
  // Check for partial matches
  for (const [english, persian] of Object.entries(translations)) {
    if (lowerText.includes(english)) {
      return persian;
    }
  }
  
  // If no translation found, return a placeholder
  return 'ترجمه در دسترس نیست';
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
    'many', 'over', 'such', 'take', 'than', 'them', 'well', 'were', 'what', 'would', 'more',
    'said', 'each', 'which', 'their', 'called', 'other', 'after', 'first', 'also', 'back',
    'being', 'before', 'where', 'little', 'only', 'right', 'think', 'work', 'life', 'way',
    'even', 'place', 'well', 'such', 'because', 'turn', 'here', 'why', 'ask', 'went', 'look'
  ]);
  
  return commonWords.has(word.toLowerCase());
}

