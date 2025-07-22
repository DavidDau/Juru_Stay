class AppConstants {
  // API Endpoints
  static const String baseUrl = 'https://api.jurustay.com';
  static const String apiVersion = 'v1';

  // Route Names
  static const String loginRoute = '/login';

  // Asset Paths
  static const String imagesPath = 'assets/images';
  static const String iconsPath = 'assets/icons';

  // Storage Keys
  static const String authTokenKey = 'auth_token';
  static const String userDataKey = 'user_data';
  static const String themeKey = 'app_theme';

  // Timeouts
  static const int apiTimeoutSeconds = 30;
  static const int cacheValidityHours = 24;

  // UI Constants
  static const double defaultPadding = 16.0;
  static const double defaultBorderRadius = 8.0;
  static const int defaultAnimationDuration = 300;
}
