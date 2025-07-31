import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final fontSizeNotifierProvider = StateNotifierProvider<FontSizeNotifier, String>((ref) {
  return FontSizeNotifier();
});

class FontSizeNotifier extends StateNotifier<String> {
  FontSizeNotifier() : super('medium') {
    _loadFontSize();
  }

  void _loadFontSize() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getString('font_size') ?? 'medium';
  }

  void setFontSize(String size) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('font_size', size);
    state = size;
  }
}
