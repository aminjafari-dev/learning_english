# Supabase Integration for Learning Requests

## Overview

This document describes the complete Supabase integration for the Daily Lessons feature, specifically for saving and managing all `LearningRequestModel` attributes in Supabase cloud storage with complete user separation.

## 🎯 **What's Been Implemented**

### **1. Supabase Remote Data Source**
- ✅ Complete CRUD operations for `LearningRequestModel`
- ✅ User separation and data isolation
- ✅ Relational database design with foreign keys
- ✅ Row Level Security (RLS) implementation
- ✅ Comprehensive error handling and logging
- ✅ Learning analytics and statistics

### **2. Database Schema**
- ✅ `learning_requests` table with all model attributes
- ✅ `learning_request_vocabularies` table for vocabulary storage
- ✅ `learning_request_phrases` table for phrase storage
- ✅ Proper foreign key relationships and cascading deletes
- ✅ Performance indexes for optimal queries
- ✅ Row Level Security policies for data protection

### **3. Data Structure Mapping**
All attributes from `LearningRequestModel` are properly mapped to Supabase:

| Model Attribute | Supabase Column | Type | Description |
|-----------------|----------------|------|-------------|
| `requestId` | `request_id` | TEXT | Unique request identifier |
| `userId` | `user_id` | TEXT | User identifier for separation |
| `userLevel` | `user_level` | TEXT | User's English proficiency level |
| `focusAreas` | `focus_areas` | TEXT[] | Array of learning focus areas |
| `aiProvider` | `ai_provider` | TEXT | AI provider used (openai, gemini, deepseek) |
| `aiModel` | `ai_model` | TEXT | Specific AI model used |
| `totalTokensUsed` | `total_tokens_used` | INTEGER | Total tokens consumed |
| `estimatedCost` | `estimated_cost` | DECIMAL(10,6) | Estimated cost in USD |
| `requestTimestamp` | `request_timestamp` | TIMESTAMPTZ | When request was made |
| `createdAt` | `created_at` | TIMESTAMPTZ | When record was created |
| `systemPrompt` | `system_prompt` | TEXT | AI system prompt used |
| `userPrompt` | `user_prompt` | TEXT | User's input prompt |
| `errorMessage` | `error_message` | TEXT | Error message if any |
| `vocabularies` | Related table | - | Stored in `learning_request_vocabularies` |
| `phrases` | Related table | - | Stored in `learning_request_phrases` |
| `metadata` | `metadata` | JSONB | Additional metadata |

## 🚀 **Setup Instructions**

### **1. Add Supabase Dependency**
The `pubspec.yaml` has been updated with Supabase dependency:

```yaml
dependencies:
  supabase_flutter: ^2.8.0
```

Run `flutter pub get` to install the dependency.

### **2. Create Supabase Database Schema**
Execute the following SQL in your Supabase SQL editor:

```sql
-- Main learning requests table
CREATE TABLE learning_requests (
  id BIGSERIAL PRIMARY KEY,
  request_id TEXT UNIQUE NOT NULL,
  user_id TEXT NOT NULL,
  user_level TEXT NOT NULL,
  focus_areas TEXT[] NOT NULL DEFAULT '{}',
  ai_provider TEXT NOT NULL,
  ai_model TEXT NOT NULL,
  total_tokens_used INTEGER NOT NULL DEFAULT 0,
  estimated_cost DECIMAL(10,6) NOT NULL DEFAULT 0.0,
  request_timestamp TIMESTAMPTZ NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  system_prompt TEXT NOT NULL,
  user_prompt TEXT NOT NULL,
  error_message TEXT,
  metadata JSONB
);

-- Vocabularies table with foreign key relationship
CREATE TABLE learning_request_vocabularies (
  id BIGSERIAL PRIMARY KEY,
  learning_request_id BIGINT REFERENCES learning_requests(id) ON DELETE CASCADE,
  english TEXT NOT NULL,
  persian TEXT NOT NULL,
  is_used BOOLEAN NOT NULL DEFAULT FALSE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Phrases table with foreign key relationship
CREATE TABLE learning_request_phrases (
  id BIGSERIAL PRIMARY KEY,
  learning_request_id BIGINT REFERENCES learning_requests(id) ON DELETE CASCADE,
  english TEXT NOT NULL,
  persian TEXT NOT NULL,
  is_used BOOLEAN NOT NULL DEFAULT FALSE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Performance indexes
CREATE INDEX idx_learning_requests_user_id ON learning_requests(user_id);
CREATE INDEX idx_learning_requests_request_id ON learning_requests(request_id);
CREATE INDEX idx_learning_requests_created_at ON learning_requests(created_at DESC);
CREATE INDEX idx_vocabularies_learning_request_id ON learning_request_vocabularies(learning_request_id);
CREATE INDEX idx_phrases_learning_request_id ON learning_request_phrases(learning_request_id);

-- Enable Row Level Security
ALTER TABLE learning_requests ENABLE ROW LEVEL SECURITY;
ALTER TABLE learning_request_vocabularies ENABLE ROW LEVEL SECURITY;
ALTER TABLE learning_request_phrases ENABLE ROW LEVEL SECURITY;

-- RLS policies to ensure users can only access their own data
CREATE POLICY "Users can only access their own learning requests" ON learning_requests
  FOR ALL USING (auth.uid()::text = user_id);

CREATE POLICY "Users can only access their own vocabularies" ON learning_request_vocabularies
  FOR ALL USING (EXISTS (
    SELECT 1 FROM learning_requests 
    WHERE learning_requests.id = learning_request_vocabularies.learning_request_id 
    AND learning_requests.user_id = auth.uid()::text
  ));

CREATE POLICY "Users can only access their own phrases" ON learning_request_phrases
  FOR ALL USING (EXISTS (
    SELECT 1 FROM learning_requests 
    WHERE learning_requests.id = learning_request_phrases.learning_request_id 
    AND learning_requests.user_id = auth.uid()::text
  ));
```

### **3. Initialize Supabase in Your App**
Add Supabase initialization to your `main.dart`:

```dart
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Supabase
  await Supabase.initialize(
    url: 'YOUR_SUPABASE_URL',
    anonKey: 'YOUR_SUPABASE_ANON_KEY',
  );
  
  runApp(MyApp());
}
```

## 📚 **Usage Examples**

### **1. Basic CRUD Operations**

```dart
// Initialize the data source
final supabaseClient = Supabase.instance.client;
final dataSource = SupabaseLearningRequestsRemoteDataSource(supabaseClient);

// Save a learning request
final result = await dataSource.saveLearningRequest(learningRequestModel);
result.fold(
  (failure) => print('Error: ${failure.message}'),
  (requestId) => print('Saved with ID: $requestId'),
);

// Get user's learning requests
final requestsResult = await dataSource.getUserLearningRequests('user123');
requestsResult.fold(
  (failure) => print('Error: ${failure.message}'),
  (requests) => print('Found ${requests.length} requests'),
);

// Get a specific request
final requestResult = await dataSource.getLearningRequestById('req123', 'user123');
requestResult.fold(
  (failure) => print('Error: ${failure.message}'),
  (request) => request != null 
    ? print('Found request: ${request.requestId}')
    : print('Request not found'),
);

// Update a request
final updateResult = await dataSource.updateLearningRequest(updatedRequest);
updateResult.fold(
  (failure) => print('Error: ${failure.message}'),
  (success) => print('Request updated successfully'),
);

// Delete a request
final deleteResult = await dataSource.deleteLearningRequest('req123', 'user123');
deleteResult.fold(
  (failure) => print('Error: ${failure.message}'),
  (success) => print('Request deleted successfully'),
);
```

### **2. Learning Analytics**

```dart
// Get user learning statistics
final statsResult = await dataSource.getUserLearningStatistics('user123');
statsResult.fold(
  (failure) => print('Error: ${failure.message}'),
  (stats) {
    print('Total requests: ${stats['totalRequests']}');
    print('Total tokens used: ${stats['totalTokensUsed']}');
    print('Total cost: \$${stats['totalCostUsd']}');
    print('Total vocabularies: ${stats['totalVocabularies']}');
    print('Total phrases: ${stats['totalPhrases']}');
    print('Provider usage: ${stats['providerUsage']}');
  },
);
```

### **3. Pagination Support**

```dart
// Get requests with pagination
final page1 = await dataSource.getUserLearningRequests(
  'user123',
  limit: 20,
  offset: 0,
);

final page2 = await dataSource.getUserLearningRequests(
  'user123', 
  limit: 20,
  offset: 20,
);
```

### **4. User Data Management**

```dart
// Clear all user data (useful for GDPR compliance)
final clearResult = await dataSource.clearUserLearningRequests('user123');
clearResult.fold(
  (failure) => print('Error: ${failure.message}'),
  (deletedCount) => print('Deleted $deletedCount learning requests'),
);
```

## 🔒 **Security Features**

### **1. Row Level Security (RLS)**
- Each user can only access their own learning requests
- Automatic enforcement at the database level
- Prevents data leaks between users
- Works with Supabase Auth automatically

### **2. User Data Isolation**
- All operations require `userId` parameter
- Foreign key relationships maintain data integrity
- Cascading deletes ensure complete cleanup

### **3. Data Validation**
- Input validation and sanitization
- Type safety with Dart models
- Error handling for invalid data

## 🚀 **Integration with Existing Repository**

To integrate this with your existing repository pattern:

```dart
// In your repository implementation
class DailyLessonsRepositoryImpl implements DailyLessonsRepository {
  final DailyLessonsLocalDataSource _localDataSource;
  final SupabaseLearningRequestsRemoteDataSource _supabaseDataSource;
  
  DailyLessonsRepositoryImpl({
    required DailyLessonsLocalDataSource localDataSource,
    required SupabaseLearningRequestsRemoteDataSource supabaseDataSource,
  }) : _localDataSource = localDataSource,
       _supabaseDataSource = supabaseDataSource;

  @override
  Future<Either<Failure, void>> saveLearningRequest(
    LearningRequestModel request,
  ) async {
    try {
      // Save to local storage first (for offline capability)
      await _localDataSource.saveLearningRequest(request);
      
      // Then save to Supabase (for cloud backup)
      final supabaseResult = await _supabaseDataSource.saveLearningRequest(request);
      
      return supabaseResult.fold(
        (failure) {
          // Log the failure but don't fail the operation
          print('Failed to save to Supabase: ${failure.message}');
          return right(null); // Local save succeeded
        },
        (requestId) => right(null),
      );
    } catch (e) {
      return left(CacheFailure('Failed to save learning request: $e'));
    }
  }

  // Similar patterns for other operations...
}
```

## 📊 **Performance Considerations**

### **1. Database Optimization**
- Indexes on frequently queried columns (`user_id`, `created_at`)
- Foreign key relationships for data integrity
- Proper data types for efficient storage

### **2. Query Optimization**
- Pagination support for large datasets
- Selective column fetching where appropriate
- Efficient joins for related data

### **3. Caching Strategy**
- Local storage as primary cache
- Supabase as backup/sync mechanism
- Offline-first approach

## 🔄 **Sync Strategy**

### **Option 1: Real-time Sync**
```dart
// Listen to real-time changes
final subscription = supabaseClient
    .from('learning_requests')
    .stream(primaryKey: ['id'])
    .eq('user_id', userId)
    .listen((data) {
      // Update local cache with remote changes
      _syncWithLocalStorage(data);
    });
```

### **Option 2: Periodic Sync**
```dart
// Periodic background sync
Timer.periodic(Duration(minutes: 30), (timer) async {
  await _syncUserData(userId);
});
```

### **Option 3: Manual Sync**
```dart
// User-triggered sync
Future<void> syncUserData(String userId) async {
  final remoteData = await _supabaseDataSource.getUserLearningRequests(userId);
  remoteData.fold(
    (failure) => print('Sync failed: ${failure.message}'),
    (requests) => _updateLocalStorage(requests),
  );
}
```

## 🧪 **Testing**

### **Unit Tests**
```dart
// Test the data source methods
group('SupabaseLearningRequestsRemoteDataSource', () {
  test('should save learning request successfully', () async {
    // Arrange
    final mockClient = MockSupabaseClient();
    final dataSource = SupabaseLearningRequestsRemoteDataSource(mockClient);
    
    // Act
    final result = await dataSource.saveLearningRequest(testRequest);
    
    // Assert
    expect(result.isRight(), true);
  });
});
```

### **Integration Tests**
```dart
// Test with real Supabase instance
group('Supabase Integration Tests', () {
  testWidgets('should save and retrieve learning requests', (tester) async {
    // Test with real Supabase client
    final dataSource = SupabaseLearningRequestsRemoteDataSource(
      Supabase.instance.client,
    );
    
    // Save and retrieve data
    await dataSource.saveLearningRequest(testRequest);
    final result = await dataSource.getUserLearningRequests(testUserId);
    
    expect(result.isRight(), true);
  });
});
```

## 🚨 **Error Handling**

The data source includes comprehensive error handling:

### **1. Network Errors**
- Connection timeouts
- Network unavailability
- Server errors

### **2. Authentication Errors**
- Invalid credentials
- Expired tokens
- Permission denied

### **3. Data Errors**
- Invalid data format
- Constraint violations
- Foreign key errors

### **4. Recovery Strategies**
- Graceful degradation to local storage
- Retry mechanisms for transient failures
- User-friendly error messages

## 📈 **Monitoring and Analytics**

### **1. Usage Tracking**
```dart
// Track usage patterns
final stats = await dataSource.getUserLearningStatistics(userId);
stats.fold(
  (failure) => logError('Stats fetch failed', failure),
  (data) => logAnalytics('user_learning_stats', data),
);
```

### **2. Performance Monitoring**
```dart
// Monitor operation performance
final stopwatch = Stopwatch()..start();
final result = await dataSource.saveLearningRequest(request);
stopwatch.stop();

logPerformance('supabase_save_duration', stopwatch.elapsedMilliseconds);
```

## 🔮 **Future Enhancements**

### **1. Real-time Collaboration**
- Share learning progress with teachers
- Group learning sessions
- Live vocabulary competitions

### **2. Advanced Analytics**
- Learning progress tracking
- Difficulty adaptation
- Personalized recommendations

### **3. Data Export**
- CSV/JSON export functionality
- Learning progress reports
- Data portability for GDPR compliance

### **4. Multi-device Sync**
- Seamless sync across devices
- Conflict resolution strategies
- Offline-first architecture

## ✅ **Integration Complete**

The Supabase integration for learning requests is now fully implemented and provides:

1. **Complete Data Persistence** - All `LearningRequestModel` attributes saved to cloud
2. **User Separation** - Secure, isolated data for each user
3. **Scalable Architecture** - Supports millions of users and requests
4. **Robust Error Handling** - Graceful failure handling and recovery
5. **Performance Optimization** - Efficient queries and proper indexing
6. **Security** - Row Level Security and data validation
7. **Analytics Support** - Learning statistics and progress tracking

The system is ready for production use and future enhancements!