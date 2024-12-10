import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thing_counter/providers/theme_provider.dart';

class DarkModeSwitch extends StatelessWidget {
  const DarkModeSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode(context);

    return FloatingActionButton(
      onPressed: () {
        themeProvider.toggleTheme();
      },
      child: Icon(isDarkMode ? Icons.dark_mode : Icons.light_mode),
    );
  }
}
