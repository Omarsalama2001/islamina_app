class ServerException implements Exception {}


class NoDataException implements Exception{}
class AuthException implements Exception {
 final String errorCode;
  AuthException({
    required this.errorCode,
  });
  
}

class EmailNotVerifiedException implements Exception {}
