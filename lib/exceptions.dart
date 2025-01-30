class ApplicationException implements Exception {
  String message;

  ApplicationException(this.message);

  @override
  String toString() => 'ApplicationException: $message';
}

class ValidationException extends ApplicationException {
  ValidationException(super.message);

  @override
  String toString() => 'ValidationException: $message';
}

String userErrorMessage(Object exception) {
  if (exception is ApplicationException) {
    return exception.message;
  } else {
    // return 'Ошибка';
    return exception.toString();
  }

}