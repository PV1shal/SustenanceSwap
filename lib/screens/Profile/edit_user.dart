import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:urban_sketchers/models/user.dart';
import 'package:urban_sketchers/utils/app_colors.dart';
import 'package:urban_sketchers/utils/update_profile_pic.dart';
import 'package:urban_sketchers/widgets/widgets.dart';

/// Stateless Widget which is used to edit the user's details.
class EditUser extends StatelessWidget {
  /// constructor
  const EditUser({super.key});

  @override
  Widget build(BuildContext context) {
    var userDetails = Provider.of<UserModel>(context);
    TextEditingController newUserNameController =
        TextEditingController(text: userDetails.username);
    TextEditingController newFullNameController =
        TextEditingController(text: userDetails.fullName);
    TextEditingController newBioController =
        TextEditingController(text: userDetails.bio);

    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Edit Profile",
            semanticsLabel: "Edit Profile",
          ),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  userDetails.setUserName = newUserNameController.text;
                  userDetails.setFullName = newFullNameController.text;
                  userDetails.setBio = newBioController.text;
                  Navigator.of(context).pop();
                },
                child: customDoneButton(),
              ),
            )
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.all(30),
          children: [
            Center(
                child: Semantics(
              label: "Tap to edit Profile Pic",
              child: GestureDetector(
                onTap: () {
                  updateProfilePic(
                      context, userDetails.userID, FirebaseStorage.instance);
                },
                child: Stack(
                  children: [
                    circularProfilePic(userDetails.profilePic, 70),
                    const Positioned(
                        bottom: 0,
                        right: 0,
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          // backgroundColor: AppColors.primaryFocusColor,
                          child: Icon(
                            Icons.camera_alt,
                            color: Colors.black,
                          ),
                        )),
                  ],
                ),
              ),
            )),
            const SizedBox(height: 50),
            TextField(
              decoration: const InputDecoration(
                filled: true,
                label: Text("Username"),
                fillColor: AppColors.primaryFontColor,
              ),
              controller: newUserNameController,
            ),
            const SizedBox(height: 50),
            TextField(
              decoration: const InputDecoration(
                filled: true,
                label: Text("First Name"),
                fillColor: AppColors.primaryFontColor,
              ),
              controller: newFullNameController,
            ),
            const SizedBox(height: 50),
            TextField(
              decoration: const InputDecoration(
                  filled: true,
                  label: Text("Bio"),
                  fillColor: AppColors.primaryFontColor),
              controller: newBioController,
              maxLines: 5,
            )
          ],
        ));
  }
}
