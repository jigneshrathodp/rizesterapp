import 'package:flutter/material.dart';
import 'package:rizesterapp/screens/Order/product_details_screen.dart';
import '../../utils/responsive_config.dart';
import '../../widgets/widgets.dart';
import '../../widgets/widgets.dart';
import 'package:get/get.dart';
import 'package:rizesterapp/screens/main_screen.dart';
import '../notification_screen.dart' as notification;
import 'package:rizesterapp/screens/Profile/profile_screen.dart';

class OrderNowScreen extends StatefulWidget {
  final bool showAppBar;
  const OrderNowScreen({super.key, this.showAppBar = false});

  @override
  State<OrderNowScreen> createState() => _OrderNowScreenState();
}

class _OrderNowScreenState extends State<OrderNowScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<ProductItem> _products = [
    ProductItem(
      id: 1,
      name: 'Wireless Bluetooth Headphones',
      costPerGram: 4.5,
      weight: 250,
      imageUrl: 'assets/headphones.jpg',
    ),
    ProductItem(
      id: 2,
      name: 'Android Smartphone 128GB',
      costPerGram: 12,
      weight: 180,
      imageUrl: 'assets/phone.jpg',
    ),
    ProductItem(
      id: 3,
      name: 'Noise Cancelling Headphones',
      costPerGram: 10,
      weight: 280,
      imageUrl: 'assets/noise_headphones.jpg',
    ),
    ProductItem(
      id: 4,
      name: 'Noise Cancelling Headphones Pro',
      costPerGram: 5,
      weight: 220,
      imageUrl: 'assets/pro_headphones.jpg',
    ),
    ProductItem(
      id: 5,
      name: 'Smart Watch Ultra',
      costPerGram: 8,
      weight: 60,
      imageUrl: 'assets/watch.jpg',
    ),
    ProductItem(
      id: 6,
      name: 'Laptop Pro M2',
      costPerGram: 15,
      weight: 1500,
      imageUrl: 'assets/laptop.jpg',
    ),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: widget.showAppBar
          ? CustomAppBar(
              logoAsset: 'assets/black.png',
              onMenuPressed: () => _scaffoldKey.currentState?.openDrawer(),
              onNotificationPressed: () => Get.to(() => const notification.NotificationScreen()),
              onProfilePressed: () => Get.to(() => const ProfileScreen()),
            )
          : null,
      drawer: widget.showAppBar
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
          const ScreenTitle(title: 'Order Now'),
          Padding(
            padding: EdgeInsets.all(ResponsiveConfig.spacingMd(context)),
            child: CustomColumn(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomSpacer(height: 20),
                
                // Products list
                _products.isEmpty
                    ? _buildEmptyState()
                    : CustomColumn(
                        children: _products.map((product) {
                          return ProductCard(
                            product: product,
                            onTap: () => _navigateToProductDetail(product),
                          );
                        }).toList(),
                      ),
                
                CustomSpacer(height: 32),
              ],
            ),
          ),
        ],
      ),
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
        builder: (context) => ProductDetailScreen(product: product),
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
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: ResponsiveConfig.spacingMd(context)),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(ResponsiveConfig.responsiveRadius(context, 12)),
          border: Border.all(
            color: Colors.black,
            width: 0.2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(ResponsiveConfig.spacingMd(context)),
          child: CustomRow(
            children: [
              // Product image
              Container(
                width: ResponsiveConfig.responsiveWidth(context, 80),
                height: ResponsiveConfig.responsiveHeight(context, 80),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(ResponsiveConfig.responsiveRadius(context, 12)),
                  color: Colors.grey[100],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(ResponsiveConfig.responsiveRadius(context, 12)),
                  child: Image.asset(
                    product.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.image,
                        color: Colors.grey[400],
                        size: ResponsiveConfig.responsiveFont(context, 40),
                      );
                    },
                  ),
                ),
              ),

              CustomSpacer(width: ResponsiveConfig.spacingMd(context)),

              // Product info
              Expanded(
                child: CustomColumn(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: AppTextStyles.getSubheading(context).copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    CustomSpacer(height: ResponsiveConfig.spacingXs(context)),
                    
                    // Weight and Cost row
                    CustomRow(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: ResponsiveConfig.responsivePadding(context, 8),
                            vertical: ResponsiveConfig.responsivePadding(context, 4),
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '${product.weight}g',
                            style: AppTextStyles.getSmall(context).copyWith(
                              color: Colors.grey[700],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        CustomSpacer(width: ResponsiveConfig.spacingSm(context)),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: ResponsiveConfig.responsivePadding(context, 8),
                            vertical: ResponsiveConfig.responsivePadding(context, 4),
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '₹${product.costPerGram}/g',
                            style: AppTextStyles.getSmall(context).copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    CustomSpacer(height: ResponsiveConfig.spacingSm(context)),
                    
                    // Total cost
                    Text(
                      'Total: ₹${totalCost.toStringAsFixed(2)}',
                      style: AppTextStyles.getSubheading(context).copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.green[700],
                      ),
                    ),
                  ],
                ),
              ),

              // Arrow icon
              Container(
                width: ResponsiveConfig.responsiveWidth(context, 40),
                height: ResponsiveConfig.responsiveHeight(context, 40),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(ResponsiveConfig.responsiveRadius(context, 8)),
                ),
                child: Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                  size: ResponsiveConfig.responsiveFont(context, 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
