import 'dart:convert';
import 'package:http/http.dart' as http;
import '../features/auth/services/auth_service.dart';
import '../config/api_urls.dart';
import '../models/user.dart';
import '../models/membership.dart';
import '../models/entries.dart';
import '../models/login_response.dart';

class ApiException implements Exception {
  final String message;
  ApiException(this.message);
}

class ApiService {
  // ---------------- Login ----------------
  static Future<String> login(String email, String password) async {
    final url = Uri.parse(ApiUrls.login);
    final response = await http.post(url, body: {'username': email, 'password': password});

    if (response.statusCode != 200) {
      throw ApiException('Invalid email or password');
    }

    final data = jsonDecode(response.body);
    if (data['token'] == null) {
      throw ApiException('Login failed: No token returned');
    }

    return data['token'];
  }

  // ---------------- Complete Login Process ----------------
  static Future<LoginResponse> performLogin(String email, String password) async {
    // Get token
    final token = await login(email, password);
    await AuthService.saveToken(token);

    // Fetch user and membership data
    final user = await getMe();
    final membership = await getMemberStatus();

    return LoginResponse(token: token, user: user, membership: membership);
  }

  // ---------------- Authenticated GET ----------------
  static Future<Map<String, dynamic>> _get(String fullUrl) async {
    final token = await AuthService.getToken();
    if (token == null) throw ApiException('Not authenticated');

    final url = Uri.parse(fullUrl);
    final response = await http.get(url, headers: {'Authorization': 'Bearer $token'});

    if (response.statusCode == 401) {
      throw ApiException('Unauthorized. Please login again.');
    }
    if (response.statusCode != 200) {
      throw ApiException('Failed to fetch data from API');
    }

    final data = jsonDecode(response.body);
    if (data is Map<String, dynamic>) {
      return data;
    } else {
      return {'data': data}; // fallback for list endpoints
    }
  }

  // ---------------- Get Current User ----------------
  static Future<User> getMe() async {
    final data = await _get(ApiUrls.me);
    return User.fromJson(data);
  }

  // ---------------- Get User Entries ----------------
  static Future<Entries> getEntries() async {
    final data = await _get(ApiUrls.entries);
    return Entries.fromJson(data);
  }

  // ---------------- Get Membership Status ----------------
  static Future<Membership> getMemberStatus() async {
    try {
      final data = await _get(ApiUrls.memberStatus);
      return Membership.fromJson(data);
    } catch (e) {
      print('Error fetching membership: $e');
      return Membership.empty();
    }
  }

  // ---------------- Cancel Membership ----------------
  static Future<void> cancelMembership() async {
    final token = await AuthService.getToken();
    if (token == null) throw ApiException('Not authenticated');

    final url = Uri.parse(ApiUrls.cancelMembership);
    final response = await http.post(url, headers: {'Authorization': 'Bearer $token'});

    if (response.statusCode != 200) {
      final data = jsonDecode(response.body);
      throw ApiException(data['message'] ?? 'Failed to cancel membership');
    }
  }
}
