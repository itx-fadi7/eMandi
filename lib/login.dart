import 'package:emandi/forgot.dart';
import 'package:emandi/forgotpass.dart';
import 'package:emandi/main.dart';
import 'package:emandi/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:developer' as developer;

class loginPage extends StatefulWidget {
  @override
  State<loginPage> createState() => _loginPageState();
}

class _loginPageState extends State<loginPage> {
  TextEditingController emailText = TextEditingController();

  TextEditingController passText = TextEditingController();

  void login() async {
    String email = emailText.text.trim();
    String password = passText.text.trim();
    if (email == "" || password == "") {
      MyToast.myShowToast('Please fill all the fields!');
    } else {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);
        if (userCredential.user!.emailVerified) {
          Navigator.popUntil(context, (route) => route.isFirst);
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => MyHomePage(
                  email: emailText.text,
                ),
              ));
        } else if (userCredential.user!.emailVerified == false) {
          MyToast.myShowToast(
              'Please Verify Email Sent to Your Email Account!');
        }
      } on FirebaseAuthException catch (ex) {
        MyToast.myShowToast(ex.code.toString());
      }
    }
  }

  bool passwordObscured = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          'Welcome to eMandi',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            width: 290,
            child: Center(
                child: Container(
                    width: 400,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 38.0),
                          child: CircleAvatar(
                            backgroundImage:
                                AssetImage('assets/images/logo.jpg'),
                            maxRadius: 70,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Text(
                            'Please Sign in to continue',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w700),
                          ),
                        ),
                        TextField(
                          controller: emailText,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              hintText: 'Email Address',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(11),
                                  borderSide:
                                      BorderSide(color: Colors.pink, width: 3)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(11),
                                  borderSide:
                                      BorderSide(color: Colors.teal, width: 3)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(11),
                                  borderSide: BorderSide(
                                      color: Colors.black54, width: 3)),
                              prefixIcon: Icon(
                                Icons.email,
                                color: Colors.blueAccent,
                              )),
                        ),
                        Container(height: 15),
                        TextField(
                          controller: passText,
                          obscureText: passwordObscured,
                          obscuringCharacter: '*',
                          decoration: InputDecoration(
                            hintText: 'Password',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(11),
                                borderSide:
                                    BorderSide(color: Colors.pink, width: 3)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(11),
                                borderSide:
                                    BorderSide(color: Colors.teal, width: 3)),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(11),
                                borderSide: BorderSide(
                                    color: Colors.black54, width: 3)),
                            prefixIcon: Icon(
                              Icons.password_outlined,
                              color: Colors.blueAccent,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                color: Colors.blueAccent,
                                passwordObscured
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                              onPressed: () {
                                setState(() {
                                  passwordObscured = !passwordObscured;
                                });
                              },
                            ),
                          ),
                        ),
                        Align(
                            alignment: Alignment.bottomRight,
                            child: TextButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => forgotPassword(),
                                      ));
                                },
                                child: Text(
                                  'Forget Password?',
                                  style: TextStyle(
                                      color: Colors.blue, fontSize: 16),
                                ))),
                        Padding(
                          padding: const EdgeInsets.only(top: 11),
                          child: ElevatedButton(
                            onPressed: () {
                              login();
                            },
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18)),
                                backgroundColor: Colors.teal,
                                minimumSize: Size(276, 40)),
                            child: Text(
                              'SIGN IN',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                        Text('-OR-',
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.w400)),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Sign in with',
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w400)),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 68.0),
                          child: Row(
                            children: [
                              IconButton(
                                  onPressed: () {},
                                  iconSize: 54,
                                  icon: Icon(
                                    Icons.facebook,
                                    color: Colors.teal,
                                  )),
                              Padding(
                                padding: const EdgeInsets.only(left: 28.0),
                                child: InkWell(
                                  onTap: () => signInWithGoogle(context),
                                  child: CircleAvatar(
                                    backgroundImage:
                                        AssetImage('assets/images/goo.png'),
                                    radius: 27,
                                    // Adjust the radius to increase the size
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 12, left: 14.0),
                          child: Wrap(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 48.0),
                                child: Text('Do not have an account?  ',
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w400)),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 12,
                                ),
                                child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => signUp(),
                                          ));
                                    },
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.teal,
                                        minimumSize: Size(275, 40),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(18))),
                                    child: Text(
                                      'CREATE ACCOUNT',
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    )),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ))),
          ),
        ),
      ),
    );
  }

//   signInWithGoogle() async {
//     // Trigger the authentication flow
//     GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
//
//     // Obtain the auth details from the request
//     GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
//
//     // Create a new credential
//     AuthCredential credential = GoogleAuthProvider.credential(
//       accessToken: googleAuth?.accessToken,
//       idToken: googleAuth?.idToken,
//     );
//     UserCredential userCredential =
//         await FirebaseAuth.instance.signInWithCredential(credential);
//     print(userCredential.user?.displayName);
//   }
// }

  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser != null) {
        // Obtain the auth details from the request
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        // Create a new credential
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        // Sign in to Firebase with the Google credentials
        final UserCredential userCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);

        // Retrieve the user information
        final User? user = userCredential.user;

        if (user != null) {
          print('User signed in: ${user.displayName}');
          // Navigate to the next screen or perform any other actions upon successful sign-in
        } else {
          print('Failed to sign in with Google.');
          // Handle sign-in failure
        }
      } else {
        print('Google sign-in canceled.');
        // Handle sign-in cancellation
      }
    } catch (e) {
      print('Error signing in with Google: $e');
      // Handle sign-in errors
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to sign in with Google. Please try again later.'),
      ));
    }
  }
}
