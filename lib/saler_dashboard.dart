import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emandi/custombottomsheet.dart';
import 'package:emandi/navbar.dart';
import 'package:emandi/sellerDetailPage.dart';
import 'package:emandi/sellerpannel.dart';
import 'package:emandi/splash.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:emandi/model.dart';
import 'package:intl/intl.dart';

class sellerDashboard extends StatefulWidget {
  final String? email;

  sellerDashboard({Key? key, required this.email}) : super(key: key);

  @override
  State<sellerDashboard> createState() => _sellerDashboardState();
}

class _sellerDashboardState extends State<sellerDashboard> {
  // List<Data> _seller = [
  //   Data(
  //       image: 'assets/images/aseellala.png',
  //       title: 'Fighter Murga',
  //       postedDate: '2024-01-15',
  //       Rs: 'Rs 19,000',
  //       location: 'Lalamusa',
  //       category: 'livestock',
  //       age: '2 years',
  //       animalQuantity: '1',
  //       ownerName: 'Ali Raza',
  //       ownerPho: '03098765786',
  //       description: 'Bht hi beautiful Animal hain',
  //       views: '45',
  //       key: '#Fighter#High#Murga'),
  // ];
  List<Data> _dataList = [];
  List<Data> mainlist = [];
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
      _dataList =
          _dataList.where((_data) => _data.email == widget.email).toList();
    });
    print(_dataList.length);
  }

  Future<void> fetchData() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection("animals").get();
    setState(() {
      _dataList = querySnapshot.docs.where((doc) {
        Map<String, dynamic>? data =
            doc.data() as Map<String, dynamic>?; // Cast to Map
        return data != null &&
            data['email'] == widget.email; // Check for email match
      }).map((doc) {
        Map<String, dynamic> data =
            doc.data() as Map<String, dynamic>; // Cast to Map
        return Data(
          email: data['email'] ?? '',
          id: doc.id,
          image: data['profilePic'] ?? '',
          title: data['title'] ?? '',
          postedDate: data['PostedDate'] ?? '',
          Rs: data['price'] ?? '',
          location: data['location'] ?? '',
          key: data['keyword'] ?? '',
          views: data['views'] ?? '',
          age: data['age'] ?? '',
          description: data['description'] ?? '',
          ownerName: data['OwnerName'] ?? '',
          ownerPho: data['OwnerPho'] ?? '',
          animalQuantity: data['quantity'] ?? '',
          category: data['category'] ?? '',
        );
      }).toList();
      mainlist = _dataList;
    });

    print('Seller: >>>>>>>>>>>>>>>>>>>> ');
    print(_dataList);
  }

  Future<void> updateDocument(String documentId, Data newdata) async {
    try {
      Map<String, dynamic> dictData = {
        'profilePic': newdata.image,
        'title': newdata.title,
        // "postedDate": newdata., // Provide default value if null
        "price": newdata.Rs, // Provide default value if null
        "location": newdata.location, // Provide default value if null
        "keyword": newdata
            .key, // Provide default value if null// Provide default value if null
        "age": newdata.age, // Provide default value if null
        "description": newdata.description, // Provide default value if null
        "ownerName": newdata.ownerName, // Provide default value if null
        "ownerPho": newdata.ownerPho, // Provide default value if null
        "quantity": newdata.animalQuantity, // Provide default value if null
        "category": newdata.category
      };
      print(dictData);
      print(documentId);
      await FirebaseFirestore.instance
          .collection("animals")
          .doc(documentId) // Provide the document ID here
          .update(dictData); // Pass the new data to update
      print("Data Updated!");
    } catch (e) {
      print("Error updating data: $e");
    }
  }

  List<Data> filterListBySearch(List<Data> originalList, String targetTitle) {
    return originalList
        .where((data) =>
            data.title.toLowerCase().contains(targetTitle.toLowerCase()))
        .toList();
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
  bool searching = false;
  TextEditingController searchController = TextEditingController();
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: Container(
          decoration: BoxDecoration(
            color: Colors.teal, // Fill color
            border: Border.all(
              color: Colors.teal, // Border color
              width: 4, // Border width
            ),
            borderRadius: BorderRadius.circular(50), // Border radius
          ),
          child: IconButton(
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => seller(
                    email: widget.email ?? '',
                    dummy_image: '',
                    dummy_title: '',
                    dummy_location: '',
                    dummy_price: '',
                    dummy_key: '',
                    dummy_cate: '',
                    dummy_quantity: '',
                    dummy_age: '',
                    dummy_desc: '',
                    dummy_owner_name: '',
                    dummy_owner_pho: '',
                  ),
                ),
              );
              fetchData();
              // print(result);
            },
            icon: Icon(
              Icons.add,
              color: Colors.white, // Icon color
              size: 43,
            ),
          ),
        ),
        drawer: navBar(
          email: widget.email ?? '',
        ),
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          title: searching == false
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 48.0),
                      child: Text(
                        'eMandi app',
                        style: TextStyle(color: Colors.white),
                      ),
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
                          _dataList = filterListBySearch(mainlist, value);
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
                              _dataList = mainlist;
                            },
                          ),
                          hintText: 'Search...',
                          border: InputBorder.none),
                    ),
                  ),
                ),
          // centerTitle: true,

          backgroundColor: Colors.teal,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(

                  // bottomleft: Radius.circular(25),
                  bottomRight: Radius.circular(21),
                  bottomLeft: Radius.circular(21))),
        ),
        body: _dataList.isEmpty
            ? Center(
                child: Container(
                    height: 150,
                    width: 150,
                    child: Text('No any item uploaded')), // Loading indicator
              )
            : RefreshIndicator(
                onRefresh: () => fetchData(),
                child: Container(
                  width: double.infinity,
                  child: GridView.builder(
                    shrinkWrap: true,
                    itemCount: _dataList.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 5,
                        mainAxisExtent: 235),
                    itemBuilder: (context, index) {
                      return InkWell(
                        onLongPress: () {
                          showMenu(
                            color: Colors.teal,
                            context: context,
                            position: RelativeRect.fromLTRB(0, 0, 0, 0),
                            items: [
                              PopupMenuItem(
                                value: 'edit',
                                child: Text(
                                  'Edit',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              PopupMenuItem(
                                value: 'delete',
                                child: Text('Delete',
                                    style: TextStyle(color: Colors.white)),
                              ),
                            ],
                          ).then((value) async {
                            if (value == 'edit') {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => seller(
                                    email: widget.email ?? '',
                                    flag: 'edit',
                                    dummy_image: _dataList[index].image,
                                    dummy_id: _dataList[index].id,
                                    dummy_title: _dataList[index].title,
                                    dummy_location: _dataList[index].location,
                                    dummy_price: _dataList[index].Rs,
                                    dummy_key: _dataList[index].key,
                                    dummy_cate: _dataList[index].category,
                                    dummy_quantity:
                                        _dataList[index].animalQuantity,
                                    dummy_age: _dataList[index].age,
                                    dummy_desc: _dataList[index].description,
                                    dummy_owner_name:
                                        _dataList[index].ownerName,
                                    dummy_owner_pho: _dataList[index].ownerPho,
                                  ),
                                ),
                              );
                              if (result != null) {
                                setState(() {
                                  _dataList[index] = result;
                                  print('ID: -------');
                                  print(_dataList[index].id);
                                  updateDocument(
                                      _dataList[index].id, _dataList[index]);
                                });
                              }
                              // Handle edit action
                            } else if (value == 'delete') {
                              print(_dataList[index].id);
                              FirebaseFirestore.instance
                                  .collection("animals")
                                  .doc(_dataList[index].id)
                                  .delete();
                              setState(() {
                                _dataList.removeAt(index);
                              });
                            }
                          });
                        },
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    sellerDetailPage(temp: _dataList[index]),
                              ));
                        },
                        child: Column(
                          children: [
                            Container(
                              width: double.infinity,
                              height: 150.5,
                              decoration: BoxDecoration(
                                // color: Colors.amberAccent,
                                image: DecorationImage(
                                  image: NetworkImage(_dataList[index].image),
                                  fit: BoxFit
                                      .contain, // Adjust this as per your requirement
                                ),
                              ),
                            ),
                            Container(
                              height: 18,
                              child: Text(
                                _dataList[index].title,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                            ),
                            Container(
                                height: 21,
                                child: _dataList[index].postedDate != ''
                                    ? Text(
                                        'Posted ${DateTime.now().difference(DateFormat('yyyy-MM-dd').parse(_dataList[index].postedDate)).inDays}d ago')
                                    : Text('')),
                            Container(
                              height: 17,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 58.0),
                                child: Row(
                                  children: [
                                    Text(
                                      'Rs',
                                      style: TextStyle(
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 4.0),
                                      child: Text(
                                        _dataList[index].Rs,
                                        style: TextStyle(
                                            color: Colors.green,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              height: 20,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 45.0),
                                child: Row(
                                  children: [
                                    Icon(Icons.location_on),
                                    Text(_dataList[index].location)
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ));
  }
}
