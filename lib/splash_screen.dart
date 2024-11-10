import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gitpic_explorer/bottom_nav.dart';
import 'home.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin{
  @override
  void initState(){
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    Future.delayed(const Duration(seconds: 6),(){
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_)=> const BottomNav()));
    });
  }

  @override
  void dispose(){
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF020B2F),Colors.white,Color(0xFF020B2F)
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter
          )
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
        ClipRRect(
        borderRadius: BorderRadius.circular(20), // Set the border radius here
        child: Image.asset(
          'images/img.png',
          height: 170,
          width: 170,
          fit: BoxFit.cover,
        ),
      ),
      SizedBox(height: 20),
      Text(
        'GITPIC_EXPLORER',
        style: TextStyle(
          fontSize: 30,
          fontFamily: 'Oregano',
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
          ],
        ),
      ),
    );
  }
}
