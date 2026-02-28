import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rizesterapp/screens/Product/list_product_screen.dart';
import 'package:rizesterapp/screens/Advertise/list_ad_screen.dart';
import 'package:rizesterapp/screens/Advertise/create_ad_screen.dart';
import 'package:rizesterapp/screens/Product/create_product_screen.dart';
import 'package:rizesterapp/screens/setting_screen.dart';
import 'package:rizesterapp/screens/Product/update_product_screen.dart';
import 'package:rizesterapp/screens/Category/create_category_screen.dart';
import 'package:rizesterapp/screens/Category/update_category_screen.dart';
import 'package:rizesterapp/screens/Profile/editprofile_screen.dart';
import 'package:rizesterapp/screens/Profile/changepassword_screen.dart';
import 'package:rizesterapp/screens/Advertise/update_ads_screen.dart';
import 'package:rizesterapp/screens/notification_screen.dart' as notification;
import '../utils/responsive_config.dart';
import '../widgets/widgets.dart';
import 'Category/list_category_screen.dart';
import 'dashboard_screen.dart';
import 'Order/order_list_screen.dart';
import 'Order/order_now_screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MainScreenController());
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        logoAsset: 'assets/black.png',
        onMenuPressed: () => controller.scaffoldKey.currentState?.openDrawer(),
        onNotificationPressed: () {
          // Handle notification press
        },
        onProfilePressed: () {
          // Handle profile press
        },
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
      body: Obx(
        () => controller.screens[controller.selectedIndex.value],
      ),
    );
  }
}

class MainScreenController extends GetxController {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final selectedIndex = 0.obs;

  final List<Widget> screens = [
    const DashboardScreen(),//1
    const OrderNowScreen(),//1
    const ProductListScreen(),//2
    const CategoryListScreen(),//3
    const OrderListScreen(),//4
    const AdvertiseListScreen(),//5
    const notification.NotificationScreen(),//6
    const CreateAdScreen(),//7
    const CreateProductScreen(),//8
    const CreateCategoryScreen(),//9
    const EditProfileScreen(),//10
    const ChangePasswordScreen(),//11
  ];

  void onItemTapped(int index) {
    selectedIndex.value = index;
    Get.back();
  }
}
