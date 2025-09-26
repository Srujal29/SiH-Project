import 'dart:async';
import 'package:flutter/material.dart';
// Removed google_fonts as the text is being removed
// import 'package:google_fonts/google_fonts.dart'; 
import 'package:devadarshan/screens/login_screen.dart';
import 'package:audioplayers/audioplayers.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _startSplash();
  }

  void _startSplash() {
    _audioPlayer.play(AssetSource('audio/chant.mp3'));

    Timer(const Duration(seconds: 6), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ## MODIFIED: Logo is bigger (height increased) ##
            Image.asset(
              'assets/images/logo.jpg', // Path to your .jpg logo
              height: 250, // Increased height for a bigger logo
            ),
            // ## REMOVED: No more SizedBox below the logo for the text ##
            // ## REMOVED: The 'ॐ नमः शिवाय' text is gone ##
            // const SizedBox(height: 24), // This was for the text
            // Text(
            //   'ॐ नमः शिवाय',
            //   style: GoogleFonts.laila(
            //     fontSize: 40,
            //     fontWeight: FontWeight.bold,
            //     color: Theme.of(context).colorScheme.primary,
            //   ),
            // ),
            const SizedBox(height: 40), // Added more space above the indicator
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}