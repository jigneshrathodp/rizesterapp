import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/create_product_controller.dart';
import '../../utils/responsive_config.dart';
import '../../widgets/widgets.dart';
import 'package:rizesterapp/screens/main_screen.dart';
import '../notification_screen.dart' as notification;
import 'package:rizesterapp/screens/Profile/profile_screen.dart';

class CreateProductScreen extends StatefulWidget {
  final bool showAppBar;
  const CreateProductScreen({super.key, this.showAppBar = false});
  @override
  State<CreateProductScreen> createState() => _CreateProductScreenState();
}

class _CreateProductScreenState extends State<CreateProductScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CreateProductController());
    
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: widget.showAppBar
          ? CustomAppBar(
              logoAsset: 'assets/black.png',
              onMenuPressed: () => _scaffoldKey.currentState?.openDrawer(),
              onNotificationPressed: () => Get.to(() => const notification.NotificationScreen()),
              onProfilePressed: () => Get.to(() => const ProfileScreen()),
            )
          : null,
      drawer: widget.showAppBar
          ? SizedBox(
              width: ResponsiveConfig.getWidth(context) * 0.6,
              child: CustomDrawer(
                selectedIndex: 8,
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
          const ScreenTitle(title: 'Create Product'),
          Padding(
            padding: EdgeInsets.all(ResponsiveConfig.spacingMd(context)),
            child: Form(
              key: controller.formKey,
              child: CustomColumn(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomSpacer(height: 30),
                  
                  // Image Upload Section
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final maxHeight = ResponsiveConfig.responsiveHeight(context, 200);
                      final minHeight = ResponsiveConfig.responsiveHeight(context, 120);
                      
                      return ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: minHeight,
                          maxHeight: maxHeight,
                        ),
                        child: Obx(
                          () => GestureDetector(
                            onTap: controller.pickImage,
                            child: Container(
                              width: double.infinity,
                              constraints: BoxConstraints(
                                minHeight: minHeight,
                                maxHeight: maxHeight,
                              ),
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
                      );
                    },
                  ),
                  
                  CustomSpacer(height: 24),
                  
                  // Category
                  CustomDropdownButtonFormField<String>(
                    value: controller.categoryController.text.isEmpty ? null : controller.categoryController.text,
                    labelText: 'Category',
                    hintText: 'Select category',
                    items: controller.jewelleryCategories.map((String category) {
                      return DropdownMenuItem<String>(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                    onChanged: controller.updateCategory,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select category';
                      }
                      return null;
                    },
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
                            text: 'Create Product',
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
          'Tap to upload product image',
          style: AppTextStyles.getBody(context).copyWith(
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}
