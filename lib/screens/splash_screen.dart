// ## FIXED: Corrected the import to use a colon 'dart:async' ##
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
    // Start playing the chant immediately, without waiting for it to load.
    _audioPlayer.play(AssetSource('audio/chant.mp3'));

    // Start the navigation timer at the same time.
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
    // Stop the audio and release resources when the screen is gone.
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'ॐ नमः शिवाय',
              style: GoogleFonts.laila(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: [
                  const Shadow(
                    offset: Offset(1.0, 1.0),
                    blurRadius: 3.0,
                    color: Colors.black38,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white.withAlpha(204)),
            ),
          ],
        ),
      ),
    );
  }
}