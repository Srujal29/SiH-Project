import 'package:flutter/material.dart';
import 'package:devadarshan/theme.dart';
import 'package:devadarshan/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DevaDarshan - Temple Management',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.light,
      home: const HomeScreen(),
    );
  }
}
