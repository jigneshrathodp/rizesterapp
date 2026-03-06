import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/order_service.dart';
import '../services/auth_service.dart';
import '../App_model/Order_model/CreateOrderModel.dart';

class BuyNowController extends GetxController {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final customerNameController = TextEditingController();
  final customerEmailController = TextEditingController();
  final customerAddressController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final quantityController = TextEditingController(text: '1');
  
  final quantity = 1.obs;
  final shippingCost = 0.0.obs;
  final sellingPrice = 0.0.obs;
  final isLoading = false.obs;
  
  // Product data passed from BuyNowScreen
  late Map<String, dynamic> product;
  
  @override
  void onInit() {
    super.onInit();
    quantityController.addListener(() {
      quantity.value = int.tryParse(quantityController.text) ?? 1;
    });
  }
  
  void setProduct(Map<String, dynamic> productData) {
    product = productData;
    sellingPrice.value = (productData['costPerGram'] ?? 0.0).toDouble();
  }
  
  double get subTotal => sellingPrice.value * quantity.value;
  double get totalPrice => subTotal + shippingCost.value;
  
  Future<void> createOrder() async {
    // Validate fields
    if (customerNameController.text.isEmpty ||
        customerEmailController.text.isEmpty ||
        customerAddressController.text.isEmpty ||
        phoneNumberController.text.isEmpty ||
        quantityController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please fill all required fields',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isLoading.value = true;
      
      // Get token from AuthService
      String? token = await AuthService.getToken();
      
      if (token == null) {
        throw Exception('No authentication token found');
      }
      
      CreateOrderModel result = await OrderService.createOrder(
        token,
        productId: product['id'] ?? 1,
        customerName: customerNameController.text,
        customerEmail: customerEmailController.text,
        customerPhone: phoneNumberController.text,
        customerAddress: customerAddressController.text,
        quantity: quantity.value,
        sellingPricePerGram: sellingPrice.value.toString(),
        shippingCost: shippingCost.value.toInt(),
      );

      // Show success message
      Get.snackbar(
        'Success',
        result.message ?? 'Order created successfully!',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      // Navigate back
      Get.back();
      
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString().contains('Exception:') 
            ? e.toString().split('Exception: ')[1]
            : 'Failed to create order',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
  
  @override
  void onClose() {
    customerNameController.dispose();
    customerEmailController.dispose();
    customerAddressController.dispose();
    phoneNumberController.dispose();
    quantityController.dispose();
    super.onClose();
  }
}
