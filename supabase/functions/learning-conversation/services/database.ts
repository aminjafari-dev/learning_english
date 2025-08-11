// services/database.ts
// Database service for storing learning conversation data

import type { EnvironmentConfig, LearningRequestData, VocabularyData, PhraseData } from '../types.ts';

// Import Supabase client for Edge Functions
// @ts-ignore - This import works in Supabase Edge Functions runtime
import { createClient } from "@supabase/supabase-js";

/**
 * Database service for managing learning conversation data
 */
export class DatabaseService {
  private supabase: any;
  
  constructor(config: EnvironmentConfig) {
    this.supabase = createClient(config.supabaseUrl, config.supabaseServiceKey);
  }

  /**
   * Saves learning conversation data to the database
   * @param learningData - Complete learning request data
   * @returns Promise with saved request ID
   */
  async saveLearningConversation(learningData: LearningRequestData): Promise<string> {
    try {
      console.log('💾 [DATABASE] Saving learning conversation:', learningData.requestId);
      console.log('💾 [DATABASE] User ID:', learningData.userId);
      console.log('💾 [DATABASE] Data size - Vocabularies:', learningData.vocabularies?.length || 0, 'Phrases:', learningData.phrases?.length || 0);

      // Save main learning request
      const { data: requestData, error: requestError } = await this.supabase
        .from('requests')
        .insert({
          request_id: learningData.requestId,
          user_id: learningData.userId,
          user_level: learningData.userLevel,
          focus_areas: learningData.focusAreas,
          ai_provider: learningData.aiProvider,
          ai_model: learningData.aiModel,
          total_tokens_used: learningData.totalTokensUsed,
          estimated_cost: learningData.estimatedCost,
          request_timestamp: learningData.requestTimestamp,
          created_at: learningData.createdAt,
          system_prompt: learningData.systemPrompt,
          user_prompt: learningData.userPrompt,
          ai_response: learningData.aiResponse,
          error_message: learningData.errorMessage,
          metadata: learningData.metadata,
        })
        .select('id')
        .single();

      if (requestError) {
        console.error('❌ [DATABASE] Learning request insert error:', requestError);
        console.error('❌ [DATABASE] Error details:', JSON.stringify(requestError, null, 2));
        throw new Error(`Failed to save learning request: ${requestError.message}`);
      }

      const internalId = requestData.id;
      console.log('✅ [DATABASE] Learning request saved with internal ID:', internalId);

      // Save vocabularies if present
      if (learningData.vocabularies && learningData.vocabularies.length > 0) {
        await this.saveVocabularies(internalId, learningData.vocabularies, learningData.userId);
      }

      // Save phrases if present
      if (learningData.phrases && learningData.phrases.length > 0) {
        await this.savePhrases(internalId, learningData.phrases, learningData.userId);
      }

      console.log('✅ [DATABASE] Complete learning conversation saved successfully');
      return learningData.requestId;

    } catch (error) {
      console.error('❌ [DATABASE] Failed to save learning conversation:', error);
      throw new Error(`Database save failed: ${error.message}`);
    }
  }

  /**
   * Saves vocabularies related to a learning request
   * Uses upsert to handle duplicate words gracefully
   * @private
   */
  private async saveVocabularies(
    learningRequestId: number, 
    vocabularies: VocabularyData[],
    userId: string
  ): Promise<void> {
    console.log(`💾 [DATABASE] Saving ${vocabularies.length} vocabularies for user: ${userId}`);
    
    let savedCount = 0;
    let skippedCount = 0;

    // Process vocabularies one by one to handle duplicates gracefully
    for (const vocab of vocabularies) {
      const vocabularyData = {
        request_id: learningRequestId,
        user_id: userId,
        english: vocab.english.toLowerCase().trim(), // Normalize to avoid case-sensitive duplicates
        persian: vocab.persian,
        is_used: vocab.isUsed,
      };

      try {
        // Use upsert (INSERT ... ON CONFLICT) to handle duplicates
        const { error } = await this.supabase
          .from('vocabularies')
          .upsert(vocabularyData, {
            onConflict: 'user_id,english',
            ignoreDuplicates: false // Update existing records
          });

        if (error) {
          // If it's a duplicate key error, try to update the existing record
          if (error.message.includes('duplicate key') || error.code === '23505') {
            console.log(`🔄 [DATABASE] Vocabulary "${vocab.english}" already exists, updating Persian translation`);
            
            // Update the existing vocabulary with new Persian translation if it's better
            const { error: updateError } = await this.supabase
              .from('vocabularies')
              .update({ 
                persian: vocab.persian,
                request_id: learningRequestId // Link to current request
              })
              .eq('user_id', userId)
              .eq('english', vocabularyData.english);

            if (updateError) {
              console.error(`❌ [DATABASE] Failed to update vocabulary "${vocab.english}":`, updateError.message);
            } else {
              skippedCount++;
            }
          } else {
            console.error(`❌ [DATABASE] Failed to save vocabulary "${vocab.english}":`, error.message);
          }
        } else {
          savedCount++;
        }
      } catch (err) {
        console.error(`❌ [DATABASE] Unexpected error saving vocabulary "${vocab.english}":`, err);
      }
    }

    console.log(`✅ [DATABASE] Vocabulary summary: ${savedCount} new, ${skippedCount} updated/skipped`);
  }

  /**
   * Saves phrases related to a learning request
   * Uses upsert to handle duplicate phrases gracefully
   * @private
   */
  private async savePhrases(
    learningRequestId: number, 
    phrases: PhraseData[],
    userId: string
  ): Promise<void> {
    console.log(`💾 [DATABASE] Saving ${phrases.length} phrases for user: ${userId}`);
    
    let savedCount = 0;
    let skippedCount = 0;

    // Process phrases one by one to handle duplicates gracefully
    for (const phrase of phrases) {
      const phraseData = {
        request_id: learningRequestId,
        user_id: userId,
        english: phrase.english.trim(), // Normalize to avoid whitespace issues
        persian: phrase.persian,
        is_used: phrase.isUsed,
      };

      try {
        // Use upsert (INSERT ... ON CONFLICT) to handle duplicates
        const { error } = await this.supabase
          .from('phrases')
          .upsert(phraseData, {
            onConflict: 'user_id,english',
            ignoreDuplicates: false // Update existing records
          });

        if (error) {
          // If it's a duplicate key error, try to update the existing record
          if (error.message.includes('duplicate key') || error.code === '23505') {
            console.log(`🔄 [DATABASE] Phrase "${phrase.english}" already exists, updating Persian translation`);
            
            // Update the existing phrase with new Persian translation if it's better
            const { error: updateError } = await this.supabase
              .from('phrases')
              .update({ 
                persian: phrase.persian,
                request_id: learningRequestId // Link to current request
              })
              .eq('user_id', userId)
              .eq('english', phraseData.english);

            if (updateError) {
              console.error(`❌ [DATABASE] Failed to update phrase "${phrase.english}":`, updateError.message);
            } else {
              skippedCount++;
            }
          } else {
            console.error(`❌ [DATABASE] Failed to save phrase "${phrase.english}":`, error.message);
          }
        } else {
          savedCount++;
        }
      } catch (err) {
        console.error(`❌ [DATABASE] Unexpected error saving phrase "${phrase.english}":`, err);
      }
    }

    console.log(`✅ [DATABASE] Phrase summary: ${savedCount} new, ${skippedCount} updated/skipped`);
  }

  /**
   * Retrieves recent learning conversations for a user
   * @param userId - User ID
   * @param limit - Number of conversations to retrieve
   * @returns Promise with learning conversations
   */
  async getUserLearningConversations(userId: string, limit: number = 10): Promise<LearningRequestData[]> {
    try {
      console.log('📥 [DATABASE] Fetching learning conversations for user:', userId);

      const { data, error } = await this.supabase
        .from('requests')
        .select(`
          *,
          vocabularies(*),
          phrases(*)
        `)
        .eq('user_id', userId)
        .order('created_at', { ascending: false })
        .limit(limit);

      if (error) {
        throw new Error(`Failed to fetch learning conversations: ${error.message}`);
      }

      const conversations: LearningRequestData[] = data.map((record: any) => ({
        requestId: record.request_id,
        userId: record.user_id,
        userLevel: record.user_level,
        focusAreas: record.focus_areas,
        aiProvider: record.ai_provider,
        aiModel: record.ai_model,
        totalTokensUsed: record.total_tokens_used,
        estimatedCost: record.estimated_cost,
        requestTimestamp: record.request_timestamp,
        createdAt: record.created_at,
        systemPrompt: record.system_prompt,
        userPrompt: record.user_prompt,
        aiResponse: record.ai_response,
        errorMessage: record.error_message,
        metadata: record.metadata,
        vocabularies: record.vocabularies?.map((v: any) => ({
          english: v.english,
          persian: v.persian,
          isUsed: v.is_used,
        })) || [],
        phrases: record.phrases?.map((p: any) => ({
          english: p.english,
          persian: p.persian,
          isUsed: p.is_used,
        })) || [],
      }));

      console.log('✅ [DATABASE] Retrieved', conversations.length, 'learning conversations');
      return conversations;

    } catch (error) {
      console.error('❌ [DATABASE] Failed to fetch learning conversations:', error);
      throw new Error(`Database fetch failed: ${error.message}`);
    }
  }

  /**
   * Gets the latest active prompt from the simplified prompts table
   * @returns Promise with prompt data or null if not found
   */
  async getLatestPrompt(): Promise<{
    id: number;
    version: number;
    content: string;
    createdAt: string;
  } | null> {
    console.log('💾 [DATABASE] Fetching latest active prompt');
    
    try {
      const { data, error } = await this.supabase.rpc('get_latest_prompt');

      if (error) {
        console.error('❌ [DATABASE] Error fetching latest prompt:', error);
        throw new Error(`Failed to fetch latest prompt: ${error.message}`);
      }

      if (!data || data.length === 0) {
        console.log('⚠️ [DATABASE] No active prompt found');
        return null;
      }

      // Get the first result from the function
      const promptData = Array.isArray(data) ? data[0] : data;
      
      console.log(`✅ [DATABASE] Latest prompt fetched: version ${promptData.version}`);
      return {
        id: promptData.id,
        version: promptData.version,
        content: promptData.content,
        createdAt: promptData.created_at
      };
    } catch (error) {
      console.error('❌ [DATABASE] Failed to fetch latest prompt:', error);
      throw error;
    }
  }

  /**
   * Gets user's previously used vocabularies for avoiding duplicates
   * @param userId - User ID
   * @param limit - Maximum number of vocabularies to fetch
   * @returns Promise with array of used vocabulary words
   */
  async getUserUsedVocabularies(userId: string, limit: number = 50): Promise<string[]> {
    try {
      console.log(`📚 [DATABASE] Fetching used vocabularies for user: ${userId}`);

      const { data, error } = await this.supabase
        .from('vocabularies')
        .select('english')
        .eq('user_id', userId)
        .order('created_at', { ascending: false })
        .limit(limit);

      if (error) {
        console.error('❌ [DATABASE] Error fetching used vocabularies:', error);
        return [];
      }

      const vocabularies = data?.map(v => v.english) || [];
      console.log(`✅ [DATABASE] Retrieved ${vocabularies.length} used vocabularies`);
      return vocabularies;

    } catch (error) {
      console.error('❌ [DATABASE] Failed to fetch used vocabularies:', error);
      return [];
    }
  }

  /**
   * Gets user's previously used phrases for avoiding duplicates
   * @param userId - User ID
   * @param limit - Maximum number of phrases to fetch
   * @returns Promise with array of used phrase texts
   */
  async getUserUsedPhrases(userId: string, limit: number = 50): Promise<string[]> {
    try {
      console.log(`💬 [DATABASE] Fetching used phrases for user: ${userId}`);

      const { data, error } = await this.supabase
        .from('phrases')
        .select('english')
        .eq('user_id', userId)
        .order('created_at', { ascending: false })
        .limit(limit);

      if (error) {
        console.error('❌ [DATABASE] Error fetching used phrases:', error);
        return [];
      }

      const phrases = data?.map(p => p.english) || [];
      console.log(`✅ [DATABASE] Retrieved ${phrases.length} used phrases`);
      return phrases;

    } catch (error) {
      console.error('❌ [DATABASE] Failed to fetch used phrases:', error);
      return [];
    }
  }

  /**
   * Gets user learning statistics
   * @param userId - User ID
   * @returns Promise with user statistics
   */
  async getUserLearningStatistics(userId: string): Promise<Record<string, any>> {
    try {
      console.log('📊 [DATABASE] Fetching learning statistics for user:', userId);

      // Get basic statistics
      const { data: requestStats, error: statsError } = await this.supabase
        .from('requests')
        .select('id, total_tokens_used, estimated_cost, ai_provider, created_at')
        .eq('user_id', userId);

      if (statsError) {
        throw new Error(`Failed to fetch request statistics: ${statsError.message}`);
      }

      // Get vocabulary count
      const { count: vocabCount, error: vocabError } = await this.supabase
        .from('vocabularies')
        .select('request_id', { count: 'exact' })
        .in('request_id', requestStats.map(r => r.id) || []);

      if (vocabError) {
        throw new Error(`Failed to fetch vocabulary count: ${vocabError.message}`);
      }

      // Get phrase count
      const { count: phraseCount, error: phraseError } = await this.supabase
        .from('phrases')
        .select('request_id', { count: 'exact' })
        .in('request_id', requestStats.map(r => r.id) || []);

      if (phraseError) {
        throw new Error(`Failed to fetch phrase count: ${phraseError.message}`);
      }

      // Calculate statistics
      const totalRequests = requestStats.length;
      const totalTokens = requestStats.reduce((sum, req) => sum + (req.total_tokens_used || 0), 0);
      const totalCost = requestStats.reduce((sum, req) => sum + (req.estimated_cost || 0), 0);
      
      const providerUsage: Record<string, number> = {};
      requestStats.forEach(req => {
        const provider = req.ai_provider || 'unknown';
        providerUsage[provider] = (providerUsage[provider] || 0) + 1;
      });

      const statistics = {
        totalRequests,
        totalTokensUsed: totalTokens,
        totalCostUsd: totalCost,
        totalVocabularies: vocabCount || 0,
        totalPhrases: phraseCount || 0,
        providerUsage,
        lastUpdated: new Date().toISOString(),
      };

      console.log('✅ [DATABASE] Learning statistics retrieved successfully');
      return statistics;

    } catch (error) {
      console.error('❌ [DATABASE] Failed to fetch learning statistics:', error);
      throw new Error(`Statistics fetch failed: ${error.message}`);
    }
  }
}

/**
 * Factory function to create a configured DatabaseService instance
 * @param config - Environment configuration
 * @returns Configured DatabaseService instance
 */
export function createDatabaseService(config: EnvironmentConfig): DatabaseService {
  return new DatabaseService(config);
}