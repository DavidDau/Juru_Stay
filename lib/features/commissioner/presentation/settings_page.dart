import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:juru_stay/core/theme_notifier.dart';
import 'package:juru_stay/core/language_notifier.dart';
import 'package:juru_stay/core/font_notifier.dart';
import 'package:juru_stay/l10n/app_localizations.dart';


class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeNotifierProvider);
    final isDarkMode = themeMode == ThemeMode.dark;

    final language = ref.watch(languageNotifierProvider);
    final fontSize = ref.watch(fontSizeNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.settings)),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Theme toggle
          ListTile(
          
            title: Text(AppLocalizations.of(context)!.darkMode),

            trailing: Switch(
              value: isDarkMode,
              onChanged: (_) => ref.read(themeNotifierProvider.notifier).toggleTheme(),
            ),
          ),

          const SizedBox(height: 16),

          // Language Dropdown
          ListTile(
            title: Text(AppLocalizations.of(context)!.language),

            trailing: DropdownButton<String>(
              value: language,
              items: const [
                DropdownMenuItem(value: 'en', child: Text('English')),
                DropdownMenuItem(value: 'sw', child: Text('Swahili')),
              ],
              onChanged: (value) {
                if (value != null) {
                  ref.read(languageNotifierProvider.notifier).setLanguage(value);
                }
              },
            ),
          ),

          const SizedBox(height: 16),

          // Font Size Dropdown
          ListTile(
  title: Text(
    AppLocalizations.of(context)!.fontSize,
    style: const TextStyle(fontSize: 16), // 🔧 Explicit fontSize added
  ),
  trailing: DropdownButton<String>(
    value: fontSize,
    items: const [
      DropdownMenuItem(
        value: 'small',
        child: Text('Small', style: TextStyle(fontSize: 14)), // 🔧 Font size here too
      ),
      DropdownMenuItem(
        value: 'medium',
        child: Text('Medium', style: TextStyle(fontSize: 16)),
      ),
      DropdownMenuItem(
        value: 'large',
        child: Text('Large', style: TextStyle(fontSize: 18)),
      ),
    ],
    onChanged: (value) {
      if (value != null) {
        ref.read(fontSizeNotifierProvider.notifier).setFontSize(value);
      }
    },
  ),
),

        ],
      ),
    );
  }
}
