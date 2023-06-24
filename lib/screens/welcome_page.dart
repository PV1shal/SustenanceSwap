import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:urban_sketchers/screens/Intros/intro_page_1.dart';
import 'package:urban_sketchers/screens/Intros/intro_page_2.dart';
import 'package:urban_sketchers/screens/Intros/intro_page_3.dart';
import 'package:urban_sketchers/screens/Intros/intro_page_4.dart';
import 'package:urban_sketchers/screens/register_page.dart';
import 'package:urban_sketchers/screens/screens.dart';
import 'package:urban_sketchers/utils/app_colors.dart';

///WelcomePage is a stateful widget which is used to show first page of the app.
class WelcomePage extends StatefulWidget {
  /// constructor
  const WelcomePage({Key? key}) : super(key: key);

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  // controller for page indicator
  final PageController _controller = PageController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // background image for all
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/img/blurred_bg_map2.jpg'),
                fit: BoxFit.cover,
              ),
            ),

            // page controller to scroll through different pages
            child: PageView(
              controller: _controller,
              children: const [
                IntroOne(),
                IntroTwo(),
                IntroThree(),
                IntroFour(),
              ],
            ),
          ),

          // Dot indicator
          Container(
            alignment: const Alignment(0, 0.75),
            child: SmoothPageIndicator(
              controller: _controller,
              count: 4,
              onDotClicked: (index) {
                _controller.animateToPage(index,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.decelerate);
              },
              effect: const ExpandingDotsEffect(
                  expansionFactor: 1.5,
                  dotColor: Colors.grey,
                  activeDotColor: AppColors.primaryFocusColor,
                  strokeWidth: 2,
                  paintStyle: PaintingStyle.fill),
            ),
          ),

          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // A row of two buttons
              Container(
                alignment: Alignment.bottomCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // the button leading to log in page
                    GestureDetector(
                      onTap: () {
                        // navigate to the login page
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginPage(),
                          ),
                        );
                      },
                      child: Container(
                        height: 36,
                        width: 180,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/img/Button2.png'),
                            fit: BoxFit.fill,
                          ),
                        ),
                        child: const Center(
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 8.0),
                            child: Text(
                              'SIGN IN',
                              style: TextStyle(
                                fontFamily: 'Source Sans Pro',
                                color: Color(0xFF393E46),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Register button
                    GestureDetector(
                      onTap: () {
                        // navigate to the login page
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RegisterPage(),
                          ),
                        );
                      },
                      child: Container(
                        height: 36,
                        width: 180,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/img/Button1.png'),
                            fit: BoxFit.fill,
                          ),
                        ),
                        child: const Center(
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 8.0),
                            child: Text(
                              'REGISTER',
                              style: TextStyle(
                                fontFamily: 'Source Sans Pro',
                                color: Color(0xFF393E46),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          )
        ],
      ),
    );
  }
}
