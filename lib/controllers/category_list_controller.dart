import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../screens/Category/create_category_screen.dart';
import '../screens/Category/update_category_screen.dart';
import '../services/auth_service.dart';
import '../App_model/Category_model/GetCatgoryModel.dart';

class CategoryListController extends GetxController {
  final TextEditingController searchController = TextEditingController();
  final selectedEntries = '10'.obs;
  final entriesOptions = ['10', '25', '50', '100'].obs;
  final currentPage = 1.obs;
  final totalPages = 1.obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  
  final categories = <Map<String, dynamic>>[].obs;
  final filteredCategories = <Map<String, dynamic>>[].obs;
  
  @override
  void onInit() {
    super.onInit();
    fetchCategories();
    searchController.addListener(_onSearchChanged);
  }
  
  Future<void> fetchCategories() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final GetCatgoryModel model = await AuthService.getCategoryList();
      final List<Map<String, dynamic>> items = (model.data ?? [])
          .map((Data d) => {
                'id': d.id ?? 0,
                'name': d.name ?? '',
                'sku': d.skubarCode ?? '',
                'imageUrl': d.image ?? '',
              })
          .toList();
      items.sort((a, b) => (a['id'] ?? 0).compareTo(b['id'] ?? 0));
      categories.assignAll(items);
      filteredCategories.assignAll(items);
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar(
        'Error',
        errorMessage.value,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
  
  List<Map<String, dynamic>> get paginatedData {
    final entriesPerPage = int.parse(selectedEntries.value);
    final dataList = filteredCategories.isEmpty ? categories : filteredCategories;
    totalPages.value = (dataList.length / entriesPerPage).ceil();
    
    final startIndex = (currentPage.value - 1) * entriesPerPage;
    if (startIndex >= dataList.length) {
      currentPage.value = 1;
      return dataList.take(entriesPerPage).toList();
    }
    return dataList.skip(startIndex).take(entriesPerPage).toList();
  }
  
  int get totalEntries {
    return filteredCategories.isEmpty ? categories.length : filteredCategories.length;
  }
  
  void updateEntries(String? value) {
    if (value != null) {
      selectedEntries.value = value;
      currentPage.value = 1;
    }
  }
  
  void _onSearchChanged() {
    final query = searchController.text.toLowerCase().trim();
    if (query.isEmpty) {
      filteredCategories.clear();
    } else {
      final filtered = categories.where((category) {
        final name = (category['name'] as String).toLowerCase();
        final sku = (category['sku'] as String).toLowerCase();
        final id = category['id'].toString();
        return name.contains(query) || sku.contains(query) || id.contains(query);
      }).toList();
      filteredCategories.assignAll(filtered);
    }
    currentPage.value = 1;
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
    Get.to(() => const CreateCategoryScreen(showAppBar: true));
  }
  
  void navigateToUpdateCategory(Map<String, dynamic> categoryData) {
    Get.to(() => UpdateCategoryScreen(categoryData: categoryData, showAppBar: true));
  }
  
  void deleteCategory(int id) async {
    bool? confirm = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Delete'),
        content: Text('Are you sure you want to delete category #$id?'),
        actions: [
          TextButton(onPressed: () => Get.back(result: false), child: const Text('Cancel')),
          TextButton(onPressed: () => Get.back(result: true), child: const Text('Delete')),
        ],
      ),
    );
    if (confirm == true) {
      try {
        final result = await AuthService.deleteCategory(id);
        if (result.status == true) {
          Get.snackbar(
            'Success',
            result.message ?? 'Category deleted successfully',
            backgroundColor: Colors.green,
            colorText: Colors.white,
            duration: const Duration(seconds: 3),
          );
          await fetchCategories();
        } else {
          Get.snackbar(
            'Error',
            result.message ?? 'Failed to delete category',
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } catch (e) {
        Get.snackbar(
          'Error',
          e.toString(),
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    }
  }
  
  @override
  void onClose() {
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    super.onClose();
  }
}
