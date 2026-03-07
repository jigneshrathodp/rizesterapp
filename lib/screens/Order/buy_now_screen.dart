import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/buy_now_controller.dart';
import '../../widgets/widgets.dart';
import 'package:rizesterapp/screens/main_screen.dart';
import '../notification_screen.dart' as notification;
import 'package:rizesterapp/screens/Profile/profile_screen.dart';
import '../../utils/responsive_config.dart';

class BuyNowScreen extends StatelessWidget {
  final Map<String, dynamic> product;
  final bool showAppBar;

  const BuyNowScreen({
    super.key,
    required this.product,
    this.showAppBar = true,
  });

  @override
  Widget build(BuildContext context) {

    final controller = Get.put(BuyNowController());
    
    // Set product data in controller
    controller.setProduct(product);

    final double totalCost =
        product['weight'] * product['costPerGram'];

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

          const ScreenTitle(title: "Checkout"),

          Padding(
            padding: const EdgeInsets.all(16),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// PRODUCT SUMMARY
                _productSummary(context, totalCost),

                const SizedBox(height: 20),

                /// CUSTOMER FORM
                _customerForm(controller),

                const SizedBox(height: 20),

                /// PRICE DETAILS
                Obx(() => _priceSection(controller)),

                const SizedBox(height: 30),

                /// CREATE ORDER BUTTON
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: Obx(() => ElevatedButton(

                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),

                    onPressed: controller.isLoading.value ? null : controller.createOrder,

                    child: controller.isLoading.value
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Text(
                            "Create Order",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                  )),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// PRODUCT SUMMARY CARD
  Widget _productSummary(BuildContext context, double totalCost) {

    return Container(
      padding: const EdgeInsets.all(14),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
          )
        ],
      ),

      child: Row(
        children: [

          /// IMAGE
          ClipRRect(
            borderRadius: BorderRadius.circular(10),

            child: Image.network(
              product['imageUrl'],
              width: 70,
              height: 70,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 70,
                  height: 70,
                  color: Colors.grey[200],
                  child: const Icon(
                    Icons.image,
                    color: Colors.grey,
                    size: 30,
                  ),
                );
              },
            ),
          ),

          const SizedBox(width: 12),

          /// INFO
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [

                Text(
                  product['name'],
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  "Category: ${product['category']}",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),

                const SizedBox(height: 4),

                Row(
                  children: [

                    _chip("${product['weight']} g"),

                    const SizedBox(width: 6),

                    _chip("₹${product['costPerGram']}/g"),

                    const SizedBox(width: 6),

                    _chip("ID: ${product['id']}"),
                  ],
                ),

                const SizedBox(height: 6),

                Text(
                  "₹${totalCost.toStringAsFixed(0)}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.green,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  /// CHIP
  Widget _chip(String text) {

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),

      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(6),
      ),

      child: Text(
        text,
        style: const TextStyle(fontSize: 12),
      ),
    );
  }

  /// CUSTOMER FORM
  Widget _customerForm(BuyNowController controller) {

    return Container(
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
          )
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [

          const Text(
            "Customer Information",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),

          const SizedBox(height: 16),

          CustomTextField(
            controller: controller.customerNameController,
            labelText: "Customer Name",
            hintText: "Enter name",
          ),

          const SizedBox(height: 10),

          CustomTextField(
            controller: controller.customerEmailController,
            labelText: "Customer Email",
            hintText: "Enter email",
          ),

          const SizedBox(height: 10),

          CustomTextField(
            controller: controller.customerAddressController,
            labelText: "Address",
            hintText: "Enter address",
            maxLines: 3,
          ),

          const SizedBox(height: 10),

          CustomTextField(
            controller: controller.phoneNumberController,
            labelText: "Phone",
            hintText: "Enter phone number",
          ),

          const SizedBox(height: 10),

          CustomTextField(
            controller: controller.quantityController,
            labelText: "Quantity",
            hintText: "Enter quantity",
          ),
        ],
      ),
    );
  }

  /// PRICE SECTION
  Widget _priceSection(BuyNowController controller) {

    return Container(
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
          )
        ],
      ),

      child: Column(
        children: [

          _row("Selling Price", controller.sellingPrice.value),

          _row("Sub Total", controller.subTotal),

          _row("Shipping", controller.shippingCost.value),

          const Divider(),

          _row(
            "Total",
            controller.totalPrice,
            isTotal: true,
          ),
        ],
      ),
    );
  }

  Widget _row(String label, double value, {bool isTotal = false}) {

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,

        children: [

          Text(
            label,
            style: const TextStyle(fontSize: 14),
          ),

          Text(
            "₹${value.toStringAsFixed(2)}",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: isTotal ? 18 : 14,
              color: isTotal ? Colors.green : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}