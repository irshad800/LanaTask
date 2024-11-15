import 'package:http/http.dart' as http;

import 'api_client.dart';

class NetworkService {
  final ApiClient _apiClient = ApiClient();

  Future<http.Response> fetchData(String url) async {
    final client = await _apiClient.getClient();
    final response = await client.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return response;
    } else {
      throw Exception('Failed to load data');
    }
  }
}
