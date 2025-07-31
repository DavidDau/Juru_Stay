import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/router.dart';
import 'core/theme_notifier.dart';
import 'core/font_notifier.dart';
import 'core/language_notifier.dart';
import 'core/theme_builder.dart';
import 'package:juru_stay/l10n/app_localizations.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider); // For GoRouter
    final themeMode = ref.watch(themeNotifierProvider);
    final fontSize = ref.watch(fontSizeNotifierProvider);
    final languageCode = ref.watch(languageNotifierProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Juru Stay',

      // Theme
      theme: buildTheme(fontSize, Brightness.light),
      darkTheme: buildTheme(fontSize, Brightness.dark),
      themeMode: themeMode,

      // Localization
      locale: Locale(languageCode),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      // Routing
      routerConfig: router,
    );
  }
}
