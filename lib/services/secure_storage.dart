import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void storeKeys(Map<String, dynamic> keys) {
  const storage = FlutterSecureStorage();
  storage.write(key: 'secret', value: keys['secret']);
  storage.write(key: 'publicKey', value: keys['publicKey']);
}

void storeSecure(String key, String value) {
  const storage = FlutterSecureStorage();
  //key: joinedElections
  storage.write(key: key, value: value);
}

void storeSecureJson(String key, Map<String, dynamic> value) {
  final storage = FlutterSecureStorage();
  storage.write(key: key, value: jsonEncode(value));
}
