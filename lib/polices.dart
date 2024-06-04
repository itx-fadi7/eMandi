import 'package:flutter/material.dart';

class policies extends StatefulWidget {
  const policies({super.key});

  @override
  State<policies> createState() => _policiesState();
}

class _policiesState extends State<policies> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          'eMandi App',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.teal,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(21),
            bottomLeft: Radius.circular(21),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Privacy Policy',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Our app is committed to ensuring the privacy, security, and transparency of our users data and interactions. Our Privacy Policy outlines how we collect, use, and protect user information.',
            ),
            SizedBox(height: 20),
            Text(
              'Terms of Service',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Our Terms of Service establish the rules and guidelines for app usage.',
            ),
            SizedBox(height: 20),
            Text(
              'Security Policy',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'We adhere to strict security measures outlined in our Security Policy to safeguard user data and maintain the integrity of our platform.',
            ),
            SizedBox(height: 20),
            Text(
              'Cookie Policy',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Our Cookie Policy explains the use of cookies and similar tracking technologies.',
            ),
            SizedBox(height: 20),
            Text(
              'Community Guidelines',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'We enforce Community Guidelines to foster a respectful and safe environment for all users.',
            ),
            SizedBox(height: 20),
            Text(
              'Refund Policy',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Our Refund Policy outlines procedures for refunds.',
            ),
            SizedBox(height: 20),
            Text(
              'Accessibility',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'We comply with accessibility standards to ensure inclusivity.',
            ),
            SizedBox(height: 20),
            Text(
              'Children\'s Privacy Policy',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'For users under 13, our Children\'s Privacy Policy complies with COPPA regulations.',
            ),
            SizedBox(height: 20),
            Text(
              'GDPR Compliance',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'For EU users, we adhere to GDPR standards.',
            ),
            SizedBox(height: 20),
            Text(
              'Conclusion',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'By using our app, users agree to abide by these policies, which are designed to uphold the trust and integrity of our community.',
            ),
          ],
        ),
      ),
    );
  }
}
