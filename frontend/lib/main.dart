import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const WaitSafeApp());
}

class WaitSafeApp extends StatelessWidget {
  const WaitSafeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'WaitSafe',
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: const HomeScreen(),
    );
  }
}
