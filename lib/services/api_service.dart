import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/ride_route.dart';

class ApiService {
  static const String baseUrl = 'http://127.0.0.1:8000';

  Future<List<RideRoute>> plan(String text, {int topK = 3}) async {
    final uri = Uri.parse('$baseUrl/plan');
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'text': text, 'top_k': topK}),
    );

    if (response.statusCode != 200) {
      throw Exception('HTTP ${response.statusCode}: ${response.body}');
    }

    final Map<String, dynamic> data =
        jsonDecode(response.body) as Map<String, dynamic>;
    final List<dynamic> routesJson = data['routes'] as List<dynamic>;
    return routesJson
        .map((routeJson) => RideRoute.fromJson(routeJson as Map<String, dynamic>))
        .toList();
  }
}
