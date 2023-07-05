import '../pebble-core/base32c/base32.dart';
import '../pebble-core/pubkey/pubkey.dart';

Future<Map<String, dynamic>> createKeys() async {
  try {
    initialize();

    final privateKey = await generateKey(KeyType.keyTypeEd25519);

    return {
      'secret': privateKey.secret.toString(),
      'publicKey': privateKey.publicKey.toString()
    };
  } catch (e) {
    throw Exception('Failed to generate keys');
  }
}
