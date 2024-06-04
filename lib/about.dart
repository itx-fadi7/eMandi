import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class about extends StatefulWidget {
  const about({super.key});

  @override
  State<about> createState() => _aboutState();
}

class _aboutState extends State<about> {
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
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'eMandi - Your Digital Marketplace for Animals',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Version: 1.0.0',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 10),
            Text(
              'Description:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            Text(
              'eMandi is a revolutionary mobile app that connects farmers, traders, and buyers in a seamless digital marketplace for agricultural produce. With eMandi, farmers can sell their animals directly to buyers, eliminating intermediaries and ensuring fair prices. Buyers can browse a wide range of animals and place orders conveniently from their smartphones. Our mission is to empower farmers, promote fair livestocks trading, and optimimize trading through technology.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              'Developer:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            Text(
              'eMandi Technologies Pvt Ltd',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 5),
            Text(
              'A project of oxmDev',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Contact:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            GestureDetector(
              onTap: () => _launchURL('mailto:support@emandi.com'),
              child: Text(
                'support@emandi.com',
                style: TextStyle(fontSize: 16, color: Colors.blue),
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Website:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            GestureDetector(
              onTap: () => _launchURL('https://www.emandi.com'),
              child: Text(
                'www.emandi.com',
                style: TextStyle(fontSize: 16, color: Colors.blue),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Credits and Acknowledgments:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            Text(
              'We acknowledge the use of the Flutter framework for building the eMandi app. Special thanks to our great mentor ans supervisor.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              'Terms of Service:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            Text(
              'Please read our Terms of Service carefully before using the eMandi app.',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
