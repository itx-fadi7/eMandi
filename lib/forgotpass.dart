import 'package:fluttertoast/fluttertoast.dart';

class MyToast {
  // Toast Message
  static myShowToast(String message) {
    Fluttertoast.showToast(
      msg: message,
    );
  }
}
