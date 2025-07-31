import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:go_router/go_router.dart';
import 'firebase_options.dart';
import 'features/auth/presentation/login_page.dart';
import 'features/homepage/homepage.dart';
import 'features/search/presentation/search_page.dart';
import 'features/feedbacks/presentation/feedbacks_page.dart';
import 'features/commissioner/presentation/terms_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const JuruStayApp());
}

final _router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const LoginPage()),
    GoRoute(path: '/home', builder: (context, state) => const HomePage()),
    GoRoute(path: '/search', builder: (context, state) => const SearchPage()),
    GoRoute(path: '/feedbacks', builder: (context, state) => const FeedbacksPage()),
    GoRoute(path: '/terms', builder: (context, state) => const TermsPage()),
  ],
);

class JuruStayApp extends StatelessWidget {
  const JuruStayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      title: 'JuruStay',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}
