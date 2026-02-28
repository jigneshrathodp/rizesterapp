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
    
    return CustomScaffold(
      appBar: CustomAppBar(
        title: 'Buy Now',
        onBackPressed: () => Get.back(),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(ResponsiveConfig.responsivePadding(context, 16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Images Section
            _buildProductImages(context),
            SizedBox(height: ResponsiveConfig.spacingMd(context)),
            
            // Product Details Section
            _buildProductDetails(context),
            SizedBox(height: ResponsiveConfig.spacingMd(context)),
            
            // Customer Information Section
            _buildCustomerInformation(context, controller),
            SizedBox(height: ResponsiveConfig.spacingMd(context)),
            
            // Pricing Section
            Obx(() => _buildPricingSection(context, controller)),
            SizedBox(height: ResponsiveConfig.spacingLg(context)),
            
            // Create Order Button
            CustomButton(
              text: 'Create Order',
              onPressed: controller.createOrder,
              backgroundColor: Colors.green,
              textColor: Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductImages(BuildContext context) {
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
            'Product Image',
            fontSize: ResponsiveConfig.responsiveFont(context, 16),
            fontWeight: FontWeight.bold,
          ),
          SizedBox(height: ResponsiveConfig.spacingSm(context)),
          Row(
            children: [
              Container(
                width: ResponsiveConfig.responsiveWidth(context, 80),
                height: ResponsiveConfig.responsiveWidth(context, 80),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.image,
                  color: Colors.grey[600],
                  size: ResponsiveConfig.responsiveFont(context, 32),
                ),
              ),
              SizedBox(width: ResponsiveConfig.spacingSm(context)),
              Container(
                width: ResponsiveConfig.responsiveWidth(context, 80),
                height: ResponsiveConfig.responsiveWidth(context, 80),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.image,
                  color: Colors.grey[600],
                  size: ResponsiveConfig.responsiveFont(context, 32),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProductDetails(BuildContext context) {
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
          _buildDetailRow(context, 'Product Name', 'Wireless Bluetooth Headphones'),
          _buildDetailRow(context, 'Category', 'Electronics'),
          _buildDetailRow(context, 'Weight In Gram', '250'),
          _buildDetailRow(context, 'Cost Per Gram(RS)', '4.5'),
          _buildDetailRow(context, 'Total Cost(RS)', '1125'),
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
