import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emandi/forgotpass.dart';
import 'package:emandi/model.dart';
import 'package:emandi/imagecontroller.dart';
import 'package:emandi/navbar.dart';
import 'package:emandi/splash.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
// import 'package:emandi/selleroutput.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

class seller extends StatefulWidget {
  String email = '';
  String flag;
  String dummy_image = '';
  String dummy_title = '';
  String dummy_location = '';
  String dummy_price = '';
  String dummy_key = '';
  String dummy_cate = '';
  String dummy_quantity = '';
  String dummy_age = '';
  String dummy_desc = '';
  String dummy_owner_pho = '';
  String dummy_owner_name = '';
  String dummy_id;
  seller({
    super.key,
    this.flag = '',
    this.dummy_id = '',
    required this.dummy_image,
    required this.dummy_title,
    required this.dummy_location,
    required this.dummy_price,
    required this.dummy_key,
    required this.dummy_cate,
    required this.dummy_quantity,
    required this.dummy_age,
    required this.dummy_desc,
    required this.dummy_owner_name,
    required this.dummy_owner_pho,
    required this.email,
  });

  @override
  State<seller> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<seller> {
  String _selectedUnit = 'years';
  DateTime now = DateTime.now();
  String formattedDate = '';
  imagePickerController controller = Get.put(imagePickerController());
  // TextEditingController _img = new TextEditingController();
  TextEditingController _title = new TextEditingController();
  String _location = '';
  TextEditingController _price = new TextEditingController();
  TextEditingController _keywords = new TextEditingController();
  String _category = '';
  TextEditingController _quantity = new TextEditingController();
  TextEditingController _age = new TextEditingController();
  TextEditingController _description = new TextEditingController();
  TextEditingController _ownerName = new TextEditingController();
  TextEditingController _ownerPho = new TextEditingController();
  File? profilePic;
  bool _isTitleEmpty = true;
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

  bool _categoryError = false;
  bool _locationError = false;
  bool _priceError = false;
  bool _keywordsError = false;

  bool _quantityError = false;
  bool _ageError = false;
  bool _descriptionError = false;
  bool _ownerNameError = false;
  bool _ownerPhoError = false;
  bool _titleError = false;
  void saveData() async {
    // Extract data from text controllers
    String email = widget.email;
    print('*****************');
    print(email);
    print(widget.email);
    String title = _title.text.trim();
    String location = _location;
    String price = _price.text.trim();
    String keyword = _keywords.text.trim();
    String category = _category;
    String quantity = _quantity.text.trim();
    String age = _age.text.trim();
    String description = _description.text.trim();
    String ownerName = _ownerName.text.trim();
    String pho = _ownerPho.text.trim();
    String postedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

    if (title.isNotEmpty &&
        location.isNotEmpty &&
        price.isNotEmpty &&
        category.isNotEmpty &&
        quantity.isNotEmpty &&
        age.isNotEmpty &&
        ownerName.isNotEmpty &&
        pho.isNotEmpty) {
      // Prepare the data to be added to Firestore
      Map<String, dynamic> newData = {
        "title": title,
        "location": location,
        "price": price,
        "Keywords": keyword,
        "category": category,
        "quantity": quantity,
        "age": age + _selectedUnit,
        "description": description,
        "OwnerName": ownerName,
        "OwnerPho": pho,
        'PostedDate': postedDate,
        'email': email
        // Add other fields as needed
      };
      // print(email);
      // Check if a profile picture is selected
      if (profilePic != null) {
        // Upload the image to Firebase Storage
        try {
          UploadTask uploadTask = FirebaseStorage.instance
              .ref()
              .child("profilePicture")
              .child(Uuid().v1())
              .putFile(profilePic!);

          TaskSnapshot taskSnapshot = await uploadTask;
          String downloadUrl = await taskSnapshot.ref.getDownloadURL();

          // Add the image URL to the data
          newData["profilePic"] = downloadUrl;
        } catch (e) {
          // Handle any errors that occur during image upload
          print("Error uploading image: $e");
        }
      }

      // Add the new data to Firestore
      try {
        await FirebaseFirestore.instance.collection("animals").add(newData);

        // Data added successfully, you can perform any additional actions here
        print("Data added successfully!");
      } catch (e) {
        // Handle any errors that occur during the Firestore operation
        print("Error adding data to Firestore: $e");
      }

      // Navigate back after data is added
      Navigator.pop(context);
    } else {
      // Show error message for empty fields
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill in all fields.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // setState(() {
    //   ;
    // });
    print(widget.email);
    setState(() {
      _title.text = widget.dummy_title;
      _price.text = widget.dummy_price;
      _location = widget.dummy_location;
      _keywords.text = widget.dummy_key;
      _category = widget.dummy_cate;
      _age.text = widget.dummy_age;
      _description.text = widget.dummy_desc;
      _ownerPho.text = widget.dummy_owner_pho;
      _quantity.text = widget.dummy_quantity;
      _ownerName.text = widget.dummy_owner_name;
    });
  }

  String? _selectedCategory;
  List<String> _categories = [
    'Livestock',
    'Hen/Aseel',
    'Birds',
  ];
  String? _selectedArea;
  List<String> _area = [
    'Gujranwala',
    'Sialkot',
    'Lalamusa',
    'Gujrat',
  ];
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: navBar(
          email: widget.email,
        ),
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
                                      _category = _selectedCategory ?? '';
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
                                      _location = _selectedArea ?? '';
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
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Enter Animal Details',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              CupertinoButton(
                onPressed: () async {
                  XFile? selectedImage = await ImagePicker()
                      .pickImage(source: ImageSource.gallery);

                  if (selectedImage != null) {
                    File convertedFile = File(selectedImage.path);
                    setState(() {
                      profilePic = convertedFile;
                    });
                    log("Image Selected");
                  } else {
                    log('No Image Selected');
                  }
                },
                padding: EdgeInsets.zero,
                child: CircleAvatar(
                  radius: 80,
                  backgroundImage:
                      (widget.dummy_image.startsWith('https') != -1 &&
                              profilePic == null)
                          ? NetworkImage(widget.dummy_image)
                          : // For network URL
                          (profilePic != null
                              ? FileImage(profilePic!) as ImageProvider<Object>?
                              : null), // For local file
                  backgroundColor: Colors.grey,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 18.0, right: 27),
                child: TextField(
                  controller: _title,
                  decoration: InputDecoration(
                    labelText: 'Enter Title',
                    labelStyle: TextStyle(color: Colors.black),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(11),
                        borderSide: BorderSide(
                            color: _titleError ? Colors.red : Colors.green,
                            width: 3)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(11),
                        borderSide: BorderSide(
                            color: _titleError ? Colors.red : Colors.teal,
                            width: 3)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(11),
                        borderSide: BorderSide(
                            color: _titleError ? Colors.red : Colors.grey,
                            width: 3)),
                  ),
                ),
              ),
              Container(height: 18),
              Padding(
                padding: const EdgeInsets.only(left: 18.0, right: 27),
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
                      _location = _selectedArea ?? '';
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Select Area',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(11),
                        borderSide: BorderSide(
                            color: _locationError ? Colors.red : Colors.green,
                            width: 3)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(11),
                        borderSide: BorderSide(
                            color: _locationError ? Colors.red : Colors.teal,
                            width: 3)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(11),
                        borderSide: BorderSide(
                            color: _locationError ? Colors.red : Colors.grey,
                            width: 3)),
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 16,
                    ),
                  ),
                ),
              ),
              Container(height: 18),
              Padding(
                padding: const EdgeInsets.only(left: 18.0, right: 27),
                child: TextField(
                  keyboardType: TextInputType.number,
                  controller: _price,
                  decoration: InputDecoration(
                    labelText: 'Enter Price',
                    labelStyle: TextStyle(color: Colors.black),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(11),
                        borderSide: BorderSide(
                            color: _priceError ? Colors.red : Colors.green,
                            width: 3)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(11),
                        borderSide: BorderSide(
                            color: _priceError ? Colors.red : Colors.teal,
                            width: 3)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(11),
                        borderSide: BorderSide(
                            color: _priceError ? Colors.red : Colors.grey,
                            width: 3)),
                  ),
                ),
              ),
              Container(height: 18),
              Padding(
                padding: const EdgeInsets.only(left: 18.0, right: 27),
                child: TextField(
                  controller: _keywords,
                  decoration: InputDecoration(
                    labelText: 'Enter KeyWords',
                    labelStyle: TextStyle(color: Colors.black),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(11),
                        borderSide: BorderSide(color: Colors.green, width: 3)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(11),
                        borderSide: BorderSide(color: Colors.teal, width: 3)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(11),
                        borderSide: BorderSide(color: Colors.grey, width: 3)),
                    // suffixIcon: Icon(Icons.email)
                  ),
                ),
              ),
              Container(height: 18),
              Padding(
                padding: const EdgeInsets.only(left: 18.0, right: 27),
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
                      _category = _selectedCategory ?? '';
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Select Category',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(11),
                        borderSide: BorderSide(
                            color: _categoryError ? Colors.red : Colors.green,
                            width: 3)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(11),
                        borderSide: BorderSide(
                            color: _categoryError ? Colors.red : Colors.teal,
                            width: 3)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(11),
                        borderSide: BorderSide(
                            color: _categoryError ? Colors.red : Colors.grey,
                            width: 3)),
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 16,
                    ),
                  ),
                ),
              ),
              Container(height: 18),
              Padding(
                padding: const EdgeInsets.only(left: 18.0, right: 27),
                child: TextField(
                  keyboardType: TextInputType.number,
                  controller: _quantity,
                  decoration: InputDecoration(
                    labelText: 'Enter Animal Quantity',
                    labelStyle: TextStyle(color: Colors.black),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(11),
                        borderSide: BorderSide(
                            color: _quantityError ? Colors.red : Colors.green,
                            width: 3)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(11),
                        borderSide: BorderSide(
                            color: _quantityError ? Colors.red : Colors.teal,
                            width: 3)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(11),
                        borderSide: BorderSide(
                            color: _quantityError ? Colors.red : Colors.grey,
                            width: 3)),
                  ),
                ),
              ),
              Container(height: 18),
              Padding(
                padding: const EdgeInsets.only(left: 18.0, right: 27),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        // keyboardType: TextInputType.phone,
                        controller: _age,
                        decoration: InputDecoration(
                          labelText: 'Enter Animal Age',
                          labelStyle: TextStyle(color: Colors.black),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(11),
                              borderSide: BorderSide(
                                  color: _ageError ? Colors.red : Colors.green,
                                  width: 3)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(11),
                              borderSide: BorderSide(
                                  color: _ageError ? Colors.red : Colors.teal,
                                  width: 3)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(11),
                              borderSide: BorderSide(
                                  color: _ageError ? Colors.red : Colors.grey,
                                  width: 3)),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(11),
                        border: Border.all(
                          color: Colors.grey,
                          width: 3,
                        ),
                      ),
                      child: Theme(
                        data: Theme.of(context).copyWith(
                          unselectedWidgetColor: Colors
                              .grey, // Set the color to grey when not focused
                        ),
                        child: DropdownButton<String>(
                          value: _selectedUnit,
                          items: <String>['years', 'months', 'days']
                              .map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              _selectedUnit = newValue.toString();
                            });
                          },
                          underline: SizedBox(), // Remove the default underline
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(height: 18),
              Padding(
                padding: const EdgeInsets.only(left: 18.0, right: 27),
                child: TextField(
                  controller: _description,
                  decoration: InputDecoration(
                    labelText: 'Enter Description',
                    labelStyle: TextStyle(color: Colors.black),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(11),
                        borderSide: BorderSide(color: Colors.green, width: 3)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(11),
                        borderSide: BorderSide(color: Colors.teal, width: 3)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(11),
                        borderSide: BorderSide(color: Colors.grey, width: 3)),
                    // suffixIcon: Icon(Icons.email)
                  ),
                ),
              ),
              Container(height: 18),
              Padding(
                padding: const EdgeInsets.only(left: 18.0, right: 27),
                child: TextField(
                  controller: _ownerName,
                  decoration: InputDecoration(
                    labelText: 'Enter Owner Name',
                    labelStyle: TextStyle(color: Colors.black),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(11),
                        borderSide: BorderSide(
                            color: _ownerNameError ? Colors.red : Colors.green,
                            width: 3)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(11),
                        borderSide: BorderSide(
                            color: _ownerNameError ? Colors.red : Colors.teal,
                            width: 3)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(11),
                        borderSide: BorderSide(
                            color: _ownerNameError ? Colors.red : Colors.grey,
                            width: 3)),
                  ),
                ),
              ),
              Container(height: 18),
              Padding(
                padding: const EdgeInsets.only(left: 18.0, right: 27),
                child: TextField(
                  keyboardType: TextInputType.phone,
                  controller: _ownerPho,
                  decoration: InputDecoration(
                    labelText: 'Enter Owner Phone',
                    labelStyle: TextStyle(color: Colors.black),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(11),
                        borderSide: BorderSide(
                            color: _ownerPhoError ? Colors.red : Colors.green,
                            width: 3)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(11),
                        borderSide: BorderSide(
                            color: _ownerPhoError ? Colors.red : Colors.teal,
                            width: 3)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(11),
                        borderSide: BorderSide(
                            color: _ownerPhoError ? Colors.red : Colors.grey,
                            width: 3)),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: ElevatedButton(
                  onPressed: () async {
                    if (_title.text.isEmpty ||
                        _location.isEmpty ||
                        _price.text.isEmpty ||
                        // _keywords.text.isEmpty ||
                        _category.isEmpty ||
                        _quantity.text.isEmpty ||
                        _age.text.isEmpty ||
                        // _description.text.isEmpty ||
                        _ownerName.text.isEmpty ||
                        _ownerPho.text.isEmpty) {
                      // Show error messages and highlight empty fields in red
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Please fill in all fields.'),
                          backgroundColor: Colors.red,
                        ),
                      );
                      // Highlight empty fields in red
                      setState(() {
                        _titleError = _title.text.isEmpty;
                        _locationError = _location.isEmpty;
                        _priceError = _price.text.isEmpty;
                        // _keywordsError = _keywords.text.isEmpty;
                        _categoryError = _category.isEmpty;
                        _quantityError = _quantity.text.isEmpty;
                        _ageError = _age.text.isEmpty;
                        // _descriptionError = _description.text.isEmpty;
                        _ownerNameError = _ownerName.text.isEmpty;
                        _ownerPhoError = _ownerPho.text.isEmpty;
                      });
                    } else {
                      // All fields are filled, proceed with saving data

                      String imglink = widget
                          .dummy_image; // Initialize imglink with the dummy image
                      if (widget.flag == 'edit') {
                        // Check if profilePic is not null and update imglink if needed
                        if (profilePic != null) {
                          UploadTask uploadTask = FirebaseStorage.instance
                              .ref()
                              .child("profilePicture")
                              .child(Uuid().v1())
                              .putFile(profilePic!);
                          TaskSnapshot taskSnapshot = await uploadTask;
                          String downloadUrl =
                              await taskSnapshot.ref.getDownloadURL();
                          if (downloadUrl.isNotEmpty) {
                            imglink =
                                downloadUrl; // Update imglink with the downloadUrl
                            print(downloadUrl);
                          }
                        }
                      } else {
                        saveData();
                      }

                      // Update the data sent back via Navigator.pop with the correct image link
                      Navigator.pop(
                        context,
                        Data(
                          email: widget.email,
                          views: "0",
                          image: imglink,
                          id: widget
                              .dummy_id, // Assuming dummy_id is the ID field you want to pass back
                          postedDate: DateFormat('yyyy-MM-dd')
                              .format(DateTime.now())
                              .toString(),
                          title: _title.text,
                          location: _location,
                          Rs: _price.text,
                          key: _keywords.text,
                          category: _category,
                          animalQuantity: _quantity.text,
                          age: _age.text + _selectedUnit,
                          description: _description.text,
                          ownerName: _ownerName.text,
                          ownerPho: _ownerPho.text,
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    minimumSize: Size(180, 40),
                  ),
                  child: Text(
                    'Submit',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
