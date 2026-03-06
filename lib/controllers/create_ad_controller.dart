import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/advertise_service.dart';
import '../App_model/Advertise_model/CreateAdvertiseModel.dart';
import '../services/snackbar_service.dart';

class CreateAdController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final priceController = TextEditingController();
  final urlController = TextEditingController();
  final platformController = TextEditingController();
  final selectedPlatform = ''.obs;
  final dateController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  
  final isLoading = false.obs;
  
  @override
  void onClose() {
    titleController.dispose();
    priceController.dispose();
    urlController.dispose();
    platformController.dispose();
    dateController.dispose();
    super.onClose();
  }
  
  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != selectedDate) {
      selectedDate = picked;
      dateController.text = "${picked.toLocal()}".split(' ')[0];
    }
  }
  
  Future<void> handleSubmit() async {
    if (formKey.currentState!.validate()) {
      isLoading.value = true;
      
      try {
        // Clean and validate URL
        String url = urlController.text.trim();
        if (!url.startsWith('http://') && !url.startsWith('https://')) {
          url = 'https://$url';
        }
        if (url.startsWith('https:/') && !url.startsWith('https://')) {
          url = url.replaceFirst('https:/', 'https://');
        }
        
        final advertiseData = {
          'title': titleController.text.trim(),
          'price': int.tryParse(priceController.text.replaceAll('\$', '').trim()) ?? 0,
          'url': url,
          'socialmedia': platformController.text.trim(),
          'date': dateController.text.trim(),
        };
        
        CreateAdvertiseModel result = await AdvertiseService.createAdvertise(advertiseData);
        
        if (result.status == true) {
          SnackbarService.showSuccess(result.message ?? 'Advertisement created successfully');
          clearForm();
          Get.back();
        } else {
          SnackbarService.showError(result.message ?? 'Failed to create advertisement');
        }
      } catch (e) {
        SnackbarService.showException(Exception(e.toString()));
      } finally {
        isLoading.value = false;
      }
    }
  }
  
  void clearForm() {
    titleController.clear();
    priceController.clear();
    urlController.clear();
    platformController.clear();
    dateController.clear();
  }
  
  void showSuccessDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('Success'),
        content: const Text('Advertisement created successfully!'),
        actions: [
          TextButton(
            onPressed: () {
              Get.back(); // Close dialog
              Get.back(); // Go back to list screen
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
