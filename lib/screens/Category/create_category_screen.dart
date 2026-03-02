import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/create_category_controller.dart';
import '../../utils/responsive_config.dart';
import '../../widgets/widgets.dart';
import 'package:rizesterapp/screens/main_screen.dart';
import '../notification_screen.dart' as notification;
import 'package:rizesterapp/screens/Profile/profile_screen.dart';

class CreateCategoryScreen extends StatefulWidget {
  final bool showAppBar;
  const CreateCategoryScreen({super.key, this.showAppBar = false});
  @override
  State<CreateCategoryScreen> createState() => _CreateCategoryScreenState();
}

class _CreateCategoryScreenState extends State<CreateCategoryScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CreateCategoryController());
    
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
                selectedIndex: 9,
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
          const ScreenTitle(title: 'Create Category'),
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
                  
                  // Category Name
                  CustomTextField(
                    controller: controller.nameController,
                    labelText: 'Category Name',
                    hintText: 'Enter category name',
                    prefixIcon: const Icon(Icons.category),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter category name';
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
                  
                  // Barcode
                  CustomTextField(
                    controller: controller.barcodeController,
                    labelText: 'Barcode',
                    hintText: 'Enter barcode',
                    prefixIcon: const Icon(Icons.qr_code_scanner),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter barcode';
                      }
                      if (value.length < 8) {
                        return 'Barcode must be at least 8 characters';
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
                            text: 'Create Category',
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
          'Tap to upload image',
          style: AppTextStyles.getBody(context).copyWith(
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}
