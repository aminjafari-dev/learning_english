// config.ts
// Configuration and environment setup for learning conversation function

import type { EnvironmentConfig } from './types.ts';

// Deno global declarations for TypeScript
declare const Deno: {
  env: {
    get(key: string): string | undefined;
  };
};

/**
 * Loads and validates environment configuration
 * @returns EnvironmentConfig object with validated settings
 * @throws Error if required environment variables are missing
 */
export function loadEnvironmentConfig(): EnvironmentConfig {
  const geminiApiKey = Deno.env.get('GEMINI_API_KEY');
  // Use Supabase's automatically provided environment variables
  const supabaseUrl = Deno.env.get('SUPABASE_URL') || 'https://secsedrlvpifggleixfk.supabase.co';
  const supabaseServiceKey = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') || Deno.env.get('SUPABASE_SERVICE_KEY');
  
  if (!geminiApiKey) {
    throw new Error('Missing required environment variable: GEMINI_API_KEY');
  }

  if (!supabaseUrl) {
    throw new Error('Missing required environment variable: SUPABASE_URL');
  }

  if (!supabaseServiceKey) {
    throw new Error('Missing required environment variable: SUPABASE_SERVICE_ROLE_KEY or SUPABASE_SERVICE_KEY');
  }

  return {
    geminiApiKey,
    geminiBaseUrl: 'https://generativelanguage.googleapis.com/v1/models/gemini-1.5-flash:generateContent',
    supabaseUrl,
    supabaseServiceKey,
  };
}

/**
 * Default configuration values
 */
export const DEFAULT_CONFIG = {
  userLevel: 'intermediate' as const,
  focusAreas: ['general'] as const,
  temperature: 0.7,
  maxOutputTokens: 1024,
  timeout: 30000, // 30 seconds
  aiProvider: 'gemini',
  aiModel: 'gemini-1.5-flash',
  estimatedCostPerToken: 0.0000015, // Approximate cost per token for Gemini
} as const;