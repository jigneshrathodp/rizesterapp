import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/create_ad_controller.dart';
import '../../utils/responsive_config.dart';
import '../../widgets/widgets.dart';

class CreateAdScreen extends StatelessWidget {
  const CreateAdScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CreateAdController());
    
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
                  
                  // Image Upload Section
                  Obx(
                    () => GestureDetector(
                      onTap: controller.pickImage,
                      child: Container(
                        width: double.infinity,
                        height: ResponsiveConfig.responsiveHeight(context, 200),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(ResponsiveConfig.responsiveRadius(context, 12)),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: controller.selectedImage.value != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(ResponsiveConfig.responsiveRadius(context, 12)),
                                child: Stack(
                                  children: [
                                    Image.asset(
                                      controller.selectedImage.value!.path,
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
                                        onTap: controller.removeImage,
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
                  ),
                  
                  CustomSpacer(height: 24),
                  
                  // Ad Title
                  CustomTextField(
                    controller: controller.titleController,
                    labelText: 'Ad Title',
                    hintText: 'Enter advertisement title',
                    prefixIcon: const Icon(Icons.title),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter ad title';
                      }
                      if (value.length < 2) {
                        return 'Title must be at least 2 characters';
                      }
                      return null;
                    },
                  ),
                  
                  CustomSpacer(height: 16),
                  
                  // Platform
                  Obx(
                    () => CustomDropdownButtonFormField<String>(
                      value: controller.selectedPlatform.value,
                      labelText: 'Platform',
                      hintText: 'Select platform',
                      items: const ['Facebook', 'Google', 'Instagram', 'Twitter', 'LinkedIn'].map((String platform) {
                        return DropdownMenuItem<String>(
                          value: platform,
                          child: Text(platform),
                        );
                      }).toList(),
                      onChanged: controller.updatePlatform,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select platform';
                        }
                        return null;
                      },
                    ),
                  ),
                  
                  CustomSpacer(height: 16),
                  
                  // Budget/Price
                  CustomTextField(
                    controller: controller.priceController,
                    labelText: 'Budget/Price',
                    hintText: '\$Enter budget amount',
                    prefixIcon: const Icon(Icons.attach_money),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter budget amount';
                      }
                      if (double.tryParse(value.replaceAll('\$', '')) == null) {
                        return 'Please enter valid amount';
                      }
                      return null;
                    },
                  ),
                  
                  CustomSpacer(height: 16),
                  
                  // Destination URL
                  CustomTextField(
                    controller: controller.urlController,
                    labelText: 'Destination URL',
                    hintText: 'Enter landing page URL',
                    prefixIcon: const Icon(Icons.link),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter destination URL';
                      }
                      final uri = Uri.tryParse(value);
                      if (uri == null || !uri.hasAbsolutePath) {
                        return 'Please enter valid URL';
                      }
                      return null;
                    },
                  ),
                  
                  CustomSpacer(height: 16),
                  
                  // Ad Description
                  CustomTextField(
                    controller: controller.descriptionController,
                    labelText: 'Ad Description',
                    hintText: 'Enter advertisement description',
                    prefixIcon: const Icon(Icons.description),
                    maxLines: 4,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter ad description';
                      }
                      if (value.length < 10) {
                        return 'Description must be at least 10 characters';
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
                            text: 'Create Ad',
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
          'Tap to upload ad creative',
          style: AppTextStyles.getBody(context).copyWith(
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}
