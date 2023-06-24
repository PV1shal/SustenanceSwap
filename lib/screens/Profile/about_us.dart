import 'package:flutter/material.dart';
import 'package:urban_sketchers/screens/Profile/privacy_policy.dart';
import 'package:urban_sketchers/screens/Profile/terms_and_conditions.dart';
import 'package:urban_sketchers/utils/app_colors.dart';

/// Stateless Widget which will show the app's creators and how to contact them.
class AboutUs extends StatelessWidget {
  /// constructor
  const AboutUs({super.key});

  /// Returns all the details as const Texts here.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: [
          const ListTile(
            minVerticalPadding: 25,
            title: Center(
                child: Text(
              "About Us",
              semanticsLabel: "About Us",
              style: TextStyle(
                  color: AppColors.primaryFontColor,
                  fontSize: 32,
                  fontWeight: FontWeight.bold),
            )),
          ),
          const SizedBox(height: 15),
          Semantics(
            label: "Urban Sketchers Logo",
            child: Image.asset(
              'assets/img/Logo.png',
              height: 130.0,
            ),
          ),
          const SizedBox(height: 60),
          UnconstrainedBox(
              child: Container(
            decoration: const BoxDecoration(
                color: AppColors.primaryAppBarBackgroundColor,
                borderRadius: BorderRadius.all(Radius.circular(20))),
            width: MediaQuery.of(context).size.width * 0.85,
            height: 100,
            child: Column(
              children: [
                Row(
                  children: const [
                    Padding(
                      padding: EdgeInsets.all(15),
                      child: Text(
                        "Contact us",
                        semanticsLabel: "Contact us",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryFontColor),
                      ),
                    )
                  ],
                ),
                Row(
                  children: const [
                    Padding(
                      padding: EdgeInsets.only(left: 15),
                      child: Icon(
                        Icons.mail,
                        color: AppColors.primaryFocusColor,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 5),
                      child: Text(
                        "teamtitans@gmail.com",
                        semanticsLabel: "teamtitans@gmail.com",
                        style: TextStyle(
                            fontSize: 16, color: AppColors.primaryFontColor),
                      ),
                    )
                  ],
                )
              ],
            ),
          )),
          const SizedBox(height: 50),
          UnconstrainedBox(
              child: Container(
            decoration: const BoxDecoration(
                color: AppColors.primaryAppBarBackgroundColor,
                borderRadius: BorderRadius.all(Radius.circular(20))),
            width: MediaQuery.of(context).size.width * 0.85,
            height: 125,
            child: Column(
              children: [
                Row(
                  children: const [
                    Padding(
                      padding: EdgeInsets.all(15),
                      child: Text(
                        "Contributors",
                        semanticsLabel: "Contributors",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryFontColor),
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    Column(
                      children: [
                        Row(
                          children: const [
                            Padding(
                              padding: EdgeInsets.only(left: 15),
                              child: Text(
                                "Ambika Kabra",
                                semanticsLabel: "Ambika Kabra",
                                style: TextStyle(
                                    color: AppColors.primaryFontColor),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: const [
                            Padding(
                              padding: EdgeInsets.only(left: 15),
                              child: Text(
                                "Liang Huang",
                                semanticsLabel: "Liang Huang",
                                style: TextStyle(
                                    color: AppColors.primaryFontColor),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Row(
                          children: const [
                            Padding(
                              padding: EdgeInsets.only(left: 15),
                              child: Text(
                                "Sifan Wei",
                                semanticsLabel: "Sifan Wei",
                                style: TextStyle(
                                    color: AppColors.primaryFontColor),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: const [
                            Padding(
                              padding: EdgeInsets.only(left: 15),
                              child: Text(
                                "Vishal Pugazhendhi",
                                semanticsLabel: "Vishal Pugazhendhi",
                                style: TextStyle(
                                    color: AppColors.primaryFontColor),
                              ),
                            )
                          ],
                        ),
                      ],
                    )
                  ],
                )
              ],
            ),
          )),
          TextButton(
            key: const Key("Terms & Conditions"),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => TermsAndConditions()));
            },
            style: const ButtonStyle(alignment: Alignment.bottomLeft),
            child: const Text(
              "Read full Terms and conditions here",
              semanticsLabel: "Read full Terms and conditions here",
            ),
          ),
          TextButton(
            key: const Key("Privacy Policy"),
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => PrivacyPolicy()));
            },
            style: const ButtonStyle(alignment: Alignment.bottomLeft),
            child: const Text("Read full Privacy Policy",
                semanticsLabel: "Read full Privacy Policy"),
          ),
        ],
      ),
    );
  }
}
