import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../screens/Advertise/create_ad_screen.dart';
import '../screens/Advertise/update_ads_screen.dart';

class AdvertiseListController extends GetxController {
  final TextEditingController searchController = TextEditingController();
  final selectedEntries = '10'.obs;
  final entriesOptions = ['10', '25', '50', '100'].obs;
  final currentPage = 1.obs;
  final totalPages = 1.obs;
  
  // Sample data with more advertisements
  final advertiseData = [
    {
      'id': 1,
      'title': 'Summer Sale 2024',
      'price': '\$500',
      'platform': 'Facebook',
      'url': 'https://example.com/summer-sale',
      'date': '2024-01-15',
    },
    {
      'id': 2,
      'title': 'New Product Launch',
      'price': '\$1000',
      'platform': 'Google',
      'url': 'https://example.com/launch',
      'date': '2024-01-20',
    },
    {
      'id': 3,
      'title': 'Weekend Special',
      'price': '\$300',
      'platform': 'Instagram',
      'url': 'https://example.com/weekend',
      'date': '2024-01-25',
    },
    {
      'id': 4,
      'title': 'Flash Sale',
      'price': '\$750',
      'platform': 'Twitter',
      'url': 'https://example.com/flash',
      'date': '2024-01-30',
    },
  ].obs;
  
  List<Map<String, dynamic>> get paginatedData {
    final entriesPerPage = int.parse(selectedEntries.value);
    totalPages.value = (advertiseData.length / entriesPerPage).ceil();
    
    final startIndex = (currentPage.value - 1) * entriesPerPage;

    if (startIndex >= advertiseData.length) {
      currentPage.value = 1;
      return advertiseData.take(entriesPerPage).toList();
    }
    
    return advertiseData.skip(startIndex).take(entriesPerPage).toList();
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
    Get.to(() => const CreateAdScreen(showAppBar: true));
  }
  
  void navigateToUpdateAd(Map<String, dynamic> adData) {
    Get.to(() => UpdateAdsScreen(adData: adData, showAppBar: true));
  }
  
  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
