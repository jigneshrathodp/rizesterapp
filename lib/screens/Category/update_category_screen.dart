import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../utils/responsive_config.dart';
import '../../widgets/widgets.dart';
import 'package:get/get.dart';
import 'package:rizesterapp/screens/main_screen.dart';
import '../notification_screen.dart' as notification;
import 'package:rizesterapp/screens/Profile/profile_screen.dart';
import '../../services/auth_service.dart';
import '../../App_model/Category_model/UpdateCategoryModel.dart';

class UpdateCategoryScreen extends StatefulWidget {
  final Map<String, dynamic> categoryData;
  final bool showAppBar;

  const UpdateCategoryScreen({
    super.key,
    required this.categoryData,
    this.showAppBar = false,
  });

  @override
  State<UpdateCategoryScreen> createState() => _UpdateCategoryScreenState();
}

class _UpdateCategoryScreenState extends State<UpdateCategoryScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _skuController;

  XFile? _selectedImage;
  bool _isLoading = false;
  String? _existingImageUrl;
  late final int _categoryId;

  @override
  void initState() {
    super.initState();
    _categoryId = widget.categoryData['id'] ?? 0;
    _nameController = TextEditingController();
    _skuController = TextEditingController();
    _loadCategory();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _skuController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: widget.showAppBar
          ? _UpdateCategoryAppBarWrapper(
              logoAsset: 'assets/black.png',
              onNotificationPressed: () => Get.to(() => const notification.NotificationScreen()),
              onProfilePressed: () => Get.to(() => const ProfileScreen()),
            )
          : null,
      drawer: widget.showAppBar
          ? SizedBox(
              width: ResponsiveConfig.getWidth(context) * 0.6,
              child: CustomDrawer(
                selectedIndex: 3,
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
          const ScreenTitle(title: 'Update Category'),
          Padding(
            padding: EdgeInsets.all(ResponsiveConfig.spacingMd(context)),
            child: Form(
              key: _formKey,
              child: CustomColumn(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomSpacer(height: 30),
                  
                  // Image Upload Section
                  GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      width: double.infinity,
                      height: ResponsiveConfig.responsiveHeight(context, 200),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(ResponsiveConfig.responsiveRadius(context, 12)),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: _selectedImage != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(ResponsiveConfig.responsiveRadius(context, 12)),
                              child: Stack(
                                children: [
                                  Image.file(
                                    File(_selectedImage!.path),
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: double.infinity,
                                    errorBuilder: (context, error, stackTrace) => _buildImagePlaceholder(context),
                                  ),
                                  Positioned(
                                    top: 8,
                                    right: 8,
                                    child: GestureDetector(
                                      onTap: _removeImage,
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
                          : (_existingImageUrl != null && _existingImageUrl!.isNotEmpty)
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(ResponsiveConfig.responsiveRadius(context, 12)),
                                  child: Image.network(
                                    _existingImageUrl!,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: double.infinity,
                                    loadingBuilder: (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Container(
                                        width: double.infinity,
                                        height: double.infinity,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(ResponsiveConfig.responsiveRadius(context, 12)),
                                          color: Colors.grey[100],
                                        ),
                                        child: Center(
                                          child: SizedBox(
                                            width: 40,
                                            height: 40,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 3,
                                              valueColor: AlwaysStoppedAnimation<Color>(Colors.grey[400]!),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                    errorBuilder: (context, error, stackTrace) => _buildImagePlaceholder(context),
                                  ),
                                )
                              : _buildImagePlaceholder(context),
                    ),
                  ),
                  
                  CustomSpacer(height: 24),
                  
                  // Category Name
                  CustomTextField(
                    controller: _nameController,
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
                    controller: _skuController,
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
                  
                  CustomSpacer(height: 32),
                  
                  // Action Buttons
                  CustomRow(
                    children: [
                      Expanded(
                        child: CustomOutlineButton(
                          text: 'Cancel',
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                      CustomSpacer(width: 16),
                      Expanded(
                        child: CustomButton(
                          text: 'Update Category',
                          onPressed: _handleSubmit,
                          backgroundColor: Colors.black,
                          textColor: Colors.white,
                          isLoading: _isLoading,
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
          'Tap to change image',
          style: AppTextStyles.getBody(context).copyWith(
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choose Image Source'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () async {
                Navigator.of(context).pop();
                final XFile? image = await picker.pickImage(source: ImageSource.camera);
                if (image != null) {
                  setState(() {
                    _selectedImage = image;
                  });
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () async {
                Navigator.of(context).pop();
                final XFile? image = await picker.pickImage(source: ImageSource.gallery);
                if (image != null) {
                  setState(() {
                    _selectedImage = image;
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _removeImage() {
    setState(() {
      _selectedImage = null;
    });
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      _updateCategory();
    }
  }

  void _showSuccess() {
    Get.snackbar(
      'Success',
      'Category updated successfully',
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );
    Get.offAll(() => const MainScreen());
    Future.delayed(const Duration(milliseconds: 300), () {
      if (!Get.isRegistered<MainScreenController>()) {
        try {
          Get.put(MainScreenController());
        } catch (_) {}
      }
      final main = Get.find<MainScreenController>();
      main.onItemTapped(3);
    });
  }
  
  Future<void> _loadCategory() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final UpdateCategoryModel model = await AuthService.getCategoryById(_categoryId);
      if (model.status == true && model.data != null) {
        _nameController.text = model.data!.name ?? '';
        _skuController.text = model.data!.skubarCode ?? '';
        _existingImageUrl = model.data!.image ?? '';
      } else {
        Get.snackbar(
          'Error',
          model.message ?? 'Failed to load category',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      String errorMessage = 'Failed to load category';
      
      // Handle specific server errors
      if (e.toString().contains('503')) {
        errorMessage = 'Server is temporarily unavailable. Please try again later.';
      } else if (e.toString().contains('500')) {
        errorMessage = 'Server error occurred. Please try again later.';
      } else if (e.toString().contains('timeout')) {
        errorMessage = 'Request timed out. Please check your connection and try again.';
      } else if (e.toString().contains('network')) {
        errorMessage = 'Network error. Please check your internet connection.';
      } else if (e.toString().contains('404')) {
        errorMessage = 'Category not found. It may have been deleted.';
      } else if (e.toString().contains('401')) {
        errorMessage = 'Authentication error. Please login again.';
      } else {
        // For other errors, try to extract a clean message
        String errorString = e.toString();
        if (errorString.contains('Exception:')) {
          errorString = errorString.split('Exception:').last.trim();
        }
        // Remove HTML tags if present
        errorString = errorString.replaceAll(RegExp(r'<[^>]*>'), '').trim();
        
        if (errorString.isNotEmpty && errorString.length < 100) {
          errorMessage = errorString;
        }
      }
      
      Get.snackbar(
        'Error',
        errorMessage,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
  
  Future<void> _updateCategory() async {
    try {
      final UpdateCategoryModel result = await AuthService.updateCategory(
        id: _categoryId,
        name: _nameController.text.trim(),
        skubarCode: _skuController.text.trim(),
        image: _selectedImage,
      );
      if (result.status == true) {
        _showSuccess();
      } else {
        Get.snackbar(
          'Error',
          result.message ?? 'Failed to update category',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      String errorMessage = 'Failed to update category';
      
      // Handle specific server errors
      if (e.toString().contains('503')) {
        errorMessage = 'Server is temporarily unavailable. Please try again later.';
      } else if (e.toString().contains('500')) {
        errorMessage = 'Server error occurred. Please try again later.';
      } else if (e.toString().contains('timeout')) {
        errorMessage = 'Request timed out. Please check your connection and try again.';
      } else if (e.toString().contains('network')) {
        errorMessage = 'Network error. Please check your internet connection.';
      } else if (e.toString().contains('422')) {
        errorMessage = 'Validation error. Please check your input and try again.';
      } else if (e.toString().contains('401')) {
        errorMessage = 'Authentication error. Please login again.';
      } else if (e.toString().contains('404')) {
        errorMessage = 'Category not found. It may have been deleted.';
      } else {
        // For other errors, try to extract a clean message
        String errorString = e.toString();
        if (errorString.contains('Exception:')) {
          errorString = errorString.split('Exception:').last.trim();
        }
        // Remove HTML tags if present
        errorString = errorString.replaceAll(RegExp(r'<[^>]*>'), '').trim();
        
        if (errorString.isNotEmpty && errorString.length < 100) {
          errorMessage = errorString;
        }
      }
      
      Get.snackbar(
        'Error',
        errorMessage,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Success'),
        content: const Text('Category updated successfully!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

class _UpdateCategoryAppBarWrapper extends StatelessWidget implements PreferredSizeWidget {
  final String logoAsset;
  final VoidCallback onNotificationPressed;
  final VoidCallback onProfilePressed;

  const _UpdateCategoryAppBarWrapper({
    required this.logoAsset,
    required this.onNotificationPressed,
    required this.onProfilePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) => CustomAppBar(
        logoAsset: logoAsset,
        onMenuPressed: () {
          if (Scaffold.of(context).hasDrawer) {
            Scaffold.of(context).openDrawer();
          }
        },
        onNotificationPressed: onNotificationPressed,
        onProfilePressed: onProfilePressed,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
