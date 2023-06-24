import 'package:flutter/material.dart';
import 'package:urban_sketchers/utils/app_colors.dart';

/// IntroTwo is a stateful widget showing purpose of app
class IntroTwo extends StatefulWidget {
  /// constructor
  const IntroTwo({Key? key}) : super(key: key);

  @override
  _IntroTwoState createState() => _IntroTwoState();
}

class _IntroTwoState extends State<IntroTwo> {
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
          left: 126,
          height: 150,
          child: Image.asset(
            'assets/img/artist_icon.png',
            fit: BoxFit.cover,
          ),
        ),

        // tagline
        const Positioned(
          top: 490,
          child: Text(
            'Discover Local Artists',
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
            'Find the best artist nearby & make commissions',
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
