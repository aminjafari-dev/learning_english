// index.ts
// User Profile Management Edge Function
// Handles user profile creation, retrieval, and updates

// @ts-ignore - This import works in Supabase Edge Functions runtime
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

// Simple CORS headers
const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
  'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
};

// Environment configuration type
interface EnvironmentConfig {
  supabaseUrl: string;
  supabaseServiceKey: string;
}

/**
 * Validates that the request is from an authenticated user
 * @param request - The HTTP request object
 * @param config - Environment configuration
 * @returns Promise with user ID if authenticated
 * @throws Error if not authenticated
 */
async function validateAuthentication(
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

// Deno global declaration for TypeScript
declare const Deno: {
  serve: (handler: (req: Request) => Promise<Response> | Response) => void;
  env: {
    get(key: string): string | undefined;
  };
};

/**
 * Main request handler for user profile management
 * Routes requests to appropriate handlers based on HTTP method
 */
async function requestHandler(request: Request): Promise<Response> {
  try {
    console.log('User Profile Request:', request.method, request.url);
    
    // Handle CORS preflight requests
    if (request.method === 'OPTIONS') {
      return new Response('ok', { headers: corsHeaders });
    }

    // Get environment configuration
    const config: EnvironmentConfig = {
      supabaseUrl: Deno.env.get('SUPABASE_URL')!,
      supabaseServiceKey: Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!,
    };

    // Validate authentication
    const userId = await validateAuthentication(request, config);
    
    // Create Supabase client
    const supabase = createClient(config.supabaseUrl, config.supabaseServiceKey);

    if (request.method === 'GET') {
      // Get user profile
      return await getUserProfile(supabase, userId);
    } else if (request.method === 'POST') {
      // Create or update user profile
      const body = await request.json();
      return await createOrUpdateProfile(supabase, userId, body);
    } else {
      return new Response(
        JSON.stringify({ error: 'Method not allowed' }),
        { 
          status: 405, 
          headers: { ...corsHeaders, 'Content-Type': 'application/json' } 
        }
      );
    }

  } catch (error) {
    console.error('❌ [USER-PROFILE] Error:', error);
    return new Response(
      JSON.stringify({ error: error.message }),
      { 
        status: 400, 
        headers: { ...corsHeaders, 'Content-Type': 'application/json' } 
      }
    );
  }
}

/**
 * Gets the user profile for the authenticated user
 * @param supabase - Supabase client
 * @param userId - User ID
 * @returns Response with profile data
 */
async function getUserProfile(supabase: any, userId: string): Promise<Response> {
  try {
    // Try to get existing profile
    const { data: profile, error } = await supabase
      .from('user_profiles')
      .select('*')
      .eq('user_id', userId)
      .single();

    if (error && error.code !== 'PGRST116') { // PGRST116 = no rows returned
      throw new Error(`Database error: ${error.message}`);
    }

    if (!profile) {
      // Profile doesn't exist, create one with default values
      const { data: newProfile, error: createError } = await supabase
        .from('user_profiles')
        .insert({
          user_id: userId,
          level: 'beginner', // Default level
          focus_areas: [], // Default empty focus areas
          language: 'en', // Default language
          theme: 'goldTheme', // Default theme
          created_at: new Date().toISOString(),
          updated_at: new Date().toISOString()
        })
        .select()
        .single();

      if (createError) {
        throw new Error(`Failed to create profile: ${createError.message}`);
      }

      return new Response(
        JSON.stringify({ 
          profile: newProfile, 
          created: true,
          message: 'Profile created with default settings'
        }),
        { 
          status: 201, 
          headers: { ...corsHeaders, 'Content-Type': 'application/json' } 
        }
      );
    }

    return new Response(
      JSON.stringify({ 
        profile, 
        created: false,
        message: 'Profile retrieved successfully'
      }),
      { 
        status: 200, 
        headers: { ...corsHeaders, 'Content-Type': 'application/json' } 
      }
    );

  } catch (error) {
    console.error('❌ [USER-PROFILE] Get profile error:', error);
    return new Response(
      JSON.stringify({ error: error.message }),
      { 
        status: 500, 
        headers: { ...corsHeaders, 'Content-Type': 'application/json' } 
      }
    );
  }
}

/**
 * Creates or updates a user profile
 * @param supabase - Supabase client
 * @param userId - User ID
 * @param profileData - Profile data to update
 * @returns Response with updated profile
 */
async function createOrUpdateProfile(
  supabase: any, 
  userId: string, 
  profileData: any
): Promise<Response> {
  try {
    // Validate profile data
    const validatedData = validateProfileData(profileData);
    
    // Check if profile exists
    const { data: existingProfile } = await supabase
      .from('user_profiles')
      .select('id')
      .eq('user_id', userId)
      .single();

    let result;
    if (existingProfile) {
      // Update existing profile
      const { data: updatedProfile, error } = await supabase
        .from('user_profiles')
        .update({
          ...validatedData,
          updated_at: new Date().toISOString()
        })
        .eq('user_id', userId)
        .select()
        .single();

      if (error) {
        throw new Error(`Failed to update profile: ${error.message}`);
      }

      result = { 
        profile: updatedProfile, 
        action: 'updated',
        message: 'Profile updated successfully'
      };
    } else {
      // Create new profile with defaults for missing fields
      const newProfileData = {
        user_id: userId,
        level: 'beginner',
        focus_areas: [],
        language: 'en',
        theme: 'goldTheme',
        ...validatedData,
        created_at: new Date().toISOString(),
        updated_at: new Date().toISOString()
      };

      const { data: newProfile, error } = await supabase
        .from('user_profiles')
        .insert(newProfileData)
        .select()
        .single();

      if (error) {
        throw new Error(`Failed to create profile: ${error.message}`);
      }

      result = { 
        profile: newProfile, 
        action: 'created',
        message: 'Profile created successfully'
      };
    }

    return new Response(
      JSON.stringify(result),
      { 
        status: 200, 
        headers: { ...corsHeaders, 'Content-Type': 'application/json' } 
      }
    );

  } catch (error) {
    console.error('❌ [USER-PROFILE] Create/Update profile error:', error);
    return new Response(
      JSON.stringify({ error: error.message }),
      { 
        status: 500, 
        headers: { ...corsHeaders, 'Content-Type': 'application/json' } 
      }
    );
  }
}

/**
 * Validates profile data and ensures proper format
 * @param profileData - Raw profile data from request
 * @returns Validated profile data
 */
function validateProfileData(profileData: any): any {
  const validated: any = {};

  // Validate and set full_name
  if (profileData.full_name && typeof profileData.full_name === 'string') {
    validated.full_name = profileData.full_name.trim();
  }

  // Validate and set email
  if (profileData.email && typeof profileData.email === 'string') {
    validated.email = profileData.email.trim().toLowerCase();
  }

  // Validate and set level
  if (profileData.level && ['beginner', 'elementary', 'intermediate', 'advanced'].includes(profileData.level)) {
    validated.level = profileData.level;
  }

  // Validate and set focus_areas
  if (profileData.focus_areas && Array.isArray(profileData.focus_areas)) {
    validated.focus_areas = profileData.focus_areas.filter((area: string) => 
      typeof area === 'string' && area.trim().length > 0
    );
  }

  // Validate and set language
  if (profileData.language && ['en', 'fa'].includes(profileData.language)) {
    validated.language = profileData.language;
  }

  // Validate and set theme
  if (profileData.theme && ['goldTheme', 'blueTheme', 'greenTheme', 'purpleTheme'].includes(profileData.theme)) {
    validated.theme = profileData.theme;
  }

  return validated;
}

// Start the Edge Function server using Deno.serve
Deno.serve(requestHandler);
