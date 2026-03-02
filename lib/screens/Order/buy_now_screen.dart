import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/buy_now_controller.dart';
import '../../utils/responsive_config.dart';
import '../../widgets/widgets.dart';

class BuyNowScreen extends StatelessWidget {
  final Map<String, dynamic> product;

  const BuyNowScreen({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BuyNowController());
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollWidget(
        children: [
          const ScreenTitle(title: 'Buy Now'),
          Padding(
            padding: EdgeInsets.all(ResponsiveConfig.spacingMd(context)),
            child: CustomColumn(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomCard(
                  child: _buildProductImages(context),
                  margin: EdgeInsets.zero,
                ),
                CustomSpacer(height: ResponsiveConfig.spacingMd(context)),
                CustomCard(
                  child: _buildProductDetails(context),
                  margin: EdgeInsets.zero,
                ),
                CustomSpacer(height: ResponsiveConfig.spacingMd(context)),
                CustomCard(
                  child: _buildCustomerInformation(context, controller),
                  margin: EdgeInsets.zero,
                ),
                CustomSpacer(height: ResponsiveConfig.spacingMd(context)),
                Obx(
                  () => CustomCard(
                    child: _buildPricingSection(context, controller),
                    margin: EdgeInsets.zero,
                  ),
                ),
                CustomSpacer(height: ResponsiveConfig.spacingLg(context)),
                CustomButton(
                  text: 'Create Order',
                  onPressed: controller.createOrder,
                  backgroundColor: Colors.black,
                  textColor: Colors.white,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductImages(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(ResponsiveConfig.responsivePadding(context, 20)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(ResponsiveConfig.responsiveRadius(context, 16)),
        border: Border.all(
          color: Colors.black,
          width: 0.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: CustomColumn(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveConfig.responsivePadding(context, 12),
                  vertical: ResponsiveConfig.responsivePadding(context, 8),
                ),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(ResponsiveConfig.responsiveRadius(context, 8)),
                ),
                child: Text(
                  'Product Images',
                  style: AppTextStyles.getBody(context).copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          CustomSpacer(height: ResponsiveConfig.spacingMd(context)),
          Row(
            children: [
              _buildImageContainer(context, 'assets/headphones.jpg'),
              CustomSpacer(width: ResponsiveConfig.spacingMd(context)),
              _buildImageContainer(context, 'assets/phone.jpg'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildImageContainer(BuildContext context, String imagePath) {
    return Container(
      width: ResponsiveConfig.responsiveWidth(context, 100),
      height: ResponsiveConfig.responsiveHeight(context, 100),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(ResponsiveConfig.responsiveRadius(context, 12)),
        color: Colors.grey[100],
        border: Border.all(
          color: Colors.black,
          width: 0.2,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(ResponsiveConfig.responsiveRadius(context, 12)),
        child: Image.asset(
          imagePath,
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
    );
  }

  Widget _buildProductDetails(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(ResponsiveConfig.responsivePadding(context, 20)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(ResponsiveConfig.responsiveRadius(context, 16)),
        border: Border.all(
          color: Colors.black,
          width: 0.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: CustomColumn(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveConfig.responsivePadding(context, 12),
              vertical: ResponsiveConfig.responsivePadding(context, 8),
            ),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(ResponsiveConfig.responsiveRadius(context, 8)),
            ),
            child: Text(
              'Product Details',
              style: AppTextStyles.getBody(context).copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          CustomSpacer(height: ResponsiveConfig.spacingMd(context)),
          _buildProductDetailRow(context, 'Product Name', 'Wireless Bluetooth Headphones', Icons.inventory_2),
          CustomSpacer(height: ResponsiveConfig.spacingSm(context)),
          _buildProductDetailRow(context, 'Category', 'Electronics', Icons.category),
          CustomSpacer(height: ResponsiveConfig.spacingSm(context)),
          _buildProductDetailRow(context, 'Weight', '250 grams', Icons.scale),
          CustomSpacer(height: ResponsiveConfig.spacingSm(context)),
          _buildProductDetailRow(context, 'Cost per Gram', '₹4.5', Icons.currency_rupee),
          CustomSpacer(height: ResponsiveConfig.spacingSm(context)),
          _buildProductDetailRow(context, 'Total Cost', '₹1125', Icons.calculate, isTotal: true),
        ],
      ),
    );
  }

  Widget _buildProductDetailRow(BuildContext context, String label, String value, IconData icon, {bool isTotal = false}) {
    return Container(
      padding: EdgeInsets.all(ResponsiveConfig.spacingMd(context)),
      decoration: BoxDecoration(
        color: isTotal ? Colors.green[50] : Colors.grey[50],
        borderRadius: BorderRadius.circular(ResponsiveConfig.responsiveRadius(context, 8)),
        border: Border.all(
          color: isTotal ? Colors.green[200]! : Colors.grey[200]!,
          width: 1,
        ),
      ),
      child: CustomRow(
        children: [
          Container(
            width: ResponsiveConfig.responsiveWidth(context, 40),
            height: ResponsiveConfig.responsiveHeight(context, 40),
            decoration: BoxDecoration(
              color: isTotal ? Colors.green : Colors.grey[600],
              borderRadius: BorderRadius.circular(ResponsiveConfig.responsiveRadius(context, 8)),
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: ResponsiveConfig.responsiveFont(context, 20),
            ),
          ),
          CustomSpacer(width: ResponsiveConfig.spacingMd(context)),
          Expanded(
            child: CustomColumn(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyles.getSmall(context).copyWith(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  value,
                  style: AppTextStyles.getBody(context).copyWith(
                    fontWeight: FontWeight.bold,
                    color: isTotal ? Colors.green[700] : Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: ResponsiveConfig.spacingXs(context)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: ResponsiveConfig.responsiveWidth(context, 120),
            child: CustomText(
              label,
              fontSize: ResponsiveConfig.responsiveFont(context, 14),
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          Expanded(
            child: CustomText(
              value,
              fontSize: ResponsiveConfig.responsiveFont(context, 14),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerInformation(BuildContext context, BuyNowController controller) {
    return Container(
      padding: EdgeInsets.all(ResponsiveConfig.responsivePadding(context, 16)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(ResponsiveConfig.responsiveRadius(context, 12)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            'Customer Information',
            fontSize: ResponsiveConfig.responsiveFont(context, 18),
            fontWeight: FontWeight.bold,
          ),
          SizedBox(height: ResponsiveConfig.spacingMd(context)),
          
          CustomTextField(
            controller: controller.customerNameController,
            hintText: 'Enter Customer Name',
            labelText: 'Customer Name',
          ),
          SizedBox(height: ResponsiveConfig.spacingSm(context)),
          
          CustomTextField(
            controller: controller.customerEmailController,
            hintText: 'Enter Customer Email',
            labelText: 'Customer Email',
            keyboardType: TextInputType.emailAddress,
          ),
          SizedBox(height: ResponsiveConfig.spacingSm(context)),
          
          CustomTextField(
            controller: controller.customerAddressController,
            hintText: 'Enter Customer Address',
            labelText: 'Customer Address',
            maxLines: 3,
          ),
          SizedBox(height: ResponsiveConfig.spacingSm(context)),
          
          CustomTextField(
            controller: controller.phoneNumberController,
            hintText: 'Enter phone number',
            labelText: 'Phone Number',
            keyboardType: TextInputType.phone,
          ),
          SizedBox(height: ResponsiveConfig.spacingSm(context)),
          
          CustomTextField(
            controller: controller.quantityController,
            hintText: 'Enter quantity',
            labelText: 'Quantity',
            keyboardType: TextInputType.number,
          ),
        ],
      ),
    );
  }

  Widget _buildPricingSection(BuildContext context, BuyNowController controller) {
    return Container(
      padding: EdgeInsets.all(ResponsiveConfig.responsivePadding(context, 16)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(ResponsiveConfig.responsiveRadius(context, 12)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            'Pricing Details',
            fontSize: ResponsiveConfig.responsiveFont(context, 18),
            fontWeight: FontWeight.bold,
          ),
          SizedBox(height: ResponsiveConfig.spacingMd(context)),
          
          _buildPricingRow(context, 'Selling Price(RS)', controller.sellingPrice.value.toStringAsFixed(2)),
          _buildPricingRow(context, 'Sub Total Price(RS)', controller.subTotal.toStringAsFixed(2)),
          _buildPricingRow(context, 'Shipping Cost(RS)', controller.shippingCost.value.toStringAsFixed(2)),
          _buildPricingRow(context, 'Total Price(RS)', controller.totalPrice.toStringAsFixed(2)),
          _buildPricingRow(context, 'Sold Price(RS)', controller.totalPrice.toStringAsFixed(2)),
        ],
      ),
    );
  }

  Widget _buildPricingRow(BuildContext context, String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: ResponsiveConfig.spacingXs(context)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText(
            label,
            fontSize: ResponsiveConfig.responsiveFont(context, 14),
            fontWeight: FontWeight.w500,
          ),
          CustomText(
            value,
            fontSize: ResponsiveConfig.responsiveFont(context, 14),
            fontWeight: FontWeight.bold,
          ),
        ],
      ),
    );
  }
}
