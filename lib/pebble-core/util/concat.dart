import 'dart:typed_data';

Uint8List concat(List<Uint8List> byteLists) {
  int totalLength = byteLists.fold(0, (prev, element) => prev + element.length);
  var result = Uint8List(totalLength);
  var offset = 0;
  for (var list in byteLists) {
    result.setAll(offset, list);
    offset += list.length;
  }
  return result;
}
