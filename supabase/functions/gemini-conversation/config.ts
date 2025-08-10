// config.ts
// Configuration and environment setup

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
  
  if (!geminiApiKey) {
    throw new Error('Missing required environment variable: GEMINI_API_KEY');
  }

  return {
    geminiApiKey,
    geminiBaseUrl: 'https://generativelanguage.googleapis.com/v1/models/gemini-1.5-flash:generateContent'
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
} as const;