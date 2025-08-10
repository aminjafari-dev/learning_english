#!/bin/bash

# Test Dynamic Prompts System
# This script tests the deployed learning-conversation function with dynamic prompts

echo "🧪 Testing Dynamic Prompts System..."

# Get the project URL
PROJECT_URL="https://secsedrlvpifggleixfk.supabase.co"
ANON_KEY="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNlY3NlZHJsdnBpZmdnbGVpeGZrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjMxMDM4MzksImV4cCI6MjAzODY3OTgzOX0.fOgcOKT35I7bUXfpHWnVHcVpk6OT0LVvhQGOFkkjHm8"

echo "📡 Testing Educational Prompt..."
curl -X POST "$PROJECT_URL/functions/v1/learning-conversation" \
  -H "Authorization: Bearer $ANON_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "message": "Can you explain the difference between present perfect and past simple?",
    "userId": "test_user_educational",
    "userLevel": "intermediate",
    "focusAreas": ["grammar", "tenses"]
  }' | jq '.success, .response[:100]'

echo ""
echo "💬 Testing Conversation Prompt..."
curl -X POST "$PROJECT_URL/functions/v1/learning-conversation" \
  -H "Authorization: Bearer $ANON_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "message": "Hello! How are you today?",
    "userId": "test_user_conversation",
    "userLevel": "beginner",
    "focusAreas": ["conversation", "daily_life"]
  }' | jq '.success, .response[:100]'

echo ""
echo "🏋️ Testing Practice Prompt..."
curl -X POST "$PROJECT_URL/functions/v1/learning-conversation" \
  -H "Authorization: Bearer $ANON_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "message": "Give me some practice exercises for irregular verbs",
    "userId": "test_user_practice",
    "userLevel": "intermediate",
    "focusAreas": ["grammar", "verbs"]
  }' | jq '.success, .response[:100]'

echo ""
echo "📝 Testing Assessment Prompt..."
curl -X POST "$PROJECT_URL/functions/v1/learning-conversation" \
  -H "Authorization: Bearer $ANON_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "message": "Please check this sentence: I have went to the store yesterday",
    "userId": "test_user_assessment",
    "userLevel": "intermediate",
    "focusAreas": ["grammar", "tenses"]
  }' | jq '.success, .response[:100]'

echo ""
echo "✅ Testing Complete!"
echo ""
echo "🔍 Check the function logs for prompt type detection:"
echo "Expected logs:"
echo "• 🎯 [PROMPT] Determined prompt type: educational"
echo "• 🎯 [PROMPT] Determined prompt type: conversation" 
echo "• 🎯 [PROMPT] Determined prompt type: practice"
echo "• 🎯 [PROMPT] Determined prompt type: assessment"