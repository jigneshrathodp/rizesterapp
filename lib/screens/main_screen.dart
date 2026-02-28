import 'package:flutter/material.dart';
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
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_drawer.dart';
import 'Category/list_category_screen.dart';
import 'dashboard_screen.dart';
import 'Order/order_list_screen.dart';
import 'Order/order_now_screen.dart';


class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const DashboardScreen(),//1
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


  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        logoAsset: 'assets/black.png',
        onMenuPressed: () => _scaffoldKey.currentState?.openDrawer(),
        onNotificationPressed: () {
          // Handle notification press
        },
        onProfilePressed: () {
          // Handle profile press
        },
      ),
      drawer: SizedBox(
        width: ResponsiveConfig.getWidth(context) * 0.6,
        child: CustomDrawer(
          selectedIndex: _selectedIndex,
          onItemTapped: _onItemTapped,
          logoAsset: 'assets/white.png',
        ),
      ),
      body: _screens[_selectedIndex],
    );
  }
}
