import 'dart:async';
import 'package:eproject/screens/converter_screen.dart';
import 'package:eproject/utils/app_constant.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
        Duration(seconds: 7),
        () => Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => ConverterScreen())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    return Stack(
      children: [
        // Background animation that covers the whole screen
        Positioned.fill(
          child: Lottie.asset(
            "assets/animation/17.json",
            fit: BoxFit.cover,
            repeat: true,
          ),
        ),
        // Foreground content
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(
                "assets/animation/16.json",
                repeat: true,
                width: 250,
                height: 250,
              ),
              SizedBox(height: 6),
              AnimatedTextKit(
                animatedTexts: [
                  WavyAnimatedText('CurrenSee',
                      textStyle: TextStyle(
                          color: AppConstant().themeColor,
                          fontSize: 30,
                          fontWeight: FontWeight.bold)),
                ],
                repeatForever: true,
                pause: Duration(milliseconds: 1000),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
