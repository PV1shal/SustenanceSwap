import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:provider/provider.dart';
import 'package:urban_sketchers/models/post.dart';
import 'package:urban_sketchers/utils/app_colors.dart';
import 'package:urban_sketchers/utils/location_utils.dart';
import 'package:urban_sketchers/widgets/comment_card.dart';
import 'package:urban_sketchers/widgets/custom_profile_pic.dart';
import 'package:urban_sketchers/widgets/like_button.dart';

/// Common Widget used to open a post with all it's details.
/// Takes [context], [userID] - UID of logged in user, [post] - post model of the post.
void showPost(
    context, String userID, PostModel post, FirebaseFirestore instance) {
  TextEditingController commentController = TextEditingController();

  showBottomSheet(
      backgroundColor: AppColors.primaryBackgroundColor,
      context: context,
      builder: (BuildContext bc) {
        return FutureBuilder(
            future: instance.collection("users").doc(post.ownerId).get(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                // print(snapshot.data.data());
                return SizedBox(
                    height: MediaQuery.of(context).size.height * 0.9,
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        children: [
                          Expanded(
                            child: ListView(
                              children: [
                                Row(
                                  children: [
                                    Semantics(
                                      label: "Close Post",
                                      child: IconButton(
                                        key: const Key("Close Button"),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        icon: const Icon(Icons.arrow_back),
                                        color: AppColors.primaryFontColor,
                                      ),
                                    ),
                                    const Spacer(),
                                    post.ownerId == userID
                                        ? Semantics(
                                            label: "Delete Post",
                                            child: IconButton(
                                              key: const Key("Delete Button"),
                                              onPressed: () {
                                                post.deletePost();
                                                Navigator.of(context).pop();
                                              },
                                              icon: const Icon(Icons.delete),
                                              color: AppColors.primaryFontColor,
                                            ),
                                          )
                                        : const SizedBox(),
                                  ],
                                ),
                                // Post's Image
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.4,
                                  width: MediaQuery.of(context).size.width *
                                      0.9, // set the width to fill the available space
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10.0),
                                    child: Semantics(
                                      label:
                                          "Post with caption, ${post.caption}",
                                      child: Image.network(
                                        post.mediaUrl,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                // Profile Pic + Username Widgets + Likes
                                Row(
                                  children: [
                                    circularProfilePic(
                                        snapshot.data["Profile Pic"], 30),
                                    const SizedBox(width: 10),
                                    Text(
                                      "@${snapshot.data["Username"]}",
                                      semanticsLabel:
                                          "Posted by, ${snapshot.data["Username"]}",
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primaryFocusColor,
                                      ),
                                    ),
                                    const Spacer(),
                                    ChangeNotifierProvider.value(
                                      value: post,
                                      child: CustomLikeWidget(),
                                    )
                                    // CustomLikeWidget(posts: post.likes),
                                  ],
                                ),
                                const SizedBox(height: 10),

                                // Post's CaptionizedBox(width: 10),
                                Text(
                                  post.caption,
                                  semanticsLabel: "Caption, ${post.caption}",
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: AppColors.primaryFontColor,
                                  ),
                                ),

                                const SizedBox(height: 10),
                                const Text(
                                  "Location",
                                  semanticsLabel: "Location",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primaryFocusColor,
                                  ),
                                ),

                                // Gets Address from Lat/Long
                                FutureBuilder(
                                  future: getAddress(post.lat, post.long),
                                  builder: (BuildContext context,
                                      AsyncSnapshot snapshot) {
                                    if (snapshot.hasData) {
                                      return Text(
                                        "${snapshot.data}",
                                        semanticsLabel:
                                            "was taken at ${snapshot.data}",
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: AppColors.primaryFontColor,
                                        ),
                                      );
                                    } else {
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }
                                  },
                                ),

                                const SizedBox(height: 10),
                                Text(
                                  post.timestamp.toDate().toString(),
                                  semanticsLabel:
                                      "was taken on ${post.timestamp.toDate().toString()}",
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: AppColors.primaryFontColor,
                                  ),
                                ),

                                const SizedBox(height: 20),
                                const Text(
                                  "Comments",
                                  semanticsLabel: "Comments",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primaryFocusColor,
                                  ),
                                ),

                                Column(
                                  children: [
                                    customCommentCards(
                                        post.ownerId, post.postID, instance)
                                  ],
                                ),
                              ],
                            ),
                          ),

                          // Adding your Comments
                          Container(
                            decoration: BoxDecoration(
                              color: AppColors.primaryFontColor,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Semantics(
                                    label: "Enter your comment here",
                                    child: TextField(
                                      key: const Key("Post Comment"),
                                      decoration: const InputDecoration(
                                        contentPadding:
                                            EdgeInsets.only(left: 20),
                                        hintText: 'Enter your comment...',
                                        border: InputBorder.none,
                                      ),
                                      controller: commentController,
                                    ),
                                  ),
                                ),
                                Semantics(
                                  label: "Post Comment",
                                  child: IconButton(
                                    onPressed: () async {
                                      await post.addComment(
                                          userID,
                                          post.ownerId,
                                          post.postID,
                                          commentController.text);
                                      // Wait for the comment to be added, then refresh the page
                                      Navigator.of(context).pop();
                                      showPost(context, userID, post, instance);
                                    },
                                    icon: const Icon(Icons.send_rounded),
                                    color: AppColors.primaryFocusColor,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ));
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            });
      });
}
