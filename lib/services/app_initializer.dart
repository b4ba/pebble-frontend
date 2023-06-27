import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'api_initial.dart';
import 'secure_storage.dart';

Future<void> checkAndFetchKeys() async {
  final storage = FlutterSecureStorage();
  final provingKey = await storage.read(key: 'provingKey');
  final verifyingKey = await storage.read(key: 'verifyingKey');

  if (provingKey == null || verifyingKey == null) {
    final keys = await fetchData();
    print('keys: $keys');
    storeKeys(keys);
  }

  print('provingKey: $provingKey');
  print('verifyingKey: $verifyingKey');

  // Continue to the rest of the app
}
