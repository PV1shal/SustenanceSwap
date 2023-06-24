import 'package:flutter/material.dart';
import 'package:urban_sketchers/screens/register_page.dart';
import 'package:urban_sketchers/screens/screens.dart';
import 'package:urban_sketchers/screens/welcome_page.dart';
import 'package:urban_sketchers/utils/app_colors.dart';
import 'package:urban_sketchers/utils/color.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';

import 'firebase_options.dart';

/// Entry point of this app
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

/// Root widget of this app as StatelessWidget
class MyApp extends StatelessWidget {
  /// Constructor of MyApp
  const MyApp({super.key});

  /// green custom color for primarySwatch as MaterialColor
  final MaterialColor greenCustomColor =
      const MaterialColor(0xFF32E0C4, greenColor);

  /// This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        title: 'Urban Sketchers',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: greenCustomColor,
          scaffoldBackgroundColor: AppColors.primaryBackgroundColor,
          fontFamily: GoogleFonts.sourceSansPro().fontFamily,
          appBarTheme: const AppBarTheme(
              backgroundColor: AppColors.primaryAppBarBackgroundColor,
              titleTextStyle:
                  TextStyle(fontSize: 21, color: AppColors.primaryFontColor),
              iconTheme: IconThemeData(color: AppColors.iconColor)),
        ),
        home: const WelcomePage());
  }
}
