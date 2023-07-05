import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'keygen.dart';
import 'secure_storage.dart';

Future<void> checkAndFetchKeys() async {
  final storage = FlutterSecureStorage();
  final secret = await storage.read(key: 'secret');
  final publicKey = await storage.read(key: 'publicKey');

  if (secret == null || publicKey == null) {
    final keys = await createKeys();
    print('keys: $keys');
    storeKeys(keys);
  }

  print('secret: $secret');
  print('publicKey: $publicKey');

  // Continue to the rest of the app
}
