import 'package:emandi/model.dart';
import 'package:emandi/splash.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class sellerDetailPage extends StatefulWidget {
  Data temp;
  sellerDetailPage({super.key, required this.temp});
  @override
  State<sellerDetailPage> createState() => _sellerDetailPageState();
}

class _sellerDetailPageState extends State<sellerDetailPage> {
  var _detail = Data(
      email: '20011598-014@uog.edu.pk',
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
          actions: <Widget>[
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.search, color: Colors.white),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(
                    Icons.read_more,
                    size: 28,
                    // color: Colors.white,
                  ),
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) => SingleChildScrollView(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 16.0, top: 16.0, bottom: 69),
                                      child: Text(
                                        'Filter',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 216.0, top: 16.0, bottom: 69),
                                      child: TextButton(
                                        onPressed: () {
                                          Navigator.of(context)
                                              .pop(); // Close the bottom sheet
                                        },
                                        child: Text(
                                          'Close',
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Align(
                                  alignment: Alignment.topLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 22.0, bottom: 6),
                                    child: Text(
                                      'Select Category',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 18.0, right: 18),
                                child: DropdownButtonFormField(
                                  value: _selectedCategory,
                                  items: _categories.map((String category) {
                                    return DropdownMenuItem(
                                      value: category,
                                      child: Text(category),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedCategory = value;
                                    });
                                  },
                                  decoration: InputDecoration(
                                    hintText: 'Select Category',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(11),
                                      borderSide: BorderSide(
                                        color: Colors.pink,
                                        width: 3,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(11),
                                      borderSide: BorderSide(
                                        color: Colors.teal,
                                        width: 3,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(11),
                                      borderSide: BorderSide(
                                        color: Colors.black54,
                                        width: 3,
                                      ),
                                    ),
                                    contentPadding: EdgeInsets.symmetric(
                                      vertical: 16,
                                      horizontal: 16,
                                    ),
                                  ),
                                ),
                              ),
                              Align(
                                  alignment: Alignment.topLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 22.0, bottom: 6, top: 8),
                                    child: Text(
                                      'Select Area',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 18.0, right: 18),
                                child: DropdownButtonFormField(
                                  value: _selectedArea,
                                  items: _area.map((String category) {
                                    return DropdownMenuItem(
                                      value: category,
                                      child: Text(category),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedArea = value;
                                    });
                                  },
                                  decoration: InputDecoration(
                                    hintText: 'Select Area',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(11),
                                      borderSide: BorderSide(
                                        color: Colors.pink,
                                        width: 3,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(11),
                                      borderSide: BorderSide(
                                        color: Colors.teal,
                                        width: 3,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(11),
                                      borderSide: BorderSide(
                                        color: Colors.black54,
                                        width: 3,
                                      ),
                                    ),
                                    contentPadding: EdgeInsets.symmetric(
                                      vertical: 16,
                                      horizontal: 16,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 12.0, left: 22, bottom: 8),
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    'Max Price(PKR)',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 18.0,
                                  right: 18,
                                ),
                                child: TextField(
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                    hintText: 'Enter Price',
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(11),
                                        borderSide: BorderSide(
                                            color: Colors.pink, width: 3)),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(11),
                                        borderSide: BorderSide(
                                            color: Colors.teal, width: 3)),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(11),
                                        borderSide: BorderSide(
                                            color: Colors.black54, width: 3)),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 12.0, left: 22, bottom: 18),
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    'Select Age',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                )
              ],
            )
          ],
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
                      child: Center(child: Image.network(_detail.image)),
                    )),
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
                                  padding: const EdgeInsets.only(right: 6.0),
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
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return Center(
                              child: Container(
                                width: 340,
                                // height: 10,
                                child: Image.asset('assets/images/zamant.png'),
                              ),
                            );
                          });
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
}
