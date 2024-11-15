import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../rbac/role_based_access.dart';
import '../utils/constants.dart';

class AuthService {
  final _secureStorage = FlutterSecureStorage();
  final String clientId = Constants.clientId;
  final String clientSecret = Constants.clientSecret;
  final String authUrl = Constants.authUrl;

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

        String? userRole = _decodeToken(accessToken);
        RoleBasedAccessControl roleBasedAccess =
            RoleBasedAccessControl(userRole ?? '');

        if (roleBasedAccess.isAdmin()) {
          print('User is Admin');
        } else if (roleBasedAccess.isUser()) {
          print('User is a regular user');
        }

        return {
          Constants.authTokenKey: accessToken,
          Constants.refreshTokenKey: refreshToken,
        };
      } else {
        return null;
      }
    } catch (e) {
      print('Authentication failed: $e');
      return null;
    }
  }

  String? _decodeToken(String token) {
    try {
      // final decoded = Jwt.parseJwt(token);
      //
      // return decoded['role'];
    } catch (e) {
      print('Error decoding JWT: $e');
      return null;
    }
  }

  Future<void> _storeTokens(String accessToken, String refreshToken) async {
    await _secureStorage.write(key: Constants.authTokenKey, value: accessToken);
    await _secureStorage.write(
        key: Constants.refreshTokenKey, value: refreshToken);
  }

  Future<String?> getAccessToken() async {
    return await _secureStorage.read(key: Constants.authTokenKey);
  }

  Future<String?> getRefreshToken() async {
    return await _secureStorage.read(key: Constants.refreshTokenKey);
  }

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
      await _secureStorage.write(
          key: Constants.authTokenKey, value: newAccessToken);
      return newAccessToken;
    }
    return null;
  }

  Future<void> logout() async {
    await _secureStorage.delete(key: Constants.authTokenKey);
    await _secureStorage.delete(key: Constants.refreshTokenKey);
  }
}
