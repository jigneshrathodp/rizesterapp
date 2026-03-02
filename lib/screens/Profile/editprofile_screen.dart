import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/edit_profile_controller.dart';
import '../../utils/responsive_config.dart';
import '../../widgets/widgets.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EditProfileController());
    
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
                  
                  // Profile Photo Section
                  _buildImageUploadSection(context, controller, "Profile Photo", "profile"),
                  
                  CustomSpacer(height: 24),
                  
                  // Name
                  CustomTextField(
                    controller: controller.nameController,
                    labelText: 'Name',
                    hintText: 'Enter your name',
                    prefixIcon: const Icon(Icons.person),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      if (value.length < 2) {
                        return 'Name must be at least 2 characters';
                      }
                      return null;
                    },
                  ),
                  
                  CustomSpacer(height: 16),
                  
                  // Email
                  CustomTextField(
                    controller: controller.emailController,
                    labelText: 'Email',
                    hintText: 'Enter your email',
                    prefixIcon: const Icon(Icons.email),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  
                  CustomSpacer(height: 16),
                  
                  // Contact Number
                  CustomTextField(
                    controller: controller.contactController,
                    labelText: 'Contact Number',
                    hintText: 'Enter your contact number',
                    prefixIcon: const Icon(Icons.phone),
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your contact number';
                      }
                      if (!RegExp(r'^[\d\s\-\+\(\)]{10,}$').hasMatch(value)) {
                        return 'Please enter a valid contact number';
                      }
                      return null;
                    },
                  ),
                  
                  CustomSpacer(height: 16),
                  
                  // Site Name
                  CustomTextField(
                    controller: controller.siteNameController,
                    labelText: 'Site Name',
                    hintText: 'Enter site name',
                    prefixIcon: const Icon(Icons.language),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter site name';
                      }
                      return null;
                    },
                  ),
                  
                  CustomSpacer(height: 16),
                  
                  // Address
                  CustomTextField(
                    controller: controller.addressController,
                    labelText: 'Address',
                    hintText: 'Enter your address',
                    prefixIcon: const Icon(Icons.location_on),
                    maxLines: 3,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your address';
                      }
                      return null;
                    },
                  ),
                  
                  CustomSpacer(height: 24),
                  
                  // Fav Icon
                  _buildImageUploadSection(context, controller, "Fav Icon", "favIcon", height: 100),
                  
                  CustomSpacer(height: 24),
                  
                  // Logo Light
                  _buildImageUploadSection(context, controller, "Logo Light", "logoLight", height: 120),
                  
                  CustomSpacer(height: 24),
                  
                  // Logo Dark
                  _buildImageUploadSection(context, controller, "Logo Dark", "logoDark", height: 120),
                  
                  CustomSpacer(height: 24),
                  
                  // Footer
                  CustomTextField(
                    controller: controller.footerController,
                    labelText: 'Footer',
                    hintText: 'Enter footer text',
                    prefixIcon: const Icon(Icons.description),
                    maxLines: 2,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter footer text';
                      }
                      return null;
                    },
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
                            text: 'Update Profile',
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

  Widget _buildImageUploadSection(BuildContext context, EditProfileController controller, String label, String imageType, {double height = 150}) {
    return Obx(
      () => CustomColumn(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.getBody(context).copyWith(
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          CustomSpacer(height: 8),
          
          GestureDetector(
            onTap: () => controller.pickImage(imageType),
            child: Container(
              width: double.infinity,
              height: ResponsiveConfig.responsiveHeight(context, height),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(ResponsiveConfig.responsiveRadius(context, 12)),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: controller.getImageByType(imageType) != null && controller.getImageByType(imageType)!.path.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(ResponsiveConfig.responsiveRadius(context, 12)),
                      child: Stack(
                        children: [
                          Image.asset(
                            controller.getImageByType(imageType)!.path,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                            errorBuilder: (context, error, stackTrace) => _buildImagePlaceholder(context),
                          ),
                          // Remove image button
                          Positioned(
                            top: 8,
                            right: 8,
                            child: GestureDetector(
                              onTap: () => controller.removeImage(imageType),
                              child: Container(
                                width: ResponsiveConfig.responsiveWidth(context, 32),
                                height: ResponsiveConfig.responsiveWidth(context, 32),
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.close,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : _buildImagePlaceholder(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImagePlaceholder(BuildContext context) {
    return CustomColumn(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.cloud_upload,
          size: ResponsiveConfig.responsiveFont(context, 48),
          color: Colors.grey[400],
        ),
        CustomSpacer(height: 8),
        Text(
          'Tap to upload image',
          style: AppTextStyles.getBody(context).copyWith(
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}