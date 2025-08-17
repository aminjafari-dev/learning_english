# Authentication Implementation Guide

This guide explains how to implement proper authentication checking and database security rules in your Flutter app with Supabase.

## Overview

Your app now has a comprehensive authentication system that includes:

1. **AuthService** - Centralized authentication management
2. **AuthMiddleware** - Authentication wrapper for database operations
3. **Enhanced RLS Policies** - Database-level security rules
4. **Authentication Validation** - Automatic session refresh and validation

## Components

### 1. AuthService (`lib/core/services/auth_service.dart`)

The central authentication service that provides:

- **Authentication Status Checking**: `isAuthenticated()`
- **Current User Access**: `getCurrentUser()`, `getCurrentUserId()`
- **Session Management**: `isSessionValid()`, `refreshSessionIfNeeded()`
- **Authentication Validation**: `validateAuthentication()`

**Usage Example:**
```dart
final authService = getIt<AuthService>();

// Check if user is authenticated
if (await authService.isAuthenticated()) {
  // User is logged in
  final userId = authService.getCurrentUserId();
  final user = await authService.getCurrentUser();
}

// Validate authentication before operations
await authService.validateAuthentication();
```

### 2. AuthMiddleware (`lib/core/services/auth_middleware.dart`)

A middleware that wraps operations to ensure authentication:

- **withAuth()**: Execute operation with authentication validation
- **withUserContext()**: Execute operation with current user ID
- **withAuthOrDefault()**: Execute operation with fallback for unauthenticated users
- **validateRecordOwnership()**: Check if record belongs to current user

**Usage Examples:**

```dart
// Basic authentication wrapper
final result = await AuthMiddleware.withAuth(() => 
  repository.getUserData()
);

// With user context (automatically provides user ID)
final profile = await AuthMiddleware.withUserContext((userId) => 
  repository.getUserProfile(userId)
);

// With fallback for unauthenticated users
final data = await AuthMiddleware.withAuthOrDefault(
  () => repository.getPrivateData(),
  defaultValue
);

// Record ownership validation
if (AuthMiddleware.validateRecordOwnership(recordUserId)) {
  // User owns this record
}
```

## Implementation Steps

### Step 1: Update Your Data Sources

Wrap your existing data source methods with authentication middleware:

**Before:**
```dart
Future<UserProfileModel> getUserProfile(String userId) async {
  final response = await _supabase
      .from('user_profiles')
      .select()
      .eq('user_id', userId)
      .maybeSingle();
  return UserProfileModel.fromJson(response);
}
```

**After:**
```dart
Future<UserProfileModel> getUserProfile() async {
  return await AuthMiddleware.withUserContext((userId) async {
    final response = await _supabase
        .from('user_profiles')
        .select()
        .eq('user_id', userId)
        .maybeSingle();
    return UserProfileModel.fromJson(response);
  });
}
```

### Step 2: Update Your Repositories

Update repository implementations to use authenticated data sources:

```dart
class UserRepositoryImpl implements UserRepository {
  final ProfileRemoteDataSourceAuthenticated _remoteDataSource;
  
  @override
  Future<Either<Failure, UserProfile>> getUserProfile() async {
    try {
      final profile = await _remoteDataSource.getUserProfile();
      return Right(profile.toDomain());
    } catch (e) {
      if (e is UnauthorizedException) {
        return Left(AuthFailure('Authentication required'));
      }
      return Left(ServerFailure(e.toString()));
    }
  }
}
```

### Step 3: Update Your Use Cases

Use cases should handle authentication errors:

```dart
class GetUserProfileUseCase implements UseCase<UserProfile, NoParams> {
  final UserRepository repository;
  
  @override
  Future<Either<Failure, UserProfile>> call(NoParams params) async {
    return await repository.getUserProfile();
  }
}
```

### Step 4: Update Your BLoCs

BLoCs should handle authentication state:

```dart
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetUserProfileUseCase getUserProfileUseCase;
  
  Future<void> _onGetUserProfile(Emitter<ProfileState> emit) async {
    emit(state.copyWith(profile: const ProfileState.loading()));
    
    final result = await getUserProfileUseCase(NoParams());
    
    result.fold(
      (failure) {
        if (failure is AuthFailure) {
          emit(state.copyWith(profile: ProfileState.unauthenticated()));
        } else {
          emit(state.copyWith(profile: ProfileState.error(failure.message)));
        }
      },
      (profile) {
        emit(state.copyWith(profile: ProfileState.completed(profile)));
      },
    );
  }
}
```

## Database Security Rules

### Row Level Security (RLS)

All tables now have RLS enabled with the following policies:

1. **User Profiles**: Users can only access their own profile
2. **Requests**: Users can only access their own requests
3. **Vocabularies**: Users can only access their own vocabularies
4. **Phrases**: Users can only access their own phrases
5. **Prompts**: Users can only access their own prompts

### Authentication Helper Functions

The database includes helper functions:

- `is_authenticated()`: Check if user is authenticated
- `get_current_user_id()`: Get current user ID
- `validate_user_ownership(table_user_id)`: Validate record ownership

### Audit Logging

Authentication events are logged in the `auth_audit_log` table for security monitoring.

## Error Handling

### Authentication Errors

Handle authentication errors appropriately:

```dart
try {
  final result = await AuthMiddleware.withAuth(() => operation());
} catch (e) {
  if (e is UnauthorizedException) {
    // Handle authentication failure
    // Redirect to login or show authentication required message
  } else {
    // Handle other errors
  }
}
```

### Common Error Types

1. **UnauthorizedException**: User is not authenticated
2. **DatabaseException**: Database operation failed
3. **AuthFailure**: Authentication-related failure
4. **ServerFailure**: Server/network failure

## Best Practices

### 1. Always Validate Authentication

```dart
// ✅ Good: Always check authentication
final result = await AuthMiddleware.withAuth(() => operation());

// ❌ Bad: Direct database access without authentication
final result = await operation();
```

### 2. Use User Context When Possible

```dart
// ✅ Good: Use user context for user-specific operations
final profile = await AuthMiddleware.withUserContext((userId) => 
  repository.getUserProfile(userId)
);

// ❌ Bad: Pass user ID manually
final userId = AuthMiddleware.getCurrentUserId();
final profile = await repository.getUserProfile(userId);
```

### 3. Handle Authentication Errors Gracefully

```dart
// ✅ Good: Handle authentication errors
try {
  final result = await AuthMiddleware.withAuth(() => operation());
} catch (e) {
  if (e is UnauthorizedException) {
    // Show login prompt or redirect
    showLoginDialog();
  }
}

// ❌ Bad: Ignore authentication errors
final result = await AuthMiddleware.withAuth(() => operation());
```

### 4. Use Conditional Authentication

```dart
// ✅ Good: Handle both authenticated and unauthenticated states
final data = await AuthMiddleware.withAuthOrDefault(
  () => repository.getPrivateData(),
  repository.getPublicData(),
);
```

## Migration Checklist

To implement authentication in your existing features:

- [ ] Update data sources to use `AuthMiddleware.withAuth()` or `AuthMiddleware.withUserContext()`
- [ ] Update repositories to handle authentication errors
- [ ] Update use cases to propagate authentication errors
- [ ] Update BLoCs to handle authentication state
- [ ] Update UI to show authentication status
- [ ] Test authentication flow end-to-end
- [ ] Verify RLS policies are working correctly

## Testing

### Unit Tests

Test authentication middleware:

```dart
test('should throw UnauthorizedException when not authenticated', () async {
  // Arrange
  when(authService.isAuthenticated()).thenAnswer((_) async => false);
  
  // Act & Assert
  expect(
    () => AuthMiddleware.withAuth(() => Future.value('test')),
    throwsA(isA<UnauthorizedException>()),
  );
});
```

### Integration Tests

Test with real Supabase:

```dart
testWidgets('should require authentication for protected operations', (tester) async {
  // Arrange
  await tester.pumpWidget(MyApp());
  
  // Act
  await tester.tap(find.byKey(Key('protected_button')));
  await tester.pump();
  
  // Assert
  expect(find.text('Authentication required'), findsOneWidget);
});
```

## Security Considerations

1. **Never expose user IDs in URLs or logs**
2. **Always validate record ownership before operations**
3. **Use HTTPS for all API calls**
4. **Implement proper session management**
5. **Log authentication events for security monitoring**
6. **Regularly review and update RLS policies**

## Troubleshooting

### Common Issues

1. **"User must be authenticated" errors**: User is not logged in
2. **"Session is invalid" errors**: Session has expired
3. **"Access denied" errors**: User doesn't own the record
4. **RLS policy violations**: Database policies are blocking access

### Debug Steps

1. Check authentication status: `await AuthService().isAuthenticated()`
2. Verify session validity: `AuthService().isSessionValid()`
3. Check user ID: `AuthService().getCurrentUserId()`
4. Review RLS policies in Supabase dashboard
5. Check authentication logs in `auth_audit_log` table

This authentication system provides comprehensive security while maintaining clean, maintainable code. Follow the patterns and best practices outlined in this guide to ensure your app is secure and user-friendly.
