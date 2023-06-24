import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:urban_sketchers/utils/image_utils.dart';
import 'package:urban_sketchers/utils/upload_service.dart';

/// upload file in firebase storage
Future uploadImage(
    File compressedImage, String userID, FirebaseStorage instance) async {
  // print(userModel.userID);
  UploadFileService uploadService = UploadFileService(
    storage: instance,
  );
  Future<String> downloadURL = uploadService.uploadFile(
      compressedImage, "${userID}.jpg", '/profilePics');

  return downloadURL;
}

/// Opens gallery for user to pick a picture to be used as profile pic.
/// The selected File is compress and uploaded.
void updateProfilePic(
    BuildContext context, String userID, FirebaseStorage instance) async {
  // var userDetails = Provider.of<UserModel>(context, listen: false);
  final ImagePicker picker = ImagePicker();
  final XFile? profilePicXFile = await picker.pickImage(
      source: ImageSource.gallery, maxHeight: 1800, maxWidth: 1800);
  File profilePicFile = File(profilePicXFile!.path);
  File compressedImageFile =
      await compressImage('profilePic.jpg', profilePicFile);

  // userDetails.setProfilePic =
  //     await uploadImage(compressedImageFile, userDetails);
  FirebaseFirestore.instance.collection("users").doc(userID).update({
    "Profile Pic": await uploadImage(compressedImageFile, userID, instance)
  });
}
