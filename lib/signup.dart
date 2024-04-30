import 'dart:math';
import 'dart:developer' as developer;
import 'package:emandi/forgotpass.dart';
import 'package:emandi/login.dart';
import 'package:emandi/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class signUp extends StatefulWidget {
  @override
  State<signUp> createState() => _DashBoardState();
}

class _DashBoardState extends State<signUp> {
  TextEditingController emailText = TextEditingController();
  TextEditingController passText = TextEditingController();
  TextEditingController cpassText = TextEditingController();

  void creatAcount() async {
    String email = emailText.text.trim();
    String password = passText.text.trim();
    String cpassword = cpassText.text.trim();
    if (email == "" || password == "" || cpassword == "") {
      MyToast.myShowToast('Please fill all the details!');
      developer.log("");
    } else if (password != cpassword) {
      MyToast.myShowToast('password do not match!');
      developer.log("");
    } else {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);
        if (userCredential != null) {
          FirebaseAuth.instance.currentUser!.sendEmailVerification();
          Navigator.popUntil(context, (route) => route.isFirst);
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => loginPage(),
              ));
        }
      } on FirebaseAuthException catch (ex) {
        MyToast.myShowToast(ex.code.toString());
      }
    }
  }

  bool passwordObsured = true;
  bool passwordObsuredCon = true;
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
                          padding: const EdgeInsets.only(top: 28.0),
                          child: CircleAvatar(
                            backgroundImage:
                                AssetImage('assets/images/logo.jpg'),
                            maxRadius: 70,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Text(
                            'Lets Join Our Community',
                            style: TextStyle(
                                fontSize: 19, fontWeight: FontWeight.w700),
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
                          obscureText: passwordObsured,
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
                                  passwordObsured
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                ),
                                onPressed: () {
                                  setState(() {
                                    passwordObsured = !passwordObsured;
                                  });
                                },
                              )),
                        ),
                        Container(height: 15),
                        TextField(
                          controller: cpassText,
                          obscureText: passwordObsuredCon,
                          obscuringCharacter: '*',
                          decoration: InputDecoration(
                              hintText: 'Confirm Password',
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
                                  passwordObsuredCon
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                ),
                                onPressed: () {
                                  setState(() {
                                    passwordObsuredCon = !passwordObsuredCon;
                                  });
                                },
                              )),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: ElevatedButton(
                            onPressed: () {
                              creatAcount();
                            },
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18)),
                                backgroundColor: Colors.teal,
                                minimumSize: Size(276, 40)),
                            child: Text(
                              'SIGN UP',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text('-OR-',
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w400)),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(18.0),
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
                                  onTap: () async {
                                    var result = await signInWithGoogle();
                                    if (result.user != null) {
                                      print(
                                          'LoginSuccess - name , email : ${result.user!.displayName!}, ${result.user!.email!} ');
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                        builder: (context) => MyHomePage(
                                          email: result.user?.email,
                                        ),
                                      ));
                                    } else {
                                      MyToast.myShowToast(
                                          'Error While Login with Google!');
                                    }
                                  },
                                  child: CircleAvatar(
                                    backgroundImage:
                                        AssetImage('assets/images/google.png'),
                                    radius: 30,
                                    // Adjust the radius to increase the size
                                  ),
                                ),
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

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}
