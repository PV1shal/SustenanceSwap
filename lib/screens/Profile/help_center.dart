import 'package:flutter/material.dart';
import 'package:urban_sketchers/utils/app_colors.dart';

/// Stateless Widget which returns Frequently asked questions.
class HelpCenter extends StatelessWidget {
  /// constructor
  const HelpCenter({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: const [
          ListTile(
            minVerticalPadding: 25,
            title: Center(
                child: Text(
              "Help Center",
              semanticsLabel: "Help Center",
              style: TextStyle(
                  color: AppColors.primaryFontColor,
                  fontSize: 32,
                  fontWeight: FontWeight.bold),
            )),
          ),
          Padding(
            padding: EdgeInsets.only(left: 28),
            child: Text(
              "F&Qs",
              semanticsLabel: "Frequently asked questions",
              style: TextStyle(fontSize: 24, color: AppColors.primaryFontColor),
            ),
          ),
          SizedBox(height: 15),
          Padding(
            padding: EdgeInsets.only(left: 28),
            child: Text(
              "How can I read terms and conditions?",
              semanticsLabel: "How can I read terms and conditions?",
              style: TextStyle(color: AppColors.primaryFocusColor),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 28),
            child: Text(
              """A. Follow the steps given below:
     1. Go to Profile page 
     2. Click on Settings 
     3. Click on About us page.
     4. Click on ‘Read full Terms and Conditions’""",
              semanticsLabel: """A. Follow the steps given below:
     1. Go to Profile page 
     2. Click on Settings 
     3. Click on About us page.
     4. Click on ‘Read full Terms and Conditions’""",
              style: TextStyle(color: AppColors.primaryFontColor),
            ),
          ),
          SizedBox(height: 15),
          Padding(
            padding: EdgeInsets.only(left: 28),
            child: Text(
              "How can I change my account details?",
              semanticsLabel: "How can I change my account details?",
              style: TextStyle(color: AppColors.primaryFocusColor),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 28),
            child: Text(
              """A. Follow the steps given below:
     1. Go to Profile page
     2. Click on Settings 
     3. Click on personal information settings
     4. edit your email and verify the new one.""",
              semanticsLabel: """Follow the steps given below:
     1. Go to Profile page
     2. Click on Settings 
     3. Click on personal information settings
     4. edit your email and verify the new one.""",
              style: TextStyle(color: AppColors.primaryFontColor),
            ),
          ),
          SizedBox(height: 15),
          Padding(
            padding: EdgeInsets.only(left: 28),
            child: Text(
              "3. Why should I choose MealMates app?",
              semanticsLabel: "Why should I choose MealMates app?",
              style: TextStyle(color: AppColors.primaryFocusColor),
            ),
          ),
          SizedBox(height: 15),
          Padding(
            padding: EdgeInsets.only(left: 28),
            child: Text(
              """A. MealMates provides a platform for students from various universities to share their fresh vegetables, fruits, produce, and meals with other students. Wherever/Whenever you are in the city, you can upload photos and share meals with your classmates. MealMates also has privacy features in which you can post only to your fellow university students or make it public, i.e., to all students of different Universities.  """,
              semanticsLabel:
                  """MealMates provides a platform for students from various universities to share their fresh vegetables, fruits, produce, and meals with other students. Wherever/Whenever you are in the city, you can upload photos and share meals with your classmates. MealMates also has privacy features in which you can post only to your fellow university students or make it public, i.e., to all students of different Universities.  """,
              style: TextStyle(color: AppColors.primaryFontColor),
            ),
          ),
          SizedBox(height: 15)
        ],
      ),
    );
  }
}
