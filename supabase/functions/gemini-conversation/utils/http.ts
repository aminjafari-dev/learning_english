// utils/http.ts
// HTTP utilities for handling requests and responses

import type { GeminiResponse } from '../types.ts';

/**
 * Creates CORS headers for responses
 */
export function createCorsHeaders(): Record<string, string> {
  return {
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Methods': 'POST, OPTIONS',
    'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
    'Content-Type': 'application/json',
  };
}

/**
 * Handles CORS preflight requests
 */
export function handleCorsRequest(): Response {
  return new Response(null, {
    status: 200,
    headers: createCorsHeaders(),
  });
}

/**
 * Creates a success response
 */
export function createSuccessResponse(response: string): Response {
  const body: GeminiResponse = {
    success: true,
    response,
  };

  return new Response(JSON.stringify(body), {
    status: 200,
    headers: createCorsHeaders(),
  });
}

/**
 * Creates an error response
 */
export function createErrorResponse(error: string, status: number = 500): Response {
  const body: GeminiResponse = {
    success: false,
    error,
  };

  return new Response(JSON.stringify(body), {
    status,
    headers: createCorsHeaders(),
  });
}

/**
 * Safely parses JSON request body
 */
export async function parseRequestBody(request: Request): Promise<unknown> {
  try {
    return await request.json();
  } catch (error) {
    throw new Error('Invalid JSON in request body');
  }
}