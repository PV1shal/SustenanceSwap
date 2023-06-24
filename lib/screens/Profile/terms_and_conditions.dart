import 'package:flutter/material.dart';
import 'package:urban_sketchers/utils/app_colors.dart';
import 'package:flutter/services.dart' show rootBundle;

/// Stateless Widget which returns Terms and conditions of the App.
/// Uses the Terms and conditions present in [assets/terms_and_conditions.txt].
/// Edit this file in case of changes to Term's and conditions.
class TermsAndConditions extends StatelessWidget {
  /// constructor
  const TermsAndConditions({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: FutureBuilder(
          future: rootBundle.loadString('assets/terms_and_conditions.txt'),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView(
                children: [
                  const ListTile(
                    minVerticalPadding: 25,
                    title: Center(
                        child: Text(
                      "Terms & Conditions",
                      semanticsLabel: "Terms & Conditions",
                      style: TextStyle(
                          color: AppColors.primaryFontColor,
                          fontSize: 32,
                          fontWeight: FontWeight.bold),
                    )),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text(
                          "Welcome to UrbanSketchers!",
                          semanticsLabel: "Welcome to UrbanSketchers!",
                          style: TextStyle(
                              color: AppColors.primaryFontColor,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          snapshot.data!,
                          semanticsLabel: snapshot.data!,
                          style: const TextStyle(
                              color: AppColors.primaryFontColor),
                        )
                      ],
                    ),
                  )
                ],
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ));
  }
}
