import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void showToast(String message, {ToastType type = ToastType.error}) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: type.color,
      textColor: Colors.white,
      fontSize: 16.0);
}

enum ToastType { error, info, success }

extension GetToastColor on ToastType {
  Color get color {
    switch (this) {
      case ToastType.error:
        return Colors.red;
      case ToastType.info:
        return Colors.blue;
      case ToastType.success:
        return Colors.green;
    }
  }
}
