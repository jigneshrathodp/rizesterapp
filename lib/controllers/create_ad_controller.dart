import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class CreateAdController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final priceController = TextEditingController();
  final urlController = TextEditingController();
  final descriptionController = TextEditingController();
  
  final selectedPlatform = 'Facebook'.obs;
  final selectedImage = Rx<XFile?>(null);
  final isLoading = false.obs;
  
  final ImagePicker picker = ImagePicker();

  var scaffoldKey;
  
  @override
  void onClose() {
    titleController.dispose();
    priceController.dispose();
    urlController.dispose();
    descriptionController.dispose();
    super.onClose();
  }
  
  void updatePlatform(String? value) {
    if (value != null) {
      selectedPlatform.value = value;
    }
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
        content: const Text('Advertisement created successfully!'),
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
