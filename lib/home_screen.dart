import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'auth/auth_service.dart';

class HomeScreen extends StatelessWidget {
  final AuthService _authService = AuthService();
  final _secureStorage = FlutterSecureStorage();

  Future<void> _logout(BuildContext context) async {
    await _authService.logout();
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: Center(
        child: FutureBuilder<String?>(
          future: _authService.getAccessToken(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            final accessToken = snapshot.data;
            if (accessToken == null) {
              return Text('No Access Token');
            }

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Welcome, User!'),
                SizedBox(height: 20),
                Text('Access Token: $accessToken'),
              ],
            );
          },
        ),
      ),
    );
  }
}
