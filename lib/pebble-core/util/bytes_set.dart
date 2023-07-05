import 'package:flutter/foundation.dart';

class Bucket {
  List<int> value;
  bool ok;

  Bucket({this.value = const [], this.ok = false});
}

class BytesSet {
  List<Bucket> v = [];
  int length = 0;

  BytesSet() {
    v = List<Bucket>.filled(0, Bucket(), growable: true);
    length = 0;
  }

  int hashBytes(List<int> p) {
    int h = 12345;
    for (int b in p) {
      h = (h + b) * 16777619;
      h ^= h >> 24;
    }
    return h;
  }

  int get len => length;

  bool contains(List<int> p) {
    if (length == 0) {
      return false;
    }
    int hash = hashBytes(p);
    int mask = v.length - 1;
    int idx = hash & mask;
    while (true) {
      if (!v[idx].ok || hashBytes(v[idx].value) != hash) {
        return false;
      }
      if (listEquals(p, v[idx].value)) {
        return true;
      }
      idx = (idx + 1) & mask;
    }
  }

  void put(List<int> p) {
    if (length * 2 >= v.length) {
      resize();
    }
    int mask = v.length - 1;
    int idx = hashBytes(p) & mask;
    while (true) {
      if (!v[idx].ok) {
        v[idx].value = p;
        v[idx].ok = true;
        length++;
        return;
      }
      idx = (idx + 1) & mask;
    }
  }

  void clear() {
    v = List<Bucket>.filled(0, Bucket(), growable: true);
    length = 0;
  }

  void resize() {
    List<Bucket> old = v;
    length = 0;
    if (old.isEmpty) {
      v = List<Bucket>.filled(16, Bucket(), growable: true);
    } else {
      v = List<Bucket>.filled(old.length * 2, Bucket(), growable: true);
      for (Bucket b in old) {
        if (b.ok) {
          put(b.value);
        }
      }
    }
  }
}
