import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api_url.dart';
import '../App_model/Advertise_model/CreateAdvertiseModel.dart';
import '../App_model/Advertise_model/GetAdvertiseModel.dart';
import '../App_model/Advertise_model/UpdateAdvertiseModel.dart';
import '../App_model/Advertise_model/DeleteAdvertiseModel.dart';
import 'auth_service.dart';

class AdvertiseService {
  static const String baseUrl = ApiUrls.baseUrl;

  // Get all advertisements with pagination and search support
  static Future<GetAdvertiseModel> getAdvertises({
    int page = 1,
    int limit = 20,
    String? search,
  }) async {
    try {
      // Get authentication token
      String? token = await AuthService.getToken();
      if (token == null) {
        throw Exception('No authentication token found');
      }
      
      // Build URL with query parameters
      Uri uri = Uri.parse(ApiUrls.advertiseList).replace(queryParameters: {
        'page': page.toString(),
        'limit': limit.toString(),
        if (search != null && search.isNotEmpty) 'search': search,
      });
      
      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () => throw Exception('Request timeout'),
      );

      if (response.statusCode == 200) {
        return GetAdvertiseModel.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load advertisements: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching advertisements: $e');
    }
  }

  // Create new advertisement
  static Future<CreateAdvertiseModel> createAdvertise(Map<String, dynamic> advertiseData) async {
    try {
      // Get authentication token
      String? token = await AuthService.getToken();
      if (token == null) {
        throw Exception('No authentication token found');
      }
      
      final response = await http.post(
        Uri.parse(ApiUrls.advertiseCreate),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(advertiseData),
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () => throw Exception('Request timeout'),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return CreateAdvertiseModel.fromJson(json.decode(response.body));
      } else if (response.statusCode == 422) {
        // Handle validation errors specifically
        final errorData = json.decode(response.body);
        String errorMessage = 'Validation error occurred';
        
        if (errorData['errors'] != null) {
          // Extract specific validation errors
          final errors = errorData['errors'];
          if (errors['socialmedia'] != null) {
            errorMessage = 'Invalid platform. Please use: facebook, instagram, twitter, threads, or pinterest';
          }
        } else if (errorData['message'] != null) {
          errorMessage = errorData['message'];
        }
        
        throw Exception(errorMessage);
      } else {
        // Try to parse error response for more details
        String errorMessage = 'Failed to create advertisement: ${response.statusCode}';
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
      throw Exception('Error creating advertisement: $e');
    }
  }

  // Update advertisement
  static Future<UpdateAdvertiseModel> updateAdvertise(int id, Map<String, dynamic> advertiseData) async {
    try {
      // Get authentication token
      String? token = await AuthService.getToken();
      if (token == null) {
        throw Exception('No authentication token found');
      }
      
      final response = await http.put(
        Uri.parse(ApiUrls.advertiseUpdate(id)),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(advertiseData),
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () => throw Exception('Request timeout'),
      );

      if (response.statusCode == 200) {
        return UpdateAdvertiseModel.fromJson(json.decode(response.body));
      } else if (response.statusCode == 422) {
        // Handle validation errors specifically
        final errorData = json.decode(response.body);
        String errorMessage = 'Validation error occurred';
        
        if (errorData['errors'] != null) {
          // Extract specific validation errors
          final errors = errorData['errors'];
          if (errors['socialmedia'] != null) {
            errorMessage = 'Invalid platform. Please use: facebook, instagram, twitter, threads, or pinterest';
          }
        } else if (errorData['message'] != null) {
          errorMessage = errorData['message'];
        }
        
        throw Exception(errorMessage);
      } else {
        // Try to parse error response for more details
        String errorMessage = 'Failed to update advertisement: ${response.statusCode}';
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
      throw Exception('Error updating advertisement: $e');
    }
  }

  // Delete advertisement
  static Future<DeleteAdvertiseModel> deleteAdvertise(int id) async {
    try {
      // Get authentication token
      String? token = await AuthService.getToken();
      if (token == null) {
        throw Exception('No authentication token found');
      }
      
      final response = await http.delete(
        Uri.parse(ApiUrls.advertiseDelete(id)),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () => throw Exception('Request timeout'),
      );

      if (response.statusCode == 200) {
        return DeleteAdvertiseModel.fromJson(json.decode(response.body));
      } else {
        // Try to parse error response for more details
        String errorMessage = 'Failed to delete advertisement: ${response.statusCode}';
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
      throw Exception('Error deleting advertisement: $e');
    }
  }
}
