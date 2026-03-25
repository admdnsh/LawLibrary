// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Law Library';

  @override
  String get settings => 'Settings';

  @override
  String get appearance => 'Appearance';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get uiDensity => 'UI Density';

  @override
  String get fontSize => 'Font Size';

  @override
  String get adjustSpacing => 'Adjust spacing';

  @override
  String get adjustFontSize => 'Adjust text size';

  @override
  String get language => 'Language';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get data => 'Data & Storage';

  @override
  String get favorites => 'Favorites';

  @override
  String get clearFavorites => 'Clear Favorites';

  @override
  String get removeSavedLaws => 'Remove all saved laws';

  @override
  String get clearCache => 'Clear Cache';

  @override
  String get removeTempData => 'Remove temporary data';

  @override
  String get confirm => 'Confirm';

  @override
  String get cancel => 'Cancel';

  @override
  String get confirmRemoveFavorites => 'Are you sure you want to remove all favorites?';

  @override
  String get confirmClearCache => 'Are you sure you want to clear cached data?';

  @override
  String get about => 'About';

  @override
  String get appVersion => 'App Version';

  @override
  String get paymentInformation => 'Payment Information';

  @override
  String get whereToPay => 'Where to Make Your Payment';

  @override
  String get paymentOptionsText => 'To make your payment, you have two convenient options:';

  @override
  String get onlinePayment => '1. Online Payment';

  @override
  String get onlinePaymentDescription => 'You can settle your fines or fees quickly and securely through our official online payment portal. This method is available 24/7, allowing you to pay from anywhere using a computer or mobile device.';

  @override
  String get inPersonPayment => '2. In-Person Payment at JSKLL Branches';

  @override
  String get inPersonPaymentDescription => 'If you prefer to make your payment in person, you may visit selected JSKLL branches located at specific locations. These branches are equipped to process payments during their regular operating hours.';

  @override
  String get importantNote => 'Important Note';

  @override
  String get importantNoteDescription => 'Please ensure you bring the necessary documentation (e.g., offence notice, identification) when making payments at a branch.';

  @override
  String get onlinePaymentGuide => 'Online Payment Guide';

  @override
  String get videoReference => 'For more information about online payments, please refer to this video:';

  @override
  String get aboutLawLibrary => 'About Law Library';

  @override
  String get appVersionNumber => 'Version 2.0';

  @override
  String get aboutDescriptionTitle => 'Description';

  @override
  String get aboutDescriptionBody => 'Law Library is a comprehensive application designed to help users access, explore, and manage legal information efficiently. The app enables searching, categorizing, and bookmarking laws for quick reference. All legal content is sourced from the Road Traffic Act (2022) and Road Traffic Regulations (2022).';

  @override
  String get aboutFeaturesTitle => 'Features';

  @override
  String get featureSearch => 'Search Laws';

  @override
  String get featureCategories => 'Category Filtering';

  @override
  String get featureFavorites => 'Favorites Management';

  @override
  String get featureSettings => 'Customizable Settings';

  @override
  String get aboutCapstoneTitle => 'Capstone Project';

  @override
  String get aboutCapstoneBody => 'This application is developed as a capstone project to fulfill the requirements of the Bachelor of Science (Hons) in Computing (Major in Software Development). The project is conducted in collaboration with the Traffic Control and Investigation Department (JSKLL), integrating theoretical knowledge and practical skills to address real-world challenges through applied research and innovation.';

  @override
  String get aboutCreditsTitle => 'Credits';

  @override
  String get aboutCreditsBody => 'Project by: Muhammad Adam Danish bin Shukri\n\nUTB Supervisors:\nDr. Wida Susanty Haji Suhaili\nAk. Dr Mohd Salihin Pg Haji Abdul Rahim\n\nHost Supervisors:\nASP Pg Hjh Nafiah Pg Hj Asli';

  @override
  String get homeTitle => 'Law Library';

  @override
  String get homeSubtitle => 'Search, browse, and manage road offense acts';

  @override
  String searchFound(num count, Object query) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'entries',
      one: 'entry',
    );
    return 'Found $count $_temp0 for \"$query\"';
  }

  @override
  String totalLaws(Object count) {
    return 'Total Laws: $count';
  }

  @override
  String get welcomeTitle => 'Welcome!';

  @override
  String get welcomeIntro => 'Here\'s how to use the app:';

  @override
  String get guideSearch => '• Use the search bar at the top to find laws.';

  @override
  String get guideFilter => '• Filter by category below the search bar.';

  @override
  String get guideTap => '• Tap a law to view details.';

  @override
  String get guideFavorite => '• Tap the star icon to add/remove favorites.';

  @override
  String get guideNav => '• Use the bottom navigation to switch screens.';

  @override
  String get guideAdmin => '• Admins can access the Admin Panel from top-right menu.';

  @override
  String get gotIt => 'Got it!';

  @override
  String get logoutSuccess => 'Logged out successfully';

  @override
  String get tabFavorites => 'Favorites';

  @override
  String get tabPayment => 'Payment';

  @override
  String get tabAbout => 'About';

  @override
  String get tabSettings => 'Settings';

  @override
  String get tabHome => 'Home';

  @override
  String get noFavoritesTitle => 'No favorites yet';

  @override
  String get noFavoritesDescription => 'Add laws to your favorites to see them here';

  @override
  String get searchFavoritesHint => 'Search favorites...';

  @override
  String favoritesSearchResult(num count, Object query) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'entries',
      one: 'entry',
    );
    return 'Found $count $_temp0 for \"$query\"';
  }

  @override
  String get noSearchResultsTitle => 'No matches found';

  @override
  String get noSearchResultsDescription => 'Try adjusting your search';

  @override
  String lawChapterCategory(Object chapter, Object category) {
    return 'Chapter $chapter • $category';
  }

  @override
  String get loginAppBarTitle => 'Admin Login';

  @override
  String get loginWelcomeTitle => 'Welcome Back';

  @override
  String get loginSubtitle => 'Sign in to access admin features';

  @override
  String get loginUsernameLabel => 'Username';

  @override
  String get loginPasswordLabel => 'Password';

  @override
  String get loginButton => 'LOGIN';

  @override
  String get loginErrorGeneric => 'An error occurred. Please try again.';

  @override
  String get loginUsernameRequired => 'Username is required';

  @override
  String get loginUsernameMinLength => 'Username must be at least 3 characters';

  @override
  String get loginPasswordRequired => 'Password is required';

  @override
  String get loginPasswordMinLength => 'Password must be at least 6 characters';

  @override
  String get lawChapterRequired => 'Chapter is required';

  @override
  String get lawTitleRequired => 'Title is required';

  @override
  String get lawCategoryRequired => 'Category is required';

  @override
  String get searchHint => 'Search laws...';

  @override
  String get searchNoResults => 'No results found';

  @override
  String get searchNoResultsTitle => 'No laws found';

  @override
  String get searchNoResultsSubtitle => 'Try adjusting your search or filter criteria';

  @override
  String get paginationPrevious => 'Previous page';

  @override
  String get paginationNext => 'Next page';

  @override
  String searchError(Object errorMessage) {
    return 'Error: $errorMessage';
  }

  @override
  String get recentSearches => 'Recent';

  @override
  String get clearSearches => 'Clear';

  @override
  String get noResultsFound => 'No results found';

  @override
  String get noResultsHint => 'Try searching by offence title, chapter number, or category.';

  @override
  String get noResultsTryLabel => 'Try searching for:';

  @override
  String get compoundFines => 'COMPOUND FINES';

  @override
  String get tabDashboard => 'Dashboard';

  @override
  String get dashboardLawsByCategory => 'Laws by Category';

  @override
  String get dashboardRecentSearches => 'Recent Searches';

  @override
  String get dashboardError => 'Could not load dashboard';

  @override
  String get dashboardErrorHint => 'Check your connection and try again.';

  @override
  String get dashboardRetry => 'Retry';

  @override
  String get dashboardTotalLaws => 'Total Laws';

  @override
  String get dashboardTotalLawsSubtitle => 'Road offences in database';

  @override
  String get splashSubtitle => 'Road Offences Reference';

  @override
  String get onboardingSlide1Title => 'Find offences instantly';

  @override
  String get onboardingSlide1Desc => 'Search by keyword, chapter number, or category to pull up the exact road offence you need — even under pressure at a roadblock.';

  @override
  String get onboardingSlide2Title => 'Save your most used laws';

  @override
  String get onboardingSlide2Desc => 'Swipe any result to favourite it. Your saved offences are always one tap away, even without an internet connection.';

  @override
  String get onboardingSlide3Title => 'Ready to go';

  @override
  String get onboardingSlide3Desc => 'Everything you need is right here. Stay efficient, stay informed, and let the app do the looking up.';

  @override
  String get onboardingSkip => 'Skip';

  @override
  String get onboardingGetStarted => 'Get Started';

  @override
  String get onboardingNext => 'Next';

  @override
  String get dashboardNoSearches => 'No searches yet — start searching to see history here';

  @override
  String get dashboardNoCategoryData => 'No category data available';

  @override
  String get lawDetailsTitle => 'Law Details';

  @override
  String get confirmDeleteTitle => 'Confirm Delete';

  @override
  String confirmDeleteMessage(Object chapter) {
    return 'Are you sure you want to delete Chapter $chapter?';
  }

  @override
  String get delete => 'Delete';

  @override
  String get lawOffence1 => '1st Offence';

  @override
  String get lawOffence2 => '2nd Offence';

  @override
  String get lawOffence3 => '3rd Offence';

  @override
  String get lawOffence4 => '4th Offence';

  @override
  String get lawOffence5 => '5th Offence';

  @override
  String searchFoundPage(Object page, num count, Object query) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'results',
      one: 'result',
    );
    return 'Page $page · $count $_temp0 for \"$query\"';
  }
}
