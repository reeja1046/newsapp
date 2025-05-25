import 'package:flutter/material.dart';
import 'package:newsapp/controller/provider.dart';
import 'package:newsapp/view/splash.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
       create: (_) => BookmarkProvider(),
      child: MaterialApp(
        title: "NewsApp",
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
      ),
    );
  }
}
