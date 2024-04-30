import 'package:flutter/material.dart';

class bottomSheet extends StatefulWidget {
  const bottomSheet({super.key});

  @override
  State<bottomSheet> createState() => _bottomSheetState();
}

class _bottomSheetState extends State<bottomSheet> {
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
  RangeValues values = RangeValues(0, 10);
  @override
  Widget build(BuildContext context) {
    RangeLabels labels =
        RangeLabels(values.start.toString(), values.end.toString());
    return SingleChildScrollView(
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
                        Navigator.of(context).pop(); // Close the bottom sheet
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
                  padding: const EdgeInsets.only(left: 22.0, bottom: 6),
                  child: Text(
                    'Select Category',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                )),
            Padding(
              padding: const EdgeInsets.only(left: 18.0, right: 18),
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
                  padding: const EdgeInsets.only(left: 22.0, bottom: 6, top: 8),
                  child: Text(
                    'Select Area',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                )),
            Padding(
              padding: const EdgeInsets.only(left: 18.0, right: 18),
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
              padding: const EdgeInsets.only(top: 12.0, left: 22, bottom: 8),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Max Price(PKR)',
                  style: TextStyle(fontWeight: FontWeight.bold),
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
                      borderSide: BorderSide(color: Colors.pink, width: 3)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(11),
                      borderSide: BorderSide(color: Colors.teal, width: 3)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(11),
                      borderSide: BorderSide(color: Colors.black54, width: 3)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 12.0, left: 22, bottom: 18),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Select Age',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 18.0, right: 18, bottom: 10),
              child: RangeSlider(
                  values: values,
                  labels: labels,
                  divisions: 10,
                  inactiveColor: Colors.teal.shade100,
                  activeColor: Colors.teal,

                  // Set the desired color here
                  // Set the desired color here
                  min: 0,
                  max: 10,
                  onChanged: (newValues) {
                    values = newValues;
                    setState(() {});
                  }),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 18.0),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 58.0, right: 48),
                    child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(9)),
                            backgroundColor: Colors.teal,
                            minimumSize: Size(98, 40)),
                        child: Text(
                          'Apply',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        )),
                  ),
                  ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(9)),
                          backgroundColor: Colors.white,
                          minimumSize: Size(98, 40)),
                      child: Text(
                        'Reset',
                        style: TextStyle(color: Colors.black),
                      )),
                ],
              ),
            ) // Add other filter options similarly
            // ...
          ],
        ),
      ),
    );
  }
}
