import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api_url.dart';
import '../App_model/profile_model/LoginModel.dart';
import '../App_model/profile_model/GetProfileModel.dart';
import '../App_model/profile_model/UpdateProfileModel.dart';
import '../App_model/profile_model/ResetPasswordModel.dart';
import '../App_model/profile_model/LogoutModel.dart';

class ApiService {
  static const String baseUrl = ApiUrls.baseUrl;
  
  // Add headers method
  static Map<String, String> _getHeaders({String? token}) {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }
    
    return headers;
  }

  // Login API
  static Future<LoginModel> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse(ApiUrls.login),
        headers: _getHeaders(),
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        return LoginModel.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to login: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Login error: $e');
    }
  }

  // Logout API
  static Future<LogoutModel> logout(String token) async {
    try {
      final response = await http.post(
        Uri.parse(ApiUrls.logout),
        headers: _getHeaders(token: token),
      );

      if (response.statusCode == 200) {
        return LogoutModel.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to logout: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Logout error: $e');
    }
  }

  // Get Profile Details API
  static Future<GetProfileModel> getProfileDetails(String token) async {
    try {
      final response = await http.get(
        Uri.parse(ApiUrls.profileDetails),
        headers: _getHeaders(token: token),
      );

      if (response.statusCode == 200) {
        return GetProfileModel.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to get profile: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Profile error: $e');
    }
  }

  // Update Profile API
  static Future<UpdateProfileModel> updateProfile(
    String token,
    Map<String, dynamic> profileData,
  ) async {
    try {
      final response = await http.post(
        Uri.parse(ApiUrls.updateProfile),
        headers: _getHeaders(token: token),
        body: jsonEncode(profileData),
      );

      if (response.statusCode == 200) {
        return UpdateProfileModel.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to update profile: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Update profile error: $e');
    }
  }

  // Reset Password API
  static Future<ResetPasswordModel> resetPassword(
    String token,
    String currentPassword,
    String newPassword,
  ) async {
    try {
      final response = await http.post(
        Uri.parse(ApiUrls.resetPassword),
        headers: _getHeaders(token: token),
        body: jsonEncode({
          'current_password': currentPassword,
          'new_password': newPassword,
        }),
      );

      if (response.statusCode == 200) {
        return ResetPasswordModel.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to reset password: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Reset password error: $e');
    }
  }
}
