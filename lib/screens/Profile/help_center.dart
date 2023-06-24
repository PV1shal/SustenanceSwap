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
              "3. Why should I choose UrbanSketchers app?",
              semanticsLabel: "Why should I choose UrbanSketchers app?",
              style: TextStyle(color: AppColors.primaryFocusColor),
            ),
          ),
          SizedBox(height: 15),
          Padding(
            padding: EdgeInsets.only(left: 28),
            child: Text(
              """A. This app provides a platform for artist/sketch lovers to share their immediate sketching ideas through the city. Wherever/Whenever you are in the city, you can upload your wild thinking/impressions of a certain scenery to the platform, and share/communicate ideas worldwide. The arts have no limitation of proficiency, whether you are a professional or amateur, you can always use this app to share and learn.  """,
              semanticsLabel:
                  """This app provides a platform for artist/sketch lovers to share their immediate sketching ideas through the city. Wherever/Whenever you are in the city, you can upload your wild thinking/impressions of a certain scenery to the platform, and share/communicate ideas worldwide. The arts have no limitation of proficiency, whether you are a professional or amateur, you can always use this app to share and learn.  """,
              style: TextStyle(color: AppColors.primaryFontColor),
            ),
          ),
          SizedBox(height: 15),
          Padding(
            padding: EdgeInsets.only(left: 28),
            child: Text(
              "4. Who is app's target audience?",
              semanticsLabel: "Who is app's target audience?",
              style: TextStyle(color: AppColors.primaryFocusColor),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 28),
            child: Text(
              """A. 
   (i) People who love sketching or wants to try sketching: Not everyone has time and space to do fancy colorful paintings every day, but simple lines of sketch are easy. It would be a great place to start an art journey.   
  
  (ii) People who are artists themselves - The app would gather a group of local artists and enhance their communication.  
 
 (iii) Tourists - This app will provide them with a different way of exploring the city and give them a chance to jot down their impressions of the city.""",
              semanticsLabel:
                  """(i) People who love sketching or wants to try sketching: Not everyone has time and space to do fancy colorful paintings every day, but simple lines of sketch are easy. It would be a great place to start an art journey.   
  
  (ii) People who are artists themselves - The app would gather a group of local artists and enhance their communication.  
 
 (iii) Tourists - This app will provide them with a different way of exploring the city and give them a chance to jot down their impressions of the city.""",
              style: TextStyle(color: AppColors.primaryFontColor),
            ),
          ),
        ],
      ),
    );
  }
}
