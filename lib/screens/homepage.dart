import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:urban_sketchers/models/user.dart';
import 'package:urban_sketchers/screens/screens.dart';
import 'package:urban_sketchers/utils/app_colors.dart';

/// HomePage screen
class HomePage extends StatefulWidget {
  var firebaseFirestoreInstance;
  FirebaseAuth firebaseAuth;
  HomePage(
      {required this.firebaseFirestoreInstance, required this.firebaseAuth});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int pageIndex = 0;
  late PageController pageController;
  // final FirebaseAuth _auth = FirebaseAuth.instance;
  late FirebaseAuth _auth;
  late var _firestoreInstance;
  User? _currentUser;
  late UserModel _user;

  @override
  void initState() {
    super.initState();
    _auth = widget.firebaseAuth;
    _firestoreInstance = widget.firebaseFirestoreInstance;
    _auth.authStateChanges().listen((User? user) {
      if (user != null) {
        _currentUser = user;
        _user =
            UserModel(userID: user.uid, fireBaseInstance: _firestoreInstance);
        _user.getUserInfo().then((_) => setState(() {}));
      }
    });
    // _user = UserModel(
    //     userID: "KghKvjxZ4uNtQmEPRr3WVllHXXj2",
    //     fireStoreCollection: FirebaseFirestore.instance.collection('users'));
    // _user.getUserInfo().then((_) => setState(() {}));
    pageController = PageController();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  //this function will change pageIndex on PageView loading any widget
  onPageChanged(int pageIndex) {
    setState(() {
      this.pageIndex = pageIndex;
    });
  }

  //When any bottomNavigation bar's menu will be tapped, this function will trigger
  onTap(int pageIndex) {
    pageController.animateToPage(
      pageIndex,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  //this function provides view of Timeline having bottomNavigationBar in default
  Scaffold buildAuthScreen() {
    return Scaffold(
      body: PageView(
        controller: pageController,
        onPageChanged: onPageChanged,
        physics: const NeverScrollableScrollPhysics(),
        children: <Widget>[
          Timeline(
            firebaseAuth: _auth,
            firebaseFirestore: FirebaseFirestore.instance,
          ),
          Upload(
            firebaseAuth: _auth,
            firestore: FirebaseFirestore.instance,
          ),
          ProfilePage()
        ],
      ),
      //   ],
      // ),
      bottomNavigationBar: CupertinoTabBar(
        currentIndex: pageIndex,
        backgroundColor: AppColors.primaryAppBarBackgroundColor,
        onTap: onTap,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.map_sharp),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle),
            label: "New post",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.manage_accounts),
            label: "Profile",
          ),
        ],
        activeColor: Theme.of(context).primaryColor,
        inactiveColor: AppColors.iconColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => _user,
      child: buildAuthScreen(),
    );
  }
}
