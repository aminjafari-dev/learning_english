#!/bin/bash

# deploy-learning-conversation.sh
# Deployment script for the learning-conversation Supabase function
# This script handles database schema setup and function deployment

set -e  # Exit on any error

echo "🚀 Starting Learning Conversation Function Deployment"
echo "=================================================="

# Check if Supabase CLI is installed
if ! command -v supabase &> /dev/null; then
    echo "❌ Supabase CLI is not installed. Please install it first:"
    echo "   npm install -g supabase"
    exit 1
fi

# Check if we're in a Supabase project
if [ ! -f "supabase/config.toml" ]; then
    echo "❌ This doesn't appear to be a Supabase project (missing config.toml)"
    echo "   Please run this script from your project root directory"
    exit 1
fi

# Check if the function directory exists
if [ ! -d "supabase/functions/learning-conversation" ]; then
    echo "❌ Learning conversation function directory not found"
    echo "   Expected: supabase/functions/learning-conversation"
    exit 1
fi

echo "✅ Environment checks passed"
echo ""

# Step 1: Setup database schema
echo "📊 Setting up database schema..."
echo "--------------------------------"

if [ -f "supabase/functions/learning-conversation/schema.sql" ]; then
    echo "🔧 Applying database schema..."
    supabase db reset --db-url postgresql://localhost:54322/postgres || {
        echo "⚠️  Database reset failed, continuing with schema application..."
    }
    
    # Apply the schema
    supabase db push
    
    echo "✅ Database schema applied successfully"
else
    echo "⚠️  Schema file not found, skipping database setup"
fi

echo ""

# Step 2: Check environment variables
echo "🔐 Checking environment variables..."
echo "-----------------------------------"

# List of required environment variables
REQUIRED_VARS=("GEMINI_API_KEY" "SUPABASE_URL" "SUPABASE_SERVICE_ROLE_KEY")
MISSING_VARS=()

for var in "${REQUIRED_VARS[@]}"; do
    # Check if variable is set in Supabase secrets
    if ! supabase secrets list | grep -q "$var"; then
        MISSING_VARS+=("$var")
    fi
done

if [ ${#MISSING_VARS[@]} -gt 0 ]; then
    echo "❌ Missing required environment variables:"
    for var in "${MISSING_VARS[@]}"; do
        echo "   - $var"
    done
    echo ""
    echo "Please set these variables using:"
    echo "   supabase secrets set VARIABLE_NAME=value"
    echo ""
    echo "Example:"
    echo "   supabase secrets set GEMINI_API_KEY=your_api_key_here"
    exit 1
fi

echo "✅ All required environment variables are set"
echo ""

# Step 3: Deploy the function
echo "🚀 Deploying learning-conversation function..."
echo "---------------------------------------------"

# Deploy the function
supabase functions deploy learning-conversation

if [ $? -eq 0 ]; then
    echo "✅ Function deployed successfully!"
else
    echo "❌ Function deployment failed"
    exit 1
fi

echo ""

# Step 4: Test the deployment
echo "🧪 Testing function deployment..."
echo "--------------------------------"

# Get the function URL
FUNCTION_URL=$(supabase status | grep "Functions URL" | awk '{print $3}')

if [ -z "$FUNCTION_URL" ]; then
    echo "⚠️  Could not determine function URL, skipping test"
else
    echo "🌐 Function URL: ${FUNCTION_URL}/learning-conversation"
    
    # Optional: Run a simple test
    echo "💡 You can test the function with:"
    echo "   curl -X POST ${FUNCTION_URL}/learning-conversation \\"
    echo "     -H \"Authorization: Bearer \$SUPABASE_ANON_KEY\" \\"
    echo "     -H \"Content-Type: application/json\" \\"
    echo "     -d '{\"message\": \"Hello!\", \"userId\": \"test_user\"}'"
fi

echo ""

# Step 5: Display next steps
echo "🎯 Deployment Complete!"
echo "======================"
echo ""
echo "Next steps:"
echo "1. Update your Flutter app to use the new function"
echo "2. Remove any references to SupabaseLearningRequestsRemoteDataSource"
echo "3. Test the integration with real user data"
echo "4. Monitor function logs in the Supabase dashboard"
echo ""
echo "📚 Documentation: supabase/functions/learning-conversation/README.md"
echo "🔧 Schema: supabase/functions/learning-conversation/schema.sql"
echo ""
echo "Happy learning! 🎓"