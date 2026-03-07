import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../screens/Category/create_category_screen.dart';
import '../screens/Category/update_category_screen.dart';
import '../services/auth_service.dart';
import '../services/snackbar_service.dart';
import '../App_model/Category_model/GetCatgoryModel.dart';

class CategoryListController extends GetxController {
  final TextEditingController searchController = TextEditingController();
  final selectedEntries = '10'.obs;
  final entriesOptions = ['10', '25', '50', '100'].obs;
  final currentPage = 1.obs;
  final totalPages = 1.obs;
  final pageSize = 20;
  final hasReachedMax = false.obs;
  final searchQuery = ''.obs;
  final isLoading = false.obs;
  final isLoadingMore = false.obs;
  final errorMessage = ''.obs;
  
  final categories = <Map<String, dynamic>>[].obs;
  final filteredCategories = <Map<String, dynamic>>[].obs;
  
  @override
  void onInit() {
    super.onInit();
    fetchCategories();
    searchController.addListener(_onSearchChanged);
  }
  
  Future<void> fetchCategories({bool refresh = false}) async {
    if (refresh) {
      currentPage.value = 1;
      hasReachedMax.value = false;
      categories.clear();
      filteredCategories.clear();
    }
    
    if (isLoading.value || hasReachedMax.value) return;
    
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final GetCatgoryModel model = await AuthService.getCategoryList(
        page: currentPage.value,
        limit: pageSize,
        search: searchQuery.value.isNotEmpty ? searchQuery.value : null,
      );
      
      final List<Map<String, dynamic>> items = (model.data ?? [])
          .map((Data d) => {
                'id': d.id ?? 0,
                'name': d.name ?? '',
                'sku': d.skubarCode ?? '',
                'imageUrl': d.image ?? '',
              })
          .toList();
      
      items.sort((a, b) => (a['id'] ?? 0).compareTo(b['id'] ?? 0));
      
      if (refresh) {
        categories.clear();
      }
      
      categories.addAll(items);
      filteredCategories.assignAll(categories);
      
      if (items.length < pageSize) {
        hasReachedMax.value = true;
      } else {
        currentPage.value++;
      }
    } catch (e) {
      errorMessage.value = e.toString();
      SnackbarService.showException(Exception(e.toString()));
    } finally {
      isLoading.value = false;
    }
  }
  
  Future<void> loadMoreCategories() async {
    if (isLoadingMore.value || hasReachedMax.value) return;
    
    try {
      isLoadingMore.value = true;
      
      final GetCatgoryModel model = await AuthService.getCategoryList(
        page: currentPage.value,
        limit: pageSize,
        search: searchQuery.value.isNotEmpty ? searchQuery.value : null,
      );
      
      final List<Map<String, dynamic>> items = (model.data ?? [])
          .map((Data d) => {
                'id': d.id ?? 0,
                'name': d.name ?? '',
                'sku': d.skubarCode ?? '',
                'imageUrl': d.image ?? '',
              })
          .toList();
      
      items.sort((a, b) => (a['id'] ?? 0).compareTo(b['id'] ?? 0));
      
      categories.addAll(items);
      filteredCategories.assignAll(categories);
      
      if (items.length < pageSize) {
        hasReachedMax.value = true;
      } else {
        currentPage.value++;
      }
    } catch (e) {
      SnackbarService.showException(Exception(e.toString()));
    } finally {
      isLoadingMore.value = false;
    }
  }
  
  void searchCategories(String query) {
    searchQuery.value = query;
    fetchCategories(refresh: true);
  }
  
  void refreshCategories() {
    fetchCategories(refresh: true);
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
    Get.to(() => const CreateCategoryScreen(showAppBar: true))?.then((_) {
      refreshCategories();
    });
  }
  
  void navigateToUpdateCategory(Map<String, dynamic> categoryData) {
    Get.to(() => UpdateCategoryScreen(categoryData: categoryData, showAppBar: true))?.then((_) {
      refreshCategories();
    });
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
          SnackbarService.showSuccess(
            result.message ?? 'Category deleted successfully',
          );
          await fetchCategories();
        } else {
          SnackbarService.showError(
            result.message ?? 'Failed to delete category',
          );
        }
      } catch (e) {
        SnackbarService.showException(Exception(e.toString()));
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
