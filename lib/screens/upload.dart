import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:urban_sketchers/utils/app_colors.dart';
import 'package:urban_sketchers/utils/image_utils.dart';
import 'package:urban_sketchers/utils/location_utils.dart' as loc;
import 'package:urban_sketchers/utils/privacy_option.dart';
import 'package:urban_sketchers/utils/save_post_service.dart';
import 'package:uuid/uuid.dart';
import '../utils/upload_service.dart';
import '../widgets/widgets.dart';

/// This stateful widget is used for creating a new post and uploading sketch
class Upload extends StatefulWidget {
  /// FirebaseFirestore instance
  final FirebaseFirestore firestore;

  /// FirebaseAuth instance
  final FirebaseAuth firebaseAuth;

  /// constructor
  const Upload(
      {super.key, required this.firestore, required this.firebaseAuth});
  @override
  State<Upload> createState() => _UploadState();
}

/// State class used for Upload widget
class _UploadState extends State<Upload> {
  /// current image as sketch
  File? _currentImage;

  /// _picker instance of ImagePicker
  final ImagePicker _picker = ImagePicker();

  /// current privacy option chosen by user
  PrivacyOption _privacyOption = PrivacyOption.public;

  /// boolean for Upload progress
  bool _isUpload = false;

  /// instance of TextEditingController for location text field
  final TextEditingController _locationController = TextEditingController();

  /// instance of TextEditingController for caption text field
  final TextEditingController _captionController = TextEditingController();

  /// Current post id
  String postId = const Uuid().v4();

  /// current latitude
  late double _latitude;

  ///current longitude
  late double _longitude;

  ///If currentImage is empty then so imagePicker else show post form
  @override
  Widget build(BuildContext context) {
    return _currentImage == null ? buildImagePicker() : buildPostForm();
  }

  /// function is used for back button in sketch preview
  void clearImage() {
    setState(() {
      _currentImage = null;
      _privacyOption = PrivacyOption.public;
      _locationController.clear();
      _captionController.clear();
      _isUpload = false;
    });
  }

  /// set langitude and latitude based on address in text field
  Future<void> setLatLang() async {
    Location currentLocation =
        await loc.getLocationFromAddress(_locationController.text);
    setState(() {
      _latitude = currentLocation.latitude;
      _longitude = currentLocation.longitude;
    });
  }

  /// compress current image
  compressSketch() async {
    File compressedImageFile =
        await compressImage('img_$postId.jpg', _currentImage!);
    setState(() {
      _currentImage = compressedImageFile;
    });
  }

  /// upload file in firebase storage
  Future uploadImage() async {
    UploadFileService uploadService = UploadFileService(
      storage: FirebaseStorage.instance,
    );
    Future<String> downloadURL =
        uploadService.uploadFile(_currentImage!, "post_$postId.jpg", '/posts');

    return downloadURL;
  }

  /// this function will run on clicking green tick on top
  onSubmit() async {
    if (_locationController.text.trim().isEmpty || _currentImage == null) {
      const snackBar = SnackBar(
        content: Text('Unable to submit post! Enter location.',
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    } else {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
    }

    setState(() {
      _isUpload = true;
    });

    await setLatLang();
    await compressSketch();
    String downloadURL = await uploadImage();

    var save =
        SaveInFirestore(widget.firebaseAuth.currentUser!, widget.firestore);

    await save.putPostInFirestore(
      mediaUrl: downloadURL,
      latitude: _latitude,
      longitude: _longitude,
      privacyOption: _privacyOption.value,
      postId: postId,
      caption: _captionController.text,
    );

    _captionController.clear();
    _locationController.clear();

    setState(() {
      _currentImage = null;
      _isUpload = false;
      postId = const Uuid().v4();
    });
  }

  /// This return Scaffold to show image preview and post form
  Widget buildPostForm() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryAppBarBackgroundColor,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: AppColors.iconColor,
            semanticLabel: "back",
          ),
          onPressed: clearImage,
        ),
        title: const Text(
          "Caption Post",
          style: TextStyle(color: AppColors.iconColor),
        ),
        actions: [
          IconButton(
            onPressed: _isUpload ? () {} : onSubmit,
            icon: const Icon(
              Icons.done,
              color: AppColors.primaryFocusColor,
              semanticLabel: "Submit post",
            ),
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          _isUpload ? customLinearProgressIndicator() : const Text(""),
          SizedBox(
            height: 220.0,
            width: MediaQuery.of(context).size.width * 0.8,
            child: Center(
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: FileImage(_currentImage!),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 10.0),
          ),
          ListTile(
            title: SizedBox(
              width: 250.0,
              child: TextField(
                style: const TextStyle(color: AppColors.iconColor),
                controller: _captionController,
                decoration: const InputDecoration(
                  hintText: "Write a caption...",
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: AppColors.iconColor),
                ),
              ),
            ),
          ),
          const Divider(
            color: AppColors.iconColor,
          ),
          ListTile(
            leading: const Icon(
              Icons.lock,
              color: AppColors.primaryFocusColor,
              size: 35.0,
            ),
            title: const Text(
              'Privacy',
              style: TextStyle(color: AppColors.iconColor),
            ),
            trailing: DropdownButton<PrivacyOption>(
              style: const TextStyle(
                color: AppColors.iconColor,
              ),
              value: _privacyOption,
              icon: const Icon(Icons.keyboard_arrow_down),
              dropdownColor: AppColors.primaryBackgroundColor,
              onChanged: (PrivacyOption? option) {
                setState(() {
                  _privacyOption = option!;
                });
              },
              items: PrivacyOption.values.map((option) {
                return DropdownMenuItem<PrivacyOption>(
                  value: option,
                  child: Text(option.value),
                );
              }).toList(),
            ),
          ),
          const Divider(
            color: AppColors.iconColor,
          ),
          ListTile(
            leading: const Icon(
              Icons.pin_drop,
              color: AppColors.primaryFocusColor,
              size: 35.0,
            ),
            title: SizedBox(
              width: 250.0,
              child: TextField(
                controller: _locationController,
                style: const TextStyle(color: AppColors.iconColor),
                decoration: const InputDecoration(
                  hintText: "Tag your location",
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: AppColors.iconColor),
                ),
              ),
            ),
          ),
          Container(
            width: 200.0,
            height: 100.0,
            alignment: Alignment.center,
            child: ElevatedButton.icon(
              onPressed: () async {
                Position position = await loc.getCurrentLocation();

                String address =
                    await loc.getAddress(position.latitude, position.longitude);
                setState(() {
                  _latitude = position.latitude;
                  _longitude = position.longitude;
                  _locationController.text = address;
                });
              },
              icon: const Icon(Icons.my_location),
              label: const Text(
                "Use current location",
                style: TextStyle(fontSize: 18.0),
              ),
            ),
          )
        ],
      ),
    );
  }

  /// This function returns view for picking image
  Widget buildImagePicker() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SvgPicture.asset(
          'assets/images/upload-background.svg',
          height: 260,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20),
          child: GestureDetector(
            onTap: () => selectImage(context),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.primaryFocusColor,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: const Text(
                "Upload Image",
                style: TextStyle(fontSize: 22.0, color: Colors.black),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// select image alert with option to choose from gallery or cancel
  Future<void> selectImage(BuildContext parentContext) async {
    return showDialog(
      context: parentContext,
      builder: (context) {
        return SimpleDialog(
          title: const Text("Create Post"),
          children: <Widget>[
            SimpleDialogOption(
              child: const Text("Image from Gallery"),
              onPressed: () {
                Navigator.pop(context);
                getImage(ImageSource.gallery);
              },
            ),
            SimpleDialogOption(
              child: const Text("Cancel"),
              onPressed: () => Navigator.pop(context),
            )
          ],
        );
      },
    );
  }

  /// get image from given media
  Future<void> getImage(ImageSource media) async {
    final pickedFile = await _picker.pickImage(
      source: media,
      maxWidth: 1800,
      maxHeight: 1800,
    );

    if (pickedFile != null) {
      setState(() {
        _currentImage = File(pickedFile.path);
      });
    }
  }
}
