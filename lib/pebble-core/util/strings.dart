String getSuffix(String s, String prefix) {
  if (s.startsWith(prefix)) {
    return s.substring(prefix.length);
  }
  return "";
}

bool hasSuffix(String s, String prefix) {
  return s.startsWith(prefix);
}
