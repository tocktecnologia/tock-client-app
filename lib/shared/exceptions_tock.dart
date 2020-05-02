class TockExceptions {
  final message;
  final type;
  TockExceptions(this.message, this.type);
}

class InternetException extends TockExceptions {
  final hasTimeout;
  InternetException({this.hasTimeout, message, type}) : super(message, type);
}

class LocalNetException extends TockExceptions {
  final hasTimeout;
  LocalNetException({this.hasTimeout, message, type}) : super(message, type);
}
