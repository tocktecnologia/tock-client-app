import 'package:http/http.dart';
import 'package:http/http.dart' as http;

class TockHttpClient extends http.BaseClient {
  final Duration timeout = Duration(seconds: 15);
  final Map<String, String> defaultHeaders;

  TockHttpClient({required this.defaultHeaders});

  @override
  Future<StreamedResponse> send(BaseRequest request) {
    // TODO: implement send
    throw UnimplementedError();
  }

  // @override
  // Future<StreamedResponse> send(BaseRequest request) {
  //   return StreamedResponse;
  // }

  // @override
  // Future<http.Response> get(url, {Map<String, String> headers}) async {
  //   return null;
  // }
}
