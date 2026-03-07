import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rizesterapp/screens/Order/product_details_screen.dart';
import '../../controllers/order_now_controller.dart';
import '../../utils/responsive_config.dart';
import '../../widgets/widgets.dart';
import 'package:rizesterapp/screens/main_screen.dart';
import '../notification_screen.dart' as notification;
import 'package:rizesterapp/screens/Profile/profile_screen.dart';

class OrderNowScreen extends StatefulWidget {
  const OrderNowScreen({super.key});

  @override
  State<OrderNowScreen> createState() => _OrderNowScreenState();
}

class _OrderNowScreenState extends State<OrderNowScreen> {

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OrderNowController());

    return CustomScrollWidget(
      children: [
        const ScreenTitle(title: 'Order Now'),

        Padding(
          padding: EdgeInsets.all(ResponsiveConfig.spacingMd(context)),
          child: Obx(() => controller.isLoading.value
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : controller.products.isEmpty
                  ? _buildEmptyState()
                  : GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),

            gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.80,
            ),

            itemCount: controller.products.length,

            itemBuilder: (context, index) {
              final product = controller.products[index];

              return ProductCard(
                product: product,
                onTap: () => _navigateToProductDetail(product),
              );
            },
          )),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {

    return CustomCard(
      padding: EdgeInsets.all(ResponsiveConfig.spacingXl(context)),

      child: CustomColumn(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [

          Icon(
            Icons.inventory_2_outlined,
            size: ResponsiveConfig.responsiveFont(context, 80),
            color: Colors.grey[400],
          ),

          CustomSpacer(height: ResponsiveConfig.spacingMd(context)),

          Text(
            'No Products Available',
            style: AppTextStyles.getHeading(context).copyWith(
              color: Colors.grey[600],
              fontWeight: FontWeight.w600,
            ),
          ),

          CustomSpacer(height: ResponsiveConfig.spacingSm(context)),

          Text(
            'No products found at the moment.\nPlease check back later.',
            textAlign: TextAlign.center,
            style: AppTextStyles.getBody(context).copyWith(
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToProductDetail(ProductItem product) {

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailScreen(
          product: product,
        ),
      ),
    );
  }
}

class ProductCard extends StatelessWidget {

  final ProductItem product;
  final VoidCallback onTap;

  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {

    final totalCost = product.weight * product.costPerGram;

    return InkWell(

      onTap: onTap,
      borderRadius: BorderRadius.circular(14),

      child: Container(

        padding: const EdgeInsets.all(12),

        decoration: BoxDecoration(

          color: Colors.white,
          borderRadius: BorderRadius.circular(14),

          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),

        child: Column(

          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            Expanded(
              child: ClipRRect(

                borderRadius: BorderRadius.circular(10),

                child: Image.network(
                  product.imageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
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

            const SizedBox(height: 8),

            Text(
              product.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,

              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              "${product.weight} g • ₹${product.costPerGram}/g",

              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),

            const SizedBox(height: 6),

            Row(

              mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children: [

                Text(
                  "₹${totalCost.toStringAsFixed(0)}",

                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),

                Container(

                  height: 28,
                  width: 28,

                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(8),
                  ),

                  child: const Icon(
                    Icons.arrow_forward,
                    size: 16,
                    color: Colors.white,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}