import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void storeKeys(Map<String, dynamic> keys) {
  const storage = FlutterSecureStorage();
  storage.write(key: 'secret', value: keys['secret']);
  storage.write(key: 'publicKey', value: keys['publicKey']);
}
