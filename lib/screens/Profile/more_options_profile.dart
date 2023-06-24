import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:urban_sketchers/screens/Profile/about_us.dart';
import 'package:urban_sketchers/screens/Profile/help_center.dart';
import 'package:urban_sketchers/screens/Profile/signout_modal.dart';
import 'package:urban_sketchers/utils/app_colors.dart';

/// Opens a bottom slider modal with more settigns options.
/// Takes [context] to navigate back to previous screen.
void moreSettingsModal(context) {
  var width = MediaQuery.of(context).size.width * 0.95;
  showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return Container(
          height: MediaQuery.of(context).size.height *
              .38, // Make it 30 after Personal Info
          color: AppColors.primaryAppBarBackgroundColor,
          child: Padding(
              padding: const EdgeInsets.all(10),
              child: ListView(
                children: [
                  Row(
                    children: [
                      const Spacer(),
                      Row(
                        children: [
                          Semantics(
                            label: "Close options",
                            child: IconButton(
                              key: const Key("Close Button"),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              icon: const Icon(Icons.close),
                              color: AppColors.primaryFontColor,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(
                        height: 48,
                        width: width,
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const HelpCenter()));
                          },
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.only(left: 10),
                          ),
                          child: Container(
                            alignment:
                                Alignment.centerLeft, // Align text to the left
                            child: const Text(
                              "Help",
                              semanticsLabel: "Help",
                              style:
                                  TextStyle(color: AppColors.primaryFocusColor),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(
                        height: 48,
                        width: width,
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => AboutUs()));
                          },
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.only(left: 10),
                          ),
                          child: Container(
                            alignment:
                                Alignment.centerLeft, // Align text to the left
                            child: const Text(
                              "About Us",
                              semanticsLabel: "About Us",
                              style:
                                  TextStyle(color: AppColors.primaryFocusColor),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(
                        height: 48,
                        width: width,
                        child: TextButton(
                          onPressed: () {
                            signOutDialog(context, FirebaseAuth.instance);
                          },
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.only(left: 10),
                          ),
                          child: Container(
                            alignment:
                                Alignment.centerLeft, // Align text to the left
                            child: const Text(
                              "Sign Out",
                              semanticsLabel: "Sign Out",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 255, 63, 49),
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              )),
        );
      });
}
