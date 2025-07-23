import 'package:flutter/material.dart';

class AppConstants {
  // API Endpoints
  static const String baseUrl = 'https://api.jurustay.com';
  static const String apiVersion = 'v1';

  // Route Names
  static const String homeRoute = '/home';
  static const String loginRoute = '/login';
  static const String signupRoute = '/signup';
  static const String placesRoute = '/places';
  static const String searchRoute = '/search';
  static const String settingsRoute = '/settings';
  static const String notificationsRoute = '/notifications';
  static const String guidesRoute = '/guides';
  static const String commissionerDashboardRoute = '/commissioner/dashboard';
  static const String commissionerProfileRoute = '/commissioner/profile';

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

  // Retry Configuration
  static const int maxRetryAttempts = 3;
  static const int retryDelaySeconds = 2;
  static const int maxRetryDelaySeconds = 10;

  // UI Constants
  static const double defaultPadding = 16.0;
  static const double defaultBorderRadius = 8.0;
  static const int defaultAnimationDuration = 300;
}

class AppColors {
  static const primaryColor = Color(0xFF87CEEB); // Sky blue
  static const lightBlue = Color(0xFFE0F6FF); // Very light blue
}
