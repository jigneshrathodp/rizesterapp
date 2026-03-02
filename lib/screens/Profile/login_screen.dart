import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/login_controller.dart';
import '../../utils/responsive_config.dart';
import '../../widgets/widgets.dart';
import '../main_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());
    final size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: CustomStack(
        children: [
          // Background image - absolutely stable
          Positioned.fill(
            child: Image.asset(
              "assets/download.jpg",
              fit: BoxFit.cover,
            ),
          ),

          // Dark gradient overlay - stable
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black54,
                    Colors.black87,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),

          // Main content with keyboard handling
          CustomSafeArea(
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              physics: const ClampingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: size.height,
                ),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: ResponsiveConfig.responsivePadding(context, 28),
                    ),
                    child: CustomColumn(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        CustomSpacer(height: size.height * 0.15),

                        Padding(
                          padding: EdgeInsets.all(ResponsiveConfig.responsivePadding(context, 10)),
                          child: Image.asset(
                            "assets/logo2.png",
                            height: ResponsiveConfig.responsiveHeight(context, size.height * 0.13),
                          ),
                        ),

                        CustomSpacer(height: size.height * 0.03),

                        Text(
                          "Welcome Back",
                          style: AppTextStyles.getSubheading(context).copyWith(
                            fontSize: ResponsiveConfig.responsiveFont(context, ResponsiveConfig.isSmallScreen(context) ? 18 : 20),
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        CustomSpacer(height: size.height * 0.03),

                        Form(
                          key: controller.formKey,
                          child: CustomColumn(
                            children: [
                              GlassTextField(
                                hintText: "Email",
                                controller: controller.emailController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your email';
                                  }
                                  if (!GetUtils.isEmail(value)) {
                                    return 'Please enter a valid email';
                                  }
                                  return null;
                                },
                              ),

                              CustomSpacer(height: size.height * 0.025),

                              Obx(
                                () => GlassTextField(
                                  hintText: "Password",
                                  controller: controller.passwordController,
                                  obscureText: !controller.isPasswordVisible.value,
                                  showVisibilityToggle: true,
                                  onVisibilityToggle: controller.togglePasswordVisibility,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your password';
                                    }
                                    if (value.length < 6) {
                                      return 'Password must be at least 6 characters';
                                    }
                                    return null;
                                  },
                                ),
                              ),

                              CustomSpacer(height: size.height * 0.015),
                            ],
                          ),
                        ),

                        CustomSpacer(height: size.height * 0.04),

                        // Error/Success Messages
                        Obx(() => Column(
                          children: [
                            if (controller.errorMessage.value.isNotEmpty)
                              Container(
                                padding: EdgeInsets.all(ResponsiveConfig.responsivePadding(context, 12)),
                                margin: EdgeInsets.only(bottom: ResponsiveConfig.responsivePadding(context, 10)),
                                decoration: BoxDecoration(
                                  color: Colors.red.shade100,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.red.shade300),
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.error_outline, color: Colors.red.shade700, size: 20),
                                    SizedBox(width: ResponsiveConfig.responsivePadding(context, 8)),
                                    Expanded(
                                      child: Text(
                                        controller.errorMessage.value,
                                        style: TextStyle(color: Colors.red.shade700, fontSize: 14),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            if (controller.successMessage.value.isNotEmpty)
                              Container(
                                padding: EdgeInsets.all(ResponsiveConfig.responsivePadding(context, 12)),
                                margin: EdgeInsets.only(bottom: ResponsiveConfig.responsivePadding(context, 10)),
                                decoration: BoxDecoration(
                                  color: Colors.green.shade100,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.green.shade300),
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.check_circle_outline, color: Colors.green.shade700, size: 20),
                                    SizedBox(width: ResponsiveConfig.responsivePadding(context, 8)),
                                    Expanded(
                                      child: Text(
                                        controller.successMessage.value,
                                        style: TextStyle(color: Colors.green.shade700, fontSize: 14),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        )),

                        Obx(
                          () => CustomButton(
                            text: "Login",
                            onPressed: controller.login,
                            isLoading: controller.isLoading.value,
                          ),
                        ),

                        CustomSpacer(height: size.height * 0.03),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
