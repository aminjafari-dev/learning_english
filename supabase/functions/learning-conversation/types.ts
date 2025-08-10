// types.ts
// Type definitions for the Learning Conversation function

export interface LearningConversationRequest {
  message: string;
  userId: string;
  userLevel?: string;
  focusAreas?: string[];
  requestId?: string;
}

export interface LearningConversationResponse {
  success: boolean;
  response?: string;
  requestId?: string;
  error?: string;
}

export interface GeminiAPIResponse {
  candidates?: Array<{
    content?: {
      parts?: Array<{
        text?: string;
      }>;
    };
  }>;
}

export interface EnvironmentConfig {
  geminiApiKey: string;
  geminiBaseUrl: string;
  supabaseUrl: string;
  supabaseServiceKey: string;
}

export interface PromptConfig {
  userLevel: string;
  focusAreas: string[];
  message: string;
}

export interface LearningRequestData {
  requestId: string;
  userId: string;
  userLevel: string;
  focusAreas: string[];
  aiProvider: string;
  aiModel: string;
  totalTokensUsed: number;
  estimatedCost: number;
  requestTimestamp: string;
  createdAt: string;
  systemPrompt: string;
  userPrompt: string;
  aiResponse: string;
  errorMessage?: string;
  metadata?: Record<string, any>;
  vocabularies?: VocabularyData[];
  phrases?: PhraseData[];
}

export interface VocabularyData {
  english: string;
  persian: string;
  isUsed: boolean;
}

export interface PhraseData {
  english: string;
  persian: string;
  isUsed: boolean;
}