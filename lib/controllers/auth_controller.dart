import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/auth_service.dart';
import '../App_model/profile_model/LoginModel.dart';
import '../App_model/profile_model/GetProfileModel.dart';
import '../App_model/profile_model/UpdateProfileModel.dart';
import '../App_model/profile_model/ResetPasswordModel.dart';
import '../App_model/profile_model/LogoutModel.dart';

class AuthController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final isLoading = false.obs;
  final isPasswordVisible = false.obs;
  
  // Profile related controllers
  final nameController = TextEditingController();
  final contactController = TextEditingController();
  
  // Password reset controllers
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  
  // Observable variables
  var loginModel = Rxn<LoginModel>();
  var profileModel = Rxn<GetProfileModel>();
  var updateProfileModel = Rxn<UpdateProfileModel>();
  var resetPasswordModel = Rxn<ResetPasswordModel>();
  var logoutModel = Rxn<LogoutModel>();
  
  var errorMessage = ''.obs;
  var successMessage = ''.obs;
  
  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    contactController.dispose();
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
  
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }
  
  void clearMessages() {
    errorMessage.value = '';
    successMessage.value = '';
  }
  
  // Login method using FutureBuilder approach
  Future<void> login() async {
    if (formKey.currentState!.validate()) {
      isLoading.value = true;
      clearMessages();
      
      try {
        loginModel.value = await AuthService.login(
          emailController.text.trim(),
          passwordController.text,
        );
        
        if (loginModel.value?.status == true) {
          successMessage.value = loginModel.value?.message ?? 'Login successful';
          // Navigate to dashboard after successful login
          Future.delayed(const Duration(seconds: 1), () {
            Get.offAllNamed('/dashboard');
          });
        } else {
          errorMessage.value = loginModel.value?.message ?? 'Login failed';
        }
      } catch (e) {
        errorMessage.value = e.toString();
      } finally {
        isLoading.value = false;
      }
    }
  }
  
  // Get profile details method
  Future<void> getProfileDetails() async {
    isLoading.value = true;
    clearMessages();
    
    try {
      profileModel.value = await AuthService.getProfileDetails();
      
      if (profileModel.value?.status == true) {
        // Update controllers with profile data
        if (profileModel.value?.user != null) {
          nameController.text = profileModel.value!.user!.name ?? '';
          emailController.text = profileModel.value!.user!.email ?? '';
          contactController.text = profileModel.value!.user!.contact ?? '';
        }
        successMessage.value = 'Profile loaded successfully';
      } else {
        errorMessage.value = 'Failed to load profile';
      }
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
  
  // Update profile method
  Future<void> updateProfile() async {
    isLoading.value = true;
    clearMessages();
    
    try {
      Map<String, dynamic> profileData = {
        'name': nameController.text.trim(),
        'email': emailController.text.trim(),
        'contact': contactController.text.trim(),
      };
      
      updateProfileModel.value = await AuthService.updateProfile(profileData);
      
      if (updateProfileModel.value?.status == true) {
        successMessage.value = updateProfileModel.value?.message ?? 'Profile updated successfully';
        // Reload profile data
        await getProfileDetails();
      } else {
        errorMessage.value = updateProfileModel.value?.message ?? 'Failed to update profile';
      }
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
  
  // Reset password method
  Future<void> resetPassword() async {
    if (newPasswordController.text != confirmPasswordController.text) {
      errorMessage.value = 'Passwords do not match';
      return;
    }
    
    isLoading.value = true;
    clearMessages();
    
    try {
      resetPasswordModel.value = await AuthService.resetPassword(
        currentPasswordController.text,
        newPasswordController.text,
      );
      
      if (resetPasswordModel.value?.status == true) {
        successMessage.value = resetPasswordModel.value?.message ?? 'Password reset successfully';
        // Clear password fields
        currentPasswordController.clear();
        newPasswordController.clear();
        confirmPasswordController.clear();
      } else {
        errorMessage.value = resetPasswordModel.value?.message ?? 'Failed to reset password';
      }
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
  
  // Logout method
  Future<void> logout() async {
    isLoading.value = true;
    clearMessages();
    
    try {
      logoutModel.value = await AuthService.logout();
      
      if (logoutModel.value?.status == true) {
        successMessage.value = logoutModel.value?.message ?? 'Logout successful';
        // Navigate to login screen
        Future.delayed(const Duration(seconds: 1), () {
          Get.offAllNamed('/login');
        });
      } else {
        errorMessage.value = logoutModel.value?.message ?? 'Logout failed';
      }
    } catch (e) {
      errorMessage.value = e.toString();
      // Even if API call fails, navigate to login
      Future.delayed(const Duration(seconds: 1), () {
        Get.offAllNamed('/login');
      });
    } finally {
      isLoading.value = false;
    }
  }
  
  // Check login status
  Future<bool> isLoggedIn() async {
    return await AuthService.isLoggedIn();
  }
}
