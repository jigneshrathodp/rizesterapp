import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BuyNowController extends GetxController {
  final customerNameController = TextEditingController();
  final customerEmailController = TextEditingController();
  final customerAddressController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final quantityController = TextEditingController(text: '1');
  
  final quantity = 1.obs;
  final shippingCost = 0.0.obs;
  final sellingPrice = 2999.0.obs;
  
  @override
  void onInit() {
    super.onInit();
    quantityController.addListener(() {
      quantity.value = int.tryParse(quantityController.text) ?? 1;
    });
  }
  
  double get subTotal => sellingPrice.value * quantity.value;
  double get totalPrice => subTotal + shippingCost.value;
  
  void createOrder() {
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

    // Show success message
    Get.snackbar(
      'Success',
      'Order created successfully!',
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );

    // Navigate back
    Get.back();
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
