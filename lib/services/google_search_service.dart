import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;

import 'package:infobootleg/utils/exceptions.dart';
import 'package:infobootleg/models/secret_model.dart';

class GoogleSearchService {
  static final Uri searchUri =
      Uri.https("www.googleapis.com", '/customsearch/v1');

  static Future<String> fetchLawId(String query) async {
    Map<String, String> params = await _createQueryParams(query);

    final uri = searchUri.replace(queryParameters: params);
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      return _parseSearchResponse(response.body);
    } else {
      throw NoResponseFromGoogleSearchAPIException();
    }
  }

  static Future<Map<String, String>> _createQueryParams(String query) async {
    final secret = await _loadSecret();
    final Map<String, String> queryParams = {
      'key': secret.apiKey,
      'cx': secret.searchEngineId,
    };
    queryParams['q'] = query;
    return queryParams;
  }

  static Future<Secret> _loadSecret() {
    final String secretPath = "assets/secrets.json";
    return rootBundle.loadStructuredData<Secret>(secretPath, (jsonStr) async {
      return Secret.fromJson(json.decode(jsonStr));
    });
  }

  static _parseSearchResponse(String responseBody) {
    final parsed = json.decode(responseBody);
    if (parsed["items"] == null) throw NoResultsFromGoogleSearchAPIException();

    List<dynamic> usefulItems = parsed["items"]
        .where((item) => (item["link"] as String).contains("verNorma.do?id="))
        .toList();
    String linkFromFirstUsefulItem = usefulItems[0]["link"];

    return _extractIdFromLink(linkFromFirstUsefulItem);
  }

  static _extractIdFromLink(String link) {
    RegExp regexForId = RegExp(r"(verNorma\.do\?id=)(\d+)");
    RegExpMatch matchForId = regexForId.firstMatch(link);
    String id = matchForId.group(2);
    return id;
  }
}
