#!/bin/bash

# Deploy Gemini Conversation Edge Function
# Simple deployment script for the well-structured Edge Function

echo "🚀 Deploying Gemini Conversation Edge Function..."

# Check if Supabase CLI is installed
if ! command -v supabase &> /dev/null; then
    echo "❌ Supabase CLI is not installed. Please install it first:"
    echo "   npm install -g supabase"
    exit 1
fi

# Check if we're in the right directory
if [ ! -d "supabase/functions/gemini-conversation" ]; then
    echo "❌ Please run this script from your project root directory"
    echo "   (the directory that contains the supabase folder)"
    exit 1
fi

# Deploy the function
echo "📦 Deploying function..."
supabase functions deploy gemini-conversation

if [ $? -eq 0 ]; then
    echo "✅ Function deployed successfully!"
    echo ""
    echo "📝 Next steps:"
    echo "1. Set your GEMINI_API_KEY in Supabase dashboard:"
    echo "   Settings > Edge Functions > Environment Variables"
    echo ""
    echo "2. Test your function with:"
    echo "   curl -X POST 'https://your-project.supabase.co/functions/v1/gemini-conversation' \\"
    echo "     -H 'Authorization: Bearer YOUR_ANON_KEY' \\"
    echo "     -H 'Content-Type: application/json' \\"
    echo "     -d '{\"message\": \"Hello, help me learn English!\"}'"
    echo ""
    echo "🎉 Your well-structured Gemini function is ready to use!"
else
    echo "❌ Deployment failed. Please check the error messages above."
    exit 1
fi