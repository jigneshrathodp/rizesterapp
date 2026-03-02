import 'package:flutter/material.dart';
import '../utils/responsive_config.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Widget? titleWidget;
  final VoidCallback? onMenuPressed;
  final VoidCallback? onNotificationPressed;
  final VoidCallback? onProfilePressed;
  final VoidCallback? onBackPressed;
  final List<Widget>? actions;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? elevation;
  final bool automaticallyImplyLeading;
  final bool centerTitle;
  final double? titleSpacing;
  final Widget? leading;
  final bool showNotifications;
  final bool showProfile;
  final String? logoAsset;

  const CustomAppBar({
    super.key,
    this.title,
    this.titleWidget,
    this.onMenuPressed,
    this.onNotificationPressed,
    this.onProfilePressed,
    this.onBackPressed,
    this.actions,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation,
    this.automaticallyImplyLeading = true,
    this.centerTitle = false,
    this.titleSpacing,
    this.leading,
    this.showNotifications = true,
    this.showProfile = true,
    this.logoAsset,
  });

  @override
  Widget build(BuildContext context) {
    final iconSize = ResponsiveConfig.responsiveFont(context, 24);
    final logoHeight = ResponsiveConfig.responsiveHeight(context, 10);

    return AppBar(
      backgroundColor: backgroundColor ?? Colors.white,
      foregroundColor: foregroundColor ?? Colors.black,
      elevation: elevation ?? 0,
      centerTitle: centerTitle,
      titleSpacing: titleSpacing,
      automaticallyImplyLeading: automaticallyImplyLeading,
      title: titleWidget ??
          (logoAsset != null
              ? Image.asset(
            logoAsset!,
            height: logoHeight,
          )
              : null),
      leading: leading ??
          (onMenuPressed != null
              ? IconButton(
            icon: Icon(
              Icons.menu,
              color: foregroundColor ?? Colors.black,
              size: iconSize,
            ),
            onPressed: onMenuPressed,
          )
              : null),
      actions: actions ??
          [
            if (showNotifications)
              IconButton(
                icon: Icon(
                  Icons.notifications,
                  color: foregroundColor ?? Colors.black,
                  size: iconSize,
                ),
                onPressed: onNotificationPressed ?? () {},
              ),
            if (showProfile)
              IconButton(
                icon: Icon(
                  Icons.account_circle,
                  color: foregroundColor ?? Colors.black,
                  size: iconSize,
                ),
                onPressed: onProfilePressed ?? () {},
              ),
          ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class CustomSliverAppBar extends StatelessWidget {
  final String? title;
  final Widget? titleWidget;
  final VoidCallback? onMenuPressed;
  final VoidCallback? onNotificationPressed;
  final VoidCallback? onProfilePressed;
  final VoidCallback? onBackPressed;
  final List<Widget>? actions;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? expandedHeight;
  final Widget? flexibleSpace;
  final bool pinned;
  final bool floating;
  final bool snap;
  final bool stretch;
  final bool showNotifications;
  final bool showProfile;
  final String? logoAsset;

  const CustomSliverAppBar({
    super.key,
    this.title,
    this.titleWidget,
    this.onMenuPressed,
    this.onNotificationPressed,
    this.onProfilePressed,
    this.onBackPressed,
    this.actions,
    this.backgroundColor,
    this.foregroundColor,
    this.expandedHeight,
    this.flexibleSpace,
    this.pinned = false,
    this.floating = false,
    this.snap = false,
    this.stretch = false,
    this.showNotifications = true,
    this.showProfile = true,
    this.logoAsset,
  });

  @override
  Widget build(BuildContext context) {
    final iconSize = ResponsiveConfig.responsiveFont(context, 24);
    final logoHeight = ResponsiveConfig.responsiveHeight(context, 20);

    return SliverAppBar(
      backgroundColor: backgroundColor ?? Colors.white,
      foregroundColor: foregroundColor ?? Colors.black,
      elevation: 0,
      expandedHeight: expandedHeight,
      pinned: pinned,
      floating: floating,
      snap: snap,
      stretch: stretch,
      flexibleSpace: flexibleSpace,
      title: titleWidget ??
          (logoAsset != null
              ? Image.asset(
            logoAsset!,
            height: logoHeight,
          )
              : null),
      leading: onMenuPressed != null
          ? IconButton(
        icon: Icon(
          Icons.menu,
          color: foregroundColor ?? Colors.black,
          size: iconSize,
        ),
        onPressed: onMenuPressed,
      )
          : null,
      actions: actions ??
          [
            if (showNotifications)
              IconButton(
                icon: Icon(
                  Icons.notifications,
                  color: foregroundColor ?? Colors.black,
                  size: iconSize,
                ),
                onPressed: onNotificationPressed ?? () {},
              ),
            if (showProfile)
              IconButton(
                icon: Icon(
                  Icons.account_circle,
                  color: foregroundColor ?? Colors.black,
                  size: iconSize,
                ),
                onPressed: onProfilePressed ?? () {},
              ),
          ],
    );
  }
}

class CustomTabBar extends StatelessWidget implements PreferredSizeWidget {
  final List<Tab> tabs;
  final TabController? controller;
  final ValueChanged<int>? onTap;
  final Color? backgroundColor;
  final Color? indicatorColor;
  final Color? labelColor;
  final Color? unselectedLabelColor;
  final TextStyle? labelStyle;
  final TextStyle? unselectedLabelStyle;
  final EdgeInsets? padding;
  final IndicatorSize? indicatorSize;

  const CustomTabBar({
    super.key,
    required this.tabs,
    this.controller,
    this.onTap,
    this.backgroundColor,
    this.indicatorColor,
    this.labelColor,
    this.unselectedLabelColor,
    this.labelStyle,
    this.unselectedLabelStyle,
    this.padding,
    this.indicatorSize,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor ?? Colors.white,
      child: TabBar(
        controller: controller,
        onTap: onTap,
        tabs: tabs,
        indicatorColor: indicatorColor ?? Colors.black,
        labelColor: labelColor ?? Colors.black,
        unselectedLabelColor: unselectedLabelColor ?? Colors.grey,
        labelStyle: labelStyle ??
            AppTextStyles.getBody(context).copyWith(fontWeight: FontWeight.w600),
        unselectedLabelStyle: unselectedLabelStyle ??
            AppTextStyles.getBody(context).copyWith(fontWeight: FontWeight.normal),
        padding: padding,
        indicatorSize: indicatorSize != null
            ? (indicatorSize == IndicatorSize.tab ? TabBarIndicatorSize.tab : TabBarIndicatorSize.label)
            : null,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

enum IndicatorSize { tab, label }