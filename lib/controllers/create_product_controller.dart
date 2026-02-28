import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class CreateProductController extends GetxController {
  // Form key
  final formKey = GlobalKey<FormState>();
  
  // Text controllers
  final categoryController = TextEditingController();
  final nameController = TextEditingController();
  final skuController = TextEditingController();
  final quantityController = TextEditingController();
  final weightGmController = TextEditingController();
  final costPerGmController = TextEditingController();
  final totalCostController = TextEditingController();
  final sellingPriceController = TextEditingController();
  
  // Reactive variables
  final jewelleryCategories = ['Rings', 'Necklaces', 'Earrings', 'Bracelets', 'Pendants', 'Chains', 'Bangles', 'Anklets'].obs;
  final selectedStatus = 'Active'.obs;
  final forSale = true.obs;
  final selectedImage = Rx<XFile?>(null);
  final isLoading = false.obs;
  
  final ImagePicker picker = ImagePicker();
  
  @override
  void onClose() {
    categoryController.dispose();
    nameController.dispose();
    skuController.dispose();
    quantityController.dispose();
    weightGmController.dispose();
    costPerGmController.dispose();
    totalCostController.dispose();
    sellingPriceController.dispose();
    super.onClose();
  }
  
  void updateCategory(String? value) {
    if (value != null) {
      categoryController.text = value;
    }
  }
  
  void updateStatus(String? value) {
    if (value != null) {
      selectedStatus.value = value;
    }
  }
  
  void toggleForSale(bool? value) {
    forSale.value = value ?? false;
  }
  
  Future<void> pickImage() async {
    Get.dialog(
      AlertDialog(
        title: const Text('Choose Image Source'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () async {
                Get.back();
                final XFile? image = await picker.pickImage(source: ImageSource.camera);
                if (image != null) {
                  selectedImage.value = image;
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () async {
                Get.back();
                final XFile? image = await picker.pickImage(source: ImageSource.gallery);
                if (image != null) {
                  selectedImage.value = image;
                }
              },
            ),
          ],
        ),
      ),
    );
  }
  
  void removeImage() {
    selectedImage.value = null;
  }
  
  void handleSubmit() {
    if (formKey.currentState!.validate()) {
      isLoading.value = true;

      // Simulate API call
      Future.delayed(const Duration(seconds: 2), () {
        isLoading.value = false;
        showSuccessDialog();
      });
    }
  }
  
  void showSuccessDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('Success'),
        content: const Text('Product created successfully!'),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
              Get.back();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
