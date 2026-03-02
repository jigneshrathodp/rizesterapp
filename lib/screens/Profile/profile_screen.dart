import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils/responsive_config.dart';
import '../../widgets/widgets.dart';
import '../../services/auth_service.dart';
import '../../widgets/auth_future_builder.dart';
import 'editprofile_screen.dart';
import 'changepassword_screen.dart';
import '../notification_screen.dart' as notification;
import '../main_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        logoAsset: 'assets/black.png',
        onMenuPressed: () => Get.find<MainScreenController>().scaffoldKey.currentState?.openDrawer(),
        onNotificationPressed: () => Get.to(() => const notification.NotificationScreen()),
        onProfilePressed: () {},
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
                          onPressed: () => Get.reload(),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                  onSuccess: (profileModel) => Center(
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
}
