import 'package:flutter/material.dart';

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
          title: Text('eMandi App'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Container(
            child: Text(
                'eMandi - Your Digital Marketplace for Agriculture Version: 2.0.1 Description: eMandi is a revolutionary mobile app that connects farmers, traders, and consumers in a seamless digital marketplace for agricultural produce. With eMandi, farmers can sell their crops directly to buyers, eliminating intermediaries and ensuring fair prices. Buyers can browse a wide range of fresh produce and place orders conveniently from their smartphones. Our mission is to empower farmers, promote fair trade, and enhance food security through technology. Developer: eMandi Technologies Pvt Ltd Contact: support@emandi.com Website: www.emandi.com Credits and Acknowledgments: We acknowledge the use of the Flutter framework for building the eMandi app. Special thanks to the open-source community for their contributions to libraries and tools used in this projectTerms of Service: Please read our Terms of Service carefully before using the eMandi app'),
          ),
        ));
  }
}
