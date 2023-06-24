import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:urban_sketchers/models/user.dart';
import 'package:urban_sketchers/screens/Profile/edit_user.dart';
import 'package:urban_sketchers/screens/Profile/more_options_profile.dart';
import 'package:urban_sketchers/screens/Profile/share_profile.dart';
import 'package:urban_sketchers/utils/app_colors.dart';
import 'package:urban_sketchers/widgets/individual_post_view.dart';
import 'package:urban_sketchers/widgets/widgets.dart';

/// This statefule widget is used for viewing the profile of the currently logged in user.
class ProfilePage extends StatefulWidget {
  /// constructor
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

/// State class for Profile Widget.
class _ProfilePageState extends State<ProfilePage> {
  /// Deatils of the user is stored here.
  late UserModel userProfile;

  /// Says if the Box box is expanded or not. (Incase Bio has >2 lines)
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
  }

  /// Retrieves user's information from homepage
  /// Displays the details such as username, bio, posts, etc.
  @override
  Widget build(BuildContext context) {
    userProfile = Provider.of<UserModel>(context);
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text(
            "Profile",
            semanticsLabel: "Profile",
          ),
          actions: <Widget>[
            IconButton(
              key: const Key("Share Button"),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ShareProfile(
                          userID: userProfile.userID,
                          userName: userProfile.username,
                        )));
              },
              icon: const Icon(
                Icons.ios_share,
                semanticLabel: "Share Profile",
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: IconButton(
                key: const Key("Settings Button"),
                onPressed: () {
                  moreSettingsModal(context);
                },
                icon: const Icon(
                  Icons.settings,
                  semanticLabel: "Settings",
                ),
              ),
            )
          ],
        ),
        body: ListView(
          children: [
            Row(
              children: [
                /// User Profile Picture
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Semantics(
                    label: "Your Profile Picture",
                    child: GestureDetector(
                      child: circularProfilePic(userProfile.profilePic, 70),
                    ),
                  ),
                ),

                /// User's username
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 200,
                      child: Padding(
                          padding: const EdgeInsets.only(left: 5, top: 15),
                          child: Text(
                            '@${userProfile.username}',
                            semanticsLabel:
                                "Your username, @${userProfile.username}",
                            style: const TextStyle(
                              fontSize: 21,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryFocusColor,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            softWrap: false,
                          )),
                    ),
                  ],
                )
              ],
            ),

            /// Expandable Bio
            Semantics(
              label: "Your Bio, ${userProfile.bio}",
              child: Padding(
                padding: const EdgeInsets.only(left: 15, top: 10, bottom: 15),
                child: GestureDetector(
                  key: const Key("Bio Expand"),
                  onTap: () {
                    setState(() {
                      _isExpanded = !_isExpanded;
                    });
                  },
                  child: Text(
                    userProfile.bio,
                    style: const TextStyle(color: AppColors.primaryFontColor),
                    maxLines: _isExpanded
                        ? null
                        : 2, // set maxLines to null to expand the Text
                    overflow: _isExpanded ? null : TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),

            /// Button to edit profile. Onclick -> Edit user's details.
            Semantics(
              label: "Edit Profile",
              child: MaterialButton(
                key: const Key("Edit Button"),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChangeNotifierProvider.value(
                                value: userProfile,
                                child: EditUser(),
                              )));
                },
                color: AppColors.primaryFocusColor,
                child: const Text(
                  "Edit profile",
                ),
              ),
            ),

            const SizedBox(height: 15),

            /// Number of posts uploaded by the user
            Row(
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 15),
                  child: Text(
                    "Posts ",
                    semanticsLabel: "Your uploaded Posts",
                    style: TextStyle(
                        color: AppColors.primaryFontColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Text(
                  "(${userProfile.posts.length})",
                  style: const TextStyle(
                    color: AppColors.primaryFontColor,
                    fontSize: 20,
                  ),
                )
              ],
            ),

            const SizedBox(height: 15),

            /// user's Posts
            /// In a Builder to rebuild whenever data is updated in firebase.
            Builder(builder: (context) {
              return GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 0,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                children: userProfile.posts.map((post) {
                  return Semantics(
                    label: "Your post captioned, ${post.caption}",
                    child: InkWell(
                      key: Key(post.postID),
                      onTap: () {
                        showPost(context, userProfile.userID, post,
                            FirebaseFirestore.instance);
                      },
                      child: Ink.image(
                        image: NetworkImage(post.mediaUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                }).toList(),
              );
            })
          ],
        ));
  }
}
