import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:news_mobile/lib.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(NewsApp());
}

// ignore: must_be_immutable
class NewsApp extends StatelessWidget {
var c = Get.put(NewsController());
  NewsApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
        themeMode: c.isTheme.value ? ThemeMode.dark : ThemeMode.light,
      home: SplashScreen(),
    ),
    );
  }
}
