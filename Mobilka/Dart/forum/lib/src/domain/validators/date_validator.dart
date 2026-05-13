bool isValidDateTime(String value) {
  try {
    DateTime.parse(value);
    return true;
  } catch (_) {
    return false;
  }
}