import 'package:flutter/material.dart';

class ResponsiveConfig {
  static const double baseWidth = 375.0; // iPhone X base width
  static const double baseHeight = 812.0; // iPhone X base height

  static double getWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double getHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static double getScaleWidth(BuildContext context) {
    return getWidth(context) / baseWidth;
  }

  static double getScaleHeight(BuildContext context) {
    return getHeight(context) / baseHeight;
  }

  static double getScale(BuildContext context) {
    return (getScaleWidth(context) + getScaleHeight(context)) / 2;
  }

  // Responsive sizing methods
  static double responsiveWidth(BuildContext context, double size) {
    return size * getScaleWidth(context);
  }

  static double responsiveHeight(BuildContext context, double size) {
    return size * getScaleHeight(context);
  }

  static double responsiveFont(BuildContext context, double size) {
    return size * getScale(context);
  }

  static double responsiveRadius(BuildContext context, double radius) {
    return radius * getScale(context);
  }

  static double responsivePadding(BuildContext context, double padding) {
    return padding * getScale(context);
  }

  static double responsiveMargin(BuildContext context, double margin) {
    return margin * getScale(context);
  }

  // Screen size categories
  static bool isSmallScreen(BuildContext context) {
    return getWidth(context) < 360;
  }

  static bool isMediumScreen(BuildContext context) {
    return getWidth(context) >= 360 && getWidth(context) < 600;
  }

  static bool isLargeScreen(BuildContext context) {
    return getWidth(context) >= 600;
  }

  static bool isTablet(BuildContext context) {
    return getWidth(context) >= 768;
  }

  // Grid configurations
  static int getCrossAxisCount(BuildContext context) {
    final width = getWidth(context);
    if (width >= 1200) return 4;
    if (width >= 900) return 3;
    if (width >= 600) return 2;
    return 1;
  }

  static double getChildAspectRatio(BuildContext context) {
    final width = getWidth(context);
    if (width >= 600) return 1.2;
    return 1.0;
  }

  // Spacing constants
  static double spacing2xs(BuildContext context) => responsivePadding(context, 4);
  static double spacingXs(BuildContext context) => responsivePadding(context, 8);
  static double spacingSm(BuildContext context) => responsivePadding(context, 12);
  static double spacingMd(BuildContext context) => responsivePadding(context, 16);
  static double spacingLg(BuildContext context) => responsivePadding(context, 24);
  static double spacingXl(BuildContext context) => responsivePadding(context, 32);
  static double spacing2xl(BuildContext context) => responsivePadding(context, 48);
  static double spacingXxs(BuildContext context) => responsivePadding(context, 2);
}

class AppTextStyles {
  static TextStyle getHeading(BuildContext context, {
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
  }) {
    return TextStyle(
      fontSize: fontSize ?? ResponsiveConfig.responsiveFont(context, 24),
      fontWeight: fontWeight ?? FontWeight.bold,
      color: color ?? Colors.black,
    );
  }

  static TextStyle getSubheading(BuildContext context, {
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
  }) {
    return TextStyle(
      fontSize: fontSize ?? ResponsiveConfig.responsiveFont(context, 20),
      fontWeight: fontWeight ?? FontWeight.w600,
      color: color ?? Colors.black87,
    );
  }

  static TextStyle getBody(BuildContext context, {
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
  }) {
    return TextStyle(
      fontSize: fontSize ?? ResponsiveConfig.responsiveFont(context, 16),
      fontWeight: fontWeight ?? FontWeight.normal,
      color: color ?? Colors.black87,
    );
  }

  static TextStyle getCaption(BuildContext context, {
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
  }) {
    return TextStyle(
      fontSize: fontSize ?? ResponsiveConfig.responsiveFont(context, 14),
      fontWeight: fontWeight ?? FontWeight.normal,
      color: color ?? Colors.grey,
    );
  }

  static TextStyle getSmall(BuildContext context, {
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
  }) {
    return TextStyle(
      fontSize: fontSize ?? ResponsiveConfig.responsiveFont(context, 12),
      fontWeight: fontWeight ?? FontWeight.normal,
      color: color ?? Colors.grey,
    );
  }
}
