import 'package:flutter/material.dart';

/// IntroOne is a stateful widget showing purpose of app
class IntroOne extends StatefulWidget {
  /// constructor
  const IntroOne({Key? key}) : super(key: key);

  @override
  _IntroOneState createState() => _IntroOneState();
}

class _IntroOneState extends State<IntroOne> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Positioned(
          top: 216,
          height: 250,
          child: Image.asset(
            'assets/img/welcome_eclipse2.png',
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          top: 298,
          height: 85,
          child: Image.asset(
            'assets/img/Logo.png',
            fit: BoxFit.cover,
          ),
        ),

        // tagline
        const Positioned(
          top: 490,
          child: Text(
            'City is Under your pencil',
            style: TextStyle(
              fontSize: 24.0,
              fontFamily: 'Source Sans Pro',
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
