import 'package:flutter/material.dart';

class sellerOutput extends StatelessWidget {
  String title,
      location,
      price,
      keywords,
      category,
      quantity,
      age,
      description,
      ownerName,
      ownerPho;

  sellerOutput(
      {required this.title,
      required this.location,
      required this.price,
      required this.keywords,
      required this.category,
      required this.quantity,
      required this.age,
      required this.description,
      required this.ownerName,
      required this.ownerPho});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // height: screenSize.height * 0.670,
        width: double.infinity,
        child: GridView.builder(
          shrinkWrap: true,
          itemCount: 1,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, crossAxisSpacing: 5, mainAxisExtent: 235),
          itemBuilder: (context, index) {
            return Container(
              child: Column(
                children: [
                  // Container(
                  //   width: double.infinity,
                  //   height: 150.5,
                  //   decoration: BoxDecoration(
                  //       color: Colors.amberAccent,
                  //       image: DecorationImage(
                  //           image:
                  //           AssetImage(filteredList[index].image),
                  //           fit: BoxFit.cover)),
                  // ),
                  Container(
                    height: 18,
                    child: Text(
                      '${title}',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                  ),
                  // Container(
                  //     height: 21,
                  //     child: Text('Location ${location}')),
                  Container(
                    height: 17,
                    child: Text(
                      'Rs ${price}',
                      style: TextStyle(
                          color: Colors.green, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    height: 20,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 45.0),
                      child: Row(
                        children: [
                          Icon(Icons.location_on),
                          Text('${location}')
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

      // Center(
      //   child: Container(
      //     child: Column(
      //       mainAxisAlignment: MainAxisAlignment.center,
      //       children: [
      //         Text('Title ${title}'),
      //         Text('Location ${location}'),
      //         Text('Price ${price}'),
      //         Text('Keywords ${keywords}'),
      //         Text('Category ${category}'),
      //         Text('Quantity ${quantity}'),
      //         Text('Age ${age}'),
      //         Text('Description ${description}'),
      //         Text('OwnerName ${ownerName}'),
      //         Text('OwnerPho ${ownerPho}'),
      //       ],
      //     ),
      //   ),
      // ),
    );
  }
}
