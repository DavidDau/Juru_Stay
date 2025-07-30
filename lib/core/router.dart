import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:juru_stay/features/auth/presentation/forgot_passoword_page.dart';
import 'package:juru_stay/features/auth/presentation/signup_page.dart';
import 'package:juru_stay/features/commissioner/presentation/add_place_page.dart';
import 'package:juru_stay/features/commissioner/presentation/settings_page.dart';
import 'package:juru_stay/features/commissioner/presentation/terms_page.dart';
import 'package:juru_stay/features/commissioner/presentation/track_earnings_page.dart';
import '../features/auth/presentation/login_page.dart';
import '../features/test/test_page.dart';
import '../features/homepage/homepage.dart';
import '../features/loading/loading_page.dart';
import '../features/places/presentation/places_page.dart';
import '../features/search/presentation/search_page.dart';
import '../features/notifications/presentation/notifications_page.dart';
import '../features/commissioner/presentation/commissioner_dashboard_page.dart';
import 'package:juru_stay/features/auth/controller/auth_controller.dart';
import 'package:juru_stay/features/commissioner/presentation/edit_profile_page.dart';
import 'package:juru_stay/features/auth/model/user_model.dart';


final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (context, state) => const LoadingPage()),
      GoRoute(path: '/test', builder: (context, state) => const TestPage()),
      GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignupPage(),
      ),
      GoRoute(path: '/home', builder: (context, state) => HomePage()),
      GoRoute(path: '/places', builder: (context, state) => PlacesPage()),
      GoRoute(path: '/search', builder: (context, state) => SearchPage()),
      GoRoute(
        path: '/notifications',
        builder: (context, state) => const NotificationsPage(),
      ),
      GoRoute(
  path: '/commissioner/settings',
  builder: (context, state) => const SettingsPage(),
),
      GoRoute(
  path: '/commissioner/dashboard',
  builder: (context, state) {
    final user = ref.read(authControllerProvider).value;
    if (user == null) return const SizedBox(); // or Loading/Error page
    return CommissionerDashboardPage(user: user);
  },
),

      GoRoute(
        path: '/commissioner/terms',
        builder: (context, state) => const TermsPage(),
      ),
      GoRoute(
        path: '/add-place',
        builder: (context, state) => const AddPlacePage(),
      ),
      GoRoute(
        path: '/track-earnings',
        builder: (context, state) => const TrackEarningsPage(),
      ),
     
GoRoute(
  path: '/edit-commissioner-profile',
  name: 'editCommissionerProfile',
  builder: (context, state) {
    final user = state.extra as UserModel; // Must be passed when navigating
    return EditProfilePage(commissioner: user);
  },
),

GoRoute(
  path: '/forgot-password',
  name: 'forgotPassword',
  builder: (context, state) => const ForgotPasswordPage(),
),


    ],
  );
});  // <-- Proper closing