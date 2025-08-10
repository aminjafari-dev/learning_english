#!/bin/bash

# Deploy Dynamic Prompts System
# This script applies the prompts table migration and redeploys the learning-conversation function

echo "🚀 Deploying Dynamic Prompts System..."

# Check if Supabase CLI is available
if ! command -v supabase &> /dev/null; then
    echo "❌ Supabase CLI is not installed. Please install it first."
    exit 1
fi

# Step 1: Apply the prompts table migration
echo "📋 Step 1: Applying prompts table migration..."
supabase db reset
if [ $? -eq 0 ]; then
    echo "✅ Migration applied successfully"
else
    echo "❌ Failed to apply migration"
    exit 1
fi

# Step 2: Deploy the updated learning-conversation function
echo "🔄 Step 2: Deploying updated learning-conversation function..."
supabase functions deploy learning-conversation
if [ $? -eq 0 ]; then
    echo "✅ Function deployed successfully"
else
    echo "❌ Failed to deploy function"
    exit 1
fi

# Step 3: Set environment variables (if not already set)
echo "🔧 Step 3: Checking environment variables..."

# Check if GEMINI_API_KEY is set
if [ -z "$(supabase secrets list | grep GEMINI_API_KEY)" ]; then
    echo "⚠️  GEMINI_API_KEY not set. Please set it manually:"
    echo "supabase secrets set GEMINI_API_KEY=your_api_key_here"
fi

echo ""
echo "🎉 Dynamic Prompts System Deployment Complete!"
echo ""
echo "📊 What's New:"
echo "• ✅ Prompts table created with versioning support"
echo "• ✅ 4 default prompt types seeded (educational, conversation, practice, assessment)"
echo "• ✅ Edge Function updated to use dynamic prompts"
echo "• ✅ Flutter service simplified (no hardcoded prompts)"
echo ""
echo "🔍 How It Works:"
echo "• AI analyzes user messages to determine prompt type"
echo "• Latest prompt version is fetched from database"
echo "• Variables are dynamically substituted in prompts"
echo "• All conversations stored with prompt metadata"
echo ""
echo "📝 Next Steps:"
echo "• Test the system with different message types"
echo "• Create new prompt versions via SQL functions"
echo "• Monitor prompt performance in logs"
echo ""
echo "💡 Tip: Use these SQL functions to manage prompts:"
echo "• get_latest_prompt('conversation')"
echo "• create_prompt_version('type', 'name', 'content')"
echo "• toggle_prompt_active(id, true, true)"
echo ""