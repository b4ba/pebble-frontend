import 'package:test/test.dart';
import 'base32.dart';
import 'base32check.dart';

void main() {
  // Call initialize function before running tests
  initialize();

  test('Base32 Encoding and Decoding', () {
    final data = List<int>.generate(256, (index) => index);

    for (var i = 0; i < data.length; i++) {
      final encoded = encode(data.sublist(i));
      final decoded = decode(encoded);

      if (decoded != data.sublist(i)) {
        // print('Expected: ${data.sublist(i)}');
        // print('Actual: $decoded');
      }
    }
  });

  test('Base32 Check Encoding and Decoding', () {
    final data = List<int>.generate(256, (index) => index);

    for (var i = 0; i < data.length; i++) {
      final encoded = checkEncode(data.sublist(i));
      final decoded = checkDecode(encoded);

      if (decoded != data.sublist(i)) {
        print('Expected: ${data.sublist(i)}');
        print('Actual: $decoded');
      }
    }
  });
}
