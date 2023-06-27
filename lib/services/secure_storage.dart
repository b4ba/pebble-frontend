import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void storeKeys(Map<String, dynamic> keys) {
  final storage = FlutterSecureStorage();
  storage.write(key: 'provingKey', value: keys['provingKey']);
  storage.write(key: 'verifyingKey', value: keys['verifyingKey']);
}
