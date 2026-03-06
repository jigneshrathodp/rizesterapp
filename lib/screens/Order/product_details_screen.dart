import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils/responsive_config.dart';
import '../../widgets/widgets.dart';
import '../../controllers/order_now_controller.dart';
import 'buy_now_screen.dart';
import 'package:rizesterapp/screens/main_screen.dart';
import '../notification_screen.dart' as notification;
import 'package:rizesterapp/screens/Profile/profile_screen.dart';

class ProductDetailScreen extends StatelessWidget {
  final ProductItem product;
  final bool showAppBar;

  const ProductDetailScreen({
    super.key,
    required this.product,
    this.showAppBar = true,
  });

  @override
  Widget build(BuildContext context) {
    final totalCost = product.weight * product.costPerGram;
    final controller = Get.put(OrderNowController());

    return Scaffold(
      key: controller.scaffoldKey,
      backgroundColor: Colors.grey.shade100,

      appBar: showAppBar
          ? CustomAppBar(
        logoAsset: 'assets/black.png',
        onMenuPressed: () => controller.scaffoldKey.currentState?.openDrawer(),
        onNotificationPressed: () =>
            Get.to(() => const notification.NotificationScreen()),
        onProfilePressed: () => Get.to(() => const ProfileScreen()),
      )
          : null,

      drawer: showAppBar
          ? SizedBox(
        width: ResponsiveConfig.getWidth(context) * 0.6,
        child: CustomDrawer(
          selectedIndex: 1,
          onItemTapped: (index) {
            Navigator.pop(context);
            Get.offAll(() => const MainScreen());

            Future.microtask(() {
              final main = Get.find<MainScreenController>();
              main.onItemTapped(index);
            });
          },
          logoAsset: 'assets/white.png',
        ),
      )
          : null,

      body: CustomScrollWidget(
        children: [
          const ScreenTitle(title: 'Product Detail'),

          Padding(
            padding: const EdgeInsets.all(16),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                const SizedBox(height: 10),

                /// PRODUCT IMAGE
                Container(
                  width: double.infinity,
                  height: 260,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 12,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),

                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: Image.network(
                      product.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[200],
                          child: const Icon(
                            Icons.image,
                            color: Colors.grey,
                            size: 50,
                          ),
                        );
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                /// PRODUCT NAME
                Text(
                  product.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                /// PRODUCT INFO
                Row(
                  children: [

                    _infoChip("${product.weight} g"),

                    const SizedBox(width: 8),

                    _infoChip("₹${product.costPerGram}/g"),
                  ],
                ),

                const SizedBox(height: 20),

                /// PRICE CARD
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),

                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      )
                    ],
                  ),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      const Text(
                        "Total Price",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),

                      const SizedBox(height: 5),

                      Text(
                        "₹${totalCost.toStringAsFixed(0)}",
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                /// BUY BUTTON
                SizedBox(
                  width: double.infinity,
                  height: 50,

                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),

                    onPressed: () {

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BuyNowScreen(
                            product: {
                              'id': product.id,
                              'name': product.name,
                              'category': product.category,
                              'weight': product.weight,
                              'costPerGram': product.costPerGram,
                              'imageUrl': product.imageUrl,
                            },
                            showAppBar: showAppBar,
                          ),
                        ),
                      );
                    },

                    child: const Text(
                      "Buy Now",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 13),
      ),
    );
  }
}