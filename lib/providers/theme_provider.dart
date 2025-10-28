import 'package:flutter_riverpod/legacy.dart';
import 'package:hive/hive.dart';

final themeProvider = StateNotifierProvider<ThemeNotifier, bool>((ref) {
  return ThemeNotifier()..loadTheme();
});

class ThemeNotifier extends StateNotifier<bool> {
  ThemeNotifier() : super(false);

  Future<void> loadTheme() async {
    final box = await Hive.openBox('settings');
    state = box.get('isDarkMode', defaultValue: false);
  }

  Future<void> toggleTheme() async {
    final box = await Hive.openBox('settings');
    state = !state;
    await box.put('isDarkMode', state);
  }

  Future<void> setTheme(bool isDark) async {
    final box = await Hive.openBox('settings');
    state = isDark;
    await box.put('isDarkMode', isDark);
  }
}
