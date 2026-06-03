class ValidationException implements Exception {
  final String message;
  ValidationException(this.message);
  @override
  String toString() => message;
}

class NotFoundException implements Exception {
  final String message;
  NotFoundException(this.message);
  @override
  String toString() => message;
}

class StorageException implements Exception {
  final String message;
  StorageException(this.message);
  @override
  String toString() => message;
}

class LogFileException implements Exception {
  final String message;
  LogFileException(this.message);
  @override
  String toString() => message;
}
