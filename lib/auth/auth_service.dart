import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AuthService {
  final _secureStorage = FlutterSecureStorage();

  // OAuth 2.0 client credentials
  final String clientId = 'dRQBoYEw1Rg2EID3f41BBYg0U5cwWg99';
  final String clientSecret =
      'T_VSU5X1t6jbxfIDQuuDhmeWZKqA7ZVjTknTMsTEvLIcMfxbRlZlpRtWo1e5yGlM';
  final String authUrl =
      'https://dev-845g6oozz65q5v2e.us.auth0.com/oauth/token';

  Future<Map<String, String>?> authenticate() async {
    try {
      final response = await http.post(
        Uri.parse(authUrl),
        body: {
          'grant_type': 'password',
          'username': 'irshadvp800@gmail.com',
          'password': 'Irshad@2000',
          'client_id': clientId,
          'client_secret': clientSecret,
          'scope': 'openid profile email',
        },
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        String accessToken = data['access_token'];
        String refreshToken = data['refresh_token'];

        await _storeTokens(accessToken, refreshToken);
        return {
          'access_token': accessToken,
          'refresh_token': refreshToken,
        };
      } else {
        return null;
      }
    } catch (e) {
      print('Authentication failed: $e');
      return null;
    }
  }

  // Store tokens securely using flutter_secure_storage
  Future<void> _storeTokens(String accessToken, String refreshToken) async {
    await _secureStorage.write(key: 'access_token', value: accessToken);
    await _secureStorage.write(key: 'refresh_token', value: refreshToken);
  }

  // Get stored access token
  Future<String?> getAccessToken() async {
    return await _secureStorage.read(key: 'access_token');
  }

  // Get stored refresh token
  Future<String?> getRefreshToken() async {
    return await _secureStorage.read(key: 'refresh_token');
  }

  // Refresh access token using the refresh token
  Future<String?> refreshAccessToken() async {
    String? refreshToken = await getRefreshToken();
    if (refreshToken == null) {
      return null;
    }

    final response = await http.post(
      Uri.parse(authUrl),
      body: {
        'grant_type': 'refresh_token',
        'refresh_token': refreshToken,
        'client_id': clientId,
        'client_secret': clientSecret,
      },
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      String newAccessToken = data['access_token'];
      await _secureStorage.write(key: 'access_token', value: newAccessToken);
      return newAccessToken;
    }
    return null;
  }

  // Logout method to clear tokens
  Future<void> logout() async {
    await _secureStorage.delete(key: 'access_token');
    await _secureStorage.delete(key: 'refresh_token');
  }
}
