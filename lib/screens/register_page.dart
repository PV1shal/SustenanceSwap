// ignore_for_file: must_be_immutable

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:urban_sketchers/screens/login_page.dart';
import 'package:urban_sketchers/utils/app_colors.dart';
import 'package:urban_sketchers/utils/upload_service.dart';
import 'package:urban_sketchers/widgets/text_entry_box.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Register page widget used for registeration in app
class RegisterPage extends StatefulWidget {
  ///Constructor of RegisterPage
  RegisterPage({super.key});

  /// firebase Auth instance
  late FirebaseAuth firebaseAuth;

  /// FirebaseFirestore instance
  late FirebaseFirestore firebaseFirestore;

  /// setter of firebase Auth instance
  set setFirebaseAuth(FirebaseAuth firebaseAuth) {
    this.firebaseAuth = firebaseAuth;
  }

  /// setter of FirebaseFirestore instance
  set setFirebaseStore(FirebaseFirestore firebaseFirestore) {
    this.firebaseFirestore = firebaseFirestore;
  }

  @override
  RegisterPageState createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  // text controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final fullNameController = TextEditingController();
  final userNameController = TextEditingController();
  final confPswdController = TextEditingController();
  final bioController = TextEditingController();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  late UserCredential _userCredential;
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  String? imageUrl;
  File? imageFile;

  @override
  void initState() {
    widget.setFirebaseAuth = FirebaseAuth.instance;
    widget.setFirebaseStore = FirebaseFirestore.instance;
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    fullNameController.dispose();
    userNameController.dispose();
    confPswdController.dispose();
    bioController.dispose();
    super.dispose();
  }

  // This method allows users to pick image
  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxHeight: 512,
      maxWidth: 512,
      imageQuality: 75,
    );

    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
  }

  // This method allows users to build their avatar
  Widget buildAvatar() {
    if (imageFile != null) {
      return Stack(
        children: <Widget>[
          CircleAvatar(
            radius: 60,
            child: ClipOval(
              child: Image.asset(
                imageFile!.path,
                fit: BoxFit.fill,
                height: 120,
                width: 120,
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            right: 10,
            child: InkWell(
              onTap: _pickImage,
              child:
                  const Icon(Icons.camera_alt, color: Colors.white, size: 28),
            ),
          ),
        ],
      );
    } else {
      return CircleAvatar(
        radius: 60,
        backgroundColor: AppColors.primaryFocusColor,
        child: InkWell(
          onTap: _pickImage,
          child: const Icon(Icons.camera_alt, color: Colors.white, size: 28),
        ),
      );
    }
  }

  // This method validates the requirement of password
  void _validatePassword() {
    if (emailController.text.trim().isEmpty ||
        fullNameController.text.trim().isEmpty ||
        userNameController.text.trim().isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Please fill in all the required fields.',
                style: TextStyle(color: Colors.red)),
            actions: [
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      );
    } else if (passwordController.text.trim().length < 8) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Password Error'),
            content: const Text('Password must be at least8 characters long.',
                style: TextStyle(color: Colors.red)),
            actions: [
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      );
    } else {
      // proceed with registration if password are the same
      if (passwordConfirmed()) {
        registerUser();
        // Pop up a snack bar says registration success
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Registration success!Please Log In',
                style: TextStyle(color: Colors.black)),
            backgroundColor: Colors.yellow,
            behavior: SnackBarBehavior.floating,
          ),
        );
        // navigate to the register success page
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LoginPage(),
          ),
        );
      } else {
        // Pop up a snack bar says password not matching
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Your Password Does Not Match!!!',
                style: TextStyle(color: Colors.white)),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  // This method registers user using email and password
  Future registerUser() async {
    if (passwordConfirmed()) {
      // authenticate and create user first
      _userCredential = await widget.firebaseAuth
          .createUserWithEmailAndPassword(
              email: emailController.text.trim(),
              password: passwordController.text.trim());
      final User? user = _userCredential.user;
      String userUID = user!.uid;
      String? profilePic;

      if (imageFile == null) {
        profilePic = null;
      } else {
        /// upload file in firebase storage
        UploadFileService uploadService = UploadFileService(
          storage: FirebaseStorage.instance,
        );
        Future<String> downloadURL = uploadService.uploadFile(
            imageFile!, "$userUID.jpg", '/profilePics');

        profilePic = await downloadURL;
      }
      // then add user details
      addUserDetails(
          fullNameController.text.trim(),
          userNameController.text.trim(),
          emailController.text.trim(),
          bioController.text.trim(),
          userUID,
          profilePic);
    }
  }

  // This method adds user details to the database
  Future addUserDetails(String fullname, String username, String email,
      String bio, String uid, String? profilePic) async {
    await widget.firebaseFirestore.collection('users').doc(uid).set({
      'Full name': fullname,
      'Username': username,
      'Email': email,
      'bio': bio,
      'Profile Pic': profilePic,
    });
  }

  //Makes sure the password is confirmed
  bool passwordConfirmed() {
    if (passwordController.text.trim() == confPswdController.text.trim()) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          // Background image: gradient green
          Container(
            key: const Key('BackgroundImage'),
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/img/gradient_background.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
            children: [
              // Logo: Urban Sketchers
              const SizedBox(height: 70),
              // Logo: Urban Sketchers
              Center(
                key: const Key('LogoImage'),
                child: Image.asset(
                  'assets/img/Logo.png',
                  height: 85,
                  width: w,
                  alignment: Alignment.topCenter,
                ),
              ),
              // profile pick

              // User profile pick
              //userProfilePick(),
              buildAvatar(),
              // Stack of Email entry
              Expanded(
                child: Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      textEntryBox(),
                      TextFormField(
                        key: const Key('EmailEntryField'),
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Email *',
                          hintStyle: TextStyle(color: Colors.white30),
                          contentPadding: EdgeInsets.only(left: 90.0),
                        ),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
              // Off set 20

              // Stack of Full name entry
              Expanded(
                child: Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      textEntryBox(),
                      TextFormField(
                        key: const Key('FullnameEntryField'),
                        controller: fullNameController,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Full name *',
                          hintStyle: TextStyle(color: Colors.white30),
                          contentPadding: EdgeInsets.only(left: 90.0),
                        ),
                        style: const TextStyle(color: Colors.white),
                      ),
                      //const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),

              // Off set 20
              //const SizedBox(height: 20),

              // Stack of Username entry
              Expanded(
                child: Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      textEntryBox(),
                      TextFormField(
                        key: const Key('UsernameEntryField'),
                        controller: userNameController,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Username *',
                          hintStyle: TextStyle(color: Colors.white30),
                          contentPadding: EdgeInsets.only(left: 90.0),
                        ),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
              // Off set 20
              //const SizedBox(height: 20),

              // Stack of Bio entry
              Expanded(
                child: Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      textEntryBox(),
                      TextFormField(
                        key: const Key('BioEntryField'),
                        controller: bioController,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Bio',
                          hintStyle: TextStyle(color: Colors.white30),
                          contentPadding: EdgeInsets.only(left: 90.0),
                        ),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),

              // Stack of Password entry
              Expanded(
                child: Center(
                  child: Semantics(
                    label: 'Password Entry',
                    textField: true,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        textEntryBox(),
                        TextFormField(
                          key: const Key('PasswordEntryField'),
                          obscureText: true,
                          controller: passwordController,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Password *',
                            hintStyle: TextStyle(color: Colors.white30),
                            contentPadding: EdgeInsets.only(left: 90.0),
                          ),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Stack of Confirm Password entry
              Expanded(
                child: Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      textEntryBox(),
                      TextFormField(
                        key: const Key('ConfPswdEntryField'),
                        obscureText: true,
                        controller: confPswdController,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Confirm Password *',
                          hintStyle: TextStyle(color: Colors.white30),
                          contentPadding: EdgeInsets.only(left: 90.0),
                        ),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),

              // Description of the password
              Expanded(
                child: Container(
                  alignment: Alignment.topLeft,
                  width: 300.0,
                  child: const Text(
                    'Password needs to be at least 8 characters including numbers, letters, and * _ + = &  ^.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.white30,
                    ),
                  ),
                ),
              ),

              // Register button
              Expanded(
                key: const Key('RegisterButton'),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: GestureDetector(
                    onTap: () {
                      _validatePassword();
                    },
                    child: SizedBox(
                      width: 280,
                      height: 50,
                      child: Stack(
                        children: [
                          Image.asset(
                            'assets/img/Button1.png',
                            width: 280,
                            height: 50,
                          ),
                          const Center(
                            child: Padding(
                              padding: EdgeInsets.only(bottom: 20.0),
                              child: Text(
                                'Register',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // link navigates to sign in page
              Expanded(
                key: const Key('LinktoSignInPage'),
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {
                        // navigate to the register page
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginPage(),
                          ),
                        );
                      },
                      child: const Text(
                        'Already have an account?',
                        style: TextStyle(
                          color: Colors.white30,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
