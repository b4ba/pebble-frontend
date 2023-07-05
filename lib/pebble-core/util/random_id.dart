import 'dart:typed_data';
import 'dart:math';

Future<Uint8List> randomId() async {
  var random = Random.secure();
  var id = Uint8List(32);
  for (var i = 0; i < id.length; i++) {
    id[i] = random.nextInt(256);
  }
  return id;
}
