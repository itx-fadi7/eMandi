import 'package:flutter/material.dart';

class polices extends StatefulWidget {
  const polices({super.key});

  @override
  State<polices> createState() => _policesState();
}

class _policesState extends State<polices> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          'eMandi app',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.teal,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(

                // bottomleft: Radius.circular(25),
                bottomRight: Radius.circular(21),
                bottomLeft: Radius.circular(21))),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Container(
          child: Text('"Our app is commi'
              'tted to ensuring the privacy, security, and transparency o'
              'f our users data and interactions. Our Privacy Poli'
              'cy outlines how we collect, use, and protect user information, while our Term'
              's of Service establish the rules and guidelines for app usage. We adhere to strict security measures outlined in our Security Policy to safeguard user data and maintain the integrity of our platform. Additionally, our Cookie Policy explains the use of cookies and similar tracking technologies. We enforce Community Guidelines to foster a respectful and safe environment for all users. Our Refund Policy outlines procedures for refunds, and we comply with accessibility standards to ensure inclusivity. For users under 13, our Childrens Privacy Policy complies with COPPA regulations, and for EU users, we adhere to GDPR standards. By using our app, users agree to abide by these policies, w'
              'hich are designed to uphold the trust and integrity of our community."'),
        ),
      ),
    );
  }
}
