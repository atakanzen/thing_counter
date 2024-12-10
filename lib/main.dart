import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thing_counter/pages/main_page.dart';
import 'package:thing_counter/providers/theme_provider.dart';
import 'package:thing_counter/services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final notificationService = NotificationService();
  await notificationService.initialize();

  runApp(const ThingCounterApp());
}

class ThingCounterApp extends StatelessWidget {
  const ThingCounterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: ThemeData.light(),
              darkTheme: ThemeData.dark(),
              themeMode: themeProvider.themeMode,
              home: const MainPage());
        },
      ),
    );
  }
}
