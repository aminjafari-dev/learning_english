# Daily Lessons Cost Optimization Guide

## Overview

This document explains the cost optimization strategy implemented for the Daily Lessons feature to reduce AI API costs while maintaining functionality.

## Problem Statement

**Original Implementation (2 Separate Requests):**
- One request for vocabularies: ~150-200 tokens
- One request for phrases: ~150-200 tokens
- **Total cost per day: ~300-400 tokens**

**Issues:**
- High API costs due to duplicate system prompts
- Redundant network requests
- Inefficient token usage

## Solution: Combined Request Approach

**New Implementation (1 Combined Request):**
- Single request for both vocabularies and phrases: ~200-250 tokens
- **Total cost per day: ~200-250 tokens**
- **Cost savings: 25-40% reduction**

## Implementation Details

### 1. New Data Source Method

```dart
/// Fetches both daily vocabularies and phrases in a single request
/// This method is more cost-effective than making separate requests
Future<Either<Failure, ({List<Vocabulary> vocabularies, List<Phrase> phrases})>> fetchDailyLessons();
```

### 2. Optimized Prompt Structure

**Before (2 separate prompts):**
```json
// Request 1: Vocabularies
{
  "messages": [
    {"role": "system", "content": "You are an English teacher. Provide 4 vocabulary words..."},
    {"role": "user", "content": "Give me 4 English vocabulary words..."}
  ]
}

// Request 2: Phrases  
{
  "messages": [
    {"role": "system", "content": "You are an English teacher. Provide 2 phrases..."},
    {"role": "user", "content": "Give me 2 English phrases..."}
  ]
}
```

**After (1 combined prompt):**
```json
{
  "messages": [
    {
      "role": "system", 
      "content": "You are an English teacher. Provide both vocabulary words and phrases for daily learning. Respond in JSON format with two arrays: vocabularies and phrases."
    },
    {
      "role": "user", 
      "content": "Give me 4 English vocabulary words and 2 English phrases, all with Persian translations."
    }
  ]
}
```

### 3. Response Format

```json
{
  "vocabularies": [
    {"english": "word1", "persian": "ترجمه1"},
    {"english": "word2", "persian": "ترجمه2"}
  ],
  "phrases": [
    {"english": "phrase1", "persian": "ترجمه1"},
    {"english": "phrase2", "persian": "ترجمه2"}
  ]
}
```

## Cost Comparison by Provider

### OpenAI GPT-3.5-turbo
- **Before**: ~300-400 tokens/day
- **After**: ~200-250 tokens/day
- **Savings**: ~25-35%

### Google Gemini
- **Before**: ~300-400 tokens/day  
- **After**: ~200-250 tokens/day
- **Savings**: ~25-35%

### DeepSeek
- **Before**: ~300-400 tokens/day
- **After**: ~200-250 tokens/day  
- **Savings**: ~25-35%

## Migration Guide

### For Developers

1. **Use the personalized combined method:**
```dart
// Current implementation:
final userPreferences = await userPreferencesRepo.getUserPreferences();
final lessonsResult = await repo.getPersonalizedDailyLessons(userPreferences);
```

2. **Use simplified BLoC events:**
```dart
// Current usage (automatically gets preferences and uses combined request):
context.read<DailyLessonsBloc>().add(const DailyLessonsEvent.fetchLessons());

// For conversation mode:
context.read<DailyLessonsBloc>().add(
  DailyLessonsEvent.sendConversationMessage(
    preferences: preferences,
    message: "Hello",
  ),
);
```

### For UI Updates

The UI will automatically receive both vocabularies and phrases when using the new `fetchLessons` event, so no UI changes are required.

## Backward Compatibility

- Old methods (`fetchDailyVocabularies`, `fetchDailyPhrases`) are still available but deprecated
- Gradual migration is supported
- No breaking changes to existing functionality

## Best Practices

1. **Always use the combined method** for new implementations
2. **Monitor API usage** to track cost savings
3. **Consider caching** for additional cost reduction
4. **Use appropriate max_tokens** (512 for combined request vs 256 for individual)

## Monitoring and Analytics

Track these metrics to measure cost optimization:
- Total tokens used per day
- Number of API requests per day
- Cost per user session
- Error rates for combined vs separate requests

## Future Optimizations

1. **Implement caching** to avoid repeated requests for the same day
2. **Batch multiple user requests** if possible
3. **Use streaming responses** for real-time feedback
4. **Implement fallback strategies** for API failures

## Conclusion

The combined request approach provides significant cost savings (25-40%) while maintaining the same functionality. This optimization is especially important for applications with high user volumes or budget constraints. 