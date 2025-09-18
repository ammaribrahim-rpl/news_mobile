import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:news_mobile/lib.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(NewsController()); // ambil controller theme

    // Setelah 3 detik pindah ke ApiScreen
    Future.delayed(const Duration(seconds: 5), () {
      Get.off(() => ApiScreen());
    });

    return Obx(
      () => Scaffold(
        backgroundColor: c.isTheme.value
            ? MainColors.surfaceDark
            : MainColors.surfaceLight,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Animasi Lottie
              Lottie.asset(
                'assets/animations/traffic.json',
                width: 300,
                height: 300,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 20),
              Text(
                "Breaking News",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: c.isTheme.value
                      ? MainColors.textDark
                      : MainColors.textLight,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
