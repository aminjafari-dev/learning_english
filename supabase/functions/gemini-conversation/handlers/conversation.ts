// handlers/conversation.ts
// Main conversation handler

import { loadEnvironmentConfig } from '../config.ts';
import { validateRequest, validateUserLevel, validateFocusAreas } from '../utils/validation.ts';
import { parseRequestBody, createSuccessResponse, createErrorResponse } from '../utils/http.ts';
import { createAdaptivePrompt } from '../services/prompt.ts';
import { createGeminiService } from '../services/gemini.ts';
import type { GeminiRequest, PromptConfig } from '../types.ts';

/**
 * Handles conversation requests and generates AI responses
 * @param request - HTTP request object
 * @returns Promise<Response> - HTTP response with AI-generated content
 */
export async function handleConversationRequest(request: Request): Promise<Response> {
  try {
    // Load and validate environment configuration
    const config = loadEnvironmentConfig();

    // Parse and validate request body
    const body = await parseRequestBody(request);
    const validatedRequest = validateRequest(body);

    // Process the conversation request
    const aiResponse = await processConversation(validatedRequest, config);

    // Return success response
    return createSuccessResponse(aiResponse);

  } catch (error) {
    console.error('Conversation handler error:', error);
    
    // Determine appropriate error status code
    const status = error.message.includes('Invalid request') ? 400 : 500;
    
    return createErrorResponse(error.message, status);
  }
}

/**
 * Processes a conversation request and generates AI response
 * @private
 */
async function processConversation(
  request: GeminiRequest, 
  envConfig: ReturnType<typeof loadEnvironmentConfig>
): Promise<string> {
  
  // Validate and normalize request parameters
  const userLevel = validateUserLevel(request.userLevel);
  const focusAreas = validateFocusAreas(request.focusAreas);

  // Create prompt configuration
  const promptConfig: PromptConfig = {
    message: request.message,
    userLevel,
    focusAreas,
  };

  // Generate adaptive prompt based on message content
  const prompt = createAdaptivePrompt(promptConfig);

  // Create Gemini service and generate response
  const geminiService = createGeminiService(envConfig);
  const aiResponse = await geminiService.generateResponse(prompt);

  // Log successful interaction (optional, for debugging)
  console.log(`Conversation processed - Level: ${userLevel}, Focus: ${focusAreas.join(', ')}`);

  return aiResponse;
}