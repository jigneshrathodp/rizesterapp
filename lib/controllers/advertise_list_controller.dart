import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../screens/Advertise/create_ad_screen.dart';
import '../screens/Advertise/update_ads_screen.dart';
import '../services/advertise_service.dart';
import '../services/snackbar_service.dart';
import '../App_model/Advertise_model/GetAdvertiseModel.dart';
import '../App_model/Advertise_model/DeleteAdvertiseModel.dart';

class AdvertiseListController extends GetxController {
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
  
  // Observable list for advertisements
  final advertiseData = <Map<String, dynamic>>[].obs;
  final filteredData = <Map<String, dynamic>>[].obs;
  
  @override
  void onInit() {
    super.onInit();
    fetchAdvertises();
    // Add listener for search functionality
    searchController.addListener(_filterAdvertises);
  }
  
  // Fetch advertisements from API with lazy loading
  Future<void> fetchAdvertises({bool refresh = false}) async {
    if (refresh) {
      currentPage.value = 1;
      hasReachedMax.value = false;
      advertiseData.clear();
      filteredData.clear();
    }
    
    if (isLoading.value || hasReachedMax.value) return;
    
    isLoading.value = true;
    try {
      GetAdvertiseModel result = await AdvertiseService.getAdvertises(
        page: currentPage.value,
        limit: pageSize,
        search: searchQuery.value.isNotEmpty ? searchQuery.value : null,
      );
      
      if (result.status == true && result.data != null) {
        if (refresh) {
          advertiseData.clear();
        }
        
        for (var item in result.data!) {
          advertiseData.add({
            'id': item.id,
            'title': item.title,
            'price': item.price,
            'platform': item.socialmedia,
            'url': item.url,
            'date': item.date,
          });
        }
        
        if (result.data!.length < pageSize) {
          hasReachedMax.value = true;
        } else {
          currentPage.value++;
        }
        
        filteredData.assignAll(advertiseData);
      } else {
        SnackbarService.showError(result.message ?? 'Failed to load advertisements');
      }
    } catch (e) {
      SnackbarService.showException(Exception(e.toString()));
    } finally {
      isLoading.value = false;
    }
  }
  
  Future<void> loadMoreAdvertises() async {
    if (isLoadingMore.value || hasReachedMax.value) return;
    
    try {
      isLoadingMore.value = true;
      
      GetAdvertiseModel result = await AdvertiseService.getAdvertises(
        page: currentPage.value,
        limit: pageSize,
        search: searchQuery.value.isNotEmpty ? searchQuery.value : null,
      );
      
      if (result.status == true && result.data != null) {
        for (var item in result.data!) {
          advertiseData.add({
            'id': item.id,
            'title': item.title,
            'price': item.price,
            'platform': item.socialmedia,
            'url': item.url,
            'date': item.date,
          });
        }
        
        if (result.data!.length < pageSize) {
          hasReachedMax.value = true;
        } else {
          currentPage.value++;
        }
        
        filteredData.assignAll(advertiseData);
      }
    } catch (e) {
      SnackbarService.showException(Exception(e.toString()));
    } finally {
      isLoadingMore.value = false;
    }
  }
  
  void searchAdvertises(String query) {
    searchQuery.value = query;
    fetchAdvertises(refresh: true);
  }
  
  void refreshAdvertises() {
    fetchAdvertises(refresh: true);
  }
  
  List<Map<String, dynamic>> get paginatedData {
    final entriesPerPage = int.parse(selectedEntries.value);
    totalPages.value = (filteredData.length / entriesPerPage).ceil();
    
    final startIndex = (currentPage.value - 1) * entriesPerPage;

    if (startIndex >= filteredData.length) {
      currentPage.value = 1;
      return filteredData.take(entriesPerPage).toList();
    }
    
    return filteredData.skip(startIndex).take(entriesPerPage).toList();
  }
  
  // Filter advertisements based on search query
  void _filterAdvertises() {
    final query = searchController.text.toLowerCase().trim();
    
    if (query.isEmpty) {
      filteredData.assignAll(advertiseData);
    } else {
      filteredData.assignAll(
        advertiseData.where((ad) =>
          (ad['title']?.toString().toLowerCase().contains(query) ?? false) ||
          (ad['platform']?.toString().toLowerCase().contains(query) ?? false) ||
          (ad['price']?.toString().toLowerCase().contains(query) ?? false) ||
          (ad['date']?.toString().toLowerCase().contains(query) ?? false)
        ).toList(),
      );
    }
    
    // Reset to first page when searching
    currentPage.value = 1;
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
  
  void navigateToCreateAd() {
    Get.to(() => const CreateAdScreen(showAppBar: true))?.then((_) {
      refreshAdvertises();
    });
  }
  
  void navigateToUpdateAd(Map<String, dynamic> adData) {
    Get.to(() => UpdateAdsScreen(adData: adData, showAppBar: true))?.then((_) {
      refreshAdvertises();
    });
  }
  
  // Delete advertisement
  Future<void> deleteAdvertise(int id) async {
    try {
      final confirmed = await Get.dialog<bool>(
        AlertDialog(
          title: const Text('Confirm Delete'),
          content: const Text('Are you sure you want to delete this advertisement?'),
          actions: [
            TextButton(
              onPressed: () => Get.back(result: false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Get.back(result: true),
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      );
      
      if (confirmed == true) {
        DeleteAdvertiseModel result = await AdvertiseService.deleteAdvertise(id);
        
        if (result.status == true) {
          SnackbarService.showSuccess(result.message ?? 'Advertisement deleted successfully');
          await fetchAdvertises();
        } else {
          SnackbarService.showError(result.message ?? 'Failed to delete advertisement');
        }
      }
    } catch (e) {
      SnackbarService.showException(Exception(e.toString()));
    }
  }
  
  @override
  void onClose() {
    searchController.removeListener(_filterAdvertises);
    searchController.dispose();
    super.onClose();
  }
}
