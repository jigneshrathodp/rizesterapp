import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import '../App_model/product_model/CreateProductModel.dart';
import '../App_model/product_model/DeleteProductModel.dart';
import '../App_model/product_model/GetproductModel.dart';
import '../App_model/product_model/UpdateProductModel.dart';
import '../api_url.dart';

class ProductService {
  // ================= PRODUCT APIS =================

  static Map<String, String> _getHeaders({required String token}) {
    return {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    };
  }

  // Get Product List with pagination and search support
  static Future<GetproductModel> getProductList(String token, {
    int page = 1,
    int limit = 20,
    String? search,
  }) async {
    try {
      // Build URL with query parameters
      Uri uri = Uri.parse(ApiUrls.productList).replace(queryParameters: {
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
        return GetproductModel.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to get products: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Product list error: $e');
    }
  }

// Get Product by ID
  static Future<UpdateProductModel> getProductById(String token, int id) async {
    try {
      final response = await http.get(
        Uri.parse(ApiUrls.productView(id)),
        headers: _getHeaders(token: token),
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () => throw Exception('Request timeout'),
      );
      if (response.statusCode == 200) {
        return UpdateProductModel.fromJson(json.decode(response.body));
      } else {
        // Try to parse error response for more details
        String errorMessage = 'Failed to get product: ${response.statusCode}';
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
      throw Exception('Product view error: $e');
    }
  }

// Create Product with image upload
  static Future<CreateProductModel> createProduct(String token, {
    required String name,
    required String category,
    required String qnty,
    required String weightInGram,
    required String costPerGram,
    XFile? image,
    required String sts,
    required String forSale,
  }) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(ApiUrls.productCreate),
      );
      request.headers.addAll({
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'multipart/form-data',
      });

      request.fields['name'] = name;
      request.fields['category'] = category;
      request.fields['qnty'] = qnty;
      request.fields['weight_in_gram'] = weightInGram;
      request.fields['cost_per_gram'] = costPerGram;
      request.fields['sts'] = sts;
      request.fields['for_sale'] = forSale;

      if (image != null && image.path.isNotEmpty) {
        request.files.add(
            await http.MultipartFile.fromPath('image', image.path));
      }

      final response = await request.send().timeout(
        const Duration(seconds: 30),
        onTimeout: () => throw Exception('Request timeout'),
      );
      final body = await response.stream.bytesToString();
      if (response.statusCode == 200 || response.statusCode == 201) {
        return CreateProductModel.fromJson(json.decode(body));
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
        // Try to parse error response for more details
        String errorMessage = 'Failed to create product: ${response.statusCode}';
        try {
          final errorData = json.decode(body);
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
      throw Exception('Create product error: $e');
    }
  }

// Update Product by ID with optional image
  static Future<UpdateProductModel> updateProduct(String token, {
    required int id,
    required String name,
    required String category,
    required String qnty,
    required String weightInGram,
    required String costPerGram,
    XFile? image,
    required String sts,
    required String forSale,
  }) async {
    try {
      var request = http.MultipartRequest(
        'PUT',
        Uri.parse(ApiUrls.productUpdate(id)),
      );
      request.headers.addAll({
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'multipart/form-data',
      });

      request.fields['name'] = name;
      request.fields['category'] = category;
      request.fields['qnty'] = qnty;
      request.fields['weight_in_gram'] = weightInGram;
      request.fields['cost_per_gram'] = costPerGram;
      request.fields['sts'] = sts;
      request.fields['for_sale'] = forSale;

      if (image != null && image.path.isNotEmpty) {
        request.files.add(
            await http.MultipartFile.fromPath('image', image.path));
      }

      final response = await request.send().timeout(
        const Duration(seconds: 30),
        onTimeout: () => throw Exception('Request timeout'),
      );
      final body = await response.stream.bytesToString();
      if (response.statusCode == 200 || response.statusCode == 201) {
        return UpdateProductModel.fromJson(json.decode(body));
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
        // Try to parse error response for more details
        String errorMessage = 'Failed to update product: ${response.statusCode}';
        try {
          final errorData = json.decode(body);
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
      throw Exception('Update product error: $e');
    }
  }

// Delete Product by ID
  static Future<DeleteProductModel> deleteProduct(String token, int id) async {
    try {
      final response = await http.delete(
        Uri.parse(ApiUrls.productDelete(id)),
        headers: _getHeaders(token: token),
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () => throw Exception('Request timeout'),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return DeleteProductModel.fromJson(json.decode(response.body));
      } else {
        // Try to parse error response for more details
        String errorMessage = 'Failed to delete product: ${response.statusCode}';
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
      throw Exception('Delete product error: $e');
    }
  }


}