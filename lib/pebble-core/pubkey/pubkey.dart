// import '../util/buffer_reader_writer.dart';
// import '../util/concat.dart';
// import '../util/hash.dart';
// import '../util/bytes_set.dart';
// import '../util/random_id.dart';
// import '../util/strings.dart';
// import '../base32c/base32.dart';
import '../base32c/base32check.dart';

// import 'package:cryptography_flutter/cryptography_flutter.dart';
import 'package:cryptography/cryptography.dart';
import 'dart:typed_data';

// Class representing a public key.
class PublicKey {
  // The type of the key.
  final KeyType type;
  // The actual key data.
  final Uint8List data;

  // Constructor for PublicKey.
  PublicKey(this.type, this.data);

  // Getter for keyType.
  KeyType get keyType {
    return type;
  }

  // Getter for publicKey.
  Uint8List get publicKey {
    return data;
  }

  // Verifies the given message with the given signature.
  // Returns a Future that completes with a boolean indicating whether the verification was successful.
  Future<bool> verify(Uint8List msg, Uint8List signature) async {
    // If the key type is Ed25519, perform verification using the Ed25519 algorithm.
    if (type == KeyType.keyTypeEd25519) {
      final algorithm = Ed25519();
      final publicKey = SimplePublicKey(data, type: KeyPairType.ed25519);

      final isSignatureCorrect = await algorithm.verify(
        msg,
        signature: Signature(signature, publicKey: publicKey),
      );

      return isSignatureCorrect;
    } else {
      throw Exception("Unknown key type");
    }
  }

  // Returns a string representation of the PublicKey.
  @override
  String toString() {
    return 'EPK${checkEncode(data)}';
  }
}

// Class representing a private key.
class PrivateKey {
  // The corresponding public key.
  PublicKey publicKey;
  // The actual secret key data.
  Uint8List secret;

  // Constructor for PrivateKey.
  PrivateKey(this.publicKey, this.secret);

  // Getter for keyType.
  KeyType get keyType {
    return publicKey.type;
  }

  // Getter for privateKey.
  Uint8List get privateKey {
    return secret;
  }

  // Signs the given message with the private key.
  // Returns a Future that completes with the signature as a Uint8List.
  Future<Uint8List> sign(Uint8List msg) async {
    // If the key type is Ed25519, perform signing using the Ed25519 algorithm.
    if (publicKey.type == KeyType.keyTypeEd25519) {
      final algorithm = Ed25519();
      final keyPairData = SimpleKeyPairData(
        secret,
        publicKey: SimplePublicKey(publicKey.data, type: KeyPairType.ed25519),
        type: KeyPairType.ed25519,
      );
      final signature = await algorithm.sign(
        msg,
        keyPair: keyPairData,
      );
      return Uint8List.fromList(signature.bytes);
    } else {
      throw Exception("Unknown key type");
    }
  }
}

// Enum representing possible key types.
enum KeyType {
  keyTypeUnknown,
  keyTypeEd25519,
}

// Function that creates a new PublicKey object.
PublicKey newPublicKey(KeyType keyType, Uint8List key) {
  return PublicKey(keyType, key);
}

// Function that generates a new PrivateKey.
// Returns a Future that completes with the new PrivateKey.
Future<PrivateKey> generateKey(KeyType keyType) async {
  // If the key type is Ed25519, generate a key using the Ed25519 algorithm.
  if (keyType == KeyType.keyTypeEd25519) {
    final algorithm = Ed25519();
    final keyPair = await algorithm.newKeyPair();
    final simplePublicKey = await keyPair.extractPublicKey();
    final simplePrivateKey = await keyPair.extract();
    return PrivateKey(
      newPublicKey(keyType, Uint8List.fromList(simplePublicKey.bytes)),
      Uint8List.fromList(simplePrivateKey.bytes),
    );
  } else {
    throw Exception("Unknown key type");
  }
}

// Parses a string into a PublicKey object.
PublicKey parse(String publicKeyString) {
  // If the string represents an Ed25519 key, parse the key data.
  if (publicKeyString.startsWith("EPK")) {
    final keyBytes = checkDecode(publicKeyString.substring(3));
    if (keyBytes == null) {
      throw Exception("Invalid key data");
    }
    return newPublicKey(KeyType.keyTypeEd25519, Uint8List.fromList(keyBytes));
  } else {
    throw Exception("Unknown key type");
  }
}
