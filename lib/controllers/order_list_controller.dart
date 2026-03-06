import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/order_service.dart';
import '../services/auth_service.dart';
import '../services/snackbar_service.dart';
import '../App_model/Order_model/GetOrderModel.dart';
import '../App_model/Order_model/DeleteOrderModel.dart';
import '../screens/Order/order_now_screen.dart';

class OrderListController extends GetxController {
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
  final orders = <OrderItem>[].obs;
  
  @override
  void onInit() {
    super.onInit();
    fetchOrders();
  }
  
  Future<void> fetchOrders({bool refresh = false}) async {
    if (refresh) {
      currentPage.value = 1;
      hasReachedMax.value = false;
      orders.clear();
    }
    
    if (isLoading.value || hasReachedMax.value) return;
    
    try {
      isLoading.value = true;
      
      String? token = await AuthService.getToken();
      
      if (token == null) {
        SnackbarService.showError('No authentication token found');
        return;
      }
      
      GetOrderModel result = await OrderService.getOrderList(
        token,
        page: currentPage.value,
        limit: pageSize,
        search: searchQuery.value.isNotEmpty ? searchQuery.value : null,
      );
      
      if (result.status == true && result.data != null) {
        if (refresh) {
          orders.clear();
        }
        
        for (var orderData in result.data!) {
          orders.add(OrderItem.fromApiData(orderData));
        }
        
        if (result.data!.length < pageSize) {
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
  
  Future<void> loadMoreOrders() async {
    if (isLoadingMore.value || hasReachedMax.value) return;
    
    try {
      isLoadingMore.value = true;
      
      String? token = await AuthService.getToken();
      
      if (token == null) {
        SnackbarService.showError('No authentication token found');
        return;
      }
      
      GetOrderModel result = await OrderService.getOrderList(
        token,
        page: currentPage.value,
        limit: pageSize,
        search: searchQuery.value.isNotEmpty ? searchQuery.value : null,
      );
      
      if (result.status == true && result.data != null) {
        for (var orderData in result.data!) {
          orders.add(OrderItem.fromApiData(orderData));
        }
        
        if (result.data!.length < pageSize) {
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
  
  void searchOrders(String query) {
    searchQuery.value = query;
    fetchOrders(refresh: true);
  }
  
  void refreshOrders() {
    fetchOrders(refresh: true);
  }
  
  List<OrderItem> get paginatedData {
    final entriesPerPage = int.parse(selectedEntries.value);
    totalPages.value = (orders.length / entriesPerPage).ceil();
    
    final startIndex = (currentPage.value - 1) * entriesPerPage;

    if (startIndex >= orders.length) {
      currentPage.value = 1;
      return orders.take(entriesPerPage).toList();
    }
    
    return orders.skip(startIndex).take(entriesPerPage).toList();
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
  
  void navigateToOrderNow() {
    Get.to(() => const OrderNowScreen(showAppBar: true));
  }
  
  Future<void> deleteOrder(int id) async {
    try {
      // Get token from AuthService
      String? token = await AuthService.getToken();
      
      if (token == null) {
        throw Exception('No authentication token found');
      }
      
      DeleteOrderModel result = await OrderService.deleteOrder(token, id);
      
      if (result.status == true) {
        orders.removeWhere((order) => order.id == id);
        SnackbarService.showSuccess(result.message ?? 'Order deleted successfully!');
      }
      
    } catch (e) {
      SnackbarService.showException(Exception(e.toString()));
    }
  }
  
  Color getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'electronics':
        return Colors.blue;
      case 'computers':
        return Colors.purple;
      case 'mobile':
        return Colors.green;
      case 'wearables':
        return Colors.orange;
      case 'tablets':
        return Colors.red;
      case 'photography':
        return Colors.brown;
      case 'audio':
        return Colors.teal;
      case 'accessories':
        return Colors.indigo;
      case 'displays':
        return Colors.pink;
      default:
        return Colors.grey;
    }
  }
  
  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}

class OrderItem {
  final int id;
  final String imageUrl;
  final String productName;
  final String category;
  final String userName;
  final String shippingCost;
  final String totalPrice;
  final String date;

  OrderItem({
    required this.id,
    required this.imageUrl,
    required this.productName,
    required this.category,
    required this.userName,
    required this.shippingCost,
    required this.totalPrice,
    required this.date,
  });
  
  // Factory method to create OrderItem from API data
  factory OrderItem.fromApiData(dynamic data) {
    return OrderItem(
      id: data.orderId ?? 0,
      imageUrl: data.product?.image ?? 'assets/default_product.jpg',
      productName: data.product?.name ?? 'Unknown Product',
      category: data.product?.category ?? 'Unknown',
      userName: data.customer?.name ?? 'Unknown Customer',
      shippingCost: '₹${data.pricing?.shippingCost ?? 0}',
      totalPrice: '₹${data.pricing?.totalPrice ?? 0}',
      date: DateTime.now().toString().split(' ')[0], // You might want to use actual date from API
    );
  }
}
