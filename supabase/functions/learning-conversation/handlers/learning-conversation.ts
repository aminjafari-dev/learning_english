// handlers/learning-conversation.ts
// Main learning conversation handler that processes messages and stores data

import { loadEnvironmentConfig, DEFAULT_CONFIG } from '../config.ts';
import { 
  validateLearningConversationRequest, 
  validateUserLevel, 
  validateFocusAreas, 
  generateRequestId 
} from '../utils/validation.ts';
import { 
  parseRequestBody, 
  createSuccessResponse, 
  createErrorResponse 
} from '../utils/http.ts';
import { createLearningPrompt, extractLearningContent } from '../services/prompt.ts';
import { createGeminiService } from '../services/gemini.ts';
import { createDatabaseService } from '../services/database.ts';
import type { 
  LearningConversationRequest, 
  PromptConfig, 
  LearningRequestData 
} from '../types.ts';

/**
 * Handles learning conversation requests with AI and data storage
 * @param request - HTTP request object
 * @returns Promise<Response> - HTTP response with AI-generated content and request ID
 */
export async function handleLearningConversationRequest(request: Request): Promise<Response> {
  try {
    console.log('🚀 [HANDLER] Learning conversation request received');
    
    // Load and validate environment configuration
    const config = loadEnvironmentConfig();
    console.log('✅ [HANDLER] Environment config loaded successfully');

    // Parse and validate request body
    const body = await parseRequestBody(request);
    console.log('📥 [HANDLER] Request body received:', JSON.stringify(body, null, 2));
    
    const validatedRequest = validateLearningConversationRequest(body);
    console.log('✅ [HANDLER] Request validation successful for user:', validatedRequest.userId);

    // Process the learning conversation
    const result = await processLearningConversation(validatedRequest, config);

    // Return success response with AI response and request ID
    return createSuccessResponse(result.aiResponse, result.requestId);

  } catch (error) {
    console.error('Learning conversation handler error:', error);
    
    // Determine appropriate error status code
    const status = error.message.includes('Invalid request') ? 400 : 500;
    
    return createErrorResponse(error.message, status);
  }
}

/**
 * Processes a learning conversation request and stores the complete interaction
 * @private
 */
async function processLearningConversation(
  request: LearningConversationRequest, 
  envConfig: ReturnType<typeof loadEnvironmentConfig>
): Promise<{ aiResponse: string; requestId: string }> {
  
  // Generate unique request ID if not provided
  const requestId = request.requestId || generateRequestId(request.userId);
  
  // Validate and normalize request parameters
  const userLevel = validateUserLevel(request.userLevel);
  const focusAreas = validateFocusAreas(request.focusAreas);

  console.log(`🎯 [LEARNING] Processing conversation for user: ${request.userId}`);
  console.log(`📊 [LEARNING] Level: ${userLevel}, Focus: ${focusAreas.join(', ')}`);

  try {
    // Create prompt configuration
    const promptConfig: PromptConfig = {
      message: request.message,
      userLevel,
      focusAreas,
    };

    // Generate educational prompt
    const systemPrompt = createLearningPrompt(promptConfig);
    
    // Create Gemini service and generate response
    const geminiService = createGeminiService(envConfig);
    const aiResult = await geminiService.generateResponse(systemPrompt);

    console.log(`✅ [LEARNING] AI response generated (${aiResult.tokensUsed} tokens)`);

    // Extract learning content (vocabulary and phrases) from the response
    const learningContent = extractLearningContent(aiResult.response, userLevel);
    
    console.log(`📚 [LEARNING] Extracted ${learningContent.vocabularies.length} vocabularies, ${learningContent.phrases.length} phrases`);

    // Prepare learning request data for storage
    const currentTime = new Date().toISOString();
    const learningRequestData: LearningRequestData = {
      requestId,
      userId: request.userId,
      userLevel,
      focusAreas,
      aiProvider: DEFAULT_CONFIG.aiProvider,
      aiModel: DEFAULT_CONFIG.aiModel,
      totalTokensUsed: aiResult.tokensUsed,
      estimatedCost: aiResult.estimatedCost,
      requestTimestamp: currentTime,
      createdAt: currentTime,
      systemPrompt,
      userPrompt: request.message,
      aiResponse: aiResult.response,
      vocabularies: learningContent.vocabularies,
      phrases: learningContent.phrases,
      metadata: {
        messageType: 'conversation',
        extractedContentCount: {
          vocabularies: learningContent.vocabularies.length,
          phrases: learningContent.phrases.length,
        },
      },
    };

    // Save to database
    const databaseService = createDatabaseService(envConfig);
    await databaseService.saveLearningConversation(learningRequestData);

    console.log(`✅ [LEARNING] Complete learning conversation saved with ID: ${requestId}`);

    return {
      aiResponse: aiResult.response,
      requestId,
    };

  } catch (error) {
    console.error(`❌ [LEARNING] Failed to process conversation for user ${request.userId}:`, error);
    
    // Try to save error information to database if possible
    try {
      const currentTime = new Date().toISOString();
      const errorRequestData: LearningRequestData = {
        requestId,
        userId: request.userId,
        userLevel,
        focusAreas,
        aiProvider: DEFAULT_CONFIG.aiProvider,
        aiModel: DEFAULT_CONFIG.aiModel,
        totalTokensUsed: 0,
        estimatedCost: 0,
        requestTimestamp: currentTime,
        createdAt: currentTime,
        systemPrompt: 'Error occurred before prompt generation',
        userPrompt: request.message,
        aiResponse: '',
        errorMessage: error.message,
        vocabularies: [],
        phrases: [],
        metadata: {
          messageType: 'error',
          errorOccurred: true,
        },
      };

      const databaseService = createDatabaseService(envConfig);
      await databaseService.saveLearningConversation(errorRequestData);
      
    } catch (dbError) {
      console.error('❌ [LEARNING] Failed to save error to database:', dbError);
    }

    throw error;
  }
}