import 'package:flutter/material.dart';
import 'dart:io';
import 'package:get/get.dart';
import '../../controllers/update_product_controller.dart';
import '../../utils/responsive_config.dart';
import '../../widgets/widgets.dart';
import 'package:rizesterapp/screens/main_screen.dart';
import '../notification_screen.dart' as notification;
import 'package:rizesterapp/screens/Profile/profile_screen.dart';

class UpdateProductScreen extends StatelessWidget {
  final Map<String, dynamic> productData;
  final bool showAppBar;

  const UpdateProductScreen({super.key, required this.productData, this.showAppBar = false});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UpdateProductController(productId: productData['id']));
    
    return Scaffold(
      key: GlobalKey<ScaffoldState>(),
      backgroundColor: Colors.white,
      appBar: showAppBar
          ? CustomAppBar(
              logoAsset: 'assets/black.png',
              onMenuPressed: () => controller.scaffoldKey.currentState?.openDrawer(),
              onNotificationPressed: () => Get.to(() => const notification.NotificationScreen()),
              onProfilePressed: () => Get.to(() => const ProfileScreen()),
            )
          : null,
      drawer: showAppBar
          ? SizedBox(
              width: ResponsiveConfig.getWidth(context) * 0.6,
              child: CustomDrawer(
                selectedIndex: 2,
                onItemTapped: (index) {
                  Navigator.pop(context);
                  Get.offAll(() => const MainScreen());
                  Future.microtask(() {
                    final main = Get.find<MainScreenController>();
                    main.onItemTapped(index);
                  });
                },
                logoAsset: 'assets/white.png',
              ),
            )
          : null,
      body: CustomScrollWidget(
        children: [
          const ScreenTitle(title: 'Update Product'),
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
                                    Image.file(
                                      File(controller.selectedImage.value!.path),
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
                            : productData['image'] != null && productData['image'].toString().isNotEmpty
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(ResponsiveConfig.responsiveRadius(context, 12)),
                                    child: Image.network(
                                      productData['image'],
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      height: double.infinity,
                                      errorBuilder: (context, error, stackTrace) => _buildImagePlaceholder(context),
                                    ),
                                  )
                                : _buildImagePlaceholder(context),
                      ),
                    ),
                  ),
                  
                  CustomSpacer(height: 24),
                  
                  // Category Dropdown
                  Obx(
                    () => controller.isCategoriesLoading.value
                        ? CustomDropdownButtonFormField<String>(
                            value: null,
                            labelText: 'Category',
                            hintText: 'Loading categories...',
                            items: const [],
                            onChanged: null,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select category';
                              }
                              return null;
                            },
                          )
                        : CustomDropdownButtonFormField<String>(
                            value: controller.categoryController.text.isNotEmpty 
                                ? controller.categoryController.text 
                                : null,
                            labelText: 'Category',
                            hintText: 'Select category',
                            items: controller.categories.map((category) {
                              return DropdownMenuItem<String>(
                                value: category.name,
                                child: Text(category.name),
                              );
                            }).toList(),
                            onChanged: controller.updateCategoryString,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select category';
                              }
                              return null;
                            },
                          ),
                  ),
                  
                  CustomSpacer(height: 16),
                  
                  // Product Name
                  CustomTextField(
                    controller: controller.nameController,
                    labelText: 'Product Name',
                    hintText: 'Enter product name',
                    prefixIcon: const Icon(Icons.inventory_2),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter product name';
                      }
                      if (value.length < 2) {
                        return 'Name must be at least 2 characters';
                      }
                      return null;
                    },
                  ),
                  
                  CustomSpacer(height: 16),
                  
                  // SKU
                  CustomTextField(
                    controller: controller.skuController,
                    labelText: 'SKU',
                    hintText: 'Enter SKU',
                    prefixIcon: const Icon(Icons.tag),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter SKU';
                      }
                      if (value.length < 3) {
                        return 'SKU must be at least 3 characters';
                      }
                      return null;
                    },
                  ),
                  
                  CustomSpacer(height: 16),
                  
                  // Quantity and Weight Row
                  LayoutBuilder(
                    builder: (context, constraints) {
                      return IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              flex: 1,
                              child: CustomTextField(
                                controller: controller.quantityController,
                                labelText: 'Quantity',
                                hintText: 'Enter quantity',
                                prefixIcon: const Icon(Icons.add_shopping_cart),
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter quantity';
                                  }
                                  if (int.tryParse(value) == null || int.parse(value) < 0) {
                                    return 'Please enter valid quantity';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            CustomSpacer(width: 16),
                            Expanded(
                              flex: 1,
                              child: CustomTextField(
                                controller: controller.weightGmController,
                                labelText: 'Weight (gm)',
                                hintText: 'Enter weight in grams',
                                prefixIcon: const Icon(Icons.scale),
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter weight';
                                  }
                                  if (double.tryParse(value) == null || double.parse(value) <= 0) {
                                    return 'Please enter valid weight';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  
                  CustomSpacer(height: 16),
                  
                  // Cost per gram and Total Cost Row
                  LayoutBuilder(
                    builder: (context, constraints) {
                      return IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              flex: 1,
                              child: CustomTextField(
                                controller: controller.costPerGmController,
                                labelText: 'Cost per gm (₹)',
                                hintText: '₹Enter cost per gram',
                                prefixIcon: const Icon(Icons.currency_rupee),
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter cost per gram';
                                  }
                                  if (double.tryParse(value.replaceAll('₹', '')) == null || double.parse(value.replaceAll('₹', '')) <= 0) {
                                    return 'Please enter valid cost';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            CustomSpacer(width: 16),
                            Expanded(
                              flex: 1,
                              child: CustomTextField(
                                controller: controller.totalCostController,
                                labelText: 'Total Cost (₹)',
                                hintText: '₹Enter total cost',
                                prefixIcon: const Icon(Icons.currency_rupee),
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter total cost';
                                  }
                                  if (double.tryParse(value.replaceAll('₹', '')) == null || double.parse(value.replaceAll('₹', '')) <= 0) {
                                    return 'Please enter valid total cost';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  
                  CustomSpacer(height: 16),
                  
                  // Selling Price
                  CustomTextField(
                    controller: controller.sellingPriceController,
                    labelText: 'Selling Price (₹)',
                    hintText: '₹Enter selling price',
                    prefixIcon: const Icon(Icons.currency_rupee),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter selling price';
                      }
                      if (double.tryParse(value.replaceAll('₹', '')) == null || double.parse(value.replaceAll('₹', '')) <= 0) {
                        return 'Please enter valid selling price';
                      }
                      return null;
                    },
                  ),
                  
                  CustomSpacer(height: 16),
                  
                  // For Sale Checkbox
                  CustomRow(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Obx(
                              () => CustomCheckbox(
                                value: controller.forSale.value,
                                onChanged: controller.toggleForSale,
                              ),
                            ),
                            CustomSpacer(width: 8),
                            Text(
                              'For Sale',
                              style: TextStyle(
                                fontSize: ResponsiveConfig.responsiveFont(context, 16),
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  
                  CustomSpacer(height: 16),
                  
                  // Status
                  Obx(
                    () => CustomDropdownButtonFormField<String>(
                      value: controller.selectedStatus.value,
                      labelText: 'Status',
                      hintText: 'Select status',
                      items: const ['Active', 'Inactive'].map((String status) {
                        return DropdownMenuItem<String>(
                          value: status,
                          child: Text(status),
                        );
                      }).toList(),
                      onChanged: controller.updateStatus,
                    ),
                  ),
                  
                  CustomSpacer(height: 16),
                  
                  // Sold Status
                  Obx(
                    () => CustomDropdownButtonFormField<String>(
                      value: controller.selectedSoldStatus.value,
                      labelText: 'Sold Status',
                      hintText: 'Select sold status',
                      items: const ['Sold', 'Unsold'].map((String status) {
                        return DropdownMenuItem<String>(
                          value: status,
                          child: Text(status),
                        );
                      }).toList(),
                      onChanged: controller.updateSoldStatus,
                    ),
                  ),
                  
                  CustomSpacer(height: 32),
                  
                  // Action Buttons
                  CustomRow(
                    children: [
                      Expanded(
                        child: CustomOutlineButton(
                          text: 'Cancel',
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ),
                      CustomSpacer(width: 16),
                      Expanded(
                        child: Obx(
                          () => CustomButton(
                            text: 'Update Product',
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
          Icons.add_photo_alternate,
          size: ResponsiveConfig.responsiveFont(context, 48),
          color: Colors.grey[400],
        ),
        CustomSpacer(height: 8),
        Text(
          'Tap to change image',
          style: AppTextStyles.getBody(context).copyWith(
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}
