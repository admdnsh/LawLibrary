class ApiConstants {
  // Base URL for the API (XAMPP)
  static const String baseUrl =
      'http://localhost:80/law_library_api'; // For Android emulator // update this if testing on a network. (use address of network)
  // Use 'http://localhost:80/law_library_api' for iOS simulator

  // Default pagination values
  static const int defaultItemsPerPage = 10;
  static const int defaultPage = 1;

  // API endpoints
  static const String lawsEndpoint = '/get_laws.php';
  static const String categoriesEndpoint = '/get_categories.php';
  static const String loginEndpoint = '/login.php';
}

class AppConstants {
  // App name and version
  static const String appName = 'Law Library';
  static const String appVersion = '1.0.0';

  // About page information
  static const String aboutDescription =
      'Law Library is a comprehensive collection of laws and regulations for reference by legal professionals and the general public.';
  static const String aboutCompany = 'Legal Services Authority';
  static const String aboutWebsite = 'www.legalservices.org';
  static const String aboutEmail = 'contact@legalservices.org';

  // Preferences keys
  static const String themePreferenceKey = 'theme_mode';
  static const String fontSizePreferenceKey = 'font_size';
}
