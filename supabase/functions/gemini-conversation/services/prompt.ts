// services/prompt.ts
// Prompt generation service for educational content

import type { PromptConfig } from '../types.ts';

/**
 * Creates an educational prompt for Gemini based on user preferences
 * @param config - Prompt configuration with user level, focus areas, and message
 * @returns Formatted prompt string for Gemini API
 */
export function createEducationalPrompt(config: PromptConfig): string {
  const { userLevel, focusAreas, message } = config;

  const basePrompt = `You are an experienced English learning assistant helping students improve their language skills.

User Profile:
- English Level: ${userLevel}
- Learning Focus: ${focusAreas.join(', ')}

Instructions:
1. Provide helpful, educational responses appropriate for ${userLevel} level
2. Focus on ${focusAreas.join(' and ')} topics when relevant
3. Use clear, simple language for beginners; more complex structures for advanced learners
4. When introducing new vocabulary or phrases, format them clearly:
   • Vocabulary: [word] - [definition/meaning]
   • Phrases: "[phrase]" - [meaning/usage]
5. Be encouraging and supportive in your teaching approach
6. Provide examples when explaining concepts

Student's message: "${message}"

Please provide a helpful educational response:`;

  return basePrompt;
}

/**
 * Creates a conversation prompt for more interactive learning
 * @param config - Prompt configuration
 * @returns Conversation-focused prompt string
 */
export function createConversationPrompt(config: PromptConfig): string {
  const { userLevel, focusAreas, message } = config;

  return `You are a friendly English conversation partner helping a ${userLevel} level student practice English.

Focus areas: ${focusAreas.join(', ')}

Guidelines:
- Keep responses natural and conversational
- Match the complexity to ${userLevel} level
- Gently correct errors when helpful
- Ask follow-up questions to encourage more practice
- Include relevant vocabulary from focus areas: ${focusAreas.join(', ')}

Student says: "${message}"

Respond naturally:`;
}

/**
 * Determines which prompt type to use based on message content
 * @param message - User's message
 * @returns Prompt type identifier
 */
export function determinePromptType(message: string): 'educational' | 'conversation' {
  const educationalKeywords = [
    'explain', 'what is', 'how to', 'help me learn', 'teach me',
    'grammar', 'vocabulary', 'meaning', 'definition', 'difference'
  ];

  const messageText = message.toLowerCase();
  const hasEducationalKeywords = educationalKeywords.some(keyword => 
    messageText.includes(keyword)
  );

  return hasEducationalKeywords ? 'educational' : 'conversation';
}

/**
 * Creates an appropriate prompt based on message analysis
 * @param config - Prompt configuration
 * @returns Generated prompt string
 */
export function createAdaptivePrompt(config: PromptConfig): string {
  const promptType = determinePromptType(config.message);
  
  return promptType === 'educational' 
    ? createEducationalPrompt(config)
    : createConversationPrompt(config);
}