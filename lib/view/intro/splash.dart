import 'package:flutter/material.dart';
import 'package:gren_mart/view/intro/intro.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future.delayed(
      Duration(seconds: 2),
      () => Navigator.of(context).pushReplacementNamed(Intro.routeName),
    );
    return Scaffold(
      body: Center(
        child: Container(
          height: 150,
          width: 300,
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            'assets/images/grenmart.png',
            // fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
