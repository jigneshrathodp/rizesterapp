import 'package:flutter/material.dart';
import '../utils/responsive_config.dart';

class CustomCard extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;
  final Color? shadowColor;
  final double? elevation;
  final double? width;
  final double? height;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final BorderRadius? borderRadius;
  final Border? border;
  final VoidCallback? onTap;
  final bool isClickable;

  const CustomCard({
    super.key,
    required this.child,
    this.backgroundColor,
    this.shadowColor,
    this.elevation,
    this.width,
    this.height,
    this.margin,
    this.padding,
    this.borderRadius,
    this.border,
    this.onTap,
    this.isClickable = false,
  });

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? BorderRadius.circular(ResponsiveConfig.responsiveRadius(context, 12));
    final cardMargin = margin ?? EdgeInsets.all(ResponsiveConfig.spacingSm(context));
    final cardPadding = padding ?? EdgeInsets.all(ResponsiveConfig.spacingMd(context));

    Widget card = Container(
      width: width,
      height: height,
      margin: cardMargin,
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white,
        borderRadius: radius,
        border: border,
        boxShadow: [
          BoxShadow(
            color: shadowColor ?? Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: elevation ?? 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: cardPadding,
        child: child,
      ),
    );

    if (isClickable || onTap != null) {
      card = GestureDetector(
        onTap: onTap,
        child: card,
      );
    }

    return card;
  }
}

class DashboardCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color? backgroundColor;
  final Color? iconColor;
  final Color? titleColor;
  final Color? valueColor;
  final VoidCallback? onTap;

  const DashboardCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    this.backgroundColor,
    this.iconColor,
    this.titleColor,
    this.valueColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      onTap: onTap,
      isClickable: onTap != null,
      padding: EdgeInsets.all(ResponsiveConfig.spacingMd(context)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: AppTextStyles.getCaption(context).copyWith(
                    color: titleColor ?? Colors.grey,
                    fontWeight: FontWeight.normal, // Changed from FontWeight.w500 to normal
                  ),
                ),
                SizedBox(height: ResponsiveConfig.spacingXs(context)),
                Text(
                  value,
                  style: AppTextStyles.getHeading(context).copyWith(
                    fontSize: ResponsiveConfig.responsiveFont(context, 24),
                    color: valueColor ?? Colors.black,
                    fontWeight: FontWeight.normal, // Changed from default bold to normal
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: ResponsiveConfig.responsiveWidth(context, 40),
            height: ResponsiveConfig.responsiveWidth(context, 40),
            decoration: BoxDecoration(
              color: iconColor ?? Colors.black,
              borderRadius: BorderRadius.circular(ResponsiveConfig.responsiveRadius(context, 8)),
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: ResponsiveConfig.responsiveFont(context, 20),
            ),
          ),
        ],
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final String name;
  final String category;
  final String sku;
  final String price;
  final String? imageUrl;
  final String status;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const ProductCard({
    super.key,
    required this.name,
    required this.category,
    required this.sku,
    required this.price,
    this.imageUrl,
    this.status = 'Active',
    this.onTap,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      onTap: onTap,
      isClickable: onTap != null,
      margin: EdgeInsets.symmetric(
        horizontal: ResponsiveConfig.spacingSm(context),
        vertical: ResponsiveConfig.spacingXs(context),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product image or placeholder
          Container(
            width: double.infinity,
            height: ResponsiveConfig.responsiveHeight(context, 120),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(ResponsiveConfig.responsiveRadius(context, 8)),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(ResponsiveConfig.responsiveRadius(context, 8)),
              child: imageUrl != null && imageUrl!.startsWith('assets')
                  ? Image.asset(
                      imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return _buildImagePlaceholder(context);
                      },
                    )
                  : _buildImagePlaceholder(context),
            ),
          ),
          SizedBox(height: ResponsiveConfig.spacingSm(context)),
          
          // Product info
          Text(
            name,
            style: AppTextStyles.getBody(context).copyWith(
              fontWeight: FontWeight.w600,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: ResponsiveConfig.spacingXs(context)),
          
          Row(
            children: [
              Expanded(
                child: Text(
                  category,
                  style: AppTextStyles.getCaption(context),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveConfig.spacingXs(context),
                  vertical: ResponsiveConfig.spacingXxs(context),
                ),
                decoration: BoxDecoration(
                  color: status == 'Active' ? Colors.green : Colors.grey,
                  borderRadius: BorderRadius.circular(ResponsiveConfig.responsiveRadius(context, 4)),
                ),
                child: Text(
                  status,
                  style: AppTextStyles.getSmall(context).copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: ResponsiveConfig.spacingXs(context)),
          
          Text(
            'SKU: $sku',
            style: AppTextStyles.getSmall(context),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: ResponsiveConfig.spacingSm(context)),
          
          // Price and status row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                price,
                style: AppTextStyles.getSubheading(context).copyWith(
                  color: Colors.green[700],
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveConfig.spacingXs(context),
                  vertical: ResponsiveConfig.spacing2xs(context),
                ),
                decoration: BoxDecoration(
                  color: status == 'Active' ? Colors.green[100] : Colors.red[100],
                  borderRadius: BorderRadius.circular(ResponsiveConfig.responsiveRadius(context, 12)),
                ),
                child: Text(
                  status,
                  style: AppTextStyles.getSmall(context).copyWith(
                    color: status == 'Active' ? Colors.green[700] : Colors.red[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          
          // Action buttons
          if (onEdit != null || onDelete != null) ...[
            SizedBox(height: ResponsiveConfig.spacingSm(context)),
            Row(
              children: [
                if (onEdit != null)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: onEdit!,
                      child: Text(
                        'Edit',
                        style: TextStyle(
                          fontSize: ResponsiveConfig.responsiveFont(context, 14),
                        ),
                      ),
                    ),
                  ),
                if (onEdit != null && onDelete != null)
                  SizedBox(width: ResponsiveConfig.spacingSm(context)),
                if (onDelete != null)
                  Expanded(
                    child: ElevatedButton(
                      onPressed: onDelete!,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                      child: Text(
                        'Delete',
                        style: TextStyle(
                          fontSize: ResponsiveConfig.responsiveFont(context, 14),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildImagePlaceholder(BuildContext context) {
    return Center(
      child: Icon(
        Icons.image,
        size: ResponsiveConfig.responsiveFont(context, 40),
        color: Colors.grey[400],
      ),
    );
  }
}

class StatusCard extends StatelessWidget {
  final String title;
  final String value;
  final Color statusColor;
  final IconData? icon;

  const StatusCard({
    super.key,
    required this.title,
    required this.value,
    required this.statusColor,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(ResponsiveConfig.spacingMd(context)),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(ResponsiveConfig.responsiveRadius(context, 12)),
        border: Border.all(
          color: statusColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              color: statusColor,
              size: ResponsiveConfig.responsiveFont(context, 24),
            ),
            SizedBox(width: ResponsiveConfig.spacingSm(context)),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.getCaption(context).copyWith(
                    color: statusColor,
                  ),
                ),
                SizedBox(height: ResponsiveConfig.spacing2xs(context)),
                Text(
                  value,
                  style: AppTextStyles.getBody(context).copyWith(
                    color: statusColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
