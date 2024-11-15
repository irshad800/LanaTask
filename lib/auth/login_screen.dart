import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../biometric/biometric_auth.dart';
import 'auth_service.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _authService = AuthService();
  final _secureStorage = FlutterSecureStorage();
  bool _isLoading = false;
  final BiometricAuth _biometricAuth = BiometricAuth();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Logo or App Title
              Padding(
                padding: const EdgeInsets.only(top: 190.0),
                child: Icon(
                  Icons.login,
                  size: 100,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 20),
              // App Title
              Center(
                child: Text(
                  'Welcome',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 2,
                  ),
                ),
              ),
              SizedBox(height: 30),
              // OAuth Login Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.blueAccent,
                    backgroundColor: Colors.white, // Text color
                    padding: EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(30), // Rounded corners
                    ),
                    elevation: 5, // Shadow
                  ),
                  onPressed: _authenticateWithOAuth,
                  child: _isLoading
                      ? CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.blueAccent),
                        )
                      : Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text("  "),
                            Icon(Icons.login, color: Colors.blueAccent),
                            SizedBox(width: 10),
                            Text(
                              '  Login with OAuth 2.0     ',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.blueAccent,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
              SizedBox(height: 20),
              // Biometric Authentication Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.blueAccent,
                    backgroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 5,
                  ),
                  onPressed: _authenticateWithBiometrics,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("   "),
                      Icon(Icons.fingerprint, color: Colors.blueAccent),
                      SizedBox(width: 10),
                      Text(
                        '  Login with Biometrics   ',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.blueAccent,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 100),
              TextButton(
                onPressed: () {},
                child: Text(
                  'Don\'t have an account? Sign Up',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Authenticate user using OAuth 2.0
  Future<void> _authenticateWithOAuth() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Authenticate and get the access token
      var result = await _authService.authenticate();
      if (result != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Logged in successfully')),
        );
        // Navigate to the next screen
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        // Authentication failed
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login failed')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error during authentication: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Authenticate using Biometric Authentication
  Future<void> _authenticateWithBiometrics() async {
    setState(() {
      _isLoading = true;
    });

    try {
      bool isAuthenticated = await _biometricAuth.authenticate();
      if (isAuthenticated) {
        // Successfully authenticated with biometrics
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Biometric authentication successful')),
        );

        Navigator.pushReplacementNamed(context, '/home');
      } else {
        // Authentication failed
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Biometric authentication failed')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error during biometric authentication: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
