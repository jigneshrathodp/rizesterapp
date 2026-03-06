import 'package:rizesterapp/services/product_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_service.dart';
import '../App_model/profile_model/LoginModel.dart';
import '../App_model/profile_model/GetProfileModel.dart';
import '../App_model/profile_model/UpdateProfileModel.dart';
import '../App_model/profile_model/ResetPasswordModel.dart';
import '../App_model/profile_model/LogoutModel.dart';
import '../App_model/profile_model/GetDashboardModel.dart';
import '../App_model/Category_model/GetCatgoryModel.dart';
import '../App_model/Category_model/CreateCategoryModel.dart';
import '../App_model/Category_model/UpdateCategoryModel.dart';
import '../App_model/Category_model/DeleteCategoryModel.dart';
import '../App_model/product_model/GetproductModel.dart';
import '../App_model/product_model/CreateProductModel.dart';
import '../App_model/product_model/UpdateProductModel.dart';
import '../App_model/product_model/DeleteProductModel.dart';
import 'package:image_picker/image_picker.dart';

import 'category_service.dart';

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
    String confirmPassword,
  ) async {
    try {
      String? token = await getToken();
      
      if (token == null) {
        throw Exception('No authentication token found');
      }
      
      return await ApiService.resetPassword(token, currentPassword, newPassword, confirmPassword);
    } catch (e) {
      throw Exception('Failed to reset password: $e');
    }
  }

  // Check if user is logged in
  static Future<bool> isLoggedIn() async {
    String? token = await getToken();
    return token != null && token.isNotEmpty;
  }

  // Get Dashboard data
  static Future<GetDashboardModel> getDashboard() async {
    try {
      String? token = await getToken();
      
      if (token == null) {
        throw Exception('No authentication token found');
      }
      
      return await ApiService.getDashboard(token);
    } catch (e) {
      throw Exception('Failed to get dashboard: $e');
    }
  }
  
  // Get categories with pagination and search support
  static Future<GetCatgoryModel> getCategoryList({
    int page = 1,
    int limit = 20,
    String? search,
  }) async {
    try {
      String? token = await getToken();
      if (token == null) {
        throw Exception('No authentication token found');
      }
      return await CategoryService.getCategoryList(
        token,
        page: page,
        limit: limit,
        search: search,
      );
    } catch (e) {
      throw Exception('Failed to get categories: $e');
    }
  }
  
  // Create category
  static Future<CreateCategoryModel> createCategory({
    required String name,
    required String skubarCode,
    XFile? image,
  }) async {
    try {
      String? token = await getToken();
      if (token == null) {
        throw Exception('No authentication token found');
      }
      return await CategoryService.createCategory(
        token,
        name: name,
        skubarCode: skubarCode,
        image: image,
      );
    } catch (e) {
      throw Exception('Failed to create category: $e');
    }
  }
  
  // View category by ID
  static Future<UpdateCategoryModel> getCategoryById(int id) async {
    try {
      String? token = await getToken();
      if (token == null) {
        throw Exception('No authentication token found');
      }
      return await CategoryService.getCategoryById(token, id);
    } catch (e) {
      throw Exception('Failed to get category: $e');
    }
  }
  
  // Update category
  static Future<UpdateCategoryModel> updateCategory({
    required int id,
    required String name,
    required String skubarCode,
    XFile? image,
  }) async {
    try {
      String? token = await getToken();
      if (token == null) {
        throw Exception('No authentication token found');
      }
      return await CategoryService.updateCategory(
        token,
        id: id,
        name: name,
        skubarCode: skubarCode,
        image: image,
      );
    } catch (e) {
      throw Exception('Failed to update category: $e');
    }
  }
  
  // Delete category
  static Future<DeleteCategoryModel> deleteCategory(int id) async {
    try {
      String? token = await getToken();
      if (token == null) {
        throw Exception('No authentication token found');
      }
      return await CategoryService.deleteCategory(token, id);
    } catch (e) {
      throw Exception('Failed to delete category: $e');
    }
  }

  // ================= PRODUCT SERVICES =================

  // Get products with pagination and search support
  static Future<GetproductModel> getProductList(
    String token, {
    int page = 1,
    int limit = 20,
    String? search,
  }) async {
    try {
      if (token == null) {
        throw Exception('No authentication token found');
      }
      return await ProductService.getProductList(
        token,
        page: page,
        limit: limit,
        search: search,
      );
    } catch (e) {
      throw Exception('Failed to get products: $e');
    }
  }

  // Get product by ID
  static Future<UpdateProductModel> getProductById(int id) async {
    try {
      String? token = await getToken();
      if (token == null) {
        throw Exception('No authentication token found');
      }
      return await ProductService.getProductById(token, id);
    } catch (e) {
      throw Exception('Failed to get product: $e');
    }
  }

  // Create product
  static Future<CreateProductModel> createProduct({
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
      String? token = await getToken();
      if (token == null) {
        throw Exception('No authentication token found');
      }
      return await ProductService.createProduct(
        token,
        name: name,
        category: category,
        qnty: qnty,
        weightInGram: weightInGram,
        costPerGram: costPerGram,
        image: image,
        sts: sts,
        forSale: forSale,
      );
    } catch (e) {
      throw Exception('Failed to create product: $e');
    }
  }

  // Update product
  static Future<UpdateProductModel> updateProduct({
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
      String? token = await getToken();
      if (token == null) {
        throw Exception('No authentication token found');
      }
      return await ProductService.updateProduct(
        token,
        id: id,
        name: name,
        category: category,
        qnty: qnty,
        weightInGram: weightInGram,
        costPerGram: costPerGram,
        image: image,
        sts: sts,
        forSale: forSale,
      );
    } catch (e) {
      throw Exception('Failed to update product: $e');
    }
  }

  // Delete product
  static Future<DeleteProductModel> deleteProduct(int id) async {
    try {
      String? token = await getToken();
      if (token == null) {
        throw Exception('No authentication token found');
      }
      return await ProductService.deleteProduct(token, id);
    } catch (e) {
      throw Exception('Failed to delete product: $e');
    }
  }

}
