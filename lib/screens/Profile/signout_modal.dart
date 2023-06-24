import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:urban_sketchers/screens/login_page.dart';
import 'package:urban_sketchers/utils/app_colors.dart';

/// Signout out Modal. Takes [Context] and [Firebase Auth] to signout user and return back to login page.
void signOutDialog(BuildContext context, FirebaseAuth auth) {
  showDialog(
      context: context,
      builder: (context) => AlertDialog(
            semanticLabel: "Alert: Sign out?",
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            title: const Text("Log out of your account?"),
            actions: [
              SizedBox(
                width: 100,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                      shadowColor: AppColors.primaryFocusColor,
                      backgroundColor: AppColors.primaryFontColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: const BorderSide(color: Colors.black))),
                  child: const Text(
                    "No",
                    semanticsLabel: "No",
                  ),
                ),
              ),
              const SizedBox(width: 10),
              SizedBox(
                  width: 100,
                  child: ElevatedButton(
                    onPressed: () {
                      auth.signOut();
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginPage(),
                          ),
                          (route) => false);
                    },
                    style: ElevatedButton.styleFrom(
                        shadowColor: AppColors.primaryFocusColor,
                        backgroundColor: AppColors.primaryFocusColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: const BorderSide(color: Colors.black))),
                    child: const Text(
                      "Yes",
                      semanticsLabel: "No",
                    ),
                  ))
            ],
            actionsAlignment: MainAxisAlignment.center,
          ));
}
