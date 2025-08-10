// services/prompt.ts
// Educational prompt generation service with vocabulary and phrase extraction

import type { PromptConfig, VocabularyData, PhraseData } from '../types.ts';

/**
 * Creates an educational prompt for learning conversation
 * @param config - Prompt configuration with user level, focus areas, and message
 * @returns Formatted prompt string for Gemini API
 */
export function createLearningPrompt(config: PromptConfig): string {
  const { userLevel, focusAreas, message } = config;

  const basePrompt = `You are an experienced English learning assistant helping students improve their language skills through conversation.

User Profile:
- English Level: ${userLevel}
- Learning Focus: ${focusAreas.join(', ')}

Instructions:
1. Provide helpful, educational responses appropriate for ${userLevel} level learners
2. Focus on ${focusAreas.join(' and ')} topics when relevant
3. Use clear, simple language for beginners; more complex structures for advanced learners
4. Include relevant vocabulary and phrases that would be useful for learning
5. Be encouraging and supportive in your teaching approach
6. Provide examples and context when explaining concepts
7. Make the conversation natural and engaging

IMPORTANT: Your response should include educational content that helps the student learn new vocabulary and phrases naturally within the conversation context.

Student's message: "${message}"

Please provide a helpful educational response that:
- Answers or responds to the student's message naturally
- Introduces relevant vocabulary and phrases for their level
- Maintains an encouraging and supportive tone
- Stays focused on the learning areas: ${focusAreas.join(', ')}

Response:`;

  return basePrompt;
}

/**
 * Extracts vocabulary and phrases from AI response text
 * This is a simple implementation that looks for common patterns
 * @param responseText - The AI response text
 * @param userLevel - User's English level for appropriate difficulty
 * @returns Object with extracted vocabularies and phrases
 */
export function extractLearningContent(
  responseText: string, 
  userLevel: string
): { vocabularies: VocabularyData[]; phrases: PhraseData[] } {
  const vocabularies: VocabularyData[] = [];
  const phrases: PhraseData[] = [];

  // Simple extraction logic - you can enhance this with more sophisticated NLP
  // Look for words that might be new vocabulary (longer words, less common)
  const words = responseText.toLowerCase()
    .replace(/[^\w\s]/g, ' ')
    .split(/\s+/)
    .filter(word => word.length > 4 && !isCommonWord(word));

  // Extract unique vocabulary words
  const uniqueWords = [...new Set(words)].slice(0, 10); // Limit to 10 words
  
  for (const word of uniqueWords) {
    vocabularies.push({
      english: word,
      persian: '', // Would need translation service to fill this
      isUsed: false,
    });
  }

  // Extract phrases (simple pattern matching for quoted text or common phrase patterns)
  const phrasePatterns = [
    /"([^"]+)"/g, // Quoted phrases
    /\b(how to \w+)/gi, // "how to" phrases
    /\b(would you like to \w+)/gi, // Polite phrases
    /\b(let me \w+)/gi, // Helpful phrases
  ];

  for (const pattern of phrasePatterns) {
    let match;
    while ((match = pattern.exec(responseText)) !== null && phrases.length < 5) {
      const phrase = match[1].trim();
      if (phrase.length > 5 && phrase.split(' ').length >= 2) {
        phrases.push({
          english: phrase,
          persian: '', // Would need translation service to fill this
          isUsed: false,
        });
      }
    }
  }

  return { vocabularies, phrases };
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

/**
 * Determines if the message needs educational focus or conversational focus
 * @param message - User's message
 * @returns Message type for appropriate response
 */
export function analyzeMessageType(message: string): 'educational' | 'conversational' | 'practice' {
  const messageText = message.toLowerCase();
  
  const educationalKeywords = [
    'explain', 'what is', 'how to', 'help me learn', 'teach me', 'what does',
    'grammar', 'vocabulary', 'meaning', 'definition', 'difference', 'understand'
  ];
  
  const practiceKeywords = [
    'practice', 'exercise', 'quiz', 'test', 'review', 'repeat', 'again'
  ];
  
  if (educationalKeywords.some(keyword => messageText.includes(keyword))) {
    return 'educational';
  }
  
  if (practiceKeywords.some(keyword => messageText.includes(keyword))) {
    return 'practice';
  }
  
  return 'conversational';
}