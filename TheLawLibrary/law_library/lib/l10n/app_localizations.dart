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
  /// **'Project by: Muhammad Adam Danish bin Shukri\n\nUTB Supervisors:\nDr. Wida Susanty Haji Suhaili\nAk. Dr Mohd Salihin Pg Haji Abdul Rahim\n\nHost Supervisors:\nASP Pg Hjh Nafiah Pg Hj Asli'**
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

  /// No description provided for @recentSearches.
  ///
  /// In en, this message translates to:
  /// **'Recent'**
  String get recentSearches;

  /// No description provided for @clearSearches.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clearSearches;

  /// No description provided for @noResultsFound.
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get noResultsFound;

  /// No description provided for @noResultsHint.
  ///
  /// In en, this message translates to:
  /// **'Try searching by offence title, chapter number, or category.'**
  String get noResultsHint;

  /// No description provided for @noResultsTryLabel.
  ///
  /// In en, this message translates to:
  /// **'Try searching for:'**
  String get noResultsTryLabel;

  /// No description provided for @compoundFines.
  ///
  /// In en, this message translates to:
  /// **'COMPOUND FINES'**
  String get compoundFines;

  /// No description provided for @tabDashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get tabDashboard;

  /// No description provided for @dashboardLawsByCategory.
  ///
  /// In en, this message translates to:
  /// **'Laws by Category'**
  String get dashboardLawsByCategory;

  /// No description provided for @dashboardRecentSearches.
  ///
  /// In en, this message translates to:
  /// **'Recent Searches'**
  String get dashboardRecentSearches;

  /// No description provided for @dashboardError.
  ///
  /// In en, this message translates to:
  /// **'Could not load dashboard'**
  String get dashboardError;

  /// No description provided for @dashboardErrorHint.
  ///
  /// In en, this message translates to:
  /// **'Check your connection and try again.'**
  String get dashboardErrorHint;

  /// No description provided for @dashboardRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get dashboardRetry;

  /// No description provided for @dashboardTotalLaws.
  ///
  /// In en, this message translates to:
  /// **'Total Laws'**
  String get dashboardTotalLaws;

  /// No description provided for @dashboardTotalLawsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Road offences in database'**
  String get dashboardTotalLawsSubtitle;

  /// No description provided for @splashSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Road Offences Reference'**
  String get splashSubtitle;

  /// No description provided for @onboardingSlide1Title.
  ///
  /// In en, this message translates to:
  /// **'Find offences instantly'**
  String get onboardingSlide1Title;

  /// No description provided for @onboardingSlide1Desc.
  ///
  /// In en, this message translates to:
  /// **'Search by keyword, chapter number, or category to pull up the exact road offence you need — even under pressure at a roadblock.'**
  String get onboardingSlide1Desc;

  /// No description provided for @onboardingSlide2Title.
  ///
  /// In en, this message translates to:
  /// **'Save your most used laws'**
  String get onboardingSlide2Title;

  /// No description provided for @onboardingSlide2Desc.
  ///
  /// In en, this message translates to:
  /// **'Swipe any result to favourite it. Your saved offences are always one tap away, even without an internet connection.'**
  String get onboardingSlide2Desc;

  /// No description provided for @onboardingSlide3Title.
  ///
  /// In en, this message translates to:
  /// **'Ready to go'**
  String get onboardingSlide3Title;

  /// No description provided for @onboardingSlide3Desc.
  ///
  /// In en, this message translates to:
  /// **'Everything you need is right here. Stay efficient, stay informed, and let the app do the looking up.'**
  String get onboardingSlide3Desc;

  /// No description provided for @onboardingSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get onboardingSkip;

  /// No description provided for @onboardingGetStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get onboardingGetStarted;

  /// No description provided for @onboardingNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get onboardingNext;

  /// No description provided for @dashboardNoSearches.
  ///
  /// In en, this message translates to:
  /// **'No searches yet — start searching to see history here'**
  String get dashboardNoSearches;

  /// No description provided for @dashboardNoCategoryData.
  ///
  /// In en, this message translates to:
  /// **'No category data available'**
  String get dashboardNoCategoryData;

  /// No description provided for @lawDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Law Details'**
  String get lawDetailsTitle;

  /// No description provided for @confirmDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Confirm Delete'**
  String get confirmDeleteTitle;

  /// No description provided for @confirmDeleteMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete Chapter {chapter}?'**
  String confirmDeleteMessage(Object chapter);

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @lawOffence1.
  ///
  /// In en, this message translates to:
  /// **'1st Offence'**
  String get lawOffence1;

  /// No description provided for @lawOffence2.
  ///
  /// In en, this message translates to:
  /// **'2nd Offence'**
  String get lawOffence2;

  /// No description provided for @lawOffence3.
  ///
  /// In en, this message translates to:
  /// **'3rd Offence'**
  String get lawOffence3;

  /// No description provided for @lawOffence4.
  ///
  /// In en, this message translates to:
  /// **'4th Offence'**
  String get lawOffence4;

  /// No description provided for @lawOffence5.
  ///
  /// In en, this message translates to:
  /// **'5th Offence'**
  String get lawOffence5;

  /// No description provided for @searchFoundPage.
  ///
  /// In en, this message translates to:
  /// **'Page {page} · {count} {count, plural, one{result} other{results}} for \"{query}\"'**
  String searchFoundPage(Object page, num count, Object query);

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @copiedToClipboard.
  ///
  /// In en, this message translates to:
  /// **'Copied to clipboard'**
  String get copiedToClipboard;

  /// No description provided for @videoUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Video unavailable'**
  String get videoUnavailable;

  /// No description provided for @themeModeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeModeLight;

  /// No description provided for @themeModeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeModeSystem;

  /// No description provided for @themeModeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeModeDark;

  /// No description provided for @clearRecentSearches.
  ///
  /// In en, this message translates to:
  /// **'Clear Recent Searches'**
  String get clearRecentSearches;

  /// No description provided for @removeSearchHistory.
  ///
  /// In en, this message translates to:
  /// **'Remove recent search history'**
  String get removeSearchHistory;

  /// No description provided for @confirmClearSearches.
  ///
  /// In en, this message translates to:
  /// **'Remove all saved search history?'**
  String get confirmClearSearches;

  /// No description provided for @searchesCleared.
  ///
  /// In en, this message translates to:
  /// **'Recent searches cleared'**
  String get searchesCleared;

  /// No description provided for @favoritesCleared.
  ///
  /// In en, this message translates to:
  /// **'Favorites cleared'**
  String get favoritesCleared;

  /// No description provided for @savedLawsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{{count} saved law} other{{count} saved laws}}'**
  String savedLawsCount(num count);

  /// No description provided for @sortByTitle.
  ///
  /// In en, this message translates to:
  /// **'Sort by Title'**
  String get sortByTitle;

  /// No description provided for @sortByCategory.
  ///
  /// In en, this message translates to:
  /// **'Sort by Category'**
  String get sortByCategory;

  /// No description provided for @sortByChapter.
  ///
  /// In en, this message translates to:
  /// **'Sort by Chapter'**
  String get sortByChapter;

  /// No description provided for @sortTitle.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get sortTitle;

  /// No description provided for @sortCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get sortCategory;

  /// No description provided for @sortChapter.
  ///
  /// In en, this message translates to:
  /// **'Chapter'**
  String get sortChapter;

  /// No description provided for @adminPanelTitle.
  ///
  /// In en, this message translates to:
  /// **'Admin Panel'**
  String get adminPanelTitle;

  /// No description provided for @adminCategories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get adminCategories;

  /// No description provided for @adminThisPage.
  ///
  /// In en, this message translates to:
  /// **'This Page'**
  String get adminThisPage;

  /// No description provided for @adminFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get adminFilterAll;

  /// No description provided for @adminFilteringBy.
  ///
  /// In en, this message translates to:
  /// **'Filtering by: {category}'**
  String adminFilteringBy(Object category);

  /// No description provided for @adminDeleteLawTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Law'**
  String get adminDeleteLawTitle;

  /// No description provided for @adminDeleteLawMessage.
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone.'**
  String get adminDeleteLawMessage;

  /// No description provided for @adminAddLaw.
  ///
  /// In en, this message translates to:
  /// **'Add Law'**
  String get adminAddLaw;

  /// No description provided for @adminLawDeleted.
  ///
  /// In en, this message translates to:
  /// **'Law deleted successfully'**
  String get adminLawDeleted;

  /// No description provided for @adminNoLawsInCategory.
  ///
  /// In en, this message translates to:
  /// **'No laws in \"{category}\" category'**
  String adminNoLawsInCategory(Object category);

  /// No description provided for @adminNoLawsHint.
  ///
  /// In en, this message translates to:
  /// **'Try adjusting your search or add a new law.'**
  String get adminNoLawsHint;

  /// No description provided for @adminPage.
  ///
  /// In en, this message translates to:
  /// **'Page {page}'**
  String adminPage(Object page);

  /// No description provided for @adminPageLast.
  ///
  /// In en, this message translates to:
  /// **'· Last'**
  String get adminPageLast;
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
