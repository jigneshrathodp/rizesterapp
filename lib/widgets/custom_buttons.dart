import 'package:flutter/material.dart';
import '../utils/responsive_config.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final double? height;
  final double? fontSize;
  final FontWeight? fontWeight;
  final BorderRadius? borderRadius;
  final EdgeInsets? padding;
  final Widget? icon;
  final bool isLoading;
  final bool isDisabled;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.width,
    this.height,
    this.fontSize,
    this.fontWeight,
    this.borderRadius,
    this.padding,
    this.icon,
    this.isLoading = false,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    final buttonHeight = height ?? ResponsiveConfig.responsiveHeight(context, 55);
    final buttonWidth = width ?? double.infinity;
    final radius = borderRadius ?? BorderRadius.circular(ResponsiveConfig.responsiveRadius(context, 14));

    return SizedBox(
      width: buttonWidth,
      height: buttonHeight,
      child: ElevatedButton(
        onPressed: isDisabled || isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? Colors.white,
          foregroundColor: textColor ?? Colors.black,
          shape: RoundedRectangleBorder(borderRadius: radius),
          padding: padding ?? EdgeInsets.symmetric(
            horizontal: ResponsiveConfig.responsivePadding(context, 24),
            vertical: ResponsiveConfig.responsivePadding(context, 16),
          ),
          elevation: 2,
          shadowColor: Colors.black.withOpacity(0.1),
        ),
        child: isLoading
            ? SizedBox(
                width: ResponsiveConfig.responsiveWidth(context, 20),
                height: ResponsiveConfig.responsiveWidth(context, 20),
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    textColor ?? Colors.black,
                  ),
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    icon!,
                    SizedBox(width: ResponsiveConfig.spacingXs(context)),
                  ],
                  Flexible(
                    child: Text(
                      text,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: fontSize ?? ResponsiveConfig.responsiveFont(context, 18),
                        fontWeight: fontWeight ?? FontWeight.bold,
                        color: textColor ?? Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class CustomIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? iconColor;
  final double? size;
  final double? iconSize;
  final BorderRadius? borderRadius;
  final String? tooltip;

  const CustomIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.backgroundColor,
    this.iconColor,
    this.size,
    this.iconSize,
    this.borderRadius,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    final buttonSize = size ?? ResponsiveConfig.responsiveWidth(context, 40);
    final radius = borderRadius ?? BorderRadius.circular(ResponsiveConfig.responsiveRadius(context, 8));

    Widget button = Container(
      width: buttonSize,
      height: buttonSize,
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.black,
        borderRadius: radius,
      ),
      child: IconButton(
        icon: Icon(
          icon,
          color: iconColor ?? Colors.white,
          size: iconSize ?? ResponsiveConfig.responsiveFont(context, 20),
        ),
        onPressed: onPressed,
        padding: EdgeInsets.zero,
      ),
    );

    if (tooltip != null) {
      button = Tooltip(
        message: tooltip!,
        child: button,
      );
    }

    return button;
  }
}

class CustomTextButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? textColor;
  final double? fontSize;
  final FontWeight? fontWeight;
  final EdgeInsets? padding;
  final Widget? icon;

  const CustomTextButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.textColor,
    this.fontSize,
    this.fontWeight,
    this.padding,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding: padding ?? EdgeInsets.symmetric(
          horizontal: ResponsiveConfig.responsivePadding(context, 16),
          vertical: ResponsiveConfig.responsivePadding(context, 8),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            icon!,
            SizedBox(width: ResponsiveConfig.spacingXs(context)),
          ],
          Text(
            text,
            style: TextStyle(
              fontSize: fontSize ?? ResponsiveConfig.responsiveFont(context, 16),
              fontWeight: fontWeight ?? FontWeight.w500,
              color: textColor ?? Colors.blue,
            ),
          ),
        ],
      ),
    );
  }
}

class CustomOutlineButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? borderColor;
  final Color? textColor;
  final double? width;
  final double? height;
  final double? fontSize;
  final FontWeight? fontWeight;
  final BorderRadius? borderRadius;
  final EdgeInsets? padding;

  const CustomOutlineButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.borderColor,
    this.textColor,
    this.width,
    this.height,
    this.fontSize,
    this.fontWeight,
    this.borderRadius,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final buttonHeight = height ?? ResponsiveConfig.responsiveHeight(context, 55);
    final buttonWidth = width ?? double.infinity;
    final radius = borderRadius ?? BorderRadius.circular(ResponsiveConfig.responsiveRadius(context, 14));

    return SizedBox(
      width: buttonWidth,
      height: buttonHeight,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: borderColor ?? Colors.black),
          shape: RoundedRectangleBorder(borderRadius: radius),
          padding: padding ?? EdgeInsets.symmetric(
            horizontal: ResponsiveConfig.responsivePadding(context, 24),
            vertical: ResponsiveConfig.responsivePadding(context, 16),
          ),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: fontSize ?? ResponsiveConfig.responsiveFont(context, 18),
            fontWeight: fontWeight ?? FontWeight.bold,
            color: textColor ?? Colors.black,
          ),
        ),
      ),
    );
  }
}
