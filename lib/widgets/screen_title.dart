import 'package:flutter/material.dart';
import '../utils/responsive_config.dart';

class ScreenTitle extends StatelessWidget {
  final String title;
  final Widget? action;
  final EdgeInsets? padding;
  final Color? titleColor;
  final double? fontSize;
  final FontWeight? fontWeight;

  const ScreenTitle({
    super.key,
    required this.title,
    this.action,
    this.padding,
    this.titleColor,
    this.fontSize,
    this.fontWeight,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding ?? EdgeInsets.all(ResponsiveConfig.responsivePadding(context, 16)),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.shade300,
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: fontSize ?? ResponsiveConfig.responsiveFont(context, 18),
                fontWeight: fontWeight ?? FontWeight.bold,
                color: titleColor ?? Colors.black,
              ),
            ),
          ),
          if (action != null) action!,
        ],
      ),
    );
  }
}
