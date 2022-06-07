import 'dart:convert';
import 'dart:io';

class DataEncoding {
  static String encode(dynamic data) {
    String encoded = json.encode(data);
    final enCodedJson = utf8.encode(encoded);
    final gZipJson = gzip.encode(enCodedJson);
    String decodeData = base64.encode(gZipJson);
    return decodeData;
  }

  static dynamic decode(String old) {
    try {
      print(old);
      final decodeBase64Json = base64.decode(old);
      final decodeZipJson = gzip.decode(decodeBase64Json);
      String originalJson = utf8.decode(decodeZipJson);
      print(originalJson);
      return json.decode(originalJson);
    } catch (err) {
      print(err);
      return "Wrong formatted";
    }
  }
}
