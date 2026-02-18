import 'package:flutter/material.dart';
import 'package:rizesterapp/screens/product_category_screen.dart';
import 'package:rizesterapp/screens/product_list_screen.dart';
import 'package:rizesterapp/screens/advertise_list_screen.dart';
import 'package:rizesterapp/screens/create_ad_screen.dart';
import 'package:rizesterapp/screens/create_product_screen.dart';
import 'package:rizesterapp/screens/setting_screen.dart';
import 'package:rizesterapp/screens/update_product_screen.dart';
import '../utils/responsive_config.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_drawer.dart';
import 'dashboard_screen.dart';
import 'order_list_screen.dart';
import 'order_now_screen.dart';


class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const DashboardScreen(),
    const ProductListScreen(),
    const ProductCategoryScreen(),
    const OrderNowScreen(),
    const OrderListScreen(),
    const NotificationScreen(),
    const AdvertiseListScreen(),
    const SettingScreen(),
    const CreateAdScreen(),
    const CreateProductScreen(),
    const UpdateProductScreen(productData: {},),


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
