import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  // Using 10.0.2.2 for Android Emulator connecting to local server
  // Change to your server's IP if testing on real device
  static const String baseUrl = 'http://10.0.2.2:5000/api/auth';
  final storage = const FlutterSecureStorage();

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['token'] != null) {
        await storage.write(key: 'jwt_token', value: data['token']);
        return {'success': true, 'data': data};
      } else {
        return {'success': false, 'message': data['message'] ?? 'Login failed'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: ${e.toString()}'};
    }
  }

  Future<Map<String, dynamic>> signup(String fullName, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'fullName': fullName,
          'email': email,
          'password': password
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 201 && data['token'] != null) {
        await storage.write(key: 'jwt_token', value: data['token']);
        return {'success': true, 'data': data};
      } else {
        return {'success': false, 'message': data['message'] ?? 'Signup failed'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: ${e.toString()}'};
    }
  }

  Future<void> logout() async {
    await storage.delete(key: 'jwt_token');
  }

  Future<String?> getToken() async {
    return await storage.read(key: 'jwt_token');
  }
}
