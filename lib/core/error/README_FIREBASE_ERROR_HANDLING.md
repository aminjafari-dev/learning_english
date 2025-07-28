# Firebase Error Handling System

This comprehensive error handling system provides robust handling for all Firebase-related errors, including regional restrictions (like those in Iran), network issues, authentication failures, and Firestore errors.

## 🎯 Features

- **Comprehensive Error Classification**: Handles all Firebase error types
- **Regional Restriction Detection**: Specifically handles 403 Forbidden errors common in Iran
- **User-Friendly Messages**: Provides clear, actionable error messages in Persian/English
- **Recovery Strategies**: Identifies which errors are recoverable vs. requiring user action
- **Reusable Widgets**: Pre-built error display components
- **Localization Support**: Error messages in both English and Persian

## 📁 Files Structure

```
lib/core/error/
├── firebase_failure.dart          # Firebase-specific failure classes
├── firebase_error_handler.dart    # Error handling utility
└── widgets/
    └── firebase_error_widget.dart # Reusable error display widgets
```

## 🚀 Quick Start

### 1. Wrap Firebase Operations

Replace your existing Firebase calls with error-handled versions:

```dart
// Before
try {
  await firestore.collection('users').doc(userId).set(data);
} catch (e) {
  // Generic error handling
}

// After
try {
  await FirebaseErrorHandler.wrapFirebaseOperation(
    () async {
      await firestore.collection('users').doc(userId).set(data);
    },
    context: 'save_user_data',
  );
} catch (exception) {
  // Exception is now a FirebaseFailure with proper classification
  final failure = FirebaseErrorHandler.handleException(exception);
  // Handle based on failure type
}
```

### 2. Update Your Data Sources

```dart
class UserRemoteDataSource {
  final FirebaseFirestore firestore;

  UserRemoteDataSource(this.firestore);

  Future<void> saveUserLevel(String userId, Level level) async {
    try {
      await FirebaseErrorHandler.wrapFirebaseOperation(
        () async {
          await firestore.collection('users').doc(userId).set({
            'level': level.name,
          }, SetOptions(merge: true));
        },
        context: 'save_user_level',
      );
    } catch (exception) {
      FirebaseErrorHandler.logError(exception, context: 'save_user_level');
      rethrow;
    }
  }
}
```

### 3. Update Your Repositories

```dart
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  @override
  Future<Either<FirebaseFailure, User>> signInWithGoogle() async {
    try {
      final userModel = await remoteDataSource.signInWithGoogle();
      return Right(userModel.toEntity());
    } catch (exception) {
      final failure = FirebaseErrorHandler.handleException(
        exception,
        context: 'auth_repository_sign_in',
      );
      return Left(failure);
    }
  }
}
```

### 4. Update Your BLoCs

```dart
class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthRepository repository;

  Future<void> _onGoogleSignIn(Emitter<AuthenticationState> emit) async {
    emit(const AuthenticationState.loading());

    try {
      final result = await repository.signInWithGoogle();
      
      result.fold(
        (failure) {
          // Handle different types of Firebase failures
          if (failure is FirebaseRegionalFailure) {
            emit(AuthenticationState.error(
              'Authentication services are restricted in your region. Please try using a VPN.',
            ));
          } else if (failure is FirebaseNetworkFailure) {
            emit(AuthenticationState.error(
              'Network connection failed. Please check your internet connection.',
            ));
          } else {
            emit(AuthenticationState.error(failure.userFriendlyMessage));
          }
        },
        (user) {
          emit(AuthenticationState.authenticated(user));
        },
      );
    } catch (e) {
      emit(AuthenticationState.error('An unexpected error occurred. Please try again.'));
    }
  }
}
```

### 5. Use Error Widgets in Your UI

```dart
class AuthenticationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        state.when(
          initial: () {},
          loading: () {},
          authenticated: (user) {
            // Navigate to next screen
          },
          unauthenticated: () {},
          error: (message) {
            // Show error dialog
            showDialog(
              context: context,
              builder: (context) => FirebaseErrorDialog(
                failure: FirebaseGenericFailure(message),
                onRetry: () {
                  Navigator.of(context).pop();
                  context.read<AuthenticationBloc>()
                      .add(const AuthenticationEvent.googleSignIn());
                },
                onClose: () => Navigator.of(context).pop(),
              ),
            );
          },
        );
      },
      child: Scaffold(
        body: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, state) {
            return state.when(
              initial: () => _buildSignInButton(context),
              loading: () => const Center(child: CircularProgressIndicator()),
              authenticated: (user) => const Center(child: Text('Success!')),
              unauthenticated: () => _buildSignInButton(context),
              error: (message) => _buildErrorState(context, message),
            );
          },
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return Center(
      child: FirebaseErrorWidget(
        failure: FirebaseGenericFailure(message),
        onRetry: () {
          context.read<AuthenticationBloc>()
              .add(const AuthenticationEvent.googleSignIn());
        },
        onClose: () {
          // Handle close action
        },
      ),
    );
  }
}
```

## 🔧 Error Types

### FirebaseAuthFailure
Handles authentication-related errors:
- `user-not-found`
- `wrong-password`
- `email-already-in-use`
- `network-request-failed`
- `popup-closed-by-user`
- And many more...

### FirebaseFirestoreFailure
Handles database-related errors:
- `permission-denied`
- `unauthenticated`
- `not-found`
- `resource-exhausted`
- `deadline-exceeded`
- And more...

### FirebaseRegionalFailure
Handles regional restrictions (like Iran):
- 403 Forbidden errors
- Network access restrictions
- Authentication service restrictions
- Firestore service restrictions

### FirebaseNetworkFailure
Handles network-related issues:
- Connection timeouts
- Network unreachable
- HTTP status codes (403, 404, 500, etc.)

### FirebaseGenericFailure
Handles unclassified Firebase errors.

## 🎨 Error Widgets

### FirebaseErrorWidget
A reusable widget for displaying Firebase errors with:
- User-friendly error messages
- Appropriate action buttons (retry, close, contact support)
- Technical details (optional, for debugging)
- Consistent styling

### FirebaseErrorSnackBar
A SnackBar widget for quick error notifications:
- Compact error display
- Retry action (if error is recoverable)
- Auto-dismiss after 4 seconds

### FirebaseErrorDialog
A dialog widget for important errors:
- Full error details
- Multiple action buttons
- Technical information for debugging

## 🌍 Localization

Error messages are localized in both English and Persian:

**English (app_en.arb):**
```json
{
  "errorFirebaseAuth": "Authentication failed. Please try again.",
  "errorFirebaseFirestore": "Database operation failed. Please try again.",
  "errorFirebaseNetwork": "Network connection failed. Please check your internet connection and try again.",
  "errorFirebaseRegional": "Firebase services are restricted in your region. Please try using a VPN or contact support.",
  "errorFirebaseGeneric": "An unexpected error occurred. Please try again.",
  "errorRetry": "Retry",
  "errorClose": "Close",
  "errorContactSupport": "Contact Support"
}
```

**Persian (app_fa.arb):**
```json
{
  "errorFirebaseAuth": "احراز هویت ناموفق بود. لطفاً دوباره تلاش کنید.",
  "errorFirebaseFirestore": "عملیات پایگاه داده ناموفق بود. لطفاً دوباره تلاش کنید.",
  "errorFirebaseNetwork": "اتصال شبکه ناموفق بود. لطفاً اتصال اینترنت خود را بررسی کرده و دوباره تلاش کنید.",
  "errorFirebaseRegional": "سرویس‌های Firebase در منطقه شما محدود شده‌اند. لطفاً از VPN استفاده کنید یا با پشتیبانی تماس بگیرید.",
  "errorFirebaseGeneric": "خطای غیرمنتظره‌ای رخ داد. لطفاً دوباره تلاش کنید.",
  "errorRetry": "تلاش مجدد",
  "errorClose": "بستن",
  "errorContactSupport": "تماس با پشتیبانی"
}
```

## 🔍 Error Properties

Each FirebaseFailure has these properties:

- `message`: Technical error message
- `userFriendlyMessage`: User-friendly error message
- `isRecoverable`: Whether the error can be retried
- `requiresUserAction`: Whether user intervention is needed
- `code`: Firebase error code
- `details`: Additional error details
- `originalError`: The original exception

## 🛠️ Integration Steps

1. **Update Data Sources**: Wrap Firebase operations with `FirebaseErrorHandler.wrapFirebaseOperation()`
2. **Update Repositories**: Convert exceptions to `FirebaseFailure` using `FirebaseErrorHandler.handleException()`
3. **Update BLoCs**: Handle different failure types appropriately
4. **Update UI**: Use Firebase error widgets for consistent error display
5. **Add Localization**: Ensure error messages are localized

## 🎯 Benefits

- **No More App Freezes**: Errors are properly caught and displayed
- **User-Friendly Messages**: Clear, actionable error messages
- **Regional Support**: Handles Iran's internet restrictions gracefully
- **Consistent UX**: Standardized error handling across the app
- **Debugging Support**: Technical details available when needed
- **Localization**: Error messages in user's preferred language

## 🚨 Common Error Scenarios

### Regional Restriction (Iran)
```
Error: 403 Forbidden
Message: "Your client does not have permission to get URL /v1/token from this server"
Solution: User-friendly message suggesting VPN usage
```

### Network Issues
```
Error: Network timeout or connection failure
Message: "Network connection failed"
Solution: Retry mechanism with exponential backoff
```

### Authentication Issues
```
Error: Firebase Auth exceptions
Message: User-friendly messages based on error code
Solution: Appropriate retry or user action guidance
```

### Firestore Issues
```
Error: Permission denied or quota exceeded
Message: Clear explanation of the issue
Solution: Contact support or retry later
```

This system ensures your app handles all Firebase errors gracefully, providing a better user experience even in challenging network environments like Iran. 