import 'package:flutter/material.dart';
import 'package:newsapp/view/splash.dart';

void main() {
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title:"NewsApp",
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}