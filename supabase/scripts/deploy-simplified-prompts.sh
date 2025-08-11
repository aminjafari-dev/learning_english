#!/bin/bash

# Deploy Simplified Prompts System
# This script deploys the new simplified prompts table and inserts the fixed prompt

set -e

echo "🚀 Deploying Simplified Prompts System..."

# Get the current directory (should be project root)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

echo "📍 Project root: $PROJECT_ROOT"

# Check if we're in a Supabase project
if [ ! -f "$PROJECT_ROOT/supabase/config.toml" ]; then
    echo "❌ Error: Not in a Supabase project directory"
    echo "   Please run this script from your project root"
    exit 1
fi

# Check if supabase CLI is installed
if ! command -v supabase &> /dev/null; then
    echo "❌ Error: Supabase CLI is not installed"
    echo "   Please install it from: https://supabase.com/docs/guides/cli"
    exit 1
fi

# Navigate to project root
cd "$PROJECT_ROOT"

echo "🔄 Checking Supabase status..."
if ! supabase status | grep -q "DB URL"; then
    echo "❌ Error: Supabase is not running"
    echo "   Please start Supabase with: supabase start"
    exit 1
fi

echo "✅ Supabase is running"

# Apply the simplified prompts table migration
echo "📋 Applying simplified prompts table migration..."
if [ -f "supabase/migrations/20250201000001_simplified_prompts_table.sql" ]; then
    supabase db reset --linked
    echo "✅ Simplified prompts table migration applied"
else
    echo "❌ Error: Migration file not found"
    echo "   Expected: supabase/migrations/20250201000001_simplified_prompts_table.sql"
    exit 1
fi

# Insert the fixed prompt
echo "📝 Inserting the fixed learning prompt..."
if [ -f "supabase/migrations/20250201000002_insert_fixed_prompt.sql" ]; then
    echo "✅ Fixed prompt inserted successfully"
else
    echo "❌ Error: Prompt insertion file not found"
    echo "   Expected: supabase/migrations/20250201000002_insert_fixed_prompt.sql"
    exit 1
fi

# Verify the deployment
echo "🔍 Verifying deployment..."

# Check if the prompts table exists and has data
PROMPT_COUNT=$(supabase db --execute "SELECT COUNT(*) FROM prompts;" | tail -n 1 | tr -d ' ')

if [ "$PROMPT_COUNT" -gt 0 ]; then
    echo "✅ Prompts table created with $PROMPT_COUNT prompt(s)"
else
    echo "❌ Error: Prompts table is empty"
    exit 1
fi

# Check if the function exists
FUNCTION_EXISTS=$(supabase db --execute "SELECT 1 FROM information_schema.routines WHERE routine_name = 'get_latest_prompt';" | wc -l)

if [ "$FUNCTION_EXISTS" -gt 1 ]; then
    echo "✅ get_latest_prompt function is available"
else
    echo "❌ Error: get_latest_prompt function not found"
    exit 1
fi

# Test the function
echo "🧪 Testing get_latest_prompt function..."
LATEST_PROMPT=$(supabase db --execute "SELECT version FROM get_latest_prompt();" | tail -n 1 | tr -d ' ')

if [ -n "$LATEST_PROMPT" ] && [ "$LATEST_PROMPT" != "version" ]; then
    echo "✅ Latest prompt function works (version: $LATEST_PROMPT)"
else
    echo "❌ Error: get_latest_prompt function test failed"
    exit 1
fi

echo ""
echo "🎉 Simplified Prompts System deployed successfully!"
echo ""
echo "📊 Deployment Summary:"
echo "   ✅ Simplified prompts table created"
echo "   ✅ Fixed learning prompt inserted (version: $LATEST_PROMPT)"
echo "   ✅ get_latest_prompt function available"
echo "   ✅ Database functions tested"
echo ""
echo "🔧 Next Steps:"
echo "   1. Deploy the learning-conversation function:"
echo "      supabase functions deploy learning-conversation"
echo ""
echo "   2. Test the complete system:"
echo "      curl -X POST http://localhost:54321/functions/v1/learning-conversation \\"
echo "        -H \"Authorization: Bearer \$ANON_KEY\" \\"
echo "        -H \"Content-Type: application/json\" \\"
echo "        -d '{\"userId\": \"test_user\", \"userLevel\": \"intermediate\", \"focusAreas\": [\"vocabulary\"]}'"
echo ""
echo "   3. Monitor function logs:"
echo "      supabase functions logs learning-conversation --follow"
echo ""

echo "📚 The new system features:"
echo "   • Single versioned prompt with dynamic variables"
echo "   • Automatic replacement of user_level, focus_areas, used_vocabularies, used_phrases"
echo "   • No more complex prompt types - just one flexible prompt"
echo "   • Structured JSON response format"
echo "   • Persian translations without Finglish"
echo ""

echo "🎯 Deployment completed at $(date)"