import 'dart:ui';
import 'package:flutter/material.dart';
import '../utils/responsive_config.dart';

class CustomTextField extends StatelessWidget {
  final String? labelText;
  final String? hintText;
  final TextEditingController? controller;
  final bool obscureText;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onTap;
  final FormFieldValidator<String>? validator;
  final bool readOnly;
  final int maxLines;
  final int? maxLength;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Color? fillColor;
  final Color? textColor;
  final Color? hintColor;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final double? fontSize;
  final FontWeight? fontWeight;
  final BorderRadius? borderRadius;
  final EdgeInsets? contentPadding;
  final bool autofocus;
  final FocusNode? focusNode;

  const CustomTextField({
    super.key,
    this.labelText,
    this.hintText,
    this.controller,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.validator,
    this.readOnly = false,
    this.maxLines = 1,
    this.maxLength,
    this.prefixIcon,
    this.suffixIcon,
    this.fillColor,
    this.textColor,
    this.hintColor,
    this.borderColor,
    this.focusedBorderColor,
    this.fontSize,
    this.fontWeight,
    this.borderRadius,
    this.contentPadding,
    this.autofocus = false,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? BorderRadius.circular(ResponsiveConfig.responsiveRadius(context, 14));
    final padding = contentPadding ?? EdgeInsets.symmetric(
      horizontal: ResponsiveConfig.responsivePadding(context, 16),
      vertical: ResponsiveConfig.responsivePadding(context, 14),
    );

    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      onChanged: onChanged,
      onFieldSubmitted: onSubmitted,
      onTap: onTap,
      validator: validator,
      readOnly: readOnly,
      maxLines: maxLines,
      maxLength: maxLength,
      autofocus: autofocus,
      focusNode: focusNode,
      style: TextStyle(
        fontSize: fontSize ?? ResponsiveConfig.responsiveFont(context, 16),
        fontWeight: fontWeight ?? FontWeight.normal,
        color: textColor ?? Colors.black,
      ),
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        fillColor: fillColor ?? Colors.grey.withOpacity(0.1),
        filled: true,
        contentPadding: padding,
        border: OutlineInputBorder(
          borderRadius: radius,
          borderSide: BorderSide(color: borderColor ?? Colors.grey.withOpacity(0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: radius,
          borderSide: BorderSide(color: borderColor ?? Colors.grey.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: radius,
          borderSide: BorderSide(color: focusedBorderColor ?? Colors.black, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: radius,
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: radius,
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        labelStyle: TextStyle(
          fontSize: fontSize ?? ResponsiveConfig.responsiveFont(context, 14),
          color: Colors.grey[600],
        ),
        hintStyle: TextStyle(
          fontSize: fontSize ?? ResponsiveConfig.responsiveFont(context, 16),
          color: hintColor ?? Colors.grey[500],
        ),
        counterText: maxLength != null ? '' : null,
      ),
    );
  }
}

class GlassTextField extends StatelessWidget {
  final String? hintText;
  final TextEditingController? controller;
  final bool obscureText;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final FormFieldValidator<String>? validator;
  final Widget? suffixIcon;
  final double? fontSize;
  final FontWeight? fontWeight;
  final BorderRadius? borderRadius;
  final EdgeInsets? contentPadding;
  final VoidCallback? onVisibilityToggle;
  final bool showVisibilityToggle;

  const GlassTextField({
    super.key,
    this.hintText,
    this.controller,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.onChanged,
    this.onSubmitted,
    this.validator,
    this.suffixIcon,
    this.fontSize,
    this.fontWeight,
    this.borderRadius,
    this.contentPadding,
    this.onVisibilityToggle,
    this.showVisibilityToggle = false,
  });

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? BorderRadius.circular(ResponsiveConfig.responsiveRadius(context, 14));
    final padding = contentPadding ?? EdgeInsets.symmetric(
      horizontal: ResponsiveConfig.responsivePadding(context, 16),
      vertical: ResponsiveConfig.responsivePadding(context, 14),
    );

    return ClipRRect(
      borderRadius: radius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: TextField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          onChanged: onChanged,
          onSubmitted: onSubmitted,
          style: TextStyle(
            fontSize: fontSize ?? ResponsiveConfig.responsiveFont(context, 16),
            fontWeight: fontWeight ?? FontWeight.normal,
            color: Colors.white,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
              fontSize: fontSize ?? ResponsiveConfig.responsiveFont(context, 16),
              color: Colors.white70,
            ),
            filled: true,
            fillColor: Colors.white.withOpacity(0.15),
            contentPadding: padding,
            suffixIcon: showVisibilityToggle
                ? IconButton(
                    icon: Icon(
                      obscureText ? Icons.visibility_off : Icons.visibility,
                      color: Colors.white,
                      size: ResponsiveConfig.responsiveFont(context, 20),
                    ),
                    onPressed: onVisibilityToggle,
                  )
                : suffixIcon,
            border: OutlineInputBorder(
              borderRadius: radius,
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: radius,
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: radius,
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ),
    );
  }
}

class SearchTextField extends StatelessWidget {
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final String? hintText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final VoidCallback? onClear;

  const SearchTextField({
    super.key,
    this.controller,
    this.onChanged,
    this.onSubmitted,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: controller,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      hintText: hintText ?? 'Search...',
      prefixIcon: prefixIcon ?? Icon(
        Icons.search,
        color: Colors.grey[600],
        size: ResponsiveConfig.responsiveFont(context, 20),
      ),
      suffixIcon: suffixIcon ??
          (controller?.text.isNotEmpty == true
              ? IconButton(
                  icon: Icon(
                    Icons.clear,
                    color: Colors.grey[600],
                    size: ResponsiveConfig.responsiveFont(context, 20),
                  ),
                  onPressed: () {
                    controller?.clear();
                    onClear?.call();
                  },
                )
              : null),
      borderRadius: BorderRadius.circular(ResponsiveConfig.responsiveRadius(context, 25)),
      contentPadding: EdgeInsets.symmetric(
        horizontal: ResponsiveConfig.responsivePadding(context, 20),
        vertical: ResponsiveConfig.responsivePadding(context, 12),
      ),
    );
  }
}
