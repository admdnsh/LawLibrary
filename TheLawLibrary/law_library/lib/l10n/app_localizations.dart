import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ms.dart';

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
    Locale('ms')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Law Library'**
  String get appTitle;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @uiDensity.
  ///
  /// In en, this message translates to:
  /// **'UI Density'**
  String get uiDensity;

  /// No description provided for @fontSize.
  ///
  /// In en, this message translates to:
  /// **'Font Size'**
  String get fontSize;

  /// No description provided for @adjustSpacing.
  ///
  /// In en, this message translates to:
  /// **'Adjust spacing'**
  String get adjustSpacing;

  /// No description provided for @adjustFontSize.
  ///
  /// In en, this message translates to:
  /// **'Adjust text size'**
  String get adjustFontSize;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @data.
  ///
  /// In en, this message translates to:
  /// **'Data & Storage'**
  String get data;

  /// No description provided for @favorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favorites;

  /// No description provided for @clearFavorites.
  ///
  /// In en, this message translates to:
  /// **'Clear Favorites'**
  String get clearFavorites;

  /// No description provided for @removeSavedLaws.
  ///
  /// In en, this message translates to:
  /// **'Remove all saved laws'**
  String get removeSavedLaws;

  /// No description provided for @clearCache.
  ///
  /// In en, this message translates to:
  /// **'Clear Cache'**
  String get clearCache;

  /// No description provided for @removeTempData.
  ///
  /// In en, this message translates to:
  /// **'Remove temporary data'**
  String get removeTempData;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @confirmRemoveFavorites.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to remove all favorites?'**
  String get confirmRemoveFavorites;

  /// No description provided for @confirmClearCache.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to clear cached data?'**
  String get confirmClearCache;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @appVersion.
  ///
  /// In en, this message translates to:
  /// **'App Version'**
  String get appVersion;

  /// No description provided for @paymentInformation.
  ///
  /// In en, this message translates to:
  /// **'Payment Information'**
  String get paymentInformation;

  /// No description provided for @whereToPay.
  ///
  /// In en, this message translates to:
  /// **'Where to Make Your Payment'**
  String get whereToPay;

  /// No description provided for @paymentOptionsText.
  ///
  /// In en, this message translates to:
  /// **'To make your payment, you have two convenient options:'**
  String get paymentOptionsText;

  /// No description provided for @onlinePayment.
  ///
  /// In en, this message translates to:
  /// **'1. Online Payment'**
  String get onlinePayment;

  /// No description provided for @onlinePaymentDescription.
  ///
  /// In en, this message translates to:
  /// **'You can settle your fines or fees quickly and securely through our official online payment portal. This method is available 24/7, allowing you to pay from anywhere using a computer or mobile device.'**
  String get onlinePaymentDescription;

  /// No description provided for @inPersonPayment.
  ///
  /// In en, this message translates to:
  /// **'2. In-Person Payment at JSKLL Branches'**
  String get inPersonPayment;

  /// No description provided for @inPersonPaymentDescription.
  ///
  /// In en, this message translates to:
  /// **'If you prefer to make your payment in person, you may visit selected JSKLL branches located at specific locations. These branches are equipped to process payments during their regular operating hours.'**
  String get inPersonPaymentDescription;

  /// No description provided for @importantNote.
  ///
  /// In en, this message translates to:
  /// **'Important Note'**
  String get importantNote;

  /// No description provided for @importantNoteDescription.
  ///
  /// In en, this message translates to:
  /// **'Please ensure you bring the necessary documentation (e.g., offence notice, identification) when making payments at a branch.'**
  String get importantNoteDescription;

  /// No description provided for @onlinePaymentGuide.
  ///
  /// In en, this message translates to:
  /// **'Online Payment Guide'**
  String get onlinePaymentGuide;

  /// No description provided for @videoReference.
  ///
  /// In en, this message translates to:
  /// **'For more information about online payments, please refer to this video:'**
  String get videoReference;

  /// No description provided for @aboutLawLibrary.
  ///
  /// In en, this message translates to:
  /// **'About Law Library'**
  String get aboutLawLibrary;

  /// No description provided for @appVersionNumber.
  ///
  /// In en, this message translates to:
  /// **'Version 2.0'**
  String get appVersionNumber;

  /// No description provided for @aboutDescriptionTitle.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get aboutDescriptionTitle;

  /// No description provided for @aboutDescriptionBody.
  ///
  /// In en, this message translates to:
  /// **'Law Library is a comprehensive application designed to help users access, explore, and manage legal information efficiently. The app enables searching, categorizing, and bookmarking laws for quick reference. All legal content is sourced from the Road Traffic Act (2022) and Road Traffic Regulations (2022).'**
  String get aboutDescriptionBody;

  /// No description provided for @aboutFeaturesTitle.
  ///
  /// In en, this message translates to:
  /// **'Features'**
  String get aboutFeaturesTitle;

  /// No description provided for @featureSearch.
  ///
  /// In en, this message translates to:
  /// **'Search Laws'**
  String get featureSearch;

  /// No description provided for @featureCategories.
  ///
  /// In en, this message translates to:
  /// **'Category Filtering'**
  String get featureCategories;

  /// No description provided for @featureFavorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites Management'**
  String get featureFavorites;

  /// No description provided for @featureSettings.
  ///
  /// In en, this message translates to:
  /// **'Customizable Settings'**
  String get featureSettings;

  /// No description provided for @aboutCapstoneTitle.
  ///
  /// In en, this message translates to:
  /// **'Capstone Project'**
  String get aboutCapstoneTitle;

  /// No description provided for @aboutCapstoneBody.
  ///
  /// In en, this message translates to:
  /// **'This application is developed as a capstone project to fulfill the requirements of the Bachelor of Science (Hons) in Computing (Major in Software Development). The project is conducted in collaboration with the Traffic Control and Investigation Department (JSKLL), integrating theoretical knowledge and practical skills to address real-world challenges through applied research and innovation.'**
  String get aboutCapstoneBody;

  /// No description provided for @aboutCreditsTitle.
  ///
  /// In en, this message translates to:
  /// **'Credits'**
  String get aboutCreditsTitle;

  /// No description provided for @aboutCreditsBody.
  ///
  /// In en, this message translates to:
  /// **'Project by: Muhammad Adam Danish bin Shukri\n\nUTB Supervisors:\nDr. Wida Susanty Haji Suhaili\nAk. Dr Mohd Salihin Pg Haji Abdul Rahim\n\nHost Supervisors:\nASP Dk Husmawati Pg Hussin\nASP Pg Hjh Nafiah Pg Hj Asli'**
  String get aboutCreditsBody;

  /// No description provided for @homeTitle.
  ///
  /// In en, this message translates to:
  /// **'Law Library'**
  String get homeTitle;

  /// No description provided for @homeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Search, browse, and manage road offense acts'**
  String get homeSubtitle;

  /// No description provided for @searchFound.
  ///
  /// In en, this message translates to:
  /// **'Found {count} {count, plural, one{entry} other{entries}} for \"{query}\"'**
  String searchFound(num count, Object query);

  /// No description provided for @totalLaws.
  ///
  /// In en, this message translates to:
  /// **'Total Laws: {count}'**
  String totalLaws(Object count);

  /// No description provided for @welcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome!'**
  String get welcomeTitle;

  /// No description provided for @welcomeIntro.
  ///
  /// In en, this message translates to:
  /// **'Here\'s how to use the app:'**
  String get welcomeIntro;

  /// No description provided for @guideSearch.
  ///
  /// In en, this message translates to:
  /// **'• Use the search bar at the top to find laws.'**
  String get guideSearch;

  /// No description provided for @guideFilter.
  ///
  /// In en, this message translates to:
  /// **'• Filter by category below the search bar.'**
  String get guideFilter;

  /// No description provided for @guideTap.
  ///
  /// In en, this message translates to:
  /// **'• Tap a law to view details.'**
  String get guideTap;

  /// No description provided for @guideFavorite.
  ///
  /// In en, this message translates to:
  /// **'• Tap the star icon to add/remove favorites.'**
  String get guideFavorite;

  /// No description provided for @guideNav.
  ///
  /// In en, this message translates to:
  /// **'• Use the bottom navigation to switch screens.'**
  String get guideNav;

  /// No description provided for @guideAdmin.
  ///
  /// In en, this message translates to:
  /// **'• Admins can access the Admin Panel from top-right menu.'**
  String get guideAdmin;

  /// No description provided for @gotIt.
  ///
  /// In en, this message translates to:
  /// **'Got it!'**
  String get gotIt;

  /// No description provided for @logoutSuccess.
  ///
  /// In en, this message translates to:
  /// **'Logged out successfully'**
  String get logoutSuccess;

  /// No description provided for @tabFavorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get tabFavorites;

  /// No description provided for @tabPayment.
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get tabPayment;

  /// No description provided for @tabAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get tabAbout;

  /// No description provided for @tabSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get tabSettings;

  /// No description provided for @tabHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get tabHome;

  /// No description provided for @noFavoritesTitle.
  ///
  /// In en, this message translates to:
  /// **'No favorites yet'**
  String get noFavoritesTitle;

  /// No description provided for @noFavoritesDescription.
  ///
  /// In en, this message translates to:
  /// **'Add laws to your favorites to see them here'**
  String get noFavoritesDescription;

  /// No description provided for @searchFavoritesHint.
  ///
  /// In en, this message translates to:
  /// **'Search favorites...'**
  String get searchFavoritesHint;

  /// No description provided for @favoritesSearchResult.
  ///
  /// In en, this message translates to:
  /// **'Found {count} {count, plural, one{entry} other{entries}} for \"{query}\"'**
  String favoritesSearchResult(num count, Object query);

  /// No description provided for @noSearchResultsTitle.
  ///
  /// In en, this message translates to:
  /// **'No matches found'**
  String get noSearchResultsTitle;

  /// No description provided for @noSearchResultsDescription.
  ///
  /// In en, this message translates to:
  /// **'Try adjusting your search'**
  String get noSearchResultsDescription;

  /// No description provided for @lawChapterCategory.
  ///
  /// In en, this message translates to:
  /// **'Chapter {chapter} • {category}'**
  String lawChapterCategory(Object chapter, Object category);

  /// No description provided for @loginAppBarTitle.
  ///
  /// In en, this message translates to:
  /// **'Admin Login'**
  String get loginAppBarTitle;

  /// No description provided for @loginWelcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get loginWelcomeTitle;

  /// No description provided for @loginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to access admin features'**
  String get loginSubtitle;

  /// No description provided for @loginUsernameLabel.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get loginUsernameLabel;

  /// No description provided for @loginPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get loginPasswordLabel;

  /// No description provided for @loginButton.
  ///
  /// In en, this message translates to:
  /// **'LOGIN'**
  String get loginButton;

  /// No description provided for @loginErrorGeneric.
  ///
  /// In en, this message translates to:
  /// **'An error occurred. Please try again.'**
  String get loginErrorGeneric;

  /// No description provided for @loginUsernameRequired.
  ///
  /// In en, this message translates to:
  /// **'Username is required'**
  String get loginUsernameRequired;

  /// No description provided for @loginUsernameMinLength.
  ///
  /// In en, this message translates to:
  /// **'Username must be at least 3 characters'**
  String get loginUsernameMinLength;

  /// No description provided for @loginPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get loginPasswordRequired;

  /// No description provided for @loginPasswordMinLength.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get loginPasswordMinLength;

  /// No description provided for @lawChapterRequired.
  ///
  /// In en, this message translates to:
  /// **'Chapter is required'**
  String get lawChapterRequired;

  /// No description provided for @lawTitleRequired.
  ///
  /// In en, this message translates to:
  /// **'Title is required'**
  String get lawTitleRequired;

  /// No description provided for @lawCategoryRequired.
  ///
  /// In en, this message translates to:
  /// **'Category is required'**
  String get lawCategoryRequired;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search laws...'**
  String get searchHint;

  /// No description provided for @searchNoResults.
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get searchNoResults;

  /// No description provided for @searchNoResultsTitle.
  ///
  /// In en, this message translates to:
  /// **'No laws found'**
  String get searchNoResultsTitle;

  /// No description provided for @searchNoResultsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Try adjusting your search or filter criteria'**
  String get searchNoResultsSubtitle;

  /// No description provided for @paginationPrevious.
  ///
  /// In en, this message translates to:
  /// **'Previous page'**
  String get paginationPrevious;

  /// No description provided for @paginationNext.
  ///
  /// In en, this message translates to:
  /// **'Next page'**
  String get paginationNext;

  /// No description provided for @searchError.
  ///
  /// In en, this message translates to:
  /// **'Error: {errorMessage}'**
  String searchError(Object errorMessage);
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'ms'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'ms': return AppLocalizationsMs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
