import 'package:flutter/material.dart';

import '../../utils/responsive_config.dart';
import '../../widgets/custom_buttons.dart';
import '../../widgets/custom_layouts.dart';
import '../../widgets/screen_title.dart';
import 'buy_now_screen.dart';

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
      body: CustomScrollWidget(
        children: [
          const ScreenTitle(title: 'Product Detail'),
          Padding(
            padding: EdgeInsets.all(ResponsiveConfig.spacingMd(context)),
            child: CustomColumn(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomSpacer(height: 20),

                // Product image with better design
                Center(
                  child: Container(
                    width: ResponsiveConfig.responsiveWidth(context, 200),
                    height: ResponsiveConfig.responsiveHeight(context, 180),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(ResponsiveConfig.responsiveRadius(context, 20)),
                      color: Colors.grey[100],
                      border: Border.all(
                        color: Colors.black,
                        width: 0.2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(ResponsiveConfig.responsiveRadius(context, 20)),
                      child: Image.asset(
                        product.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.image,
                            color: Colors.grey[400],
                            size: ResponsiveConfig.responsiveFont(context, 80),
                          );
                        },
                      ),
                    ),
                  ),
                ),

                CustomSpacer(height: ResponsiveConfig.spacingXl(context)),

                // Product name with better styling
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(ResponsiveConfig.spacingMd(context)),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(ResponsiveConfig.responsiveRadius(context, 12)),
                    border: Border.all(
                      color: Colors.black,
                      width: 0.2,
                    ),
                  ),
                  child: Text(
                    product.name,
                    style: AppTextStyles.getHeading(context).copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                CustomSpacer(height: ResponsiveConfig.spacingXl(context)),

                // Details cards with professional design
                CustomColumn(
                  children: [
                    _buildDetailCard(
                      context,
                      "Weight",
                      "${product.weight} grams",
                      Icons.scale,
                      Colors.blue,
                    ),
                    CustomSpacer(height: ResponsiveConfig.spacingMd(context)),
                    _buildDetailCard(
                      context,
                      "Cost per Gram",
                      "₹${product.costPerGram}",
                      Icons.currency_rupee,
                      Colors.green,
                    ),
                    CustomSpacer(height: ResponsiveConfig.spacingMd(context)),
                    _buildDetailCard(
                      context,
                      "Total Cost",
                      "₹${totalCost.toStringAsFixed(2)}",
                      Icons.calculate,
                      Colors.orange,
                      isTotal: true,
                    ),
                  ],
                ),

                CustomSpacer(height: ResponsiveConfig.spacingXl(context)),

                // Buy Now button with professional design
                CustomButton(
                  text: 'Buy Now',
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
                ),

                CustomSpacer(height: ResponsiveConfig.spacingMd(context)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailCard(
      BuildContext context,
      String label,
      String value,
      IconData icon,
      Color color, {
        bool isTotal = false,
      }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(ResponsiveConfig.spacingMd(context)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(ResponsiveConfig.responsiveRadius(context, 12)),
        border: Border.all(
          color: isTotal ? color : color.withOpacity(0.3),
          width: isTotal ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: CustomRow(
        children: [
          Container(
            width: ResponsiveConfig.responsiveWidth(context, 50),
            height: ResponsiveConfig.responsiveHeight(context, 50),
            decoration: BoxDecoration(
              color: isTotal ? color : color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(ResponsiveConfig.responsiveRadius(context, 10)),
            ),
            child: Icon(
              icon,
              color: isTotal ? Colors.white : color,
              size: ResponsiveConfig.responsiveFont(context, 24),
            ),
          ),
          CustomSpacer(width: ResponsiveConfig.spacingMd(context)),
          Expanded(
            child: CustomColumn(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyles.getBody(context).copyWith(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                CustomSpacer(height: ResponsiveConfig.spacing2xs(context)),
                Text(
                  value,
                  style: AppTextStyles.getSubheading(context).copyWith(
                    fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
                    color: isTotal ? color : Colors.black,
                    fontSize: isTotal
                        ? ResponsiveConfig.responsiveFont(context, 20)
                        : ResponsiveConfig.responsiveFont(context, 18),
                  ),
                ),
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
