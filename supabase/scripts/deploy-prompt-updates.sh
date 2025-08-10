#!/bin/bash

# Deploy updated prompts with Persian translation support
# This script applies the updated prompts to the Supabase database

set -e

echo "🚀 [DEPLOY] Starting prompt updates deployment..."

# Check if Supabase CLI is available
if ! command -v supabase &> /dev/null; then
    echo "❌ [ERROR] Supabase CLI is not installed or not in PATH"
    echo "Please install it from: https://supabase.com/docs/guides/cli"
    exit 1
fi

# Check if we're in the correct directory
if [ ! -f "supabase/config.toml" ]; then
    echo "❌ [ERROR] Please run this script from the project root directory"
    echo "Current directory: $(pwd)"
    exit 1
fi

echo "📁 [INFO] Current directory: $(pwd)"
echo "🔧 [INFO] Applying prompt updates..."

# Apply the prompt updates
if supabase db push --dry-run; then
    echo "✅ [INFO] Dry run successful, applying updates..."
    
    # Apply the SQL script directly
    echo "📋 [SQL] Executing prompt update script..."
    supabase db reset --linked
    
    # Then apply the prompt updates
    psql -h localhost -p 54322 -U postgres -d postgres -f supabase/scripts/update_prompts_with_persian_translations.sql
    
    echo "✅ [SUCCESS] Prompt updates applied successfully!"
    
    # Verify the deployment
    echo "🔍 [VERIFY] Checking updated prompts..."
    psql -h localhost -p 54322 -U postgres -d postgres -c "
    SELECT 
      prompt_type,
      prompt_name,
      version,
      is_latest,
      is_active,
      created_at
    FROM prompts 
    WHERE is_latest = true
    ORDER BY prompt_type;"
    
else
    echo "❌ [ERROR] Dry run failed, please check your database configuration"
    exit 1
fi

echo ""
echo "🎉 [COMPLETE] Prompt updates deployment completed successfully!"
echo ""
echo "📋 [NEXT STEPS]"
echo "1. Test the learning conversation function with a message"
echo "2. Check that Persian translations are now populated in the database"
echo "3. Verify that vocabulary and phrases tables contain Persian text"
echo ""
echo "🧪 [TEST COMMAND]"
echo "curl -X POST http://localhost:54321/functions/v1/learning-conversation \\"
echo "  -H \"Authorization: Bearer YOUR_ANON_KEY\" \\"
echo "  -H \"Content-Type: application/json\" \\"
echo "  -d '{\"message\": \"Hello, can you teach me some vocabulary?\", \"userId\": \"test_user\", \"userLevel\": \"intermediate\"}'"
echo ""