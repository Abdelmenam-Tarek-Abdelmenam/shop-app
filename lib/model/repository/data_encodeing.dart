import 'dart:convert';

class DataEncoding {
  String encode(String data) {
    return base64.encode(utf8.encode(data));
  }

  String decode(String old) {
    try {
      return utf8.decode(base64.decode(old));
    } catch (err) {
      return "Wrong formatted";
    }
  }
}
