# Supabase Deployment Scripts

This directory contains deployment automation scripts for the Learning English app's Supabase backend.

## 📁 Scripts Overview

### 🚀 Deployment Scripts (Bash)

#### `deploy-learning-conversation.sh` (Recommended)
**Full deployment pipeline for the learning conversation system**
- ✅ Sets up database schema
- ✅ Checks all required environment variables
- ✅ Deploys the learning-conversation function
- ✅ Tests the deployment
- ✅ Provides next steps

```bash
# Usage (from project root)
./supabase/scripts/deploy-learning-conversation.sh
```

#### `deploy-dynamic-prompts.sh`
**Deploys the dynamic prompts system with database reset**
- ✅ Resets database (`supabase db reset`)
- ✅ Deploys learning-conversation function
- ✅ Checks environment variables

```bash
# Usage (from project root)
./supabase/scripts/deploy-dynamic-prompts.sh
```



### 📋 Manual Deployment Scripts (SQL)

#### `manual_deployment_prompts.sql`
**Manual deployment script for the prompts table**
- Backup deployment option if migrations fail
- Can be run directly in Supabase SQL Editor
- Contains the complete prompts system setup

## 🔧 Prerequisites

Before running any deployment script, ensure you have:

1. **Supabase CLI installed**:
   ```bash
   npm install -g supabase
   ```

2. **Required environment variables set**:
   ```bash
   supabase secrets set GEMINI_API_KEY=your_api_key_here
   supabase secrets set SUPABASE_URL=your_supabase_url
   supabase secrets set SUPABASE_SERVICE_ROLE_KEY=your_service_key
   ```

3. **Supabase project initialized** (should already be done):
   ```bash
   supabase init
   ```

## 🎯 Recommended Workflow

### For Fresh Deployment:
```bash
# 1. Deploy full system
./supabase/scripts/deploy-learning-conversation.sh
```

### For Prompt Updates Only:
```bash
# 2. Update dynamic prompts
./supabase/scripts/deploy-dynamic-prompts.sh
```



## 🛡️ Error Handling

All scripts include error checking and will:
- ✅ Validate prerequisites before running
- ✅ Stop execution if any step fails
- ✅ Provide helpful error messages
- ✅ Show next steps on successful completion

## 📝 File Organization

```
supabase/scripts/
├── deploy-learning-conversation.sh    # Full system deployment
├── deploy-dynamic-prompts.sh          # Prompts system deployment
├── manual_deployment_prompts.sql      # Manual SQL deployment
└── README.md                          # This documentation
```

## 🔍 Troubleshooting

### Common Issues:

1. **"Supabase CLI not found"**
   ```bash
   npm install -g supabase
   ```

2. **"Missing environment variables"**
   ```bash
   supabase secrets set VARIABLE_NAME=value
   ```

3. **"Function deployment failed"**
   - Check the function logs in Supabase dashboard
   - Verify all TypeScript files compile correctly
   - Ensure all dependencies are properly imported

4. **"Database migration failed"**
   - Check for conflicting table names
   - Verify SQL syntax in migration files
   - Use `supabase db reset` to start fresh

## 💡 Pro Tips

- **Always run from project root**: Scripts expect to be run from the main project directory
- **Check logs**: Monitor function logs in Supabase dashboard after deployment
- **Test incrementally**: Deploy and test each component before moving to the next
- **Backup first**: Run `supabase db dump` before major migrations

## 🆘 Support

If you encounter issues:
1. Check the error messages in terminal output
2. Review Supabase dashboard logs
3. Verify all prerequisites are met
4. Try the manual deployment SQL script as fallback