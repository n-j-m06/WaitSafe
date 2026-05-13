import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/login_screen.dart';
import 'theme/theme_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const WaitSafeApp(),
    ),
  );
}

class WaitSafeApp extends StatelessWidget {
  const WaitSafeApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'WaitSafe',
      theme: themeProvider.currentTheme,
      home: const LoginScreen(),
    );
  }
}
