class AppException implements Exception {
  final String message;
  final String prefix;

  AppException(this.message, this.prefix);

  @override
  String toString() {
    return '$prefix: $message';
  }
}

class FetchDataException extends AppException {
  FetchDataException(String message) : super(message, 'Error During Communication');
}

class BadRequestException extends AppException {
  BadRequestException(String message) : super(message, 'Invalid Request');
}

class ServerException extends AppException {
  ServerException(String message) : super(message, 'Server Busy');
}

class UnauthorizedException extends AppException {
  UnauthorizedException(String message) : super(message, 'Unauthorized');

}

class PageNotFoundException extends AppException{

  PageNotFoundException(String message) : super(message,'Page Not Found');
}

class NoInternetException extends AppException{

  NoInternetException(String message) : super(message,'Network Connection Error');
}
