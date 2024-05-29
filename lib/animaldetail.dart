import 'dart:convert';

import 'package:emandi/forgotpass.dart';
import 'package:emandi/model.dart';
import 'package:emandi/splash.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

class animalDetail extends StatefulWidget {
  Data temp;
  animalDetail({super.key, required this.temp});
  @override
  State<animalDetail> createState() => _animalDetailState();
}

class _animalDetailState extends State<animalDetail> {
  Map<String, dynamic>? paymentIntentData;

  var _detail = Data(
      email: 'asif@gmail.com',
      image: 'assets/images/cow.png',
      title: 'Cross Jersey Cow',
      postedDate: '',
      Rs: 'Rs 299,000',
      location: 'Gujranwala',
      key: '#Cross#High#Quality#Cow',
      views: '45',
      age: '2 Years',
      animalQuantity: '1',
      category: 'Cow',
      description:
          'Assalam Alaikum my friends, Bht ee beautiful animal hain color brown hain',
      ownerName: 'Ali Raza',
      ownerPho: '03095480334');
  String? _selectedCategory;
  List<String> _categories = [
    'All Category',
    'Livestock',
    'Hen/Aseel',
    'Birds',
  ];
  String? _selectedArea;
  List<String> _area = [
    'All mandi',
    'Gujranwala',
    'Sialkot',
    'Lalamusa',
    'Gujrat',
  ];
  late Uri whatsapp;

  void logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.popUntil(context, (route) => route.isFirst);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => SplashScreen(),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      _detail = widget.temp;
      whatsapp = Uri.parse('http://wa.me/'
          '${widget.temp.ownerPho.startsWith('0') ? '+'
              '92${widget.temp.ownerPho.substring(1)}' : widget.temp.ownerPho}');
    });
  }

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
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 300,
                  height: 200,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 48, top: 11.0),
                    child: Center(
                      child: _detail.image.startsWith('https')
                          ? Image.network(_detail.image)
                          : Image.asset(_detail.image),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 22, top: 18.0),
                  child: Text(
                    _detail.key,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 26,
                  ),
                  child: Text(
                    _detail.title,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8, left: 18.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.location_on),
                          Text(_detail.location),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 18.0),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 6, left: 18.0),
                        child: Icon(
                          Icons.money,
                          color: Colors.green,
                          size: 31,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0, left: 8),
                        child: Column(
                          children: [
                            Text('Price(PKR)'),
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: Text(
                                    'Rs',
                                    style: TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Text(
                                  _detail.Rs,
                                  style: TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                          padding: const EdgeInsets.only(left: 90.0, right: 8),
                          child: InkWell(
                            onTap: () {
                              launchUrl(whatsapp);
                            },
                            child: Image.asset(
                              'assets/images/whatsapp.png',
                              width: 40,
                              height: 40,
                            ),
                          )),
                      Container(
                        child: IconButton(
                            onPressed: () => launch(
                                "tel://${widget.temp.ownerPho.startsWith('0') ? '+92${widget.temp.ownerPho.substring(1)}' : widget.temp.ownerPho}"),
                            icon: Icon(Icons.call)),
                        // decoration: BoxDecoration(
                        //     border: Border(
                        //         top: BorderSide(width: 2.0),
                        //         bottom: BorderSide(width: 2.0),
                        //         left: BorderSide(width: 2.0),
                        //         right: BorderSide(width: 2.0))),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(top: 13.0, left: 13, right: 10),
                  child: ElevatedButton(
                    onPressed: () async {
                      await makePayment();
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade200,
                        minimumSize: Size(300, 45)),
                    child: Row(
                      children: [
                        Text(
                          'Buy with Payment guarantee',
                          style: TextStyle(color: Colors.red),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 75.0),
                          child: Icon(
                            Icons.navigate_next,
                            color: Colors.red,
                            size: 32,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    color: Colors.green.shade100,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            'Features',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 17),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Row(
                            children: [
                              Icon(Icons.category),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text('Category'),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 108.0, top: 13),
                                          child: Row(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 11.0),
                                                child: Icon(Icons
                                                    .format_list_numbered_sharp),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 8.0),
                                                child: Column(
                                                  children: [
                                                    Text('Animal Quantity'),
                                                    Text(
                                                        _detail.animalQuantity),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 6.0),
                                      child: Text(_detail.category),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 8, top: 58.0),
                              child: Icon(Icons.support_agent),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 8.0, top: 58),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Age'),
                                  Text(_detail.age),
                                ],
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Description',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(_detail.description),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, top: 10),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        "assets/images/star.svg",
                        height: 17,
                        width: 17,
                        color: Colors.orange,
                      ),
                      // Icon(
                      //   Icons.star_border_outlined,
                      //   color: Colors.orange,
                      //   size: 18,
                      // ),
                      Text(
                        "  Reviews",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 17),
                      ),
                      Text(
                        " (7 Reviews)",
                        style: TextStyle(
                          fontFamily: "Manrope",
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 30.0,
                  ),
                  child: Text(
                    "4.67 Stars",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        color: Colors.orange),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, left: 8),
                  child: Text(
                    'Owner Information',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                  ),
                ),
                Container(
                  color: Colors.amberAccent.shade100,
                  child: Row(
                    children: [
                      Icon(
                        Icons.person,
                        size: 55,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _detail.ownerName,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                _detail.ownerPho,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
                // decoration: BoxDecoration(
                //     border: Border(
                //         top: BorderSide(width: 2.0),
                //         bottom: BorderSide(width: 2.0),
                //         left: BorderSide(width: 2.0),
                //         right: BorderSide(width: 2.0))),
              ],
            ),
          ),
        ));
  }

//
//   Future<void> makePayment() async {
//     try {
//       paymentIntentData = await createPaymentIntent("20", 'USD');
//       await Stripe.instance.initPaymentSheet(
//           paymentSheetParameters: SetupPaymentSheetParameters(
//               paymentIntentClientSecret: paymentIntentData!['client_secret'],
//               // style: ThemeMode.dark,
//               googlePay: PaymentSheetGooglePay(merchantCountryCode: 'US'),
//               merchantDisplayName: 'Fahad'));
//       displayPaymentSheet();
//     } catch (e) {
//       print('exception' + e.toString());
//     }
//   }
//
//   displayPaymentSheet() async {
//     try {
//       await Stripe.instance.presentPaymentSheet().then((value) {
//         setState(() {
//           paymentIntentData = null;
//         });
//       });
//
//       MyToast.myShowToast('Paid Successfully');
//     } on StripeException catch (e) {
//       print(e.toString());
//       showDialog(
//           context: context,
//           builder: (_) => AlertDialog(
//                 content: Text('Cancelled'),
//               ));
//     }
//   }
//
//   createPaymentIntent(String amount, String currency) async {
//     try {
//       Map<String, dynamic> body = {
//         'amount': calculateAmount(amount),
//         'currency': currency,
//         'payment_method_types[]': 'card'
//       };
//
//       var response = await http.post(
//         Uri.parse('http://api.stripe.com/v1/payment_intents'),
//         body: body,
//         headers: {
//           'Authorization':
//               'Bearer sk_test_51PHi05Rvwlv5GWNu60409WwLGu5PTpfEMHr5SSEXnw2ZeWIKfyilRLHTdXAvJtt0EQFNGyJCi840qKPUG4UbVwEh00oV38wlxa',
//           'Content-Type': 'application/x-www-form-urlencoded'
//         },
//       );
//       return jsonDecode(response.body.toString());
//     } catch (e) {
//       print('exception' + e.toString());
//     }
//   }
//
//   calculateAmount(String amount) {
//     final price = int.parse(amount) * 100;
//     return price.toString();
//   }
// }
  Future<void> makePayment() async {
    try {
      paymentIntentData = await createPaymentIntent(_detail.Rs, "USD");
      if (paymentIntentData != null &&
          paymentIntentData!['client_secret'] != null) {
        await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
            paymentIntentClientSecret: paymentIntentData!['client_secret'],
            googlePay: const PaymentSheetGooglePay(
              merchantCountryCode: 'US',
            ),
            merchantDisplayName: 'CaterLink',
          ),
        );

        displayPaymentSheet();
      } else {
        print("Failed to create payment intent");
      }
    } catch (e) {
      print("exception: $e");
    }
  }

  Future<void> displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet().then((value) {
        setState(() {
          paymentIntentData = null;
        });
      });
    } catch (e) {
      print("exception: $e");
    }
  }

  Future<Map<String, dynamic>?> createPaymentIntent(
      String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
        'payment_method_types[]': 'card',
      };

      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        body: body,
        headers: {
          'Authorization':
              'Bearer sk_test_51PHi05Rvwlv5GWNu60409WwLGu5PTpfEMHr5SSEXnw2ZeWIKfyilRLHTdXAvJtt0EQFNGyJCi840qKPUG4UbVwEh00oV38wlxa',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
      );

      return jsonDecode(response.body);
    } catch (e) {
      print("exception: $e");
      return null;
    }
  }

  String calculateAmount(String amount) {
    String amountWithoutCommas = amount.replaceAll(',', '');
    final price = int.parse(amountWithoutCommas) * 100;
    return price.toString();
  }
}
