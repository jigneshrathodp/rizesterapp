import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductListController extends GetxController {
  final TextEditingController searchController = TextEditingController();
  final selectedEntries = '10'.obs;
  final entriesOptions = ['10', '25', '50', '100'].obs;
  final currentPage = 1.obs;
  final totalPages = 1.obs;
  
  // Sample jewelry data
  final productData = [
    {
      'id': 1,
      'name': 'Gold Diamond Ring',
      'category': 'Rings',
      'sku': 'JWL-001',
      'price': '₹52,000',
      'quantity': '2',
      'status': 'Active',
    },
    {
      'id': 2,
      'name': 'Silver Chain Necklace',
      'category': 'Necklaces',
      'sku': 'JWL-002',
      'price': '₹25,000',
      'quantity': '1',
      'status': 'Active',
    },
    {
      'id': 3,
      'name': 'Pearl Earrings',
      'category': 'Earrings',
      'sku': 'JWL-003',
      'price': '₹35,000',
      'quantity': '3',
      'status': 'Active',
    },
    {
      'id': 4,
      'name': 'Gold Bracelet',
      'category': 'Bracelets',
      'sku': 'JWL-004',
      'price': '₹45,000',
      'quantity': '0',
      'status': 'Inactive',
    },
    {
      'id': 5,
      'name': 'Diamond Pendant',
      'category': 'Pendants',
      'sku': 'JWL-005',
      'price': '₹28,000',
      'quantity': '4',
      'status': 'Active',
    },
  ].obs;
  
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
  
  void deleteProduct(int productId) {
    productData.removeWhere((p) => p['id'] == productId);
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
          TextButton(
            onPressed: () {
              Get.back();
              deleteProduct(productId);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
  
  void navigateToCreateProduct() {
    Get.toNamed('/create-product');
  }
  
  void navigateToUpdateProduct(Map<String, dynamic> productData) {
    Get.toNamed('/update-product', arguments: productData);
  }
  
  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
