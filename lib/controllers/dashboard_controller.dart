import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rizesterapp/screens/Product/list_product_screen.dart';
import 'package:rizesterapp/screens/Advertise/list_ad_screen.dart';
import 'package:rizesterapp/screens/Advertise/create_ad_screen.dart';
import 'package:rizesterapp/screens/Product/create_product_screen.dart';
import 'package:rizesterapp/screens/Category/create_category_screen.dart';
import 'package:rizesterapp/screens/Profile/editprofile_screen.dart';
import 'package:rizesterapp/screens/Profile/changepassword_screen.dart';
import 'package:rizesterapp/screens/notification_screen.dart' as notification;
import 'package:rizesterapp/screens/Category/list_category_screen.dart';
import 'package:rizesterapp/screens/dashboard_screen.dart';
import 'package:rizesterapp/screens/Order/order_list_screen.dart';
import 'package:rizesterapp/screens/Order/order_now_screen.dart';

class DashboardController extends GetxController {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final selectedIndex = 0.obs;
  
  final dashboardItems = [
    {
      'title': 'Total Category',
      'value': '10',
      'icon': Icons.category,
    },
    {
      'title': 'Total Products',
      'value': '25',
      'icon': Icons.shopping_bag,
    },
    {
      'title': 'Total Orders',
      'value': '150',
      'icon': Icons.list_alt,
    },
    {
      'title': 'Pending Orders',
      'value': '5',
      'icon': Icons.pending_actions,
    },
    {
      'title': 'Completed Orders',
      'value': '145',
      'icon': Icons.check_circle,
    },
    {
      'title': 'Total Revenue',
      'value': '\$5,000',
      'icon': Icons.attach_money,
    },
    {
      'title': 'Active Users',
      'value': '50',
      'icon': Icons.people,
    },
    {
      'title': 'Notifications',
      'value': '12',
      'icon': Icons.notifications,
    },
  ].obs;
  
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
  
  void updateIndex(int index) {
    selectedIndex.value = index;
  }
}
