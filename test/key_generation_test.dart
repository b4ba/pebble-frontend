import 'package:ecclesia_ui/pebble-core/pubkey/pubkey.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Key pair generation should return valid keys', () async {
    final keys = await generateKey(KeyType.keyTypeEd25519);
    expect(keys, isNotNull);
    expect(keys.publicKey.toString(), isNotNull);
    expect(keys.secret.toString(), isNotNull);
  });

  test('Keys should be stored in secure storage', () {
    final mockStorage = MockSecureStorage();
    final keys = generateKeyPair();
    storeKeys(mockStorage, keys);
    verify(mockStorage.write(key: 'publicKey', value: keys.publicKey));
    verify(mockStorage.write(key: 'privateKey', value: keys.privateKey));
  });
}
