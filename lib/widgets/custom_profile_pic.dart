import 'package:flutter/material.dart';

/// Returns user's Circular Profile Picture.
/// Returns default profile picture for asset when user didn't
/// upload a profile picture while register.
/// Takes [uri] - firestoer uri of the profile picture and radius of the
/// circular profile pic.
CircleAvatar circularProfilePic(String? uri, double radius) {
  return (uri != null)
      ? CircleAvatar(radius: radius, backgroundImage: NetworkImage(uri))
      : CircleAvatar(
          radius: radius,
          backgroundImage: const AssetImage("assets/images/defaultUser.png"));
}
