import 'dart:math'; // For min function
import 'dart:typed_data'; // For Uint8List

class BufferReader {
  Uint8List buf;

  BufferReader(this.buf);

  int len() {
    return buf.length;
  }

  List<int> read(List<int> p) {
    if (buf.length < p.length) {
      throw ArgumentError('Short buffer');
    }
    var n = min(p.length, buf.length);
    p = buf.sublist(0, n);
    buf = buf.sublist(n);
    return p;
  }

  Uint8List readBytes(int n) {
    if (buf.length < n) {
      throw ArgumentError('Short buffer');
    }
    var p = buf.sublist(0, n);
    buf = buf.sublist(n);
    return p;
  }

  Uint8List read32() {
    if (buf.length < 32) {
      throw ArgumentError('Short buffer');
    }
    var p = buf.sublist(0, 32);
    buf = buf.sublist(32);
    return p;
  }

  Uint8List readRemaining() {
    var p = buf;
    buf = Uint8List(0);
    return p;
  }

  Uint8List readVector() {
    var b = readByte();
    var l = b;
    if (l > 127) {
      b = readByte();
      l = ((l & 127) << 8) + b;
      if (l <= 127) {
        throw ArgumentError('Non-canonical length encoding');
      }
    }
    if (l == 0) {
      return Uint8List(0);
    }
    return readBytes(l);
  }

  int readByte() {
    if (buf.isEmpty) {
      throw ArgumentError('Short buffer');
    }
    var n = buf[0];
    buf = buf.sublist(1);
    return n;
  }

  int readUint16() {
    if (buf.length < 2) {
      throw ArgumentError('Short buffer');
    }
    var n = (buf[0] << 8) + buf[1];
    buf = buf.sublist(2);
    return n;
  }

  int readUint32() {
    if (buf.length < 4) {
      throw ArgumentError('Short buffer');
    }
    var n = buf[0];
    n = (n << 8) + buf[1];
    n = (n << 8) + buf[2];
    n = (n << 8) + buf[3];
    buf = buf.sublist(4);
    return n;
  }

  int readUint64() {
    if (buf.length < 8) {
      throw ArgumentError('Short buffer');
    }
    var n = buf[0];
    n = (n << 8) + buf[1];
    n = (n << 8) + buf[2];
    n = (n << 8) + buf[3];
    n = (n << 8) + buf[4];
    n = (n << 8) + buf[5];
    n = (n << 8) + buf[6];
    n = (n << 8) + buf[7];
    buf = buf.sublist(8);
    return n;
  }
}

class BufferWriter {
  Uint8List buffer = Uint8List(0); // Initialized here

  BufferWriter() {
    buffer = Uint8List(0);
  }

  int len() {
    return buffer.length;
  }

  void write(List<int> p) {
    buffer = Uint8List.fromList([...buffer, ...p]);
  }

  void write32(List<int> p) {
    if (p.length != 32) {
      throw ArgumentError('Incorrect length');
    }
    buffer = Uint8List.fromList([...buffer, ...p]);
  }

  void writeAll(List<List<int>> ps) {
    for (var p in ps) {
      buffer = Uint8List.fromList([...buffer, ...p]);
    }
  }

  void writeVector(List<int> p) {
    var l = p.length;
    if (l > 127) {
      if (l > 0x7FFF) {
        throw ArgumentError('Vector too big');
      }
      buffer = Uint8List.fromList([...buffer, (l >> 8) | 128, l]);
    } else {
      buffer = Uint8List.fromList([...buffer, l]);
    }
    buffer = Uint8List.fromList([...buffer, ...p]);
  }

  void writeByte(int c) {
    buffer = Uint8List.fromList([...buffer, c]);
  }

  void writeUint16(int n) {
    buffer = Uint8List.fromList([...buffer, n >> 8, n]);
  }

  void writeUint32(int n) {
    buffer = Uint8List.fromList([...buffer, n >> 24, n >> 16, n >> 8, n]);
  }

  void writeUint64(int n) {
    buffer = Uint8List.fromList([
      ...buffer,
      n >> 56,
      n >> 48,
      n >> 40,
      n >> 32,
      n >> 24,
      n >> 16,
      n >> 8,
      n
    ]);
  }
}
