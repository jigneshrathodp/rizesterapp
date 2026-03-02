import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import 'package:rizesterapp/screens/main_screen.dart';
import '../../utils/responsive_config.dart';
import '../../widgets/widgets.dart';
import '../notification_screen.dart' as notification;
import 'package:rizesterapp/screens/Profile/profile_screen.dart';

class UpdateAdsScreen extends StatefulWidget {
  final Map<String, dynamic> adData;
  final bool showAppBar;

  const UpdateAdsScreen({super.key, required this.adData, this.showAppBar = false});

  @override
  State<UpdateAdsScreen> createState() => _UpdateAdsScreenState();
}

class _UpdateAdsScreenState extends State<UpdateAdsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _priceController;
  late final TextEditingController _urlController;
  late final TextEditingController _descriptionController;
  late String _selectedPlatform;
  XFile? _selectedImage;
  bool _isLoading = false;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.adData['title'] ?? '');
    _priceController = TextEditingController(text: widget.adData['price']?.toString() ?? '');
    _urlController = TextEditingController(text: widget.adData['url'] ?? '');
    _descriptionController = TextEditingController(text: widget.adData['description'] ?? '');
    _selectedPlatform = widget.adData['platform'] ?? 'Facebook';
    
    // Initialize image if exists
    final existingImage = widget.adData['image'];
    if (existingImage != null) {
      _selectedImage = XFile(existingImage);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _urlController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                selectedIndex: 5,
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
          const ScreenTitle(title: 'Update Advertisement'),
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
                                  Image.asset(
                                    _selectedImage!.path,
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
                          : _buildImagePlaceholder(context),
                    ),
                  ),
                  
                  CustomSpacer(height: 24),
                  
                  // Ad Title
                  CustomTextField(
                    controller: _titleController,
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
                  CustomDropdownButtonFormField<String>(
                    value: _selectedPlatform,
                    labelText: 'Platform',
                    hintText: 'Select platform',
                    items: const ['Facebook', 'Google', 'Instagram', 'Twitter', 'LinkedIn'].map((String platform) {
                      return DropdownMenuItem<String>(
                        value: platform,
                        child: Text(platform),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedPlatform = newValue!;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select platform';
                      }
                      return null;
                    },
                  ),
                  
                  CustomSpacer(height: 16),
                  
                  // Budget/Price
                  CustomTextField(
                    controller: _priceController,
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
                    controller: _urlController,
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
                    controller: _descriptionController,
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
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                      CustomSpacer(width: 16),
                      Expanded(
                        child: CustomButton(
                          text: 'Update Ad',
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
          'Tap to change ad creative',
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

      // Simulate API call
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          _isLoading = false;
        });
        
        _showSuccessDialog();
      });
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Success'),
        content: const Text('Advertisement updated successfully!'),
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
