import 'package:flutter/material.dart';
import '../utils/responsive_config.dart';

class CustomIcon extends StatelessWidget {
  final IconData icon;
  final double? size;
  final Color? color;

  const CustomIcon(
    this.icon, {
    super.key,
    this.size,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Icon(
      icon,
      size: size ?? ResponsiveConfig.responsiveFont(context, 24),
      color: color,
    );
  }
}

class CustomAvatar extends StatelessWidget {
  final Widget? child;
  final ImageProvider? backgroundImage;
  final Color? backgroundColor;
  final double? radius;

  const CustomAvatar({
    super.key,
    this.child,
    this.backgroundImage,
    this.backgroundColor,
    this.radius,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      child: child,
      backgroundImage: backgroundImage,
      backgroundColor: backgroundColor,
      radius: radius,
    );
  }
}
