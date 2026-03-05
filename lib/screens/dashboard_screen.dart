import 'package:flutter/material.dart';
import 'package:get/get.dart' hide GetStringUtils;
import '../widgets/widgets.dart';
import '../widgets/auth_future_builder.dart';
import '../utils/responsive_config.dart';
import '../App_model/profile_model/GetDashboardModel.dart';
import 'Profile/profile_screen.dart';
import 'main_screen.dart';
import 'notification_screen.dart' as notification;

class DashboardScreen extends StatelessWidget {
  final bool showAppBar;
  const DashboardScreen({super.key, this.showAppBar = false});

  static void _handleDrawerNavigation(int index) {
    Get.back(); // Close drawer first
    
    if (index == 0) {
      // Already on dashboard, do nothing
      return;
    }
    
    // Navigate to MainScreen with the selected index
    Get.off(() => const MainScreen());
    
    // Use a small delay to ensure MainScreen is loaded before changing index
    Future.delayed(const Duration(milliseconds: 100), () {
      final controller = Get.find<MainScreenController>();
      controller.onItemTapped(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MainScreenController>();
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: showAppBar
          ? _CustomAppBarWrapper(
              logoAsset: 'assets/black.png',
              onNotificationPressed: () => Get.to(() => const notification.NotificationScreen()),
              onProfilePressed: () => Get.to(() => const ProfileScreen()),
            )
          : null,
      drawer: showAppBar
          ? SizedBox(
              width: ResponsiveConfig.getWidth(context) * 0.6,
              child: CustomDrawer(
                selectedIndex: 0, // Dashboard is always selected
                onItemTapped: DashboardScreen._handleDrawerNavigation,
                logoAsset: 'assets/white.png',
              ),
            )
          : null,
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: KeyboardAvoider(
            child: CustomScrollWidget(
              children: [
                const ScreenTitle(title: 'Dashboard'),
                Padding(
                  padding: EdgeInsets.all(ResponsiveConfig.spacingMd(context)),
                  child: DashboardFutureBuilder(
                  onLoading: () => const Center(
                    child: Padding(
                      padding: EdgeInsets.all(40.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 20),
                          Text('Loading dashboard data...'),
                        ],
                      ),
                    ),
                  ),
                  onError: (error) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Failed to load dashboard: $error'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    });
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.error_outline, size: 50, color: Colors.grey[400]),
                          SizedBox(height: 10),
                          Text(
                            'Failed to load dashboard',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                          SizedBox(height: 10),
                          TextButton(
                            onPressed: () => Get.reload(),
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  },
                  onSuccess: (dashboardModel) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Dashboard loaded successfully'),
                        ),
                      );
                    });
                    return _buildDashboardStats(context, dashboardModel);
                  },
                ),
              ),
            ],
          ),
        ),
        ),
      ),
    );
  }

  Widget _buildDashboardStats(BuildContext context, GetDashboardModel dashboardModel) {
    final stats = dashboardModel.data?.stats;
    
    return CustomColumn(
      children: [
        // Stats Grid
        _buildStatsGrid(context, stats),
        
        CustomSpacer(height: ResponsiveConfig.spacingLg(context)),
      ],
    );
  }

  Widget _buildStatsGrid(BuildContext context, Stats? stats) {
    final List<Map<String, dynamic>> statItems = [
      {
        'title': 'Total Categories',
        'value': '${stats?.totalCategories ?? 0}',
        'icon': Icons.category,
      },
      {
        'title': 'Total Products',
        'value': '${stats?.totalProducts ?? 0}',
        'icon': Icons.shopping_bag,
      },
      {
        'title': 'Total Orders',
        'value': '${stats?.totalOrders ?? 0}',
        'icon': Icons.list_alt,
      },
      {
        'title': 'This Month Orders',
        'value': '${stats?.currentMonthOrders ?? 0}',
        'icon': Icons.calendar_today,
      },
      {
        'title': 'Sold Products',
        'value': '${stats?.totalSoldProducts ?? 0}',
        'icon': Icons.sell,
      },
      {
        'title': 'Total Product Cost',
        'value': '₹${stats?.totalProductCost ?? 0}',
        'icon': Icons.calculate,
      },
      {
        'title': 'Total Revenue',
        'value': '₹${stats?.totalSoldPrice ?? 0}',
        'icon': Icons.currency_rupee,
      },
      {
        'title': 'Advertisements',
        'value': '${stats?.totalAdvertisements ?? 0}',
        'icon': Icons.campaign,
      },
      {
        'title': 'Ad Revenue',
        'value': '₹${stats?.totalAdvertisePrice ?? 0}',
        'icon': Icons.currency_rupee,
      },
    ];

    return Column(
      children: statItems.map((item) => _buildStatCard(context, item)).toList(),
    );
  }

  Widget _buildStatCard(BuildContext context, Map<String, dynamic> item) {
    return Container(
      margin: EdgeInsets.only(bottom: ResponsiveConfig.spacingMd(context)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(ResponsiveConfig.responsiveRadius(context, 12)),
        border: Border.all(
          color: Colors.black,
          width: 0.2,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(ResponsiveConfig.spacingMd(context)),
        child: Row(
          children: [
            Container(
              width: ResponsiveConfig.responsiveWidth(context, 60),
              height: ResponsiveConfig.responsiveHeight(context, 60),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(ResponsiveConfig.responsiveRadius(context, 12)),
              ),
              child: Icon(
                item['icon'],
                color: Colors.white,
                size: ResponsiveConfig.responsiveFont(context, 30),
              ),
            ),
            CustomSpacer(width: ResponsiveConfig.spacingMd(context)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['title'],
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  CustomSpacer(height: ResponsiveConfig.spacing2xs(context)),
                  Text(
                    item['value'],
                    style: const TextStyle(
                      fontSize: 24,
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}

class _CustomAppBarWrapper extends StatelessWidget implements PreferredSizeWidget {
  final String logoAsset;
  final VoidCallback onNotificationPressed;
  final VoidCallback onProfilePressed;

  const _CustomAppBarWrapper({
    required this.logoAsset,
    required this.onNotificationPressed,
    required this.onProfilePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) => CustomAppBar(
        logoAsset: logoAsset,
        onMenuPressed: () => Scaffold.of(context).openDrawer(),
        onNotificationPressed: onNotificationPressed,
        onProfilePressed: onProfilePressed,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
