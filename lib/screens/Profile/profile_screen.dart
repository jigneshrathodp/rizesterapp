import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../App_model/profile_model/GetProfileModel.dart';
import '../../utils/responsive_config.dart';
import '../../widgets/widgets.dart';
import '../../services/auth_service.dart';
import '../../widgets/auth_future_builder.dart';
import 'editprofile_screen.dart';
import 'changepassword_screen.dart';
import '../notification_screen.dart' as notification;
import '../main_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Image loading states
  final profilePhotoLoading = false.obs;
  final favIconLoading = false.obs;
  final logoLightLoading = false.obs;
  final logoDarkLoading = false.obs;

  void _refreshProfile() {
    setState(() {
      // This will trigger a rebuild of the FutureBuilder
    });
    
    Get.snackbar(
      'Refreshing',
      'Loading profile data...',
      backgroundColor: Colors.blue,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }

  bool getImageLoadingState(String imageType) {
    switch (imageType) {
      case 'profile':
        return profilePhotoLoading.value;
      case 'favIcon':
        return favIconLoading.value;
      case 'logoLight':
        return logoLightLoading.value;
      case 'logoDark':
        return logoDarkLoading.value;
      default:
        return false;
    }
  }

  void setImageLoadingState(String imageType, bool loading) {
    switch (imageType) {
      case 'profile':
        profilePhotoLoading.value = loading;
        break;
      case 'favIcon':
        favIconLoading.value = loading;
        break;
      case 'logoLight':
        logoLightLoading.value = loading;
        break;
      case 'logoDark':
        logoDarkLoading.value = loading;
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MainScreenController>();
    
    return Scaffold(
      key: controller.scaffoldKey,
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        logoAsset: 'assets/black.png',
        onMenuPressed: () => controller.scaffoldKey.currentState?.openDrawer(),
        onNotificationPressed: () => Get.to(() => const notification.NotificationScreen()),
        onProfilePressed: () {},
      ),
      drawer: SizedBox(
        width: ResponsiveConfig.getWidth(context) * 0.6,
        child: Obx(
          () => CustomDrawer(
            selectedIndex: controller.selectedIndex.value,
            onItemTapped: controller.onItemTapped,
            logoAsset: 'assets/white.png',
          ),
        ),
      ),
      body: CustomScrollWidget(
        children: [
          const ScreenTitle(title: 'Profile'),
          Padding(
            padding: EdgeInsets.all(ResponsiveConfig.spacingMd(context)),
            child: CustomColumn(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomSpacer(height: 20),
                
                // Refresh Button
                CustomRow(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: _refreshProfile,
                      icon: const Icon(Icons.refresh),
                      tooltip: 'Refresh Profile',
                    ),
                  ],
                ),
                
                // Profile Details using FutureBuilder
                ProfileDetailsFutureBuilder(
                  onLoading: () => const Center(
                    child: Padding(
                      padding: EdgeInsets.all(40.0),
                      child: CircularProgressIndicator(),
                    ),
                  ),
                  onError: (error) => Center(
                    child: Column(
                      children: [
                        Icon(Icons.error_outline, size: 50, color: Colors.grey[400]),
                        SizedBox(height: 10),
                        Text(
                          'Failed to load profile',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        SizedBox(height: 10),
                        TextButton(
                          onPressed: _refreshProfile,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                  onSuccess: (profileModel) => CustomColumn(
                    children: [
                      // Profile Image and Basic Info
                      Center(
                        child: Column(
                          children: [
                            Container(
                              width: ResponsiveConfig.responsiveWidth(context, 100),
                              height: ResponsiveConfig.responsiveWidth(context, 100),
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(ResponsiveConfig.responsiveRadius(context, 50)),
                                border: Border.all(color: Colors.grey[300]!),
                              ),
                              child: profileModel.user?.image != null
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(50),
                                      child: Image.network(
                                        profileModel.user!.image!,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) {
                                          return Icon(
                                            Icons.person,
                                            size: ResponsiveConfig.responsiveFont(context, 50),
                                            color: Colors.grey[700],
                                          );
                                        },
                                      ),
                                    )
                                  : Icon(
                                      Icons.person,
                                      size: ResponsiveConfig.responsiveFont(context, 50),
                                      color: Colors.grey[700],
                                    ),
                            ),
                            CustomSpacer(height: ResponsiveConfig.spacingSm(context)),
                            Text(
                              profileModel.user?.name ?? 'User Name',
                              style: AppTextStyles.getSubheading(context).copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              profileModel.user?.email ?? 'user@example.com',
                              style: AppTextStyles.getBody(context).copyWith(
                                color: Colors.grey[600],
                              ),
                            ),
                            if (profileModel.user?.contact != null) ...[
                              SizedBox(height: 4),
                              Text(
                                profileModel.user!.contact!,
                                style: AppTextStyles.getBody(context).copyWith(
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      
                      CustomSpacer(height: ResponsiveConfig.spacingXl(context)),
                      
                      // User Details Section
                      _buildDetailsSection(context, 'User Details', [
                        _buildDetailRow(context, 'Name', profileModel.user?.name ?? 'N/A'),
                        _buildDetailRow(context, 'Email', profileModel.user?.email ?? 'N/A'),
                        _buildDetailRow(context, 'Contact', profileModel.user?.contact ?? 'N/A'),
                      ]),
                      
                      CustomSpacer(height: ResponsiveConfig.spacingLg(context)),
                      
                      // Site Details Section
                      if (profileModel.details != null) ...[
                        _buildDetailsSection(context, 'Site Details', [
                          _buildDetailRow(context, 'Site Name', profileModel.details!.siteName ?? 'N/A'),
                          _buildDetailRow(context, 'Address', profileModel.details!.address ?? 'N/A'),
                          _buildDetailRow(context, 'Footer', profileModel.details!.footer ?? 'N/A'),
                        ]),
                        
                        CustomSpacer(height: ResponsiveConfig.spacingLg(context)),
                        
                        // Site Images Section
                        _buildImagesSection(context, profileModel),
                        
                        CustomSpacer(height: ResponsiveConfig.spacingLg(context)),
                      ],
                    ],
                  ),
                ),
                
                CustomSpacer(height: ResponsiveConfig.spacingXl(context)),
                CustomRow(
                  children: [
                    Expanded(
                      child: CustomButton(
                        text: 'Edit Profile',
                        onPressed: () => Get.to(() => const EditProfileScreen()),
                        backgroundColor: Colors.black,
                        textColor: Colors.white,
                      ),
                    ),
                    CustomSpacer(width: ResponsiveConfig.spacingSm(context)),
                    Expanded(
                      child: CustomOutlineButton(
                        text: 'Change Password',
                        onPressed: () => Get.to(() => const ChangePasswordScreen()),
                      ),
                    ),
                  ],
                ),
                CustomSpacer(height: ResponsiveConfig.spacingLg(context)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImagesSection(BuildContext context, GetProfileModel profileModel) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(ResponsiveConfig.spacingMd(context)),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(ResponsiveConfig.responsiveRadius(context, 12)),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: CustomColumn(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Site Images',
            style: AppTextStyles.getSubheading(context).copyWith(
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          CustomSpacer(height: ResponsiveConfig.spacingSm(context)),
          
          // Profile Photo
          _buildProfileImageItem(context, 'Profile Photo', profileModel.user?.image),
          
          CustomSpacer(height: ResponsiveConfig.spacingMd(context)),
          
          // Fav Icon
          _buildNetworkImageItem(context, 'Fav Icon', profileModel.details?.favIcon, 'favIcon'),
          
          CustomSpacer(height: ResponsiveConfig.spacingMd(context)),
          
          // Logo Light
          _buildNetworkImageItem(context, 'Logo Light', profileModel.details?.logoLight, 'logoLight'),
          
          CustomSpacer(height: ResponsiveConfig.spacingMd(context)),
          
          // Logo Dark
          _buildNetworkImageItem(context, 'Logo Dark', profileModel.details?.logoDark, 'logoDark'),
        ],
      ),
    );
  }

  Widget _buildProfileImageItem(BuildContext context, String title, String? imageUrl) {
    return CustomColumn(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.getBody(context).copyWith(
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
        CustomSpacer(height: 8),
        Container(
          width: double.infinity,
          height: ResponsiveConfig.responsiveHeight(context, 120),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(ResponsiveConfig.responsiveRadius(context, 8)),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: imageUrl != null && imageUrl.isNotEmpty
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(ResponsiveConfig.responsiveRadius(context, 8)),
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return _buildImagePlaceholder(context, title);
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      );
                    },
                  ),
                )
              : _buildImagePlaceholder(context, title),
        ),
      ],
    );
  }

  Widget _buildNetworkImageItem(BuildContext context, String title, String? imageUrl, String imageType) {
    return Obx(
      () => CustomColumn(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.getBody(context).copyWith(
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
          CustomSpacer(height: 8),
          Container(
            width: double.infinity,
            height: ResponsiveConfig.responsiveHeight(context, 120),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(ResponsiveConfig.responsiveRadius(context, 8)),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: getImageLoadingState(imageType)
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 8),
                        Text(
                          'Loading...',
                          style: AppTextStyles.getBody(context).copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  )
                : imageUrl != null && imageUrl.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(ResponsiveConfig.responsiveRadius(context, 8)),
                        child: Image.network(
                          imageUrl,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            // Reset loading state on error
                            setImageLoadingState(imageType, false);
                            return _buildImagePlaceholder(context, title);
                          },
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) {
                              setImageLoadingState(imageType, false);
                              return child;
                            }
                            // Set loading state when loading starts
                            setImageLoadingState(imageType, true);
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            );
                          },
                        ),
                      )
                    : _buildImagePlaceholder(context, title),
          ),
        ],
      ),
    );
  }

  Widget _buildImagePlaceholder(BuildContext context, String title) {
    return CustomColumn(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.image,
          size: ResponsiveConfig.responsiveFont(context, 40),
          color: Colors.grey[400],
        ),
        CustomSpacer(height: 8),
        Text(
          'No $title',
          style: AppTextStyles.getBody(context).copyWith(
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildDetailsSection(BuildContext context, String title, List<Widget> children) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(ResponsiveConfig.spacingMd(context)),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(ResponsiveConfig.responsiveRadius(context, 12)),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: CustomColumn(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.getSubheading(context).copyWith(
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          CustomSpacer(height: ResponsiveConfig.spacingSm(context)),
          ...children,
        ],
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: ResponsiveConfig.spacingSm(context)),
      child: CustomRow(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: ResponsiveConfig.responsiveWidth(context, 80),
            child: Text(
              label,
              style: AppTextStyles.getBody(context).copyWith(
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
          ),
          const Text(': '),
          Expanded(
            child: Text(
              value,
              style: AppTextStyles.getBody(context).copyWith(
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
