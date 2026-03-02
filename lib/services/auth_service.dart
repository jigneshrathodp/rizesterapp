import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_service.dart';
import '../App_model/profile_model/LoginModel.dart';
import '../App_model/profile_model/GetProfileModel.dart';
import '../App_model/profile_model/UpdateProfileModel.dart';
import '../App_model/profile_model/ResetPasswordModel.dart';
import '../App_model/profile_model/LogoutModel.dart';

class AuthService {
  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'user_data';

  // Save token to local storage
  static Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  // Get token from local storage
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  // Save user data to local storage
  static Future<void> _saveUserData(Map<String, dynamic> userData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, userData.toString());
  }

  // Get user data from local storage
  static Future<String?> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userKey);
  }

  // Clear all auth data
  static Future<void> clearAuthData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userKey);
  }

  // Login with email and password
  static Future<LoginModel> login(String email, String password) async {
    try {
      LoginModel loginResult = await ApiService.login(email, password);
      
      if (loginResult.token != null) {
        await _saveToken(loginResult.token!);
      }
      
      return loginResult;
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  // Logout user
  static Future<LogoutModel> logout() async {
    try {
      String? token = await getToken();
      
      if (token != null) {
        LogoutModel logoutResult = await ApiService.logout(token);
        await clearAuthData();
        return logoutResult;
      } else {
        throw Exception('No token found');
      }
    } catch (e) {
      // Even if API call fails, clear local data
      await clearAuthData();
      throw Exception('Logout failed: $e');
    }
  }

  // Get profile details
  static Future<GetProfileModel> getProfileDetails() async {
    try {
      String? token = await getToken();
      
      if (token == null) {
        throw Exception('No authentication token found');
      }
      
      return await ApiService.getProfileDetails(token);
    } catch (e) {
      throw Exception('Failed to get profile: $e');
    }
  }

  // Update profile
  static Future<UpdateProfileModel> updateProfile(Map<String, dynamic> profileData) async {
    try {
      String? token = await getToken();
      
      if (token == null) {
        throw Exception('No authentication token found');
      }
      
      return await ApiService.updateProfile(token, profileData);
    } catch (e) {
      throw Exception('Failed to update profile: $e');
    }
  }

  // Reset password
  static Future<ResetPasswordModel> resetPassword(
    String currentPassword,
    String newPassword,
  ) async {
    try {
      String? token = await getToken();
      
      if (token == null) {
        throw Exception('No authentication token found');
      }
      
      return await ApiService.resetPassword(token, currentPassword, newPassword);
    } catch (e) {
      throw Exception('Failed to reset password: $e');
    }
  }

  // Check if user is logged in
  static Future<bool> isLoggedIn() async {
    String? token = await getToken();
    return token != null && token.isNotEmpty;
  }
}
