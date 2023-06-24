import 'package:flutter/material.dart';
import 'package:urban_sketchers/utils/app_colors.dart';

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
          top: 210,
          height: 250,
          child: Image.asset(
            'assets/img/Logo_Icon.png',
            fit: BoxFit.cover,
            width: 250,
          ),
        ),
        const Positioned(
          top: 500, // Set the desired top position here
          child: Text(
            '''Welcome to 
              MealMates''',
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryFontColor,
            ),
          ),
        ),
      ],
    );
  }
}
