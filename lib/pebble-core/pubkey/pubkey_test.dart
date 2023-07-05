import 'dart:typed_data';
import 'dart:convert';
import 'package:test/test.dart';
import 'pubkey.dart';
import '../base32c/base32.dart';

void main() {
  setUp(() {
    initialize();
  });

  group('PublicKey', () {
    test('should create PublicKey with correct keyType and publicKey', () {
      final publicKey = newPublicKey(
          KeyType.keyTypeEd25519, Uint8List.fromList(utf8.encode('publicKey')));
      print(publicKey);
      expect(publicKey.keyType, KeyType.keyTypeEd25519);
      expect(publicKey.publicKey, Uint8List.fromList(utf8.encode('publicKey')));
    });

    test('should create PublicKey string representation', () {
      final publicKey = newPublicKey(
          KeyType.keyTypeEd25519, Uint8List.fromList(utf8.encode('publicKey')));
      expect(publicKey.toString(), startsWith('EPK'));
      print(publicKey.toString());
    });
  });

  group('PrivateKey', () {
    final privateKey = PrivateKey(
      newPublicKey(
          KeyType.keyTypeEd25519, Uint8List.fromList(utf8.encode('publicKey'))),
      Uint8List.fromList(utf8.encode('secretKey')),
    );

    test('should create PrivateKey with correct publicKey and privateKey', () {
      expect(privateKey.keyType, KeyType.keyTypeEd25519);
      expect(
          privateKey.privateKey, Uint8List.fromList(utf8.encode('secretKey')));
    });

    test('should sign the message', () async {
      final message = utf8.encode('Hello, World!');
      final signature = await privateKey.sign(Uint8List.fromList(message));
      expect(signature, isNotNull);
    });
  });

  group('Key generation and parsing', () {
    test('should generate PrivateKey and parse PublicKey', () async {
      final privateKey = await generateKey(KeyType.keyTypeEd25519);
      final publicKeyString = privateKey.publicKey.toString();

      expect(publicKeyString, startsWith('EPK'));

      print(publicKeyString);

      final parsedPublicKey = parse(publicKeyString);

      expect(parsedPublicKey.keyType, KeyType.keyTypeEd25519);
      expect(parsedPublicKey.publicKey, privateKey.publicKey.publicKey);
    });
  });
}
