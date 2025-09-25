import 'package:flutter/material.dart';
import 'package:devadarshan/theme.dart';
import 'package:devadarshan/screens/splash_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // Import the Supabase package

Future<void> main() async {
  // Ensure that Flutter widgets are initialized before running the app
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase with your project URL and anon key
  await Supabase.initialize(
    url: 'https://sdmcohzzvwnkjiyeralv.supabase.co',
    anonKey: 'sb_publishable_aTA2cyBcyw0ktriZmgig1A_zYIAMSIQ',
  );
  
  runApp(const MyApp());
}

// Create a global variable for easy access to the Supabase client
final supabase = Supabase.instance.client;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DevaDarshan',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      home: const SplashScreen(), 
    );
  }
}