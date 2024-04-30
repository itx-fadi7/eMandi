import 'package:emandi/forgotpass.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class forgotPassword extends StatefulWidget {
  const forgotPassword({Key? key}) : super(key: key);

  @override
  State<forgotPassword> createState() => _forgotPasswordState();
}

class _forgotPasswordState extends State<forgotPassword> {
  TextEditingController emailText = TextEditingController();
  final auth = FirebaseAuth.instance;

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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: emailText,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    hintText: 'Email Address',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(11),
                        borderSide: BorderSide(color: Colors.pink, width: 3)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(11),
                        borderSide: BorderSide(color: Colors.teal, width: 3)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(11),
                        borderSide:
                            BorderSide(color: Colors.black54, width: 3)),
                    prefixIcon: Icon(
                      Icons.email,
                      color: Colors.blueAccent,
                    )),
              ),
            ),
            Container(height: 26),
            ElevatedButton(
              onPressed: () {
                auth
                    .sendPasswordResetEmail(email: emailText.text.toString())
                    .then((value) {
                  MyToast.myShowToast(
                      'We have send you email to recover password, Please check email');
                }).catchError((error) {
                  MyToast.myShowToast(error.toString());
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                minimumSize: Size(250, 45),
              ),
              child: Text('Forgot'),
            )
          ],
        ),
      ),
    );
  }
}
