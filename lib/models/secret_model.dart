import 'package:meta/meta.dart';

class Secret {
  final String apiKey;
  final String searchEngineId;

  Secret({
    @required this.apiKey,
    @required this.searchEngineId,
  });

  factory Secret.fromJson(Map<String, dynamic> jsonMap) {
    return Secret(
      apiKey: jsonMap['api_key'],
      searchEngineId: jsonMap['search_engine_id'],
    );
  }
}
