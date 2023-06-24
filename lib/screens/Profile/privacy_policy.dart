import 'package:flutter/material.dart';
import 'package:urban_sketchers/utils/app_colors.dart';
import 'package:flutter/services.dart' show rootBundle;

/// Stateless Widget which returns Privacy Policy of the App.
/// Reads the Privact policy from [privacy_policy.txt]. Edit it incase of changes to Privacy policies.
class PrivacyPolicy extends StatelessWidget {
  /// constructor
  const PrivacyPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: FutureBuilder(
          future: rootBundle.loadString('assets/privacy_policy.txt'),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView(
                children: [
                  const ListTile(
                    minVerticalPadding: 25,
                    title: Center(
                        child: Text(
                      "Privacy Policy",
                      semanticsLabel: "Privacy Policy",
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
              return Center(
                child: Semantics(
                    label: "loading", child: CircularProgressIndicator()),
              );
            }
          },
        ));
  }
}
