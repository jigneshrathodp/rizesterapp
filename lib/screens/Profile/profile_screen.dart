import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils/responsive_config.dart';
import '../../widgets/widgets.dart';
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
                        child: Icon(
                          Icons.person,
                          size: ResponsiveConfig.responsiveFont(context, 50),
                          color: Colors.grey[700],
                        ),
                      ),
                      CustomSpacer(height: ResponsiveConfig.spacingSm(context)),
                      Text(
                        'John Doe',
                        style: AppTextStyles.getSubheading(context).copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'john.doe@example.com',
                        style: AppTextStyles.getBody(context).copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
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
}
