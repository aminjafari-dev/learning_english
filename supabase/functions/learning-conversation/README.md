# Learning Conversation Supabase Function

## Overview

This Supabase Edge Function handles AI-powered learning conversations using Google's Gemini API and automatically stores all learning request data, including generated vocabularies and phrases, to the database with complete user separation.

## 🎯 **Features**

### **AI Conversation Processing**
- ✅ **Adaptive prompts** based on user level and focus areas
- ✅ **Educational content generation** with vocabulary and phrase extraction
- ✅ **Token usage tracking** and cost estimation
- ✅ **Error handling and logging** for robust operation

### **Data Storage**
- ✅ **Real user data storage** - no hardcoded values
- ✅ **Complete request tracking** with metadata
- ✅ **Automatic vocabulary extraction** from AI responses
- ✅ **Automatic phrase extraction** for learning
- ✅ **User separation** with Row Level Security (RLS)

### **Security & Performance**
- ✅ **Environment variable validation** for sensitive data
- ✅ **Request validation** with detailed error messages
- ✅ **CORS support** for cross-origin requests
- ✅ **Service role access** for database operations

## 📋 **Setup Instructions**

### **Step 1: Database Setup**

1. Go to your Supabase dashboard
2. Navigate to **SQL Editor**
3. Execute the schema from `schema.sql`:

```sql
-- Copy and paste the entire contents of schema.sql
-- This creates tables, indexes, RLS policies, and helper functions
```

### **Step 2: Environment Variables**

Set the following environment variables in your Supabase project:

```bash
GEMINI_API_KEY=your_gemini_api_key_here
SUPABASE_URL=your_supabase_url
SUPABASE_SERVICE_ROLE_KEY=your_service_role_key
```

### **Step 3: Deploy the Function**

Deploy the function using Supabase CLI:

```bash
# Navigate to your project root
cd your_project_root

# Deploy the function
supabase functions deploy learning-conversation
```

### **Step 4: Test the Function**

Test with a sample request:

```bash
curl -X POST https://your-project.supabase.co/functions/v1/learning-conversation \
  -H "Authorization: Bearer YOUR_ANON_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "message": "Hello, can you help me practice English?",
    "userId": "test_user_123",
    "userLevel": "intermediate",
    "focusAreas": ["conversation", "vocabulary"]
  }'
```

## 🔧 **API Reference**

### **Request Format**

```typescript
{
  message: string;        // Required: User's message (max 2000 characters)
  userId: string;         // Required: Unique user identifier
  userLevel?: string;     // Optional: beginner|elementary|intermediate|advanced
  focusAreas?: string[];  // Optional: Array of learning focus areas
  requestId?: string;     // Optional: Custom request ID (auto-generated if not provided)
}
```

### **Response Format**

```typescript
{
  success: boolean;
  response?: string;      // AI-generated response
  requestId?: string;     // Unique request identifier
  error?: string;         // Error message if success is false
}
```

### **Example Request**

```javascript
const response = await fetch('https://your-project.supabase.co/functions/v1/learning-conversation', {
  method: 'POST',
  headers: {
    'Authorization': 'Bearer YOUR_ANON_KEY',
    'Content-Type': 'application/json',
  },
  body: JSON.stringify({
    message: "What's the difference between 'make' and 'do'?",
    userId: "user_123",
    userLevel: "intermediate",
    focusAreas: ["grammar", "vocabulary"]
  })
});

const data = await response.json();
console.log('AI Response:', data.response);
console.log('Request ID:', data.requestId);
```

## 📊 **Database Schema**

### **Tables Created**

1. **`learning_requests`** - Main conversation data
   - Stores complete request/response with metadata
   - Includes token usage and cost tracking
   - User-separated with RLS policies

2. **`learning_request_vocabularies`** - Extracted vocabularies
   - English words with Persian translations
   - Linked to learning requests
   - Prevents duplicates per user

3. **`learning_request_phrases`** - Extracted phrases
   - Common phrases for learning
   - Linked to learning requests
   - Prevents duplicates per user

### **Helper Functions**

- **`get_user_learning_statistics(user_id)`** - Returns comprehensive learning stats
- **`get_recent_learning_conversations(user_id, limit)`** - Fetches recent conversations with content

## 🚀 **Integration with Flutter App**

### **Replace Direct Supabase Calls**

Instead of using the removed `SupabaseLearningRequestsRemoteDataSource`, call this function:

```dart
// Old approach (removed)
// await supabaseDataSource.saveLearningRequest(learningRequest);

// New approach - function handles everything
final response = await Supabase.instance.client.functions.invoke(
  'learning-conversation',
  body: {
    'message': userMessage,
    'userId': currentUserId,
    'userLevel': userLevel,
    'focusAreas': focusAreas,
  },
);

if (response.data['success']) {
  final aiResponse = response.data['response'];
  final requestId = response.data['requestId'];
  // Handle successful response
} else {
  // Handle error
  final error = response.data['error'];
}
```

### **Data Retrieval**

Use the helper functions to get user data:

```dart
// Get user statistics
final statsResponse = await Supabase.instance.client
  .rpc('get_user_learning_statistics', params: {'p_user_id': userId});

// Get recent conversations
final conversationsResponse = await Supabase.instance.client
  .rpc('get_recent_learning_conversations', params: {
    'p_user_id': userId,
    'p_limit': 10
  });
```

## 🔍 **Monitoring and Debugging**

### **Function Logs**

Monitor function execution in the Supabase dashboard:

1. Go to **Edge Functions** → **learning-conversation**
2. Check the **Logs** tab for execution details
3. Look for console.log outputs with prefixes:
   - `🎯 [LEARNING]` - Main processing logs
   - `🤖 [GEMINI]` - AI API interactions
   - `💾 [DATABASE]` - Database operations
   - `❌ [ERROR]` - Error conditions

### **Database Monitoring**

Check data storage in the SQL Editor:

```sql
-- Recent learning requests
SELECT * FROM learning_requests 
WHERE user_id = 'your_user_id' 
ORDER BY created_at DESC 
LIMIT 10;

-- User statistics
SELECT * FROM get_user_learning_statistics('your_user_id');

-- Recent conversations with content
SELECT * FROM get_recent_learning_conversations('your_user_id', 5);
```

## ⚠️ **Important Notes**

### **Cost Management**
- Monitor Gemini API usage to control costs
- Token usage is tracked and stored for each request
- Set up billing alerts in Google Cloud Console

### **Security**
- All data is user-separated with RLS policies
- Service role access required for function operations
- Validate user authentication in your Flutter app before calling

### **Performance**
- Function processes and stores data in a single operation
- Vocabulary and phrase extraction happens server-side
- Consider implementing caching for frequently accessed data

## 🎯 **Benefits Over Previous Approach**

1. **Simplified Architecture** - Single function handles conversation + storage
2. **Real Data Storage** - No hardcoded values, actual user data persistence
3. **Better Error Handling** - Comprehensive error tracking and logging
4. **Automatic Content Extraction** - AI responses automatically parsed for learning content
5. **Cost Tracking** - Built-in token usage and cost estimation
6. **Scalability** - Server-side processing reduces client-side complexity

The function is now ready to handle real learning conversations with complete data storage and user separation!