import 'package:flutter/material.dart';
import 'package:gitpic_explorer/splash_screen.dart';

void main() {
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0x465064)),
        useMaterial3: true,
      ),
      home: SplashScreen(),
    );
  }
}

