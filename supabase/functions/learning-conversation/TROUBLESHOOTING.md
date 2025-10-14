# Learning Conversation Function - Troubleshooting Guide

## 🔍 **Issue: Nothing Saves to Database Tables**

### **Root Cause Analysis**

The most common reasons why data isn't being saved to the database:

1. **Function Not Deployed** - The learning-conversation function hasn't been deployed yet
2. **Old Function Being Called** - Flutter app is calling the wrong function name
3. **Missing Environment Variables** - Required API keys not set in Supabase
4. **Database Schema Not Applied** - Tables don't exist yet
5. **Authentication Issues** - User ID not properly passed or authenticated

### **✅ What We've Fixed**

1. **Updated Flutter App** - Changed from `gemini-conversation` to `learning-conversation`
2. **Added User ID** - Now properly extracts user ID from Supabase auth
3. **Enhanced Logging** - Added detailed console logs for debugging
4. **Fixed TypeScript Errors** - All import issues resolved

### **🚀 Step-by-Step Deployment & Testing**

#### **Step 1: Start Docker and Supabase**
```bash
# Start Docker daemon (if not running)
# Then start Supabase local development
supabase start
```

#### **Step 2: Apply Database Schema**
```bash
# Apply the schema to create tables
supabase db reset

# Or manually apply the schema
psql -h localhost -p 54322 -U postgres -d postgres -f supabase/functions/learning-conversation/schema.sql
```

#### **Step 3: Deploy the Function**
```bash
# Deploy the learning-conversation function
supabase functions deploy learning-conversation

# Or use our deployment script
./deploy-learning-conversation.sh
```

#### **Step 4: Set Environment Variables**
```bash
# Set required environment variables
supabase secrets set GEMINI_API_KEY=your_gemini_api_key_here
supabase secrets set SUPABASE_URL=$(supabase status | grep API | awk '{print $3}')
supabase secrets set SUPABASE_SERVICE_ROLE_KEY=your_service_role_key
```

#### **Step 5: Test the Function Directly**
```bash
# Test with curl to verify function works
curl -X POST http://localhost:54321/functions/v1/learning-conversation \
  -H "Authorization: Bearer YOUR_ANON_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "message": "Hello, can you help me practice English?",
    "userId": "test_user_123",
    "userLevel": "intermediate",
    "focusAreas": ["conversation", "vocabulary"]
  }'
```

#### **Step 6: Check Function Logs**
```bash
# View function logs in real-time
supabase functions logs learning-conversation --follow
```

#### **Step 7: Verify Database Data**
```bash
# Connect to local database
psql -h localhost -p 54322 -U postgres -d postgres

# Check if tables exist
\dt

# Check if data was inserted
SELECT * FROM learning_requests ORDER BY created_at DESC LIMIT 5;
SELECT * FROM learning_request_vocabularies LIMIT 5;
SELECT * FROM learning_request_phrases LIMIT 5;
```

### **🔍 Debug Console Output**

When the function works correctly, you should see logs like:

```
🚀 [HANDLER] Learning conversation request received
✅ [HANDLER] Environment config loaded successfully
📥 [HANDLER] Request body received: { "message": "Hello", "userId": "test_user" }
✅ [HANDLER] Request validation successful for user: test_user_123
🎯 [LEARNING] Processing conversation for user: test_user_123
📊 [LEARNING] Level: intermediate, Focus: conversation, vocabulary
🤖 [GEMINI] Sending request to API...
✅ [GEMINI] Received response from API
✅ [LEARNING] AI response generated (150 tokens)
📚 [LEARNING] Extracted 5 vocabularies, 3 phrases
💾 [DATABASE] Saving learning conversation: req_test_user_123_1234567890_abcdef
💾 [DATABASE] User ID: test_user_123
💾 [DATABASE] Data size - Vocabularies: 5 Phrases: 3
✅ [DATABASE] Learning request saved with internal ID: 1
✅ [DATABASE] Saved 5 vocabularies
✅ [DATABASE] Saved 3 phrases
✅ [DATABASE] Complete learning conversation saved successfully
✅ [LEARNING] Complete learning conversation saved with ID: req_test_user_123_1234567890_abcdef
```

### **🚨 Common Error Messages**

#### **"Cannot find module '@supabase/supabase-js'"**
- **Solution**: This is expected in local development, function will work when deployed

#### **"Missing required environment variable: GEMINI_API_KEY"**
- **Solution**: Set the environment variable: `supabase secrets set GEMINI_API_KEY=your_key`

#### **"Failed to save learning request: relation does not exist"**
- **Solution**: Apply database schema: `supabase db reset` or run schema.sql

#### **"Method not allowed. Only POST requests are supported."**
- **Solution**: Ensure you're making POST requests, not GET

#### **"Invalid request: userId field is required"**
- **Solution**: Ensure Flutter app is passing userId in request body

### **📱 Flutter App Integration Test**

To test if the Flutter app is calling the function correctly:

1. **Add Debug Prints** in `GeminiConversationService`:
```dart
print('🚀 [FLUTTER] Calling learning-conversation function');
print('📤 [FLUTTER] Request body: $requestBody');

final response = await _supabaseClient.functions.invoke(
  'learning-conversation',
  body: requestBody,
);

print('📥 [FLUTTER] Function response: ${response.data}');
```

2. **Check Authentication**:
```dart
final user = Supabase.instance.client.auth.currentUser;
print('👤 [AUTH] Current user: ${user?.id}');
```

3. **Test with Real User**:
   - Ensure user is authenticated before calling the function
   - Use real user ID, not 'anonymous_user'

### **🎯 Quick Test Checklist**

- [ ] Docker is running
- [ ] Supabase is started (`supabase start`)
- [ ] Database schema is applied
- [ ] Function is deployed
- [ ] Environment variables are set
- [ ] Flutter app calls `learning-conversation` (not `gemini-conversation`)
- [ ] User is authenticated
- [ ] Function logs show successful execution
- [ ] Database contains data after test

### **🔧 Manual Database Verification**

If you want to manually insert test data to verify tables work:

```sql
-- Insert test learning request
INSERT INTO learning_requests (
  request_id, user_id, user_level, focus_areas, ai_provider, ai_model,
  total_tokens_used, estimated_cost, request_timestamp, system_prompt,
  user_prompt, ai_response
) VALUES (
  'test_req_123',
  'test_user_123',
  'intermediate',
  ARRAY['conversation', 'vocabulary'],
  'gemini',
  'gemini-2.5-flash',
  150,
  0.000225,
  NOW(),
  'Test system prompt',
  'Test user message',
  'Test AI response'
);

-- Verify insertion
SELECT * FROM learning_requests WHERE request_id = 'test_req_123';
```

This should help identify exactly where the issue is occurring! 🎯