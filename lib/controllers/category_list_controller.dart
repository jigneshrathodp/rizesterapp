import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../screens/Category/create_category_screen.dart';
import '../screens/Category/update_category_screen.dart';

class CategoryListController extends GetxController {
  final TextEditingController searchController = TextEditingController();
  final selectedEntries = '10'.obs;
  final entriesOptions = ['10', '25', '50', '100'].obs;
  final currentPage = 1.obs;
  final totalPages = 1.obs;
  
  // Sample data
  final categories = [
    {
      'id': 1,
      'name': 'Rings',
      'sku': 'JWL-RNG-001',
      'barcode': '1234567890',
      'date': '2024-01-15',
    },
    {
      'id': 2,
      'name': 'Necklaces',
      'sku': 'JWL-NCK-002',
      'barcode': '2345678901',
      'date': '2024-01-16',
    },
    {
      'id': 3,
      'name': 'Earrings',
      'sku': 'JWL-EAR-003',
      'barcode': '3456789012',
      'date': '2024-01-17',
    },
    {
      'id': 4,
      'name': 'Bracelets',
      'sku': 'JWL-BRC-004',
      'barcode': '4567890123',
      'date': '2024-01-18',
    },
    {
      'id': 5,
      'name': 'Pendants',
      'sku': 'JWL-PND-005',
      'barcode': '5678901234',
      'date': '2024-01-19',
    },
  ].obs;
  
  List<Map<String, dynamic>> get paginatedData {
    final entriesPerPage = int.parse(selectedEntries.value);
    totalPages.value = (categories.length / entriesPerPage).ceil();
    
    final startIndex = (currentPage.value - 1) * entriesPerPage;

    if (startIndex >= categories.length) {
      currentPage.value = 1;
      return categories.take(entriesPerPage).toList();
    }
    
    return categories.skip(startIndex).take(entriesPerPage).toList();
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
  
  void navigateToCreateCategory() {
    Get.to(() => const CreateCategoryScreen());
  }
  
  void navigateToUpdateCategory(Map<String, dynamic> categoryData) {
    Get.to(() => UpdateCategoryScreen(categoryData: categoryData));
  }
  
  void deleteCategory(int id) {
    categories.removeWhere((category) => category['id'] == id);
    Get.snackbar(
      'Category Deleted',
      'Category #$id deleted',
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }
  
  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
