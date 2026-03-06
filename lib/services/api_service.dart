import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import '../api_url.dart';
import '../App_model/profile_model/LoginModel.dart';
import '../App_model/profile_model/GetProfileModel.dart';
import '../App_model/profile_model/UpdateProfileModel.dart';
import '../App_model/profile_model/ResetPasswordModel.dart';
import '../App_model/profile_model/LogoutModel.dart';
import '../App_model/profile_model/GetDashboardModel.dart';

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
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () => throw Exception('Request timeout'),
      );

      if (response.statusCode == 200) {
        return LoginModel.fromJson(json.decode(response.body));
      } else {
        // Try to parse error response for more details
        String errorMessage = 'Failed to login: ${response.statusCode}';
        try {
          final errorData = json.decode(response.body);
          if (errorData['message'] != null) {
            errorMessage = errorData['message'];
          } else if (errorData['error'] != null) {
            errorMessage = errorData['error'];
          }
        } catch (e) {
          // If error parsing fails, use default message
        }
        throw Exception(errorMessage);
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
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () => throw Exception('Request timeout'),
      );

      if (response.statusCode == 200) {
        return LogoutModel.fromJson(json.decode(response.body));
      } else {
        // Try to parse error response for more details
        String errorMessage = 'Failed to logout: ${response.statusCode}';
        try {
          final errorData = json.decode(response.body);
          if (errorData['message'] != null) {
            errorMessage = errorData['message'];
          } else if (errorData['error'] != null) {
            errorMessage = errorData['error'];
          }
        } catch (e) {
          // If error parsing fails, use default message
        }
        throw Exception(errorMessage);
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
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () => throw Exception('Request timeout'),
      );

      if (response.statusCode == 200) {
        return GetProfileModel.fromJson(json.decode(response.body));
      } else {
        // Try to parse error response for more details
        String errorMessage = 'Failed to get profile: ${response.statusCode}';
        try {
          final errorData = json.decode(response.body);
          if (errorData['message'] != null) {
            errorMessage = errorData['message'];
          } else if (errorData['error'] != null) {
            errorMessage = errorData['error'];
          }
        } catch (e) {
          // If error parsing fails, use default message
        }
        throw Exception(errorMessage);
      }
    } catch (e) {
      throw Exception('Profile error: $e');
    }
  }

  // Update Profile API with image upload support
  static Future<UpdateProfileModel> updateProfile(String token,
      Map<String, dynamic> profileData,) async {
    try {
      var request = http.MultipartRequest(
        'PUT',
        Uri.parse(ApiUrls.updateProfile),
      );

      // Add headers
      request.headers.addAll({
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'multipart/form-data',
      });

      // Add text fields
      profileData.forEach((key, value) {
        if (value != null && value is! XFile) {
          request.fields[key] = value.toString();
        }
      });

      // Add image files if present
      if (profileData['image'] != null && profileData['image'] is XFile) {
        XFile image = profileData['image'];
        request.files.add(await http.MultipartFile.fromPath(
          'image',
          image.path,
        ));
      }

      if (profileData['fav_icon'] != null && profileData['fav_icon'] is XFile) {
        XFile image = profileData['fav_icon'];
        request.files.add(await http.MultipartFile.fromPath(
          'fav_icon',
          image.path,
        ));
      }

      if (profileData['logo_light'] != null &&
          profileData['logo_light'] is XFile) {
        XFile image = profileData['logo_light'];
        request.files.add(await http.MultipartFile.fromPath(
          'logo_light',
          image.path,
        ));
      }

      if (profileData['logo_dark'] != null &&
          profileData['logo_dark'] is XFile) {
        XFile image = profileData['logo_dark'];
        request.files.add(await http.MultipartFile.fromPath(
          'logo_dark',
          image.path,
        ));
      }

      var response = await request.send().timeout(
        const Duration(seconds: 30),
        onTimeout: () => throw Exception('Request timeout'),
      );

      if (response.statusCode == 200) {
        var responseBody = await response.stream.bytesToString();
        return UpdateProfileModel.fromJson(json.decode(responseBody));
      } else {
        // Try to parse error response for more details
        var responseBody = await response.stream.bytesToString();
        String errorMessage = 'Failed to update profile: ${response.statusCode}';
        try {
          final errorData = json.decode(responseBody);
          if (errorData['message'] != null) {
            errorMessage = errorData['message'];
          } else if (errorData['error'] != null) {
            errorMessage = errorData['error'];
          }
        } catch (e) {
          // If error parsing fails, use default message
        }
        throw Exception(errorMessage);
      }
    } catch (e) {
      throw Exception('Update profile error: $e');
    }
  }

  // Reset Password API
  static Future<ResetPasswordModel> resetPassword(String token,
      String currentPassword,
      String newPassword,
      String confirmPassword,) async {
    try {
      final response = await http.post(
        Uri.parse(ApiUrls.resetPassword),
        headers: _getHeaders(token: token),
        body: jsonEncode({
          'old_password': currentPassword,
          'new_password': newPassword,
          'new_password_confirmation': confirmPassword,
        }),
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () => throw Exception('Request timeout'),
      );

      if (response.statusCode == 200) {
        return ResetPasswordModel.fromJson(json.decode(response.body));
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Invalid or expired token');
      } else if (response.statusCode == 422) {
        // Handle validation errors
        Map<String, dynamic> errorResponse = json.decode(response.body);
        String errorMessage = 'Validation failed';

        if (errorResponse['message'] != null) {
          errorMessage = errorResponse['message'];
        } else if (errorResponse['errors'] != null) {
          // Extract specific validation errors
          Map<String, dynamic> errors = errorResponse['errors'];
          List<String> errorMessages = [];

          errors.forEach((field, messages) {
            if (messages is List) {
              errorMessages.addAll(messages.map((msg) => msg.toString()));
            } else {
              errorMessages.add(messages.toString());
            }
          });

          if (errorMessages.isNotEmpty) {
            errorMessage = errorMessages.join(', ');
          }
        }

        throw Exception('Validation error: $errorMessage');
      } else {
        throw Exception('Failed to reset password: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Reset password error: $e');
    }
  }

  // Get Dashboard API
  static Future<GetDashboardModel> getDashboard(String token) async {
    try {
      final response = await http.get(
        Uri.parse(ApiUrls.dashboard),
        headers: _getHeaders(token: token),
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () => throw Exception('Request timeout'),
      );

      if (response.statusCode == 200) {
        return GetDashboardModel.fromJson(json.decode(response.body));
      } else {
        // Try to parse error response for more details
        String errorMessage = 'Failed to get dashboard: ${response.statusCode}';
        try {
          final errorData = json.decode(response.body);
          if (errorData['message'] != null) {
            errorMessage = errorData['message'];
          } else if (errorData['error'] != null) {
            errorMessage = errorData['error'];
          }
        } catch (e) {
          // If error parsing fails, use default message
        }
        throw Exception(errorMessage);
      }
    } catch (e) {
      throw Exception('Dashboard error: $e');
    }
  }

}