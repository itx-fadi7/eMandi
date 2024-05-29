import 'package:flutter/material.dart';

class payment extends StatefulWidget {
  const payment({super.key});

  @override
  State<payment> createState() => _paymentState();
}

class _paymentState extends State<payment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('eMandi'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            onTap: () async {
              await makePayment();
            },
            child: Container(
              height: 50,
              width: 150,
              decoration: BoxDecoration(color: Colors.green),
              child: Center(
                child: Text('Pay'),
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> makePayment() async {
    try {} catch (e) {
      print('exception' + e.toString());
    }
  }
}
