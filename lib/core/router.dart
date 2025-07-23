import 'package:go_router/go_router.dart';
import 'package:juru_stay/features/commissioner/presentation/add_place_page.dart';
import 'package:juru_stay/features/commissioner/presentation/track_earnings_page.dart';
import '../features/auth/presentation/login_page.dart';
import '../features/auth/presentation/signup_page.dart';
import '../features/homepage/homepage.dart';
import '../features/loading/loading_page.dart';
import '../features/places/presentation/places_page.dart';
import '../features/search/presentation/search_page.dart';
import '../features/settings/presentation/settings_page.dart';
import '../features/notifications/presentation/notifications_page.dart';
import '../features/guides/presentation/guides_page.dart';
import '../features/commissioner/presentation/commissioner_dashboard_page.dart';
import '../features/commissioner/presentation/commissioner_profile_page.dart';

final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const LoadingPage()),
    GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
    GoRoute(path: '/signup', builder: (context, state) => const SignupPage()),
    GoRoute(path: '/home', builder: (context, state) =>  HomePage()),
    GoRoute(path: '/places', builder: (context, state) =>  PlacesPage()),
    GoRoute(path: '/search', builder: (context, state) =>  SearchPage()),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsPage(),
    ),
    GoRoute(
      path: '/notifications',
      builder: (context, state) => const NotificationsPage(),
    ),
    GoRoute(path: '/guides', builder: (context, state) => const GuidesPage()),
    GoRoute(
      path: '/commissioner/dashboard',
      builder: (context, state) => const CommissionerDashboardPage(),
    ),
    GoRoute(
      path: '/commissioner/profile',
      builder: (context, state) => const EditCommissionerProfilePage(),
    ),
    GoRoute(
  path: '/add-place',
  builder: (context, state) => const AddPlacePage(),
),
GoRoute(
  path: '/track-earnings',
  builder: (context, state) => const TrackEarningsPage(),
),
  ],
);
