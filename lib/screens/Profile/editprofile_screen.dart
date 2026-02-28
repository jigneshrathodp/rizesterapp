import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../utils/responsive_config.dart';
import '../../widgets/widgets.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _contactController = TextEditingController();
  final _siteNameController = TextEditingController();
  final _addressController = TextEditingController();
  final _footerController = TextEditingController();

  XFile? _profilePhoto;
  XFile? _favIcon;
  XFile? _logoLight;
  XFile? _logoDark;
  
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _contactController.dispose();
    _siteNameController.dispose();
    _addressController.dispose();
    _footerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: 'Edit Profile',
        onBackPressed: () => Navigator.pop(context),
        showNotifications: false,
        showProfile: false,
      ),
      body: CustomScrollWidget(
        children: [
          Padding(
            padding: EdgeInsets.all(ResponsiveConfig.spacingMd(context)),
            child: Form(
              key: _formKey,
              child: CustomColumn(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomSpacer(height: 30),
                  
                  // Profile Photo Section
                  _buildImageUploadSection("Profile Photo", "profile"),
                  
                  CustomSpacer(height: 24),
                  
                  // Name
                  CustomTextField(
                    controller: _nameController,
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
                    controller: _emailController,
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
                    controller: _contactController,
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
                    controller: _siteNameController,
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
                    controller: _addressController,
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
                  _buildImageUploadSection("Fav Icon", "favIcon", height: 100),
                  
                  CustomSpacer(height: 24),
                  
                  // Logo Light
                  _buildImageUploadSection("Logo Light", "logoLight", height: 120),
                  
                  CustomSpacer(height: 24),
                  
                  // Logo Dark
                  _buildImageUploadSection("Logo Dark", "logoDark", height: 120),
                  
                  CustomSpacer(height: 24),
                  
                  // Footer
                  CustomTextField(
                    controller: _footerController,
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
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                      CustomSpacer(width: 16),
                      Expanded(
                        child: CustomButton(
                          text: 'Update Profile',
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

  Widget _buildImageUploadSection(String label, String imageType, {double height = 150}) {
    final selectedImage = _getImageByType(imageType);
    
    return CustomColumn(
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
          onTap: () => _pickImage(imageType),
          child: Container(
            width: double.infinity,
            height: ResponsiveConfig.responsiveHeight(context, height),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(ResponsiveConfig.responsiveRadius(context, 12)),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: selectedImage != null && selectedImage.path.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(ResponsiveConfig.responsiveRadius(context, 12)),
                    child: Stack(
                      children: [
                        Image.asset(
                          selectedImage.path,
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
                            onTap: () => _removeImage(imageType),
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

  Future<void> _pickImage(String imageType) async {
    final ImagePicker picker = ImagePicker();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Choose ${_getImageTitle(imageType)}'),
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
                    _setImageByType(imageType, image);
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
                    _setImageByType(imageType, image);
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  String _getImageTitle(String imageType) {
    switch (imageType) {
      case 'profile':
        return 'Profile Photo';
      case 'favIcon':
        return 'Fav Icon';
      case 'logoLight':
        return 'Logo Light';
      case 'logoDark':
        return 'Logo Dark';
      default:
        return 'Image';
    }
  }

  void _setImageByType(String imageType, XFile image) {
    switch (imageType) {
      case 'profile':
        _profilePhoto = image;
        break;
      case 'favIcon':
        _favIcon = image;
        break;
      case 'logoLight':
        _logoLight = image;
        break;
      case 'logoDark':
        _logoDark = image;
        break;
    }
  }

  XFile? _getImageByType(String imageType) {
    switch (imageType) {
      case 'profile':
        return _profilePhoto;
      case 'favIcon':
        return _favIcon;
      case 'logoLight':
        return _logoLight;
      case 'logoDark':
        return _logoDark;
      default:
        return null;
    }
  }

  void _removeImage(String imageType) {
    setState(() {
      _setImageByType(imageType, XFile(''));
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
        content: const Text('Profile updated successfully!'),
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