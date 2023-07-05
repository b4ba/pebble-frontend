import 'package:crypto/crypto.dart';
import 'package:collection/collection.dart';
import 'base32.dart';

class InvalidLengthException implements Exception {
  String errMsg() => 'Invalid base32 length';
}

class InvalidChecksumException implements Exception {
  String errMsg() => 'Invalid base32 checksum';
}

String checkEncode(List<int> p) {
  var h = sha256.convert(p).bytes;
  var b = List<int>.from(p)..addAll(h.sublist(0, 4));
  return encode(b);
}

List<int>? checkDecode(String s) {
  List<int> b;
  try {
    b = decode(s);
  } on FormatException {
    return null;
  }

  if (b.length < 4) {
    throw InvalidLengthException();
  }

  var p = b.sublist(0, b.length - 4);
  var h = sha256.convert(p).bytes;

  if (!const ListEquality().equals(h.sublist(0, 4), b.sublist(p.length))) {
    throw InvalidChecksumException();
  }

  return p;
}
