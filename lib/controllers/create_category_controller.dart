import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../services/auth_service.dart';
import '../App_model/Category_model/CreateCategoryModel.dart';
import '../screens/main_screen.dart';
import 'category_list_controller.dart';

class CreateCategoryController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final skuController = TextEditingController();
  
  final selectedImage = Rx<XFile?>(null);
  final isLoading = false.obs;
  
  final ImagePicker picker = ImagePicker();
  
  @override
  void onClose() {
    nameController.dispose();
    skuController.dispose();
    super.onClose();
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
      _createCategory();
    }
  }
  
  void showSuccessDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('Success'),
        content: const Text('Category created successfully!'),
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
  
  Future<void> _createCategory() async {
    try {
      final CreateCategoryModel result = await AuthService.createCategory(
        name: nameController.text.trim(),
        skubarCode: skuController.text.trim(),
        image: selectedImage.value,
      );
      
      if (result.status == true) {
        Get.snackbar(
          'Success',
          result.message ?? 'Category created successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
        Get.offAll(() => const MainScreen());
        Future.delayed(const Duration(milliseconds: 300), () {
          if (!Get.isRegistered<MainScreenController>()) {
            try {
              Get.put(MainScreenController());
            } catch (_) {}
          }
          final main = Get.find<MainScreenController>();
          main.onItemTapped(3);
          if (Get.isRegistered<CategoryListController>()) {
            Get.find<CategoryListController>().fetchCategories();
          }
        });
      } else {
        Get.snackbar(
          'Error',
          result.message ?? 'Failed to create category',
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
    } finally {
      isLoading.value = false;
    }
  }
}
