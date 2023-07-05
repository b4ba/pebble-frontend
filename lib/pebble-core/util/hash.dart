import 'dart:typed_data';
import 'package:crypto/crypto.dart';

typedef HashValue = Uint8List;

HashValue hash(Uint8List data) {
  var digest = sha256.convert(data);
  return Uint8List.fromList(digest.bytes);
}

HashValue hashAll(List<Uint8List> dataList) {
  var bytes = <int>[];
  for (var data in dataList) {
    bytes.addAll(data);
  }
  var digest = sha256.convert(bytes);
  return Uint8List.fromList(digest.bytes);
}
