import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import '../App_model/Category_model/CreateCategoryModel.dart';
import '../App_model/Category_model/DeleteCategoryModel.dart';
import '../App_model/Category_model/GetCatgoryModel.dart';
import '../App_model/Category_model/UpdateCategoryModel.dart';
import '../api_url.dart';

class CategoryService {
  static Map<String, String> _getHeaders({required String token}) {
    return {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    };
  }

  // Get Category List with pagination and search support
  static Future<GetCatgoryModel> getCategoryList(String token, {
    int page = 1,
    int limit = 20,
    String? search,
  }) async {
    try {
      // Build URL with query parameters
      Uri uri = Uri.parse(ApiUrls.categoryList).replace(queryParameters: {
        'page': page.toString(),
        'limit': limit.toString(),
        if (search != null && search.isNotEmpty) 'search': search,
      });
      
      final response = await http.get(
        uri,
        headers: _getHeaders(token: token),
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () => throw Exception('Request timeout'),
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
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () => throw Exception('Request timeout'),
      );
      if (response.statusCode == 200) {
        return UpdateCategoryModel.fromJson(json.decode(response.body));
      } else {
        // Try to parse error response for more details
        String errorMessage = 'Failed to get category: ${response.statusCode}';
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
        'Content-Type': 'multipart/form-data',
      });

      request.fields['name'] = name;
      request.fields['skubar_code'] = skubarCode;
      if (image != null && image.path.isNotEmpty) {
        request.files.add(await http.MultipartFile.fromPath('image', image.path));
      }

      final response = await request.send().timeout(
        const Duration(seconds: 30),
        onTimeout: () => throw Exception('Request timeout'),
      );
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
        'Content-Type': 'multipart/form-data',
      });
      request.fields['name'] = name;
      request.fields['skubar_code'] = skubarCode;
      if (image != null && image.path.isNotEmpty) {
        request.files.add(await http.MultipartFile.fromPath('image', image.path));
      }
      final response = await request.send().timeout(
        const Duration(seconds: 30),
        onTimeout: () => throw Exception('Request timeout'),
      );
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
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () => throw Exception('Request timeout'),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return DeleteCategoryModel.fromJson(json.decode(response.body));
      } else {
        // Try to parse error response for more details
        String errorMessage = 'Failed to delete category: ${response.statusCode}';
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
      throw Exception('Delete category error: $e');
    }
  }
}
