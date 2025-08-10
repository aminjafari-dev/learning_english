// services/gemini.ts
// Gemini API service for handling AI requests

import type { EnvironmentConfig, GeminiAPIResponse } from '../types.ts';
import { DEFAULT_CONFIG } from '../config.ts';

/**
 * Service class for interacting with Google's Gemini API
 */
export class GeminiService {
  private config: EnvironmentConfig;

  constructor(config: EnvironmentConfig) {
    this.config = config;
  }

  /**
   * Sends a prompt to Gemini API and returns the response
   * @param prompt - The formatted prompt to send
   * @returns Promise<string> - The AI response text
   * @throws Error if API call fails or response is invalid
   */
  async generateResponse(prompt: string): Promise<string> {
    try {
      const response = await this.makeAPIRequest(prompt);
      return this.extractResponseText(response);
    } catch (error) {
      console.error('Gemini API Error:', error);
      throw new Error(`Failed to generate response: ${error.message}`);
    }
  }

  /**
   * Makes the actual HTTP request to Gemini API
   * @private
   */
  private async makeAPIRequest(prompt: string): Promise<GeminiAPIResponse> {
    const requestBody = this.buildRequestBody(prompt);
    const url = `${this.config.geminiBaseUrl}?key=${this.config.geminiApiKey}`;

    const response = await fetch(url, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(requestBody),
    });

    if (!response.ok) {
      const errorText = await response.text();
      throw new Error(`Gemini API HTTP ${response.status}: ${errorText}`);
    }

    return await response.json();
  }

  /**
   * Builds the request body for Gemini API
   * @private
   */
  private buildRequestBody(prompt: string) {
    return {
      contents: [
        {
          parts: [
            { text: prompt }
          ]
        }
      ],
      generationConfig: {
        temperature: DEFAULT_CONFIG.temperature,
        maxOutputTokens: DEFAULT_CONFIG.maxOutputTokens,
        topP: 0.8,
        topK: 40,
      },
      safetySettings: [
        {
          category: 'HARM_CATEGORY_HARASSMENT',
          threshold: 'BLOCK_MEDIUM_AND_ABOVE'
        },
        {
          category: 'HARM_CATEGORY_HATE_SPEECH',
          threshold: 'BLOCK_MEDIUM_AND_ABOVE'
        }
      ]
    };
  }

  /**
   * Extracts the response text from Gemini API response
   * @private
   */
  private extractResponseText(apiResponse: GeminiAPIResponse): string {
    if (!apiResponse.candidates || apiResponse.candidates.length === 0) {
      throw new Error('No response candidates returned from Gemini API');
    }

    const candidate = apiResponse.candidates[0];
    if (!candidate.content || !candidate.content.parts || candidate.content.parts.length === 0) {
      throw new Error('Invalid response structure from Gemini API');
    }

    const responseText = candidate.content.parts[0].text;
    if (!responseText || responseText.trim().length === 0) {
      throw new Error('Empty response from Gemini API');
    }

    return responseText.trim();
  }

  /**
   * Validates that the service is properly configured
   * @throws Error if configuration is invalid
   */
  validateConfiguration(): void {
    if (!this.config.geminiApiKey) {
      throw new Error('Gemini API key is required');
    }

    if (!this.config.geminiBaseUrl) {
      throw new Error('Gemini base URL is required');
    }
  }
}

/**
 * Factory function to create a configured GeminiService instance
 * @param config - Environment configuration
 * @returns Configured GeminiService instance
 */
export function createGeminiService(config: EnvironmentConfig): GeminiService {
  const service = new GeminiService(config);
  service.validateConfiguration();
  return service;
}