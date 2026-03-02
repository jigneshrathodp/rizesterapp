import 'package:flutter/material.dart';
import '../../utils/responsive_config.dart';
import '../../widgets/widgets.dart';
import 'buy_now_screen.dart';

class OrderNowScreen extends StatefulWidget {
  const OrderNowScreen({super.key});

  @override
  State<OrderNowScreen> createState() => _OrderNowScreenState();
}

class _OrderNowScreenState extends State<OrderNowScreen> {
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollWidget(
        children: [
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
    return GestureDetector(
      onTap: onTap,
      child: CustomCard(
        margin: EdgeInsets.only(bottom: ResponsiveConfig.spacingMd(context)),
        padding: EdgeInsets.all(ResponsiveConfig.spacingMd(context)),
        child: CustomRow(
          children: [
            // Product image
            Container(
              width: ResponsiveConfig.responsiveWidth(context, 80),
              height: ResponsiveConfig.responsiveHeight(context, 80),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey[100],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  product.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      Icons.image,
                      color: Colors.grey[400],
                      size: ResponsiveConfig.responsiveFont(context, 32),
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
                      color: Colors.black87,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  CustomSpacer(height: ResponsiveConfig.spacingSm(context)),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: ResponsiveConfig.responsivePadding(context, 12),
                      vertical: ResponsiveConfig.responsivePadding(context, 6),
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.green[200]!),
                    ),
                    child: Text(
                      'Cost per Gram: ₹${product.costPerGram}',
                      style: AppTextStyles.getBody(context).copyWith(
                        color: Colors.green[700],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Arrow icon
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey[400],
              size: ResponsiveConfig.responsiveFont(context, 20),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductDetailScreen extends StatelessWidget {
  final ProductItem product;

  const ProductDetailScreen({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    final totalCost = product.weight * product.costPerGram;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: 'Product Detail',
        onBackPressed: () => Navigator.pop(context),
        showNotifications: false,
        showProfile: false,
      ),
      body: CustomScrollWidget(
        children: [
          Padding(
            padding: EdgeInsets.all(ResponsiveConfig.spacingMd(context)),
            child: CustomColumn(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomSpacer(height: 20),
                
                // Product image
                Center(
                  child: Container(
                    width: ResponsiveConfig.responsiveWidth(context, 200),
                    height: ResponsiveConfig.responsiveHeight(context, 200),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.grey[100],
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(
                        product.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.image,
                            color: Colors.grey[400],
                            size: ResponsiveConfig.responsiveFont(context, 60),
                          );
                        },
                      ),
                    ),
                  ),
                ),

                CustomSpacer(height: ResponsiveConfig.spacingXl(context)),

                // Product name
                Text(
                  product.name,
                  style: AppTextStyles.getHeading(context).copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),

                CustomSpacer(height: ResponsiveConfig.spacingXl(context)),

                // Details card
                CustomCard(
                  backgroundColor: Colors.grey[50],
                  padding: EdgeInsets.all(ResponsiveConfig.spacingMd(context)),
                  child: CustomColumn(
                    children: [
                      _buildDetailRow(
                        context,
                        "Weight Per Gram:",
                        product.weight.toString(),
                      ),
                      CustomSpacer(height: ResponsiveConfig.spacingMd(context)),
                      _buildDetailRow(
                        context,
                        "Cost Per Gram:",
                        "₹${product.costPerGram}",
                      ),
                      CustomSpacer(height: ResponsiveConfig.spacingMd(context)),
                      _buildDetailRow(
                        context,
                        "Total Cost:",
                        "₹${totalCost.toStringAsFixed(2)}",
                        isTotal: true,
                      ),
                    ],
                  ),
                ),

                CustomSpacer(height: ResponsiveConfig.spacingXl(context)),

                // Buy Now button
                CustomButton(
                  text: "Buy Now",
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BuyNowScreen(
                          product: {
                            'id': product.id,
                            'name': product.name,
                            'category': 'Electronics',
                            'weight': product.weight,
                            'costPerGram': product.costPerGram,
                            'imageUrl': product.imageUrl,
                          },
                        ),
                      ),
                    );
                  },
                  backgroundColor: Colors.black,
                  textColor: Colors.white,
                  fontSize: ResponsiveConfig.responsiveFont(context, 18),
                  fontWeight: FontWeight.bold,
                  height: ResponsiveConfig.responsiveHeight(context, 60),
                ),

                CustomSpacer(height: ResponsiveConfig.spacingMd(context)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context,
    String label,
    String value, {
    bool isTotal = false,
  }) {
    return CustomRow(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTextStyles.getBody(context).copyWith(
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: AppTextStyles.getSubheading(context).copyWith(
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
            color: isTotal ? Colors.green[700] : Colors.black87,
            fontSize: isTotal 
                ? ResponsiveConfig.responsiveFont(context, 20)
                : ResponsiveConfig.responsiveFont(context, 16),
          ),
        ),
      ],
    );
  }
}

class ProductItem {
  final int id;
  final String name;
  final double costPerGram;
  final int weight;
  final String imageUrl;

  ProductItem({
    required this.id,
    required this.name,
    required this.costPerGram,
    required this.weight,
    required this.imageUrl,
  });
}
