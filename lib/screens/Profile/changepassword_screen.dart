import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/change_password_controller.dart';
import '../../utils/responsive_config.dart';
import '../../widgets/widgets.dart';

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ChangePasswordController());
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollWidget(
        children: [
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
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters';
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
                        if (value.length < 8) {
                          return 'Password must be at least 8 characters';
                        }
                        if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)').hasMatch(value)) {
                          return 'Password must contain uppercase, lowercase, and number';
                        }
                        return null;
                      },
                    ),
                  ),
                  
                  CustomSpacer(height: 16),
                  
                  // Password Requirements
                  CustomCard(
                    padding: EdgeInsets.all(ResponsiveConfig.spacingMd(context)),
                    backgroundColor: Colors.blue[50],
                    child: CustomColumn(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Password Requirements:',
                          style: AppTextStyles.getSmall(context).copyWith(
                            fontWeight: FontWeight.w600,
                            color: Colors.blue[700],
                          ),
                        ),
                        CustomSpacer(height: 8),
                        ...[
                          '• At least 8 characters long',
                          '• Contains uppercase letter (A-Z)',
                          '• Contains lowercase letter (a-z)',
                          '• Contains number (0-9)',
                        ].map((requirement) => Padding(
                          padding: EdgeInsets.only(top: 4),
                          child: Text(
                            requirement,
                            style: AppTextStyles.getSmall(context).copyWith(
                              color: Colors.blue[600],
                            ),
                          ),
                        )).toList(),
                      ],
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
                            onPressed: controller.handleSubmit,
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