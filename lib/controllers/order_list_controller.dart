import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../screens/Order/order_now_screen.dart';

class OrderListController extends GetxController {
  final TextEditingController searchController = TextEditingController();
  final selectedEntries = '10'.obs;
  final entriesOptions = ['10', '25', '50', '100'].obs;
  final currentPage = 1.obs;
  final totalPages = 1.obs;
  
  final orders = [
    OrderItem(
      id: 1,
      imageUrl: 'assets/headphones.jpg',
      productName: 'Noise Cancelling Headphones',
      category: 'Electronics',
      userName: 'Jignesh Rathod',
      shippingCost: '₹0',
      totalPrice: '₹999.99',
      date: '27-02-2026',
    ),
    OrderItem(
      id: 2,
      imageUrl: 'assets/laptop.jpg',
      productName: 'MacBook Pro M2',
      category: 'Computers',
      userName: 'Jane Smith',
      shippingCost: '₹50',
      totalPrice: '₹1,299.00',
      date: '27-02-2026',
    ),
    OrderItem(
      id: 3,
      imageUrl: 'assets/phone.jpg',
      productName: 'iPhone 13 Pro',
      category: 'Mobile',
      userName: 'John Doe',
      shippingCost: '₹0',
      totalPrice: '₹799.99',
      date: '26-02-2026',
    ),
    OrderItem(
      id: 4,
      imageUrl: 'assets/watch.jpg',
      productName: 'Smart Watch Ultra',
      category: 'Wearables',
      userName: 'Mike Johnson',
      shippingCost: '₹25',
      totalPrice: '₹399.99',
      date: '26-02-2026',
    ),
    OrderItem(
      id: 5,
      imageUrl: 'assets/tablet.jpg',
      productName: 'iPad Air',
      category: 'Tablets',
      userName: 'Sarah Wilson',
      shippingCost: '₹0',
      totalPrice: '₹599.99',
      date: '25-02-2026',
    ),
    OrderItem(
      id: 6,
      imageUrl: 'assets/camera.jpg',
      productName: 'DSLR Camera',
      category: 'Photography',
      userName: 'David Brown',
      shippingCost: '₹75',
      totalPrice: '₹1,499.00',
      date: '25-02-2026',
    ),
    OrderItem(
      id: 7,
      imageUrl: 'assets/speaker.jpg',
      productName: 'Bluetooth Speaker',
      category: 'Audio',
      userName: 'Emma Davis',
      shippingCost: '₹15',
      totalPrice: '₹149.99',
      date: '24-02-2026',
    ),
    OrderItem(
      id: 8,
      imageUrl: 'assets/keyboard.jpg',
      productName: 'Mechanical Keyboard',
      category: 'Accessories',
      userName: 'Chris Lee',
      shippingCost: '₹10',
      totalPrice: '₹199.99',
      date: '24-02-2026',
    ),
    OrderItem(
      id: 9,
      imageUrl: 'assets/mouse.jpg',
      productName: 'Gaming Mouse',
      category: 'Accessories',
      userName: 'Alex Kim',
      shippingCost: '₹5',
      totalPrice: '₹79.99',
      date: '23-02-2026',
    ),
    OrderItem(
      id: 10,
      imageUrl: 'assets/monitor.jpg',
      productName: '4K Monitor',
      category: 'Displays',
      userName: 'Lisa Chen',
      shippingCost: '₹100',
      totalPrice: '₹899.99',
      date: '23-02-2026',
    ),
  ].obs;
  
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
  
  void deleteOrder(int id) {
    final deletedOrder = orders.firstWhereOrNull((order) => order.id == id);
    if (deletedOrder != null) {
      orders.removeWhere((order) => order.id == id);
      
      Get.snackbar(
        'Order Deleted',
        'Order #$id deleted',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
        mainButton: TextButton(
          onPressed: () {
            orders.insert(id - 1, deletedOrder);
          },
          child: const Text('Undo', style: TextStyle(color: Colors.white)),
        ),
      );
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
}
