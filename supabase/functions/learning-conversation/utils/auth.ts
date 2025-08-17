// utils/auth.ts
// Authentication utilities for Edge Functions

import type { EnvironmentConfig } from '../types.ts';

// @ts-ignore - This import works in Supabase Edge Functions runtime
import { createClient } from "@supabase/supabase-js";

/**
 * Validates that the request is from an authenticated user
 * @param request - The HTTP request object
 * @param config - Environment configuration
 * @returns Promise with user ID if authenticated
 * @throws Error if not authenticated
 */
export async function validateAuthentication(
  request: Request,
  config: EnvironmentConfig
): Promise<string> {
  try {
    // Get the authorization header
    const authHeader = request.headers.get('authorization');
    
    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      throw new Error('Missing or invalid authorization header');
    }

    // Extract the JWT token
    const token = authHeader.substring(7); // Remove 'Bearer ' prefix
    
    if (!token) {
      throw new Error('No JWT token provided');
    }

    // Create Supabase client with anon key for token verification
    const supabase = createClient(config.supabaseUrl, config.supabaseServiceKey);
    
    // Verify the JWT token and get user info
    const { data: { user }, error } = await supabase.auth.getUser(token);
    
    if (error || !user) {
      console.error('❌ [AUTH] Token verification failed:', error);
      throw new Error('Invalid or expired authentication token');
    }

    console.log('✅ [AUTH] User authenticated:', user.id);
    return user.id;
    
  } catch (error) {
    console.error('❌ [AUTH] Authentication validation failed:', error);
    throw new Error(`Authentication failed: ${error.message}`);
  }
}

/**
 * Validates that the user ID in the request matches the authenticated user
 * @param requestUserId - User ID from request body
 * @param authenticatedUserId - User ID from JWT token
 * @throws Error if user IDs don't match
 */
export function validateUserOwnership(
  requestUserId: string,
  authenticatedUserId: string
): void {
  if (requestUserId !== authenticatedUserId) {
    console.error('❌ [AUTH] User ID mismatch:', { requestUserId, authenticatedUserId });
    throw new Error('User ID in request does not match authenticated user');
  }
  
  console.log('✅ [AUTH] User ownership validated');
}

/**
 * Complete authentication validation for learning conversation requests
 * @param request - The HTTP request object
 * @param config - Environment configuration
 * @param requestUserId - User ID from request body
 * @returns Promise with validated user ID
 */
export async function validateLearningRequest(
  request: Request,
  config: EnvironmentConfig,
  requestUserId: string
): Promise<string> {
  // First, validate authentication
  const authenticatedUserId = await validateAuthentication(request, config);
  
  // Then, validate user ownership
  validateUserOwnership(requestUserId, authenticatedUserId);
  
  return authenticatedUserId;
}
