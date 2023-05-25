class TockExceptions {
  final String message;
  final type;
  final String messageAlert;
  TockExceptions(this.message, this.type, this.messageAlert);
}

class InternetException extends TockExceptions {
  final hasTimeout;
  InternetException({this.hasTimeout, message, type, messageAlert})
      : super(message, type, messageAlert);
}

class LocalNetException extends TockExceptions {
  final hasTimeout;
  LocalNetException({this.hasTimeout, message, type, messageAlert})
      : super(message, type, messageAlert);
}

class IotAwsException extends TockExceptions {
  final hasTimeout;
  IotAwsException({this.hasTimeout, message, type, messageAlert})
      : super(message, type, messageAlert);
}

class ApiGatewayException implements Exception {
  final hasTimeout;
  final message;
  final mReturn;
  ApiGatewayException({this.message, this.hasTimeout, this.mReturn});
}
