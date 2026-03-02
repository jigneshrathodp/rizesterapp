import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rizesterapp/screens/Profile/login_screen.dart';
import 'package:rizesterapp/services/auth_service.dart';
import '../utils/responsive_config.dart';

class CustomDrawer extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;
  final String? headerTitle;
  final String? headerSubtitle;
  final Widget? headerWidget;
  final String? logoAsset;
  final List<DrawerItem>? drawerItems;
  final Color? backgroundColor;
  final Color? selectedItemColor;
  final Color? unselectedItemColor;
  final Color? selectedTileColor;
  final TextStyle? itemTextStyle;
  final double? headerHeight;
  final bool showHeader;

  const CustomDrawer({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
    this.headerTitle,
    this.headerSubtitle,
    this.headerWidget,
    this.logoAsset,
    this.drawerItems,
    this.backgroundColor,
    this.selectedItemColor,
    this.unselectedItemColor,
    this.selectedTileColor,
    this.itemTextStyle,
    this.headerHeight,
    this.showHeader = true,
  });

  @override
  Widget build(BuildContext context) {
    final defaultDrawerItems = drawerItems ?? _getDefaultDrawerItems();
    final drawerBackgroundColor = backgroundColor ?? Colors.black;
    final selectedColor = selectedItemColor ?? Colors.white;
    final unselectedColor = unselectedItemColor ?? Colors.grey;
    final tileColor = selectedTileColor ?? Colors.grey[800];

    return Drawer(
      backgroundColor: drawerBackgroundColor,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          if (showHeader) ...[
            _buildDrawerHeader(context),
          ],
          ...defaultDrawerItems.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            final isSelected = selectedIndex == index;

            return ListTile(
              leading: Icon(
                item.icon,
                color: isSelected ? selectedColor : unselectedColor,
                size: ResponsiveConfig.responsiveFont(context, 24),
              ),
              title: Text(
                item.title,
                style: itemTextStyle ??
                    AppTextStyles.getBody(context).copyWith(
                      color: isSelected ? selectedColor : unselectedColor,
                      fontSize: ResponsiveConfig.responsiveFont(context, 16),
                    ),
              ),
              onTap: () => onItemTapped(index),
              selected: isSelected,
              selectedTileColor: tileColor,
              contentPadding: EdgeInsets.symmetric(
                horizontal: ResponsiveConfig.responsivePadding(context, 16),
                vertical: ResponsiveConfig.responsivePadding(context, 4),
              ),
            );
          }).toList(),
          const Divider(color: Colors.grey),
          _buildFooterItems(context),
        ],
      ),
    );
  }

  Widget _buildDrawerHeader(BuildContext context) {
    final logoHeight = ResponsiveConfig.responsiveHeight(context, 12.5);

    return DrawerHeader(
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.black,
      ),
      child: headerWidget ??
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: ResponsiveConfig.spacingLg(context)),
              if (logoAsset != null)
                Image.asset(
                  logoAsset!,
                  height: logoHeight,
                )
              else
                Container(
                  width: ResponsiveConfig.responsiveWidth(context, 50),
                  height: ResponsiveConfig.responsiveWidth(context, 50),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(ResponsiveConfig.responsiveRadius(context, 25)),
                  ),
                  child: Icon(
                    Icons.store,
                    color: Colors.black,
                    size: ResponsiveConfig.responsiveFont(context, 30),
                  ),
                ),
              SizedBox(height: ResponsiveConfig.spacingMd(context)),
              if (headerTitle != null) ...[
                Text(
                  headerTitle!,
                  style: AppTextStyles.getSubheading(context).copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: ResponsiveConfig.spacing2xs(context)),
              ],
              if (headerSubtitle != null)
                Text(
                  headerSubtitle!,
                  style: AppTextStyles.getCaption(context).copyWith(
                    color: Colors.white70,
                  ),
                ),
            ],
          ),
    );
  }

  Widget _buildFooterItems(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: Icon(
            Icons.logout,
            color: Colors.grey,
            size: ResponsiveConfig.responsiveFont(context, 24),
          ),
          title: Text(
            'Logout',
            style: AppTextStyles.getBody(context).copyWith(
              color: Colors.grey,
              fontSize: ResponsiveConfig.responsiveFont(context, 16),
            ),
          ),
          onTap: () async {
            // Show confirmation dialog
            bool? confirmLogout = await Get.dialog<bool>(
              AlertDialog(
                title: const Text('Logout'),
                content: const Text('Are you sure you want to logout?'),
                actions: [
                  TextButton(
                    onPressed: () => Get.back(result: false),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () => Get.back(result: true),
                    child: const Text('Logout'),
                  ),
                ],
              ),
            );
            
            if (confirmLogout == true) {
              try {
                // Call logout API
                await AuthService.logout();
                // Navigate to login screen
                Get.offAll(() => const LoginScreen());
              } catch (e) {
                // Even if API call fails, clear local data and navigate to login
                await AuthService.clearAuthData();
                Get.offAll(() => const LoginScreen());
              }
            }
          },

          contentPadding: EdgeInsets.symmetric(
            horizontal: ResponsiveConfig.responsivePadding(context, 16),
            vertical: ResponsiveConfig.responsivePadding(context, 4),
          ),
        ),
        SizedBox(height: ResponsiveConfig.spacingMd(context)),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveConfig.responsivePadding(context, 16),
          ),
          child: Text(
            'Version 1.0.0',
            style: AppTextStyles.getSmall(context).copyWith(
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(height: ResponsiveConfig.spacingMd(context)),
      ],
    );
  }

  List<DrawerItem> _getDefaultDrawerItems() {
    return [
      const DrawerItem(icon: Icons.dashboard, title: 'Dashboard'),//1
      const DrawerItem(icon: Icons.shop, title: 'Order Now'),//1
      const DrawerItem(icon: Icons.shopping_bag, title: 'Product List'),//2
      const DrawerItem(icon: Icons.category, title: 'Category List'),//3
      const DrawerItem(icon: Icons.shopping_cart_rounded, title: 'Order List'),//4
      const DrawerItem(icon: Icons.campaign, title: 'Advertise List'),//5
      const DrawerItem(icon: Icons.notifications, title: 'Notifications'),//6
      const DrawerItem(icon: Icons.post_add, title: 'Create Ad'),//7
      const DrawerItem(icon: Icons.add_circle, title: 'Create Product'),//8
      const DrawerItem(icon: Icons.category_outlined, title: 'Create Category'),//9
      const DrawerItem(icon: Icons.person, title: 'Edit Profile'),//10
      const DrawerItem(icon: Icons.lock, title: 'Change Password'),//11
    ];
  }
}

class DrawerItem {
  final IconData icon;
  final String title;
  final String? badge;

  const DrawerItem({
    required this.icon,
    required this.title,
    this.badge,
  });
}

class CustomDrawerItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isSelected;
  final VoidCallback onTap;
  final String? badge;
  final Color? selectedColor;
  final Color? unselectedColor;
  final Color? selectedTileColor;

  const CustomDrawerItem({
    super.key,
    required this.icon,
    required this.title,
    required this.isSelected,
    required this.onTap,
    this.badge,
    this.selectedColor,
    this.unselectedColor,
    this.selectedTileColor,
  });

  @override
  Widget build(BuildContext context) {
    final selected = selectedColor ?? Colors.white;
    final unselected = unselectedColor ?? Colors.grey;
    final tileColor = selectedTileColor ?? Colors.grey[800];

    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? selected : unselected,
        size: ResponsiveConfig.responsiveFont(context, 24),
      ),
      title: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: AppTextStyles.getBody(context).copyWith(
                color: isSelected ? selected : unselected,
                fontSize: ResponsiveConfig.responsiveFont(context, 16),
              ),
            ),
          ),
          if (badge != null) ...[
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveConfig.spacing2xs(context),
                vertical: ResponsiveConfig.spacing2xs(context),
              ),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(ResponsiveConfig.responsiveRadius(context, 10)),
              ),
              child: Text(
                badge!,
                style: AppTextStyles.getSmall(context).copyWith(
                  color: Colors.white,
                  fontSize: ResponsiveConfig.responsiveFont(context, 10),
                ),
              ),
            ),
          ],
        ],
      ),
      onTap: onTap,
      selected: isSelected,
      selectedTileColor: tileColor,
      contentPadding: EdgeInsets.symmetric(
        horizontal: ResponsiveConfig.responsivePadding(context, 16),
        vertical: ResponsiveConfig.responsivePadding(context, 4),
      ),
    );
  }
}
