import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_finance_app/providers/theme_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(themeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Theme',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          RadioListTile<bool>(
            title: const Text('Light Mode'),
            value: false,
            groupValue: isDarkMode,
            onChanged: (val) => ref.read(themeProvider.notifier).setTheme(val!),
          ),
          RadioListTile<bool>(
            title: const Text('Dark Mode'),
            value: true,
            groupValue: isDarkMode,
            onChanged: (val) => ref.read(themeProvider.notifier).setTheme(val!),
          ),
        ],
      ),
    );
  }
}
