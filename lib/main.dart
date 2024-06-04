import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emandi/animaldetail.dart';
import 'package:emandi/custombottomsheet.dart';
import 'package:emandi/firebase_options.dart';
import 'package:emandi/login.dart';
import 'package:emandi/map.dart';
import 'package:emandi/model.dart';
import 'package:emandi/navbar.dart';
import 'package:emandi/saler_dashboard.dart';
import 'package:emandi/sellerpannel.dart';
import 'package:emandi/splash.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

// import 'package:practice/model.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = 'pk_test_51PHi05Rvwlv5GWNuqmQMGc6xfMOkC5JJ'
      'AdeSzD9QPpDrt4TpxLNu02mq8pYjWBnkssdm2iuAuCyoZY5pWIFqcRUy00ktXNLffB';
  FirebaseApp app = await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'eMandi',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // iconTheme: IconThemeData(color: Colors.red),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: (FirebaseAuth.instance.currentUser != null)
          ? MyHomePage(
              email: FirebaseAuth.instance.currentUser?.email ?? '',
            )
          : SplashScreen(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String? email;

  MyHomePage({Key? key, required this.email}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Data> _photo = [];

// Usage
  String targetLocation = '';
  String targetCategory = '';
  List<Data> filteredList = [];
  var arrName = [
    'All Categories',
  ];
  var arrName3 = [
    'Birds',
  ];
  var arrName1 = [
    'Livestock',
  ];
  var arrName2 = [
    'Hen/Aseel',
  ];
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
    super.initState();
    fetchData();
    setState(() {
      filteredList = _photo;
    });
  }

  Future<void> fetchData() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection("animals").get();
    setState(() {
      _photo = [];
      List<Data> _dataList = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        print(data[0]);
        return Data(
          email: data['email'] ?? '',
          id: doc.id,
          image: data['profilePic'] ?? '', // Provide default value if null
          title: data['title'] ?? '', // Provide default value if null
          postedDate: data['PostedDate'] ?? '', // Provide default value if null
          Rs: data['price'] ?? '', // Provide default value if null
          location: data['location'] ?? '', // Provide default value if null
          key: data['keyword'] ?? '', // Provide default value if null
          views: data['views'] ?? '', // Provide default value if null
          age: data['age'] ?? '', // Provide default value if null
          description:
              data['description'] ?? '', // Provide default value if null
          ownerName: data['OwnerName'] ?? '', // Provide default value if null
          ownerPho: data['OwnerPho'] ?? '', // Provide default value if null
          animalQuantity:
              data['quantity'] ?? '', // Provide default value if null
          category: data['category'] ?? '', // Provide default value if null
        );
      }).toList();
      _photo = _photo + _dataList;
      print(_photo.length);
      filteredList = _photo;
    });
  }

  // String? _selectedCategory;
  // List<String> _categories = [
  //   'All Category',
  //   'Livestock',
  //   'Hen/Aseel',
  //   'Birds',
  // ];
  // String? _selectedArea;
  // List<String> _area = [
  //   'All mandi',
  //   'Gujranwala',
  //   'Sialkot',
  //   'Lalamusa',
  //   'Gujrat',
  // ];

  bool searching = false;
  TextEditingController searchController = TextEditingController();
  RangeValues values = RangeValues(0, 10);
  List<Data> filterListByLocation(
      List<Data> originalList, String targetLocation) {
    return originalList
        .where((data) =>
            data.location.toLowerCase() == targetLocation.toLowerCase())
        .toList();
  }

  List<Data> filterListByCategory(
      List<Data> originalList, String targetCategory) {
    return originalList
        .where((data) =>
            data.category.toLowerCase() == targetCategory.toLowerCase())
        .toList();
  }

  List<Data> filterListBySearch(List<Data> originalList, String targetTitle) {
    return originalList
        .where((data) =>
            data.title.toLowerCase().contains(targetTitle.toLowerCase()))
        .toList();
  }

  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    RangeLabels labels =
        RangeLabels(values.start.toString(), values.end.toString());
    print(widget.email);
    return Scaffold(
        drawer: navBar(
          email: widget.email ?? '',
        ),
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          title: searching == false
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'eMandi app',
                      style: TextStyle(color: Colors.white),
                    ),
                    IconButton(
                      icon: const Icon(Icons.search, color: Colors.white),
                      onPressed: () {
                        searching = true;
                        setState(() {});
                      },
                    ),
                  ],
                )
              : Container(
                  width: double.infinity,
                  height: 40,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(13)),
                  child: Center(
                    child: TextField(
                      controller: searchController,
                      onChanged: (value) {
                        setState(() {
                          filteredList =
                              filterListBySearch(filteredList, value);
                        });
                      },
                      decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.search),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              searching = false;
                              setState(() {});
                              searchController.clear();
                              filteredList = _photo;
                            },
                          ),
                          hintText: 'Search...',
                          border: InputBorder.none),
                    ),
                  ),
                ),
          // centerTitle: true,
          actions: <Widget>[
            IconButton(
              icon: const Icon(
                Icons.read_more,
                size: 28,
                // color: Colors.white,
              ),
              onPressed: () async {
                setState(() {});
                List<Data>? dummy_List = await showModalBottomSheet<List<Data>>(
                  context: context,
                  builder: (context) => bottomSheet(
                    data: _photo,
                  ),
                );

// Check if the result is not null
                if (dummy_List != null) {
                  setState(() {
                    filteredList = dummy_List;
                  });
                }
              },
            )
          ],
          backgroundColor: Colors.teal,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(

                  // bottomleft: Radius.circular(25),
                  bottomRight: Radius.circular(21),
                  bottomLeft: Radius.circular(21))),
        ),
        body: Container(
          height: double.infinity,
          width: double.infinity,
          child: Column(
            children: [
              Container(
                height: screenSize.height * 0.09,
                width: double.infinity,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Container(
                        width: 220,
                        height: 100,
                        color: Colors.white70,
                        child: ListView.separated(
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                if (targetLocation != '') {
                                  setState(() {
                                    filteredList = filterListByLocation(
                                        _photo, targetLocation);
                                  });
                                } else {
                                  setState(() {
                                    filteredList = _photo;
                                  });
                                }
                                // setState(() {
                                //   filteredList = filterListByLocation(
                                //       _photo, targetLocation);
                                // });
                              },
                              child: ListTile(
                                leading: CircleAvatar(
                                  child:
                                      Image.asset('assets/images/allcate.png'),
                                ),
                                title: Text(arrName[index]),
                                subtitle: Text('3450 + Ads'),
                                // trailing: Icon(Icons.access_alarm_sharp),
                              ),
                            );
                          },
                          itemCount: arrName.length,
                          separatorBuilder: (context, index) {
                            return Divider(
                              height: 100,
                            );
                          },
                        ),
                      ),
                      Container(
                        width: 220,
                        height: 100,
                        color: Colors.white70,
                        child: ListView.separated(
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                if (targetLocation != '') {
                                  setState(() {
                                    filteredList = filterListByLocation(
                                        _photo, targetLocation);
                                  });
                                } else {
                                  setState(() {
                                    filteredList = _photo;
                                  });
                                }
                                setState(() {
                                  targetCategory = 'Livestock';
                                  filteredList = filterListByCategory(
                                      filteredList, targetCategory);
                                });
                              },
                              child: ListTile(
                                leading: CircleAvatar(
                                  child: Image.asset(
                                      'assets/images/livestock.png'),
                                ),
                                title: Text(arrName1[index]),
                                subtitle: Text('4984 + Ads'),
                                // trailing: Icon(Icons.access_alarm_sharp),
                              ),
                            );
                          },
                          itemCount: arrName.length,
                          separatorBuilder: (context, index) {
                            return Divider(
                              height: 100,
                            );
                          },
                        ),
                      ),
                      Container(
                        width: 220,
                        height: 100,
                        color: Colors.white70,
                        child: ListView.separated(
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                if (targetLocation != '') {
                                  setState(() {
                                    filteredList = filterListByLocation(
                                        _photo, targetLocation);
                                  });
                                } else {
                                  setState(() {
                                    filteredList = _photo;
                                  });
                                }
                                setState(() {
                                  targetCategory = 'Hen/Aseel';
                                  filteredList = filterListByCategory(
                                      filteredList, targetCategory);
                                });
                              },
                              child: ListTile(
                                leading: CircleAvatar(
                                  child: Image.asset('assets/images/img_6.png'),
                                ),
                                title: Text(arrName2[index]),
                                subtitle: Text('4977 + Ads'),
                                // trailing: Icon(Icons.access_alarm_sharp),
                              ),
                            );
                          },
                          itemCount: arrName.length,
                          separatorBuilder: (context, index) {
                            return Divider(
                              height: 100,
                            );
                          },
                        ),
                      ),
                      Container(
                        width: 220,
                        height: 100,
                        color: Colors.white70,
                        child: ListView.separated(
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                if (targetLocation != '') {
                                  setState(() {
                                    filteredList = filterListByLocation(
                                        _photo, targetLocation);
                                  });
                                } else {
                                  setState(() {
                                    filteredList = _photo;
                                  });
                                }
                                setState(() {
                                  targetCategory = 'Birds';
                                  filteredList = filterListByCategory(
                                      filteredList, targetCategory);
                                });
                              },
                              child: ListTile(
                                leading: CircleAvatar(
                                  child: Image.asset('assets/images/birds.png'),
                                ),
                                title: Text(arrName3[index]),
                                subtitle: Text('3117 + Ads'),
                                // trailing: Icon(Icons.access_alarm_sharp),
                              ),
                            );
                          },
                          itemCount: arrName.length,
                          separatorBuilder: (context, index) {
                            return Divider(
                              height: 100,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                child: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: ElevatedButton.icon(
                        onPressed: () async {
                          List<Data>? dataList = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MapScreen(photo: _photo),
                            ),
                          );

                          if (dataList != null && dataList.isNotEmpty) {
                            print(dataList[0]);
                            setState(() {
                              filteredList = dataList;
                            });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            backgroundColor: Colors.teal,
                            minimumSize: Size(350, 40)),
                        label: Text(
                          'View Nearby Mandi',
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                        icon: Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Icon(Icons.location_on, color: Colors.white),
                        ))),
              ),
              Container(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => sellerDashboard(
                            email: widget.email,
                          ),
                        ));
                  },
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      backgroundColor: Colors.teal,
                      minimumSize: Size(350, 40)),
                  child: Text(
                    'Seller Pannel',
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ),
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () => fetchData(),
                  child: Container(
                    height: screenSize.height * 0.670,
                    width: double.infinity,
                    child: GridView.builder(
                      shrinkWrap: true,
                      itemCount: filteredList.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 5,
                          mainAxisExtent: 235),
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            print(filteredList[index].ownerPho);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => animalDetail(
                                    temp: filteredList[index],
                                    email: widget.email ?? '',
                                  ),
                                ));
                          },
                          child: Container(
                            child: Column(
                              children: [
                                Container(
                                  width: double.infinity,
                                  height: 150.5,
                                  decoration: BoxDecoration(
                                    // color: Colors.amberAccent,
                                    image: DecorationImage(
                                      image: filteredList[index]
                                              .image
                                              .startsWith('https')
                                          ? NetworkImage(
                                              filteredList[index].image)
                                          : AssetImage(
                                                  filteredList[index].image)
                                              as ImageProvider<Object>,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 18,
                                  child: Text(
                                    filteredList[index].title,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                  ),
                                ),
                                Container(
                                    height: 21,
                                    child: filteredList[index].postedDate != ''
                                        ? Text(
                                            'Posted ${DateTime.now().difference(DateFormat('yyyy-MM-dd').parse(filteredList[index].postedDate)).inDays}d ago')
                                        : Text('')),
                                Container(
                                  height: 17,
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 62.0, right: 6),
                                        child: Text(
                                          'Rs',
                                          style: TextStyle(
                                              color: Colors.green,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Text(
                                        filteredList[index].Rs,
                                        style: TextStyle(
                                            color: Colors.green,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 20,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 45.0),
                                    child: Row(
                                      children: [
                                        Icon(Icons.location_on),
                                        Text(filteredList[index].location)
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
