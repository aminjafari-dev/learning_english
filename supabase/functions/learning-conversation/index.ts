// index.ts
// Main entry point for the Learning Conversation Edge Function
// Handles AI conversation and learning request storage with real data

import { handleCorsRequest } from './utils/http.ts';
import { handleLearningConversationRequest } from './handlers/learning-conversation.ts';

// Deno global declaration for TypeScript
declare const Deno: {
  serve: (handler: (req: Request) => Promise<Response> | Response) => void;
};

/**
 * Main request handler for the learning conversation function
 * Routes requests to appropriate handlers based on HTTP method
 */
async function requestHandler(request: Request): Promise<Response> {
  try {
    console.log('Learning Conversation Request:', request.method, request.url);
    
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

    // Handle learning conversation request
    return await handleLearningConversationRequest(request);

  } catch (error) {
    // Global error handler for unexpected errors
    console.error('Unexpected error in learning conversation handler:', error);
    
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

// Start the Edge Function server using Deno.serve
Deno.serve(requestHandler);