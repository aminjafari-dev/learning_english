// utils/validation.ts
// Request validation utilities

import type { GeminiRequest } from '../types.ts';

/**
 * Validates the incoming request body
 * @param body - The request body to validate
 * @throws Error if validation fails
 */
export function validateRequest(body: unknown): GeminiRequest {
  if (!body || typeof body !== 'object') {
    throw new Error('Invalid request body: must be a JSON object');
  }

  const request = body as Record<string, unknown>;

  // Validate required fields
  if (!request.message || typeof request.message !== 'string') {
    throw new Error('Invalid request: message field is required and must be a string');
  }

  if (request.message.trim().length === 0) {
    throw new Error('Invalid request: message cannot be empty');
  }

  if (request.message.length > 2000) {
    throw new Error('Invalid request: message too long (max 2000 characters)');
  }

  // Validate optional fields
  if (request.userLevel && typeof request.userLevel !== 'string') {
    throw new Error('Invalid request: userLevel must be a string');
  }

  if (request.focusAreas && !Array.isArray(request.focusAreas)) {
    throw new Error('Invalid request: focusAreas must be an array');
  }

  if (request.focusAreas && Array.isArray(request.focusAreas) && request.focusAreas.some(area => typeof area !== 'string')) {
    throw new Error('Invalid request: all focusAreas items must be strings');
  }

  return {
    message: request.message.trim(),
    userLevel: request.userLevel as string | undefined,
    focusAreas: request.focusAreas as string[] | undefined,
  };
}

/**
 * Validates user level
 * @param userLevel - User level to validate
 * @returns Valid user level or default
 */
export function validateUserLevel(userLevel?: string): string {
  const validLevels = ['beginner', 'elementary', 'intermediate', 'advanced'];
  
  if (!userLevel || !validLevels.includes(userLevel.toLowerCase())) {
    return 'intermediate';
  }
  
  return userLevel.toLowerCase();
}

/**
 * Validates focus areas
 * @param focusAreas - Focus areas to validate
 * @returns Valid focus areas or default
 */
export function validateFocusAreas(focusAreas?: string[]): string[] {
  if (!focusAreas || focusAreas.length === 0) {
    return ['general'];
  }

  // Filter out empty strings and limit to 5 areas
  const validAreas = focusAreas
    .filter(area => typeof area === 'string' && area.trim().length > 0)
    .map(area => area.trim().toLowerCase())
    .slice(0, 5);

  return validAreas.length > 0 ? validAreas : ['general'];
}