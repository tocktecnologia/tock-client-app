import 'package:flutter_dotenv/flutter_dotenv.dart';

class DotEnvService {
  DotEnvService() {
    init();
  }
  Future init() async {
    await dotenv.load(fileName: "assets/.env", mergeWith: {'TEST_VAR': '5'});
  }

  Future<String> getEnv(String envValue, {defaultValue}) async {
    if (!dotenv.isInitialized) {
      await init();
    }
    return dotenv.get(envValue, fallback: defaultValue ?? "");
  }
}
