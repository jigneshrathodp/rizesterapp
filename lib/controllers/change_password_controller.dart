import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/auth_service.dart';
import '../App_model/profile_model/ResetPasswordModel.dart';

class ChangePasswordController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final oldPasswordVisible = false.obs;
  final newPasswordVisible = false.obs;
  final confirmPasswordVisible = false.obs;
  final isLoading = false.obs;

  var errorMessage = ''.obs;
  var successMessage = ''.obs;

  @override
  void onClose() {
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  void toggleOldPasswordVisibility() {
    oldPasswordVisible.value = !oldPasswordVisible.value;
  }

  void toggleNewPasswordVisibility() {
    newPasswordVisible.value = !newPasswordVisible.value;
  }

  void toggleConfirmPasswordVisibility() {
    confirmPasswordVisible.value = !confirmPasswordVisible.value;
  }

  void clearMessages() {
    errorMessage.value = '';
    successMessage.value = '';
  }

  Future<void> handleSubmit() async {
    if (formKey.currentState!.validate()) {
      isLoading.value = true;
      clearMessages();

      try {
        ResetPasswordModel result = await AuthService.resetPassword(
          oldPasswordController.text,
          newPasswordController.text,
        );

        if (result.status == true) {
          successMessage.value =
              result.message ?? 'Password changed successfully';
          // Clear form
          oldPasswordController.clear();
          newPasswordController.clear();
          confirmPasswordController.clear();
        } else {
          errorMessage.value = result.message ?? 'Failed to change password';
        }
      } catch (e) {
        errorMessage.value = 'Password change failed: $e';
      } finally {
        isLoading.value = false;
      }
    }
  }
}