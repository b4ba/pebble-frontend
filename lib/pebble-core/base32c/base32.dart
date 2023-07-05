const alpha = "0123456789ABCDEFGHJKLMNPQRTVWXYZ";

class InvalidBase32CharacterError implements Exception {
  String errMsg() => 'Invalid base32 character';
}

class NonZeroBase32PaddingError implements Exception {
  String errMsg() => 'Non zero base32 padding';
}

Map<String, int> decodeMap = {};

void initialize() {
  for (var i = 0; i < alpha.length; i++) {
    decodeMap[alpha[i]] = i;
  }
}

String encode(List<int> p) {
  var buf = <int>[];
  var u = 0;
  var n = 0;

  for (var b in p) {
    u |= b << n;
    n += 8;

    while (n >= 5) {
      buf.add(alpha.codeUnitAt(u & 31));
      u >>= 5;
      n -= 5;
    }
  }

  while (n > 0) {
    buf.add(alpha.codeUnitAt(u & 31));
    u >>= 5;
    n -= 5;
  }

  return String.fromCharCodes(buf);
}

List<int> decode(String s) {
  var buf = <int>[];
  var u = 0;
  var n = 0;

  for (var c in s.runes) {
    var b = decodeMap[String.fromCharCode(c)];
    if (b == null) {
      throw InvalidBase32CharacterError();
    }

    u |= b << n;
    n += 5;

    while (n >= 8) {
      buf.add(u & 255);
      u >>= 8;
      n -= 8;
    }
  }

  if (u != 0) {
    throw NonZeroBase32PaddingError();
  }

  return buf;
}
