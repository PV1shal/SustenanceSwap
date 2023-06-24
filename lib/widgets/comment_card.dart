import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:urban_sketchers/utils/app_colors.dart';
import 'package:urban_sketchers/widgets/custom_profile_pic.dart';

/// Return's FutureBuilder Widget with list of Cards with comments.
/// Takes [uid] - UID of logged in user and [postId] - Post ID of a post.
Widget customCommentCards(
    String uid, String postId, FirebaseFirestore instance) {
  return FutureBuilder(
    future: instance
        .collection("users")
        .doc(uid)
        .collection("posts")
        .doc(postId)
        .collection("comments")
        .get(),
    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
      if (snapshot.hasData) {
        List<String> uids = [];
        List<String> comments = [];
        snapshot.data!.docs.forEach((doc) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          uids.add(data["ownerId"]);
          comments.add(data["comment"]);
        });
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: comments.length,
          itemBuilder: (BuildContext context, int index) {
            String uid = uids[index];
            String comment = comments[index];
            return FutureBuilder(
              future: instance.collection("users").doc(uid).get(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  return Card(
                    color: AppColors.primaryFontColor,
                    child: Semantics(
                      label:
                          "@${snapshot.data['Username']} commented, $comment",
                      child: InkWell(
                        // onTap: () {},
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Wrap(
                            children: [
                              Row(
                                children: [
                                  circularProfilePic(
                                      snapshot.data["Profile Pic"], 20),
                                  const SizedBox(width: 5),
                                  Text(
                                    "@${snapshot.data['Username']}",
                                    semanticsLabel: "",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                              const SizedBox(height: 60),
                              Text(
                                comment,
                                semanticsLabel: "",
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                } else {
                  return const CircularProgressIndicator();
                }
              },
            );
          },
        );
      } else {
        return const CircularProgressIndicator();
      }
    },
  );
}
