import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/change_password_controller.dart';
import '../../utils/responsive_config.dart';
import '../../widgets/widgets.dart';
import '../main_screen.dart';

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ChangePasswordController());
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        logoAsset: 'assets/black.png',
        onMenuPressed: () => Get.find<MainScreenController>().scaffoldKey.currentState?.openDrawer(),
        onNotificationPressed: () {},
        onProfilePressed: () {},
      ),
      body: CustomScrollWidget(
        children: [
          const ScreenTitle(title: 'Change Password'),
          Padding(
            padding: EdgeInsets.all(ResponsiveConfig.spacingMd(context)),
            child: Form(
              key: controller.formKey,
              child: CustomColumn(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomSpacer(height: 30),
                  
                  // Old Password
                  Obx(
                    () => CustomTextField(
                      controller: controller.oldPasswordController,
                      labelText: 'Old Password',
                      hintText: 'Enter your current password',
                      prefixIcon: const Icon(Icons.lock_outline),
                      obscureText: !controller.oldPasswordVisible.value,
                      suffixIcon: IconButton(
                        icon: Icon(
                          controller.oldPasswordVisible.value ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: controller.toggleOldPasswordVisibility,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your old password';
                        }
                        return null;
                      },
                    ),
                  ),
                  
                  CustomSpacer(height: 16),
                  
                  // New Password
                  Obx(
                    () => CustomTextField(
                      controller: controller.newPasswordController,
                      labelText: 'New Password',
                      hintText: 'Enter your new password',
                      prefixIcon: const Icon(Icons.lock),
                      obscureText: !controller.newPasswordVisible.value,
                      suffixIcon: IconButton(
                        icon: Icon(
                          controller.newPasswordVisible.value ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: controller.toggleNewPasswordVisibility,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a new password';
                        }
                        return null;
                      },
                    ),
                  ),
                  
                  CustomSpacer(height: 16),
                  
                  // Confirm Password
                  Obx(
                    () => CustomTextField(
                      controller: controller.confirmPasswordController,
                      labelText: 'Confirm Password',
                      hintText: 'Confirm your new password',
                      prefixIcon: const Icon(Icons.lock_clock),
                      obscureText: !controller.confirmPasswordVisible.value,
                      suffixIcon: IconButton(
                        icon: Icon(
                          controller.confirmPasswordVisible.value ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: controller.toggleConfirmPasswordVisibility,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please confirm your new password';
                        }
                        if (value != controller.newPasswordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                  ),
                  
                  CustomSpacer(height: 32),
                  
                  // Action Buttons
                  CustomRow(
                    children: [
                      Expanded(
                        child: CustomOutlineButton(
                          text: 'Cancel',
                          onPressed: () => Get.back(),
                        ),
                      ),
                      CustomSpacer(width: 16),
                      Expanded(
                        child: Obx(
                          () => CustomButton(
                            text: 'Change Password',
                            onPressed: () async {
                              await controller.handleSubmit();
                              
                              // Show success or error snackbar
                              if (controller.successMessage.value.isNotEmpty) {
                                Get.snackbar(
                                  'Success',
                                  controller.successMessage.value,
                                  backgroundColor: Colors.green,
                                  colorText: Colors.white,
                                  icon: const Icon(Icons.check_circle, color: Colors.white),
                                  duration: const Duration(seconds: 3),
                                );
                                // Go back after successful password change
                                Future.delayed(const Duration(seconds: 1), () {
                                  Get.back();
                                });
                              } else if (controller.errorMessage.value.isNotEmpty) {
                                Get.snackbar(
                                  'Error',
                                  controller.errorMessage.value,
                                  backgroundColor: Colors.red,
                                  colorText: Colors.white,
                                  icon: const Icon(Icons.error, color: Colors.white),
                                  duration: const Duration(seconds: 3),
                                );
                              }
                            },
                            backgroundColor: Colors.black,
                            textColor: Colors.white,
                            isLoading: controller.isLoading.value,
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  CustomSpacer(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}