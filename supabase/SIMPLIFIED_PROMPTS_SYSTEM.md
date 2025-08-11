# Simplified Prompts System

## Overview

The simplified prompts system replaces the complex multi-type prompt structure with a single, versioned prompt that uses dynamic variable replacement. This makes the system much easier to maintain and allows for real-time customization based on user history.

## 🎯 **Key Features**

### **Single Prompt with Variables**
- One prompt template with `{variable}` placeholders
- Dynamic replacement with real user data
- Versioned for easy updates and rollbacks

### **Automatic User History Integration**
- Fetches user's previously used vocabularies
- Fetches user's previously used phrases  
- Prevents duplicate suggestions automatically

### **Structured JSON Response**
- Expects AI to return structured JSON
- Automatic extraction of vocabularies and phrases
- Fallback parsing for non-JSON responses

## 📋 **System Architecture**

### **Database Structure**
```sql
-- Simplified prompts table
CREATE TABLE prompts (
  id BIGSERIAL PRIMARY KEY,
  version INTEGER NOT NULL DEFAULT 1,
  content TEXT NOT NULL,
  is_active BOOLEAN NOT NULL DEFAULT TRUE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
```

### **Dynamic Variables**
The prompt system supports these variables:

| Variable | Description | Example |
|----------|-------------|---------|
| `{user_level}` | User's English level | "intermediate" |
| `{focus_areas}` | Learning focus areas | "vocabulary, conversation" |
| `{used_vocabularies}` | Previously used words | "practice, understand, fluent" |
| `{used_phrases}` | Previously used phrases | "How are you, Nice to meet you" |

### **Prompt Template**
```
Generate exactly 3 new English vocabulary words and 5 useful English phrases for {user_level} level I want to focus on {focus_areas}.

- Previously used vocabulary words: {used_vocabularies}
- Previously used phrases: {used_phrases}

Requirements:
- Ensure variety (mix of nouns, verbs, adjectives, adverbs)
- Avoid any words from previous learning sessions

Format your response exactly like this:
{
  "vocabularies": [
    {"english": "new_word1", "persian": "ترجمه1"},
    {"english": "new_word2", "persian": "ترجمه2"},
    {"english": "new_word3", "persian": "ترجمه3"}
  ],
  "phrases": [
    {"english": "new_phrase1", "persian": "ترجمه1"},
    {"english": "new_phrase2", "persian": "ترجمه2"},
    {"english": "new_phrase3", "persian": "ترجمه3"},
    {"english": "new_phrase4", "persian": "ترجمه4"},
    {"english": "new_phrase5", "persian": "ترجمه5"}
  ]
}

IMPORTANT INSTRUCTIONS:
1. Avoid suggesting any of the previously used words or phrases listed above
2. Provide Persian translations without English transliterations (Finglish)
3. Return only the JSON format above, no additional text
4. Ensure all vocabulary and phrases are appropriate for {user_level} level
```

## 🚀 **Deployment**

### **Step 1: Deploy Database Changes**
```bash
# Deploy the simplified prompts system
./supabase/scripts/deploy-simplified-prompts.sh
```

### **Step 2: Deploy Function**
```bash
# Deploy the updated learning-conversation function
supabase functions deploy learning-conversation
```

### **Step 3: Test the System**
```bash
# Test with a real user
curl -X POST http://localhost:54321/functions/v1/learning-conversation \
  -H "Authorization: Bearer $ANON_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "userId": "test_user_123",
    "userLevel": "intermediate", 
    "focusAreas": ["vocabulary", "conversation"]
  }'
```

## 🔧 **Function Workflow**

### **1. Request Processing**
```typescript
// User makes request
{
  userId: "user_123",
  userLevel: "intermediate",
  focusAreas: ["vocabulary", "conversation"]
}
```

### **2. User History Fetching**
```typescript
// Function fetches user's history
const usedVocabularies = await databaseService.getUserUsedVocabularies(userId, 50);
const usedPhrases = await databaseService.getUserUsedPhrases(userId, 50);
```

### **3. Prompt Generation**
```typescript
// Variables are replaced in the prompt template
const variables = {
  user_level: "intermediate",
  focus_areas: "vocabulary, conversation", 
  used_vocabularies: "practice, understand, fluent",
  used_phrases: "How are you, Nice to meet you"
};
```

### **4. AI Response Processing**
```typescript
// Expected AI response format
{
  "vocabularies": [
    {"english": "appreciate", "persian": "قدردانی کردن"},
    {"english": "significant", "persian": "مهم"},
    {"english": "contribute", "persian": "کمک کردن"}
  ],
  "phrases": [
    {"english": "I appreciate your help", "persian": "از کمک شما قدردانی می‌کنم"},
    {"english": "That's significant", "persian": "این مهم است"},
    {"english": "Let me contribute", "persian": "اجازه دهید کمک کنم"},
    {"english": "It's my pleasure", "persian": "خوشحالم که کمک کردم"},
    {"english": "I completely agree", "persian": "کاملاً موافقم"}
  ]
}
```

### **5. Data Storage**
```typescript
// All data is automatically saved to database
// - Learning request with metadata
// - New vocabularies (avoiding duplicates)
// - New phrases (avoiding duplicates)
```

## 📊 **Benefits Over Previous System**

### **Simplified Architecture**
- ❌ **Before**: Multiple prompt types (educational, conversation, practice, assessment)
- ✅ **After**: Single flexible prompt with variables

### **Real User Data**
- ❌ **Before**: No consideration of user's learning history
- ✅ **After**: Automatic avoidance of previously learned content

### **Easier Maintenance**
- ❌ **Before**: Complex prompt type determination logic
- ✅ **After**: Simple variable replacement

### **Better Personalization**
- ❌ **Before**: Generic prompts for all users
- ✅ **After**: Personalized based on user's actual progress

### **Structured Output**
- ❌ **Before**: Free-form text requiring complex parsing
- ✅ **After**: Structured JSON with guaranteed format

## 🛠 **Managing Prompts**

### **Update the Prompt**
```sql
-- Create a new version of the prompt
SELECT create_new_prompt_version('Your new prompt content with {variables}');
```

### **Check Current Prompt**
```sql
-- Get the current active prompt
SELECT * FROM get_latest_prompt();
```

### **View Prompt History**
```sql
-- See all prompt versions
SELECT version, is_active, created_at 
FROM prompts 
ORDER BY version DESC;
```

## 🧪 **Testing**

### **Test Prompt Generation**
```bash
# Test the complete flow
curl -X POST http://localhost:54321/functions/v1/learning-conversation \
  -H "Authorization: Bearer $ANON_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "userId": "test_user",
    "userLevel": "beginner",
    "focusAreas": ["vocabulary"]
  }'
```

### **Test with User History**
```bash
# First, create some user history
curl -X POST http://localhost:54321/functions/v1/learning-conversation \
  -H "Authorization: Bearer $ANON_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "userId": "test_user_with_history",
    "userLevel": "intermediate",
    "focusAreas": ["conversation"]
  }'

# Then test again - should avoid previous words
curl -X POST http://localhost:54321/functions/v1/learning-conversation \
  -H "Authorization: Bearer $ANON_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "userId": "test_user_with_history",
    "userLevel": "intermediate", 
    "focusAreas": ["vocabulary"]
  }'
```

## 🔍 **Monitoring**

### **Function Logs**
```bash
# Monitor function execution
supabase functions logs learning-conversation --follow
```

### **Database Queries**
```sql
-- Check user's vocabulary history
SELECT english, persian, created_at 
FROM vocabularies 
WHERE user_id = 'test_user' 
ORDER BY created_at DESC;

-- Check user's phrase history  
SELECT english, persian, created_at
FROM phrases
WHERE user_id = 'test_user'
ORDER BY created_at DESC;

-- View learning statistics
SELECT * FROM get_user_learning_statistics('test_user');
```

## 🎯 **Expected Results**

After deployment, the system will:

1. **Automatically avoid duplicates** - Users won't see the same vocabulary/phrases twice
2. **Provide structured responses** - Consistent JSON format with Persian translations
3. **Scale efficiently** - Single prompt handles all learning scenarios
4. **Easy to maintain** - Update the prompt without changing code
5. **Real user progress** - Learning builds on previous sessions

The simplified system maintains all the power of the previous complex system while being much easier to understand, maintain, and extend.