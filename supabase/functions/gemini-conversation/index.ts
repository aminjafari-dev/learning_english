// index.ts
// Main entry point for the Gemini conversation Edge Function
// Well-structured, modular approach with proper error handling

import { handleCorsRequest } from './utils/http.ts';
import { handleConversationRequest } from './handlers/conversation.ts';

// Deno global declarations for TypeScript
declare const Deno: {
  env: {
    get(key: string): string | undefined;
  };
  serve: (handler: (req: Request) => Promise<Response> | Response) => void;
};

declare function serve(handler: (req: Request) => Promise<Response> | Response): void;

/**
 * Main request handler for the Gemini conversation function
 * Routes requests to appropriate handlers based on HTTP method
 */
async function requestHandler(request: Request): Promise<Response> {
  try {
    // Handle CORS preflight requests
    if (request.method === 'OPTIONS') {
      return handleCorsRequest();
    }

    // Only allow POST requests for conversation
    if (request.method !== 'POST') {
      return new Response(
        JSON.stringify({
          success: false,
          error: 'Method not allowed. Only POST requests are supported.'
        }),
        {
          status: 405,
          headers: { 'Content-Type': 'application/json' }
        }
      );
    }

    // Handle conversation request
    return await handleConversationRequest(request);

  } catch (error) {
    // Global error handler for unexpected errors
    console.error('Unexpected error in request handler:', error);
    
    return new Response(
      JSON.stringify({
        success: false,
        error: 'Internal server error occurred'
      }),
      {
        status: 500,
        headers: { 'Content-Type': 'application/json' }
      }
    );
  }
}

// Start the Edge Function server
serve(requestHandler);