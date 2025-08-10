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
        .from('learning_requests')
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
   * @private
   */
  private async saveVocabularies(
    learningRequestId: number, 
    vocabularies: VocabularyData[],
    userId: string
  ): Promise<void> {
    const vocabularyData = vocabularies.map(vocab => ({
      learning_request_id: learningRequestId,
      english: vocab.english,
      persian: vocab.persian,
      is_used: vocab.isUsed,
    }));

    const { error } = await this.supabase
      .from('learning_request_vocabularies')
      .insert(vocabularyData);

    if (error) {
      throw new Error(`Failed to save vocabularies: ${error.message}`);
    }

    console.log('✅ [DATABASE] Saved', vocabularies.length, 'vocabularies');
  }

  /**
   * Saves phrases related to a learning request
   * @private
   */
  private async savePhrases(
    learningRequestId: number, 
    phrases: PhraseData[],
    userId: string
  ): Promise<void> {
    const phraseData = phrases.map(phrase => ({
      learning_request_id: learningRequestId,
      english: phrase.english,
      persian: phrase.persian,
      is_used: phrase.isUsed,
    }));

    const { error } = await this.supabase
      .from('learning_request_phrases')
      .insert(phraseData);

    if (error) {
      throw new Error(`Failed to save phrases: ${error.message}`);
    }

    console.log('✅ [DATABASE] Saved', phrases.length, 'phrases');
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
        .from('learning_requests')
        .select(`
          *,
          learning_request_vocabularies(*),
          learning_request_phrases(*)
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
        vocabularies: record.learning_request_vocabularies?.map((v: any) => ({
          english: v.english,
          persian: v.persian,
          isUsed: v.is_used,
        })) || [],
        phrases: record.learning_request_phrases?.map((p: any) => ({
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
   * Gets user learning statistics
   * @param userId - User ID
   * @returns Promise with user statistics
   */
  async getUserLearningStatistics(userId: string): Promise<Record<string, any>> {
    try {
      console.log('📊 [DATABASE] Fetching learning statistics for user:', userId);

      // Get basic statistics
      const { data: requestStats, error: statsError } = await this.supabase
        .from('learning_requests')
        .select('id, total_tokens_used, estimated_cost, ai_provider, created_at')
        .eq('user_id', userId);

      if (statsError) {
        throw new Error(`Failed to fetch request statistics: ${statsError.message}`);
      }

      // Get vocabulary count
      const { count: vocabCount, error: vocabError } = await this.supabase
        .from('learning_request_vocabularies')
        .select('learning_request_id', { count: 'exact' })
        .in('learning_request_id', requestStats.map(r => r.id) || []);

      if (vocabError) {
        throw new Error(`Failed to fetch vocabulary count: ${vocabError.message}`);
      }

      // Get phrase count
      const { count: phraseCount, error: phraseError } = await this.supabase
        .from('learning_request_phrases')
        .select('learning_request_id', { count: 'exact' })
        .in('learning_request_id', requestStats.map(r => r.id) || []);

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