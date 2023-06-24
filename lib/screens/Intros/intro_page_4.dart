import 'package:flutter/material.dart';
import 'package:urban_sketchers/utils/app_colors.dart';

/// IntroFour is a stateful widget showing purpose of app
class IntroFour extends StatefulWidget {
  /// constructor
  const IntroFour({Key? key}) : super(key: key);

  @override
  _IntroFourState createState() => _IntroFourState();
}

class _IntroFourState extends State<IntroFour> {
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

        // icons
        Positioned(
          top: 265,
          height: 150,
          child: Image.asset(
            'assets/img/chat_icon.png',
            fit: BoxFit.cover,
          ),
        ),

        // tagline
        const Positioned(
          top: 490,
          child: Text(
            'Form Interest Groups',
            style: TextStyle(
              fontSize: 24.0,
              fontFamily: 'Source Sans Pro',
              color: AppColors.primaryFocusColor,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),

        // tagline
        const Positioned(
          top: 536,
          child: Text(
            'Create artist events & join a paint night!',
            style: TextStyle(
              fontSize: 16.0,
              fontFamily: 'Source Sans Pro',
              color: AppColors.iconColor,
            ),
          ),
        ),
      ],
    );
  }
}
