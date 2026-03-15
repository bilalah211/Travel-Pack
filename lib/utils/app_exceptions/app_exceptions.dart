class AppException implements Exception {
  final String message;
  final String? prefix;

  AppException([this.message = '', this.prefix]);

  @override
  String toString() {
    return "$prefix$message";
  }
}

class InternetException extends AppException {
  InternetException([String message = 'No Internet Connection'])
    : super(message, 'Internet Error: ');
}

class RequestTimeout extends AppException {
  RequestTimeout([String message = 'Request Timed Out'])
    : super(message, 'Timeout: ');
}

class BadRequestException extends AppException {
  BadRequestException([String message = 'Invalid Request'])
    : super(message, 'Bad Request: ');
}

class UnauthorizedException extends AppException {
  UnauthorizedException([String message = 'Unauthorized Access'])
    : super(message, 'Unauthorized: ');
}

class ServerException extends AppException {
  ServerException([String message = 'Internal Server Error'])
    : super(message, 'Server Error: ');
}

class FetchDataException extends AppException {
  FetchDataException([String message = 'Error During Communication'])
    : super(message, 'Fetch Data Error: ');
}

class ValidationException extends AppException {
  ValidationException([String message = 'Validation Error'])
    : super(message, 'Form Error: ');
}
