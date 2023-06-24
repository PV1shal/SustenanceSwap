import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:urban_sketchers/models/post.dart';
import 'package:urban_sketchers/utils/app_colors.dart';
import 'package:urban_sketchers/widgets/individual_post_view.dart';
import 'package:urban_sketchers/widgets/widgets.dart';

/// CustomMarkerWindow is a stateless widget to create a infoWindow having preview of posts with same location on google map.
/// This takes list of PostModel instance which are in same LatLng.
class CustomMarkerWindow extends StatelessWidget {
  /// List of instances of PostModel
  final List<PostModel> postsList;

  /// instance of firebase Firestore
  final FirebaseFirestore firebaseFirestore;

  /// instance of firebaseAuth
  final FirebaseAuth firebaseAuth;

  /// Constructor of CustomMarkerWindow which requires List of instances of PostModel
  const CustomMarkerWindow(
      {super.key,
      required this.postsList,
      required this.firebaseFirestore,
      required this.firebaseAuth});

  @override
  Widget build(BuildContext context) {
    if (postsList.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Container(
      width: 300,
      height: 200,
      decoration: BoxDecoration(
        color: AppColors.primaryAppBarBackgroundColor,
        border: Border.all(color: AppColors.primaryBackgroundColor),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: postsList.length,
        itemBuilder: (context, index) {
          final post = postsList[index];
          return getPostsPreview(post);
        },
      ),
    );
  }

  /// This function is creating postsPreview for each post in List
  Padding getPostsPreview(PostModel post) {
    final currentUserUid = firebaseAuth.currentUser!.uid;
    final postImage = post.mediaUrl;
    final ownerId = post.ownerId;

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.8),
            borderRadius: BorderRadius.circular(10.0)),
        width: 250,
        child: FutureBuilder(
          future: firebaseFirestore.collection("users").doc(ownerId).get(),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data!.exists) {
              final data = snapshot.data!.data()!;
              final profilePic = data["Profile Pic"];
              final username = data["Username"];
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: GestureDetector(
                      key: Key(post.postID),
                      onTap: () {
                        showPost(
                            context, currentUserUid, post, firebaseFirestore);
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 0.0, left: 0.0, right: 0.0),
                        child: Container(
                          width: 300,
                          height: 100,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(postImage),
                              fit: BoxFit.fitWidth,
                              filterQuality: FilterQuality.high,
                            ),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(10.0),
                              topRight: Radius.circular(10.0),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        circularProfilePic(profilePic, 20),
                        const SizedBox(width: 10),
                        Text(
                          "@$username",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        const SizedBox(height: 10),
                        const Spacer(),
                      ],
                    ),
                  ),
                ],
              );
            } else {
              return customCircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}
