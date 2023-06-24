import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:urban_sketchers/utils/app_colors.dart';

/// Stateless Widget which is shows QR code of user's account.
/// Used by user to share their account.
class ShareProfile extends StatelessWidget {
  /// user uuid
  final String userID;

  /// username of user
  final String userName;

  /// constructor
  const ShareProfile({super.key, required this.userID, required this.userName});

  // NOTE: -> QR code and account sharing is good to have.
  //       -> In the future we have to setup firebase dynamic link for App.
  //       -> Then links should work.

  @override
  Widget build(BuildContext context) {
    final link = "https://urbansketcher.com/profile/$userID";
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 50),
            Center(
              child: Semantics(
                  label: "Urban Sketchers logo",
                  child: Image.asset('assets/img/Logo.png')),
            ),
            const SizedBox(height: 80),
            Semantics(
              label: "Your QR code",
              child: QrImage(
                data: link,
                backgroundColor: Colors.white,
                size: 246,
              ),
            ),
            const SizedBox(height: 10),
            Center(
                child: Text(
              '@$userName',
              semanticsLabel: "Your username, $userName",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryFocusColor,
              ),
            )),
            const SizedBox(height: 60),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 140,
                  height: 70,
                  child: Semantics(
                    label: "Share Profile link Button",
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryFontColor,
                      ),
                      onPressed: () {
                        Share.share(link);
                      },
                      child: ListView(
                        children: const [
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: Icon(Icons.share),
                          ),
                          Center(
                            child: Text("Share Profile"),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 50),
                SizedBox(
                  width: 140,
                  height: 70,
                  child: Semantics(
                    label: "Copy profile link button",
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryFocusColor,
                      ),
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: link));
                      },
                      child: ListView(
                        children: const [
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: Icon(Icons.copy),
                          ),
                          Center(
                            child: Text("Copy Link"),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
