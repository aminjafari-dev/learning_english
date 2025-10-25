// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get signInWithGoogle => 'Sign in with Google';

  @override
  String get learnEnglishTitle => 'Learn English';

  @override
  String get loginWithGoogle => 'Login with Google';

  @override
  String get termsAndConditions => 'By logging in, you agree to our Terms & Conditions';

  @override
  String get levelSelectionTitle => 'Select Your English Level';

  @override
  String get levelBeginner => 'Beginner';

  @override
  String get levelBeginnerDesc => 'For those with little to no English knowledge.';

  @override
  String get levelElementary => 'Elementary';

  @override
  String get levelElementaryDesc => 'Can understand basic phrases and simple sentences.';

  @override
  String get levelIntermediate => 'Intermediate';

  @override
  String get levelIntermediateDesc => 'Can communicate in familiar situations and understand main ideas.';

  @override
  String get levelAdvanced => 'Advanced';

  @override
  String get levelAdvancedDesc => 'Can express ideas fluently and understand complex texts.';

  @override
  String get continue_ => 'Continue';

  @override
  String get learningFocusTitle => 'Choose Your Learning Focus';

  @override
  String get learningFocusBack => 'Back';

  @override
  String get learningFocusBusiness => 'Business English';

  @override
  String get learningFocusTravel => 'Travel English';

  @override
  String get learningFocusSocial => 'Social English';

  @override
  String get learningFocusHome => 'Home English';

  @override
  String get learningFocusAcademic => 'Academic English';

  @override
  String get learningFocusMovie => 'Movie English';

  @override
  String get learningFocusMusic => 'Music English';

  @override
  String get learningFocusTV => 'TV English';

  @override
  String get learningFocusShopping => 'Shopping English';

  @override
  String get learningFocusRestaurant => 'Restaurant English';

  @override
  String get learningFocusHealth => 'Health English';

  @override
  String get learningFocusEveryday => 'Everyday English';

  @override
  String get learningFocusCustomHint => 'Or write your own learning focus...';

  @override
  String get learningFocusCustomLabel => 'Custom Learning Focus';

  @override
  String get learningFocusSavedSnack => 'Selection saved! Navigating...';

  @override
  String get focusAreasSelection => 'Focus Areas';

  @override
  String get yourDailyLessons => 'Your Daily Lessons';

  @override
  String get vocabularies => 'Vocabularies';

  @override
  String get phrases => 'Phrases';

  @override
  String get nextLessons => 'Next Lessons';

  @override
  String get errorAuth => 'Authentication failed. Please try again.';

  @override
  String get errorDatabase => 'Database operation failed. Please try again.';

  @override
  String get errorNetwork => 'Network connection failed. Please check your internet connection and try again.';

  @override
  String get errorGeneric => 'An unexpected error occurred. Please try again.';

  @override
  String get errorRetry => 'Retry';

  @override
  String get errorClose => 'Close';

  @override
  String get errorContactSupport => 'Contact Support';

  @override
  String get levelSelection => 'Level';

  @override
  String get profileTitle => 'Profile';

  @override
  String get profileImage => 'Profile Image';

  @override
  String get changePhoto => 'Change Photo';

  @override
  String get takePhoto => 'Take Photo';

  @override
  String get chooseFromGallery => 'Choose from Gallery';

  @override
  String get cancel => 'Cancel';

  @override
  String get personalInformation => 'Personal Information';

  @override
  String get fullName => 'Full Name';

  @override
  String get email => 'Email';

  @override
  String get phoneNumber => 'Phone Number';

  @override
  String get dateOfBirth => 'Date of Birth';

  @override
  String get appSettings => 'App Settings';

  @override
  String get language => 'Language';

  @override
  String get english => 'English';

  @override
  String get persian => 'Persian';

  @override
  String get saveChanges => 'Save Changes';

  @override
  String get changesSaved => 'Changes saved successfully!';

  @override
  String get errorSavingChanges => 'Error saving changes. Please try again.';

  @override
  String get loadingProfile => 'Loading profile...';

  @override
  String get history => 'History';

  @override
  String get historyRequests => 'History Requests';

  @override
  String get requestDetails => 'Request Details';

  @override
  String get noHistoryFound => 'No history found';

  @override
  String get itemsGenerated => 'items generated';

  @override
  String get vocabularyItems => 'Vocabulary Items';

  @override
  String get phraseItems => 'Phrase Items';

  @override
  String get clearHistory => 'Clear History';

  @override
  String get historyCleared => 'History cleared successfully';

  @override
  String get errorLoadingHistory => 'Error loading history';

  @override
  String get today => 'Today';

  @override
  String get yesterday => 'Yesterday';

  @override
  String daysAgo(int count) {
    return '$count days ago';
  }

  @override
  String get at => 'at';

  @override
  String get generalLearning => 'General Learning';

  @override
  String get levelBeginnerShort => 'Beginner';

  @override
  String get levelElementaryShort => 'Elementary';

  @override
  String get levelIntermediateShort => 'Intermediate';

  @override
  String get levelAdvancedShort => 'Advanced';

  @override
  String get theme => 'Theme';

  @override
  String get goldTheme => 'Gold Theme';

  @override
  String get blueTheme => 'Blue Theme';

  @override
  String get yellowLightTheme => 'Yellow Light Theme';

  @override
  String get lightBlueTheme => 'Light Blue Theme';

  @override
  String get learningPaths => 'Learning Paths';

  @override
  String get addLearningPath => 'Add Learning Path';

  @override
  String get addLearningPathDescription => 'Choose a focus area to begin your structured learning journey';

  @override
  String get startLearning => 'Start Learning';

  @override
  String get selectSubCategory => 'Select Sub-Category';

  @override
  String get continueText => 'Continue';

  @override
  String get courseProgress => 'Course Progress';

  @override
  String get courseCompleted => 'Course Completed';

  @override
  String courseN(int number) {
    return 'Course $number';
  }

  @override
  String get progress => 'Progress';

  @override
  String get deleteLearningPath => 'Delete Learning Path';

  @override
  String get deleteLearningPathMessage => 'Are you sure you want to delete your current learning path? This action cannot be undone.';

  @override
  String get delete => 'Delete';

  @override
  String get retry => 'Retry';
}
