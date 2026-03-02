import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../screens/main_screen.dart';
import '../services/auth_service.dart';
import '../App_model/profile_model/LoginModel.dart';
import '../utils/auth_helper.dart';

class LoginController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final isLoading = false.obs;
  final isPasswordVisible = false.obs;
  
  var errorMessage = ''.obs;
  var successMessage = ''.obs;
  
  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
  
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }
  
  void clearMessages() {
    errorMessage.value = '';
    successMessage.value = '';
  }
  
  Future<void> login() async {
    if (formKey.currentState!.validate()) {
      isLoading.value = true;
      clearMessages();
      
      try {
        LoginModel loginResult = await AuthService.login(
          emailController.text.trim(),
          passwordController.text,
        );
        
        if (loginResult.status == true) {
          successMessage.value = loginResult.message ?? 'Login successful';
          // Update AuthHelper state
          await AuthHelper.to.login();
          Get.offAll(() => const MainScreen());
        } else {
          errorMessage.value = loginResult.message ?? 'Login failed';
        }
      } catch (e) {
        errorMessage.value = e.toString();
      } finally {
        isLoading.value = false;
      }
    }
  }
}
