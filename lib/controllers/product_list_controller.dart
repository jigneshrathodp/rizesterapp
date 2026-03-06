import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/auth_service.dart';
import '../services/snackbar_service.dart';
import '../App_model/product_model/GetproductModel.dart';
import '../App_model/product_model/DeleteProductModel.dart';
import '../App_model/Category_model/GetCatgoryModel.dart';
import '../App_model/category_helper.dart';
import '../screens/Product/create_product_screen.dart';
import '../screens/Product/update_product_screen.dart';

class ProductListController extends GetxController {
  final TextEditingController searchController = TextEditingController();
  final selectedEntries = '10'.obs;
  final entriesOptions = ['10', '25', '50', '100'].obs;
  final currentPage = 1.obs;
  final totalPages = 1.obs;
  final pageSize = 20;
  final hasReachedMax = false.obs;
  final searchQuery = ''.obs;
  
  // Reactive variables
  final productData = <Map<String, dynamic>>[].obs;
  final categories = <CategoryHelper>[].obs;
  final isLoading = false.obs;
  final isLoadingMore = false.obs;
  final isDeleting = false.obs;
  
  @override
  void onInit() {
    super.onInit();
    
    // Add search listener
    searchController.addListener(() {
      searchProducts(searchController.text);
    });
    
    fetchCategories();
    fetchProducts();
  }
  
  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
  
  // Fetch categories from API
  Future<void> fetchCategories() async {
    try {
      GetCatgoryModel categoryModel = await AuthService.getCategoryList();
      if (categoryModel.data != null) {
        categories.value = categoryModel.data!.map((category) => 
          CategoryHelper.fromJson(category.toJson())
        ).toList();
      }
    } catch (e) {
      SnackbarService.showException(Exception(e.toString()));
    }
  }
  
  // Get category name by ID
  String getCategoryName(String? categoryId) {
    if (categoryId == null || categoryId.isEmpty) return 'Unknown';
    final category = categories.firstWhereOrNull(
      (cat) => cat.id.toString() == categoryId,
    );
    return category?.name ?? 'Unknown';
  }
  
  // Fetch products from API with lazy loading
  Future<void> fetchProducts({bool refresh = false}) async {
    if (refresh) {
      currentPage.value = 1;
      hasReachedMax.value = false;
      productData.clear();
    }
    
    if (isLoading.value || hasReachedMax.value) return;
    
    try {
      isLoading.value = true;
      
      // Get token from AuthService
      String? token = await AuthService.getToken();
      
      if (token == null) {
        SnackbarService.showError('No authentication token found');
        return;
      }
      
      GetproductModel productModel = await AuthService.getProductList(
        token, 
        page: currentPage.value,
        limit: pageSize,
        search: searchQuery.value.isNotEmpty ? searchQuery.value : null,
      );
      
      if (productModel.data != null) {
        if (refresh) {
          productData.clear();
        }
        
        for (var product in productModel.data!) {
          productData.add({
            'id': product.id,
            'name': product.name,
            'category': product.categoryId,
            'sku': product.sku,
            'quantity': product.quantity,
            'weight_in_gram': product.weightInGram,
            'cost_per_gram': product.costPerGram,
            'total_cost': product.totalCost?.toString() ?? '0',
            'sell_price': product.sellPrice ?? 'Not set',
            'image': product.image,
            'active': product.active == 1 ? 'Active' : 'Inactive',
            'for_sale': product.forSale == 1 ? 'Yes' : 'No',
          });
        }
        
        // Check if we've reached the end
        if (productModel.data!.length < pageSize) {
          hasReachedMax.value = true;
        } else {
          currentPage.value++;
        }
      }
    } catch (e) {
      SnackbarService.showException(Exception(e.toString()));
    } finally {
      isLoading.value = false;
    }
  }
  
  Future<void> loadMoreProducts() async {
    if (isLoadingMore.value || hasReachedMax.value) return;
    
    try {
      isLoadingMore.value = true;
      
      String? token = await AuthService.getToken();
      
      if (token == null) {
        SnackbarService.showError('No authentication token found');
        return;
      }
      
      GetproductModel productModel = await AuthService.getProductList(
        token, 
        page: currentPage.value,
        limit: pageSize,
        search: searchQuery.value.isNotEmpty ? searchQuery.value : null,
      );
      
      if (productModel.data != null) {
        for (var product in productModel.data!) {
          productData.add({
            'id': product.id,
            'name': product.name,
            'category': product.categoryId,
            'sku': product.sku,
            'quantity': product.quantity,
            'weight_in_gram': product.weightInGram,
            'cost_per_gram': product.costPerGram,
            'total_cost': product.totalCost?.toString() ?? '0',
            'sell_price': product.sellPrice ?? 'Not set',
            'image': product.image,
            'active': product.active == 1 ? 'Active' : 'Inactive',
            'for_sale': product.forSale == 1 ? 'Yes' : 'No',
          });
        }
        
        if (productModel.data!.length < pageSize) {
          hasReachedMax.value = true;
        } else {
          currentPage.value++;
        }
      }
    } catch (e) {
      SnackbarService.showException(Exception(e.toString()));
    } finally {
      isLoadingMore.value = false;
    }
  }
  
  void searchProducts(String query) {
    searchQuery.value = query;
    fetchProducts(refresh: true);
  }
  
  void refreshProducts() {
    fetchProducts(refresh: true);
  }
  
  List<Map<String, dynamic>> get paginatedData {
    final entriesPerPage = int.parse(selectedEntries.value);
    totalPages.value = (productData.length / entriesPerPage).ceil();
    
    final startIndex = (currentPage.value - 1) * entriesPerPage;

    if (startIndex >= productData.length) {
      currentPage.value = 1;
      return productData.take(entriesPerPage).toList();
    }
    
    return productData.skip(startIndex).take(entriesPerPage).toList();
  }
  
  void updateEntries(String? value) {
    if (value != null) {
      selectedEntries.value = value;
      currentPage.value = 1;
    }
  }
  
  void goToPreviousPage() {
    if (currentPage.value > 1) {
      currentPage.value--;
    }
  }
  
  void goToNextPage() {
    if (currentPage.value < totalPages.value) {
      currentPage.value++;
    }
  }
  
  Future<void> deleteProduct(int productId) async {
    try {
      isDeleting.value = true;
      DeleteProductModel result = await AuthService.deleteProduct(productId);
      
      if (result.status == true) {
        productData.removeWhere((p) => p['id'] == productId);
        SnackbarService.showSuccess(result.message ?? 'Product deleted successfully');
      } else {
        SnackbarService.showError(result.message ?? 'Failed to delete product');
      }
    } catch (e) {
      SnackbarService.showException(Exception(e.toString()));
    } finally {
      isDeleting.value = false;
    }
  }
  
  void showDeleteDialog(String productName, int productId) {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete Product'),
        content: Text('Are you sure you want to delete $productName?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          Obx(
            () => TextButton(
              onPressed: isDeleting.value ? null : () async {
                Get.back();
                await deleteProduct(productId);
              },
              child: isDeleting.value 
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ),
        ],
      ),
    );
  }
  
  void navigateToCreateProduct() {
    Get.to(() => const CreateProductScreen(showAppBar: true))?.then((_) {
      refreshProducts();
    });
  }
  
  void navigateToUpdateProduct(Map<String, dynamic> productData) {
    Get.to(() => UpdateProductScreen(productData: productData, showAppBar: true))?.then((_) {
      refreshProducts();
    });
  }
}
