import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fa.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fa')
  ];

  /// No description provided for @signInWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Google'**
  String get signInWithGoogle;

  /// No description provided for @learnEnglishTitle.
  ///
  /// In en, this message translates to:
  /// **'Learn English'**
  String get learnEnglishTitle;

  /// No description provided for @loginWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Login with Google'**
  String get loginWithGoogle;

  /// No description provided for @termsAndConditions.
  ///
  /// In en, this message translates to:
  /// **'By logging in, you agree to our Terms & Conditions'**
  String get termsAndConditions;

  /// No description provided for @levelSelectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Select Your English Level'**
  String get levelSelectionTitle;

  /// No description provided for @levelBeginner.
  ///
  /// In en, this message translates to:
  /// **'Beginner'**
  String get levelBeginner;

  /// No description provided for @levelBeginnerDesc.
  ///
  /// In en, this message translates to:
  /// **'For those with little to no English knowledge.'**
  String get levelBeginnerDesc;

  /// No description provided for @levelElementary.
  ///
  /// In en, this message translates to:
  /// **'Elementary'**
  String get levelElementary;

  /// No description provided for @levelElementaryDesc.
  ///
  /// In en, this message translates to:
  /// **'Can understand basic phrases and simple sentences.'**
  String get levelElementaryDesc;

  /// No description provided for @levelIntermediate.
  ///
  /// In en, this message translates to:
  /// **'Intermediate'**
  String get levelIntermediate;

  /// No description provided for @levelIntermediateDesc.
  ///
  /// In en, this message translates to:
  /// **'Can communicate in familiar situations and understand main ideas.'**
  String get levelIntermediateDesc;

  /// No description provided for @levelAdvanced.
  ///
  /// In en, this message translates to:
  /// **'Advanced'**
  String get levelAdvanced;

  /// No description provided for @levelAdvancedDesc.
  ///
  /// In en, this message translates to:
  /// **'Can express ideas fluently and understand complex texts.'**
  String get levelAdvancedDesc;

  /// No description provided for @continue_.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continue_;

  /// No description provided for @learningFocusTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose Your Learning Focus'**
  String get learningFocusTitle;

  /// No description provided for @learningFocusBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get learningFocusBack;

  /// No description provided for @learningFocusBusiness.
  ///
  /// In en, this message translates to:
  /// **'Business English'**
  String get learningFocusBusiness;

  /// No description provided for @learningFocusTravel.
  ///
  /// In en, this message translates to:
  /// **'Travel English'**
  String get learningFocusTravel;

  /// No description provided for @learningFocusSocial.
  ///
  /// In en, this message translates to:
  /// **'Social English'**
  String get learningFocusSocial;

  /// No description provided for @learningFocusHome.
  ///
  /// In en, this message translates to:
  /// **'Home English'**
  String get learningFocusHome;

  /// No description provided for @learningFocusAcademic.
  ///
  /// In en, this message translates to:
  /// **'Academic English'**
  String get learningFocusAcademic;

  /// No description provided for @learningFocusMovie.
  ///
  /// In en, this message translates to:
  /// **'Movie English'**
  String get learningFocusMovie;

  /// No description provided for @learningFocusMusic.
  ///
  /// In en, this message translates to:
  /// **'Music English'**
  String get learningFocusMusic;

  /// No description provided for @learningFocusTV.
  ///
  /// In en, this message translates to:
  /// **'TV English'**
  String get learningFocusTV;

  /// No description provided for @learningFocusShopping.
  ///
  /// In en, this message translates to:
  /// **'Shopping English'**
  String get learningFocusShopping;

  /// No description provided for @learningFocusRestaurant.
  ///
  /// In en, this message translates to:
  /// **'Restaurant English'**
  String get learningFocusRestaurant;

  /// No description provided for @learningFocusHealth.
  ///
  /// In en, this message translates to:
  /// **'Health English'**
  String get learningFocusHealth;

  /// No description provided for @learningFocusEveryday.
  ///
  /// In en, this message translates to:
  /// **'Everyday English'**
  String get learningFocusEveryday;

  /// No description provided for @learningFocusCustomHint.
  ///
  /// In en, this message translates to:
  /// **'Or write your own learning focus...'**
  String get learningFocusCustomHint;

  /// No description provided for @learningFocusCustomLabel.
  ///
  /// In en, this message translates to:
  /// **'Custom Learning Focus'**
  String get learningFocusCustomLabel;

  /// No description provided for @learningFocusSavedSnack.
  ///
  /// In en, this message translates to:
  /// **'Selection saved! Navigating...'**
  String get learningFocusSavedSnack;

  /// No description provided for @focusAreasSelection.
  ///
  /// In en, this message translates to:
  /// **'Focus Areas'**
  String get focusAreasSelection;

  /// Title for the daily lessons page.
  ///
  /// In en, this message translates to:
  /// **'Your Daily Lessons'**
  String get yourDailyLessons;

  /// Section header for vocabularies.
  ///
  /// In en, this message translates to:
  /// **'Vocabularies'**
  String get vocabularies;

  /// Section header for phrases.
  ///
  /// In en, this message translates to:
  /// **'Phrases'**
  String get phrases;

  /// No description provided for @nextLessons.
  ///
  /// In en, this message translates to:
  /// **'Next Lessons'**
  String get nextLessons;

  /// Generic authentication error message.
  ///
  /// In en, this message translates to:
  /// **'Authentication failed. Please try again.'**
  String get errorAuth;

  /// Generic database error message.
  ///
  /// In en, this message translates to:
  /// **'Database operation failed. Please try again.'**
  String get errorDatabase;

  /// Network error message.
  ///
  /// In en, this message translates to:
  /// **'Network connection failed. Please check your internet connection and try again.'**
  String get errorNetwork;

  /// Generic error message.
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred. Please try again.'**
  String get errorGeneric;

  /// Button text for retrying failed operations.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get errorRetry;

  /// Button text for closing error dialogs.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get errorClose;

  /// Button text for contacting support.
  ///
  /// In en, this message translates to:
  /// **'Contact Support'**
  String get errorContactSupport;

  /// Label for level selection in navigation.
  ///
  /// In en, this message translates to:
  /// **'Level'**
  String get levelSelection;

  /// Title for the profile page.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// Label for profile image section.
  ///
  /// In en, this message translates to:
  /// **'Profile Image'**
  String get profileImage;

  /// Button text for changing profile photo.
  ///
  /// In en, this message translates to:
  /// **'Change Photo'**
  String get changePhoto;

  /// Option to take a new photo.
  ///
  /// In en, this message translates to:
  /// **'Take Photo'**
  String get takePhoto;

  /// Option to choose photo from gallery.
  ///
  /// In en, this message translates to:
  /// **'Choose from Gallery'**
  String get chooseFromGallery;

  /// Button text for canceling an action.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Section header for personal information.
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get personalInformation;

  /// Label for full name input field.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// Label for email input field.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// Label for phone number input field.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// Label for date of birth field.
  ///
  /// In en, this message translates to:
  /// **'Date of Birth'**
  String get dateOfBirth;

  /// Section header for app settings.
  ///
  /// In en, this message translates to:
  /// **'App Settings'**
  String get appSettings;

  /// Label for language setting.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// English language option.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// Persian language option.
  ///
  /// In en, this message translates to:
  /// **'Persian'**
  String get persian;

  /// Button text for saving profile changes.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// Success message when changes are saved.
  ///
  /// In en, this message translates to:
  /// **'Changes saved successfully!'**
  String get changesSaved;

  /// Error message when saving changes fails.
  ///
  /// In en, this message translates to:
  /// **'Error saving changes. Please try again.'**
  String get errorSavingChanges;

  /// Loading message when fetching profile data.
  ///
  /// In en, this message translates to:
  /// **'Loading profile...'**
  String get loadingProfile;

  /// Title for the vocabulary history page.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// Section header for history requests.
  ///
  /// In en, this message translates to:
  /// **'History Requests'**
  String get historyRequests;

  /// Title for the request details page.
  ///
  /// In en, this message translates to:
  /// **'Request Details'**
  String get requestDetails;

  /// Message shown when no history data is available.
  ///
  /// In en, this message translates to:
  /// **'No history found'**
  String get noHistoryFound;

  /// Text showing number of items generated in a request.
  ///
  /// In en, this message translates to:
  /// **'items generated'**
  String get itemsGenerated;

  /// Section header for vocabulary items.
  ///
  /// In en, this message translates to:
  /// **'Vocabulary Items'**
  String get vocabularyItems;

  /// Section header for phrase items.
  ///
  /// In en, this message translates to:
  /// **'Phrase Items'**
  String get phraseItems;

  /// Button text for clearing history.
  ///
  /// In en, this message translates to:
  /// **'Clear History'**
  String get clearHistory;

  /// Success message when history is cleared.
  ///
  /// In en, this message translates to:
  /// **'History cleared successfully'**
  String get historyCleared;

  /// Error message when loading history fails.
  ///
  /// In en, this message translates to:
  /// **'Error loading history'**
  String get errorLoadingHistory;

  /// Text for today in date formatting.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// Text for yesterday in date formatting.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// Text for days ago in date formatting.
  ///
  /// In en, this message translates to:
  /// **'{count} days ago'**
  String daysAgo(int count);

  /// Text for 'at' in time formatting.
  ///
  /// In en, this message translates to:
  /// **'at'**
  String get at;

  /// Text for general learning focus area.
  ///
  /// In en, this message translates to:
  /// **'General Learning'**
  String get generalLearning;

  /// Short text for beginner level.
  ///
  /// In en, this message translates to:
  /// **'Beginner'**
  String get levelBeginnerShort;

  /// Short text for elementary level.
  ///
  /// In en, this message translates to:
  /// **'Elementary'**
  String get levelElementaryShort;

  /// Short text for intermediate level.
  ///
  /// In en, this message translates to:
  /// **'Intermediate'**
  String get levelIntermediateShort;

  /// Short text for advanced level.
  ///
  /// In en, this message translates to:
  /// **'Advanced'**
  String get levelAdvancedShort;

  /// Label for theme setting.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// Gold theme option.
  ///
  /// In en, this message translates to:
  /// **'Gold Theme'**
  String get goldTheme;

  /// Blue theme option.
  ///
  /// In en, this message translates to:
  /// **'Blue Theme'**
  String get blueTheme;

  /// Yellow light theme option.
  ///
  /// In en, this message translates to:
  /// **'Yellow Light Theme'**
  String get yellowLightTheme;

  /// Light blue theme option.
  ///
  /// In en, this message translates to:
  /// **'Light Blue Theme'**
  String get lightBlueTheme;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'fa'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'fa': return AppLocalizationsFa();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
