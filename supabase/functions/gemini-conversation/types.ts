// types.ts
// Type definitions for the Gemini conversation function

export interface GeminiRequest {
    message: string;
    userLevel?: string;
    focusAreas?: string[];
  }
  
  export interface GeminiResponse {
    success: boolean;
    response?: string;
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
  }
  
  export interface PromptConfig {
    userLevel: string;
    focusAreas: string[];
    message: string;
  }