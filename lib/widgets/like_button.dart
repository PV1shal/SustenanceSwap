import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:urban_sketchers/models/post.dart';
import 'package:urban_sketchers/models/user.dart';
import 'package:urban_sketchers/utils/app_colors.dart';

/// Common like button for the Application.
/// Handles uploading like to Firebase.
class CustomLikeWidget extends StatefulWidget {
  const CustomLikeWidget({super.key});

  @override
  _LikesButtonState createState() => _LikesButtonState();
}

class _LikesButtonState extends State<CustomLikeWidget> {
  late UserModel userProfile;
  late PostModel post;
  late bool isLiked;
  late Color color;
  late Icon icon;

  /// Initalises the state of the button.
  /// Like is [true] if the post is already liked, else [false].
  /// Sets color of the like button, [Red] if like is [True], else [App's primary font color].
  @override
  void initState() {
    super.initState();
    userProfile = Provider.of<UserModel>(context, listen: false);
    post = Provider.of<PostModel>(context, listen: false);
    isLiked = post.likes.contains(userProfile.userID);
    color = isLiked ? Colors.red : AppColors.primaryFontColor;
    icon = isLiked
        ? Icon(
            Icons.favorite,
            size: 35,
            color: color,
          )
        : Icon(
            Icons.favorite_border,
            size: 35,
            color: color,
          );
  }

  /// Call's post model's add like function.
  void liked() {
    post.addLikes(userProfile.userID);
  }

  /// Call's post model's remove like function.
  void disLiked() {
    post.removeLikes(userProfile.userID);
  }

  /// Like handler which calles like/dislike depending on the state of [isLiked].
  void likeHandler() {
    setState(() {
      isLiked = !isLiked;
      if (isLiked) {
        liked();
        color = Colors.red;
        icon = Icon(
          Icons.favorite,
          size: 35,
          color: color,
        );
      } else {
        disLiked();
        color = AppColors.primaryFontColor;
        icon = Icon(
          Icons.favorite_border,
          size: 35,
          color: color,
        );
      }
    });
  }

  /// Builds the like button.
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: likeHandler,
      child: Row(
        children: [
          icon,
          const SizedBox(width: 10),
          Text(
            '${post.likes.length}',
            semanticsLabel: '${post.likes.length} likes',
            style: const TextStyle(
              fontSize: 21,
              color: AppColors.primaryFontColor,
            ),
          )
        ],
      ),
    );
  }
}
