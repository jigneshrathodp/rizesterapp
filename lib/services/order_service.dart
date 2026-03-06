import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api_url.dart';
import '../App_model/Order_model/CreateOrderModel.dart';
import '../App_model/Order_model/GetOrderModel.dart';
import '../App_model/Order_model/DeleteOrderModel.dart';

class OrderService {
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

  // Get Order List with pagination and search support
  static Future<GetOrderModel> getOrderList(String token, {
    int page = 1,
    int limit = 20,
    String? search,
  }) async {
    try {
      // Build URL with query parameters
      Uri uri = Uri.parse(ApiUrls.orderList).replace(queryParameters: {
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
        return GetOrderModel.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to get orders: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Order list error: $e');
    }
  }

  // Get Order Detail by ID
  static Future<GetOrderModel> getOrderDetail(String token, int id) async {
    try {
      final response = await http.get(
        Uri.parse(ApiUrls.orderDetail(id)),
        headers: _getHeaders(token: token),
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () => throw Exception('Request timeout'),
      );
      
      if (response.statusCode == 200) {
        return GetOrderModel.fromJson(json.decode(response.body));
      } else {
        // Try to parse error response for more details
        String errorMessage = 'Failed to get order detail: ${response.statusCode}';
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
      throw Exception('Order detail error: $e');
    }
  }

  // Create Order
  static Future<CreateOrderModel> createOrder(
    String token, {
    required int productId,
    required String customerName,
    required String customerEmail,
    required String customerPhone,
    required String customerAddress,
    required int quantity,
    required String sellingPricePerGram,
    required int shippingCost,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(ApiUrls.orderCreate),
        headers: _getHeaders(token: token),
        body: jsonEncode({
          'product_id': productId,
          'customer_name': customerName,
          'customer_email': customerEmail,
          'customer_phone': customerPhone,
          'customer_address': customerAddress,
          'quantity': quantity,
          'selling_price_per_gram': sellingPricePerGram,
          'shipping_cost': shippingCost,
        }),
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () => throw Exception('Request timeout'),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return CreateOrderModel.fromJson(json.decode(response.body));
      } else if (response.statusCode == 422) {
        Map<String, dynamic> errorResponse = {};
        try {
          errorResponse = json.decode(response.body);
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
        throw Exception('Failed to create order: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Create order error: $e');
    }
  }

  // Delete Order by ID
  static Future<DeleteOrderModel> deleteOrder(String token, int id) async {
    try {
      final response = await http.delete(
        Uri.parse(ApiUrls.orderDelete(id)),
        headers: _getHeaders(token: token),
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () => throw Exception('Request timeout'),
      );
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        return DeleteOrderModel.fromJson(json.decode(response.body));
      } else {
        // Try to parse error response for more details
        String errorMessage = 'Failed to delete order: ${response.statusCode}';
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
      throw Exception('Delete order error: $e');
    }
  }
}
