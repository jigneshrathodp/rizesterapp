import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import '../App_model/Category_model/DeleteCategoryModel.dart';
import '../App_model/Category_model/UpdateCategoryModel.dart';
import '../api_url.dart';
import '../App_model/profile_model/LoginModel.dart';
import '../App_model/profile_model/GetProfileModel.dart';
import '../App_model/profile_model/UpdateProfileModel.dart';
import '../App_model/profile_model/ResetPasswordModel.dart';
import '../App_model/profile_model/LogoutModel.dart';
import '../App_model/profile_model/GetDashboardModel.dart';
import '../App_model/Category_model/GetCatgoryModel.dart';
import '../App_model/Category_model/CreateCategoryModel.dart';

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

  // Update Profile API with image upload support
  static Future<UpdateProfileModel> updateProfile(
    String token,
    Map<String, dynamic> profileData,
  ) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(ApiUrls.updateProfile),
      );
      
      // Add headers
      request.headers.addAll({
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
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
      
      if (profileData['logo_light'] != null && profileData['logo_light'] is XFile) {
        XFile image = profileData['logo_light'];
        request.files.add(await http.MultipartFile.fromPath(
          'logo_light',
          image.path,
        ));
      }
      
      if (profileData['logo_dark'] != null && profileData['logo_dark'] is XFile) {
        XFile image = profileData['logo_dark'];
        request.files.add(await http.MultipartFile.fromPath(
          'logo_dark',
          image.path,
        ));
      }
      
      var response = await request.send();
      
      if (response.statusCode == 200) {
        var responseBody = await response.stream.bytesToString();
        return UpdateProfileModel.fromJson(json.decode(responseBody));
      } else {
        var responseBody = await response.stream.bytesToString();
        throw Exception('Failed to update profile: ${response.statusCode} - $responseBody');
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
    String confirmPassword,
  ) async {
    try {
      final response = await http.post(
        Uri.parse(ApiUrls.resetPassword),
        headers: _getHeaders(token: token),
        body: jsonEncode({
          'old_password': currentPassword,
          'new_password': newPassword,
          'new_password_confirmation': confirmPassword,
        }),
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
      );

      if (response.statusCode == 200) {
        return GetDashboardModel.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to get dashboard: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Dashboard error: $e');
    }
  }
  
  // Get Category List
  static Future<GetCatgoryModel> getCategoryList(String token) async {
    try {
      final response = await http.get(
        Uri.parse(ApiUrls.categoryList),
        headers: _getHeaders(token: token),
      );
      if (response.statusCode == 200) {
        return GetCatgoryModel.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to get categories: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Category list error: $e');
    }
  }
  
  // View Category by ID
  static Future<UpdateCategoryModel> getCategoryById(String token, int id) async {
    try {
      final response = await http.get(
        Uri.parse(ApiUrls.categoryView(id)),
        headers: _getHeaders(token: token),
      );
      if (response.statusCode == 200) {
        return UpdateCategoryModel.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to get category: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Category view error: $e');
    }
  }
  
  // Create Category with image upload
  static Future<CreateCategoryModel> createCategory(
    String token, {
    required String name,
    required String skubarCode,
    XFile? image,
  }) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(ApiUrls.categoryCreate),
      );
      request.headers.addAll({
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      });
      
      request.fields['name'] = name;
      request.fields['skubar_code'] = skubarCode;
      if (image != null && image.path.isNotEmpty) {
        request.files.add(await http.MultipartFile.fromPath('image', image.path));
      }
      
      final response = await request.send();
      final body = await response.stream.bytesToString();
      if (response.statusCode == 200 || response.statusCode == 201) {
        return CreateCategoryModel.fromJson(json.decode(body));
      } else if (response.statusCode == 422) {
        Map<String, dynamic> errorResponse = {};
        try {
          errorResponse = json.decode(body);
        } catch (_) {}
        String errorMessage = 'Validation failed';
        if (errorResponse['message'] != null) {
          errorMessage = errorResponse['message'];
        }
        if (errorResponse['errors'] != null && errorResponse['errors'] is Map) {
          final Map<String, dynamic> errors = errorResponse['errors'];
          final List<String> messages = [];
          errors.forEach((field, msgs) {
            if (msgs is List) {
              messages.addAll(msgs.map((m) => m.toString()));
            } else if (msgs != null) {
              messages.add(msgs.toString());
            }
          });
          if (messages.isNotEmpty) {
            errorMessage = messages.join(', ');
          }
        }
        throw Exception('Validation error: $errorMessage');
      } else {
        throw Exception('Failed to create category: ${response.statusCode} - $body');
      }
    } catch (e) {
      throw Exception('Create category error: $e');
    }
  }
  
  // Update Category by ID with optional image
  static Future<UpdateCategoryModel> updateCategory(
    String token, {
    required int id,
    required String name,
    required String skubarCode,
    XFile? image,
  }) async {
    try {
      var request = http.MultipartRequest(
        'PUT',
        Uri.parse(ApiUrls.categoryUpdate(id)),
      );
      request.headers.addAll({
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      });
      request.fields['name'] = name;
      request.fields['skubar_code'] = skubarCode;
      if (image != null && image.path.isNotEmpty) {
        request.files.add(await http.MultipartFile.fromPath('image', image.path));
      }
      final response = await request.send();
      final body = await response.stream.bytesToString();
      if (response.statusCode == 200 || response.statusCode == 201) {
        return UpdateCategoryModel.fromJson(json.decode(body));
      } else if (response.statusCode == 422) {
        Map<String, dynamic> errorResponse = {};
        try {
          errorResponse = json.decode(body);
        } catch (_) {}
        String errorMessage = 'Validation failed';
        if (errorResponse['message'] != null) {
          errorMessage = errorResponse['message'];
        }
        if (errorResponse['errors'] != null && errorResponse['errors'] is Map) {
          final Map<String, dynamic> errors = errorResponse['errors'];
          final List<String> messages = [];
          errors.forEach((field, msgs) {
            if (msgs is List) {
              messages.addAll(msgs.map((m) => m.toString()));
            } else if (msgs != null) {
              messages.add(msgs.toString());
            }
          });
          if (messages.isNotEmpty) {
            errorMessage = messages.join(', ');
          }
        }
        throw Exception('Validation error: $errorMessage');
      } else {
        throw Exception('Failed to update category: ${response.statusCode} - $body');
      }
    } catch (e) {
      throw Exception('Update category error: $e');
    }
  }
  
  // Delete Category by ID
  static Future<DeleteCategoryModel> deleteCategory(String token, int id) async {
    try {
      final response = await http.delete(
        Uri.parse(ApiUrls.categoryDelete(id)),
        headers: _getHeaders(token: token),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return DeleteCategoryModel.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to delete category: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Delete category error: $e');
    }
  }
}
