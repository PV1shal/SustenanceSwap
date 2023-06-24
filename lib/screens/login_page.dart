import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:urban_sketchers/screens/homepage.dart';
import 'package:urban_sketchers/screens/register_page.dart';
import 'package:urban_sketchers/widgets/text_entry_box.dart';

/// LoginPage is a statefulWidget used to create a login page for app
// ignore: must_be_immutable
class LoginPage extends StatefulWidget {
  /// firebase Auth instance
  late FirebaseAuth firebaseAuth;

  /// FirebaseFirestore instance
  late FirebaseFirestore firebaseFirestore;

  /// constructor of LoginPage
  LoginPage({super.key});

  /// setter of firebase Auth instance
  set setFirebaseAuth(FirebaseAuth firebaseAuth) {
    this.firebaseAuth = firebaseAuth;
  }

  /// setter of FirebaseFirestore instance
  set setFirebaseStore(FirebaseFirestore firebaseFirestore) {
    this.firebaseFirestore = firebaseFirestore;
  }

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    widget.setFirebaseAuth = FirebaseAuth.instance;
    widget.setFirebaseStore = FirebaseFirestore.instance;
    super.initState();
  }

  /// email and password controller
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  late UserCredential _userCredential;
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  final _formKey = GlobalKey<FormState>();

  /// this methods dispose the content of the textcontrollers
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Form(
        key: _formKey,
        child: Stack(
          children: [
            // Background image: gradient green
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/img/gradient_background.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            Column(
              children: [
                const SizedBox(height: 120),
                // Logo: Urban Sketchers
                Center(
                  child: Image.asset(
                    'assets/img/Logo.png',
                    height: 85,
                    width: w,
                    alignment: Alignment.topCenter,
                  ),
                ),

                // Off set 20
                const SizedBox(height: 20),

                // Stack of Email entry
                Center(
                  child: Semantics(
                    label: 'Email Entry',
                    textField: true,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        textEntryBox(),
                        TextFormField(
                          key: const Key('sign-in-email'),
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Enter Email',
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
                const SizedBox(height: 20),

                // Stack of password entry
                Center(
                  child: Semantics(
                    label: 'Password Entry',
                    textField: true,
                    child: Stack(
                      children: [
                        textEntryBox(),
                        Container(
                          width: 280,
                          height: 48,
                          alignment: Alignment.center,
                          child: TextFormField(
                            key: const Key('sign-in-password'),
                            controller: _passwordController,
                            obscureText: true,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Password',
                              hintStyle: TextStyle(color: Colors.white30),
                              contentPadding: EdgeInsets.all(10),
                            ),
                            style: const TextStyle(color: Colors.white),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                // Off set 20
                const SizedBox(height: 20),

                // Sign in button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Semantics(
                    label: 'Sign In Button',
                    hint: 'Single tap to sign in',
                    child: GestureDetector(
                      onTap: () async {
                        // validate user with email and password
                        String emailEntry = _emailController.text.trim();
                        String pswdEntry = _passwordController.text.trim();

                        // print(emailEntry);
                        // print(pswdEntry);

                        // pop up warning for empty entry
                        if (emailEntry.isEmpty || pswdEntry.isEmpty) {
                          if (emailEntry.isEmpty && pswdEntry.isNotEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Your Email Cannot be Empty!',
                                    style: TextStyle(color: Colors.white)),
                                backgroundColor: Colors.red,
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          } else if (pswdEntry.isEmpty &&
                              emailEntry.isNotEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Your Password Cannot be Empty!',
                                    style: TextStyle(color: Colors.white)),
                                backgroundColor: Colors.red,
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          }
                        }

                        try {
                          UserCredential tempUser = await widget.firebaseAuth
                              .signInWithEmailAndPassword(
                                  email: emailEntry, password: pswdEntry);

                          // If validated user, navigate to homepage
                          // ignore: use_build_context_synchronously
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HomePage(
                                  firebaseAuth: widget.firebaseAuth,
                                  firebaseFirestoreInstance:
                                      FirebaseFirestore.instance,
                                ),
                              ),
                              (route) => false);
                        } on FirebaseAuthException catch (e) {
                          if (emailEntry.isNotEmpty &&
                              e.code == 'user-not-found') {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('No user found for that email!',
                                    style: TextStyle(color: Colors.white)),
                                backgroundColor: Colors.red,
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          } else if (pswdEntry.isNotEmpty &&
                              e.code == 'wrong-password') {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'Wrong password provided for that user!',
                                    style: TextStyle(color: Colors.white)),
                                backgroundColor: Colors.red,
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          }
                        } catch (e) {
                          print(e);
                        }
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
                            const SizedBox(width: 10),
                            const Center(
                              child: Padding(
                                padding: EdgeInsets.only(bottom: 10.0),
                                child: Text(
                                  'Sign in',
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

                // A link to registration page
                Semantics(
                  label: 'Registration Link',
                  hint: 'Tap to navigate to user registration',
                  child: GestureDetector(
                    key: const Key('register-link'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RegisterPage()),
                      );
                    },
                    child: const Text.rich(
                      TextSpan(
                        text: "Do not have an account?",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white30,
                        ),
                        children: [
                          TextSpan(
                            text: " Register here!",
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.bold,
                              color: Colors.white54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
      key: _scaffoldMessengerKey,
    );
  }
}
