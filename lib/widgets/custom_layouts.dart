import 'package:flutter/material.dart';
import '../utils/responsive_config.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;

  const ResponsiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 1200 && desktop != null) {
          return desktop!;
        } else if (constraints.maxWidth >= 800 && tablet != null) {
          return tablet!;
        } else {
          return mobile;
        }
      },
    );
  }
}

class CustomScrollWidget extends StatelessWidget {
  final List<Widget> children;
  final EdgeInsets? padding;
  final ScrollPhysics? physics;
  final bool shrinkWrap;
  final Axis scrollDirection;
  final bool reverse;
  final ScrollController? controller;

  const CustomScrollWidget({
    super.key,
    required this.children,
    this.padding,
    this.physics,
    this.shrinkWrap = false,
    this.scrollDirection = Axis.vertical,
    this.reverse = false,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final defaultPadding = padding ?? EdgeInsets.all(ResponsiveConfig.spacingMd(context));

    return SingleChildScrollView(
      padding: defaultPadding,
      physics: physics ?? const ClampingScrollPhysics(),
      scrollDirection: scrollDirection,
      reverse: reverse,
      controller: controller,
      child: Column(
        children: children,
      ),
    );
  }
}

class CustomSafeArea extends StatelessWidget {
  final Widget child;
  final bool top;
  final bool bottom;
  final bool left;
  final bool right;
  final EdgeInsets? minimum;
  final bool maintainBottomViewPadding;

  const CustomSafeArea({
    super.key,
    required this.child,
    this.top = true,
    this.bottom = true,
    this.left = true,
    this.right = true,
    this.minimum,
    this.maintainBottomViewPadding = false,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      minimum: minimum ?? EdgeInsets.zero,
      maintainBottomViewPadding: maintainBottomViewPadding,
      child: child,
    );
  }
}

class CustomContainer extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final Color? backgroundColor;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final BorderRadius? borderRadius;
  final Border? border;
  final BoxShadow? boxShadow;
  final DecorationImage? decorationImage;
  final Gradient? gradient;
  final AlignmentGeometry? alignment;
  final BoxConstraints? constraints;

  const CustomContainer({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.backgroundColor,
    this.padding,
    this.margin,
    this.borderRadius,
    this.border,
    this.boxShadow,
    this.decorationImage,
    this.gradient,
    this.alignment,
    this.constraints,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: borderRadius,
        border: border,
        boxShadow: boxShadow != null ? [boxShadow!] : null,
        image: decorationImage,
        gradient: gradient,
      ),
      alignment: alignment,
      constraints: constraints,
      child: child,
    );
  }
}

class CustomSpacer extends StatelessWidget {
  final double? height;
  final double? width;
  final bool isResponsive;

  const CustomSpacer({
    super.key,
    this.height,
    this.width,
    this.isResponsive = true,
  });

  @override
  Widget build(BuildContext context) {
    final responsiveHeight = isResponsive && height != null
        ? ResponsiveConfig.responsiveHeight(context, height!)
        : height;
    final responsiveWidth = isResponsive && width != null
        ? ResponsiveConfig.responsiveWidth(context, width!)
        : width;

    return SizedBox(
      height: responsiveHeight,
      width: responsiveWidth,
    );
  }
}

class CustomDivider extends StatelessWidget {
  final double? height;
  final double? thickness;
  final Color? color;
  final EdgeInsets? indent;
  final EdgeInsets? endIndent;

  const CustomDivider({
    super.key,
    this.height,
    this.thickness,
    this.color,
    this.indent,
    this.endIndent,
  });

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: height ?? ResponsiveConfig.responsiveHeight(context, 20),
      thickness: thickness ?? 1,
      color: color ?? Colors.grey[300],
      indent: indent?.left ?? 0,
      endIndent: endIndent?.left ?? 0,
    );
  }
}

class ResponsiveGridView extends StatelessWidget {
  final List<Widget> children;
  final SliverGridDelegate? gridDelegate;
  final EdgeInsets? padding;
  final bool shrinkWrap;
  final ScrollPhysics? physics;
  final ScrollController? controller;

  const ResponsiveGridView({
    super.key,
    required this.children,
    this.gridDelegate,
    this.padding,
    this.shrinkWrap = false,
    this.physics,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final defaultGridDelegate = gridDelegate ??
        SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1, // Changed to 1 card per row
          crossAxisSpacing: ResponsiveConfig.spacingMd(context),
          mainAxisSpacing: ResponsiveConfig.spacingMd(context),
          childAspectRatio: 2.5, // Adjusted aspect ratio for single card layout
        );

    final defaultPadding = padding ?? EdgeInsets.all(ResponsiveConfig.spacingSm(context));

    return GridView.builder(
      gridDelegate: defaultGridDelegate,
      padding: defaultPadding,
      shrinkWrap: shrinkWrap,
      physics: physics ?? (shrinkWrap ? const NeverScrollableScrollPhysics() : null),
      controller: controller,
      itemCount: children.length,
      itemBuilder: (context, index) => children[index],
    );
  }
}

class CustomListView extends StatelessWidget {
  final List<Widget> children;
  final EdgeInsets? padding;
  final bool shrinkWrap;
  final ScrollPhysics? physics;
  final ScrollController? controller;
  final Axis scrollDirection;
  final bool reverse;

  const CustomListView({
    super.key,
    required this.children,
    this.padding,
    this.shrinkWrap = false,
    this.physics,
    this.controller,
    this.scrollDirection = Axis.vertical,
    this.reverse = false,
  });

  @override
  Widget build(BuildContext context) {
    final defaultPadding = padding ?? EdgeInsets.symmetric(
      horizontal: ResponsiveConfig.spacingMd(context),
      vertical: ResponsiveConfig.spacingSm(context),
    );

    return ListView.builder(
      padding: defaultPadding,
      shrinkWrap: shrinkWrap,
      physics: physics ?? (shrinkWrap ? const NeverScrollableScrollPhysics() : null),
      controller: controller,
      scrollDirection: scrollDirection,
      reverse: reverse,
      itemCount: children.length,
      itemBuilder: (context, index) => children[index],
    );
  }
}

class CustomRow extends StatelessWidget {
  final List<Widget> children;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisSize mainAxisSize;
  final TextBaseline? textBaseline;
  final VerticalDirection verticalDirection;
  final TextDirection? textDirection;

  const CustomRow({
    super.key,
    required this.children,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisSize = MainAxisSize.max,
    this.textBaseline,
    this.verticalDirection = VerticalDirection.down,
    this.textDirection,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      mainAxisSize: mainAxisSize,
      textBaseline: textBaseline,
      verticalDirection: verticalDirection,
      textDirection: textDirection,
      children: children,
    );
  }
}

class CustomColumn extends StatelessWidget {
  final List<Widget> children;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisSize mainAxisSize;
  final TextBaseline? textBaseline;
  final VerticalDirection verticalDirection;
  final TextDirection? textDirection;

  const CustomColumn({
    super.key,
    required this.children,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisSize = MainAxisSize.max,
    this.textBaseline,
    this.verticalDirection = VerticalDirection.down,
    this.textDirection,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      mainAxisSize: mainAxisSize,
      textBaseline: textBaseline,
      verticalDirection: verticalDirection,
      textDirection: textDirection,
      children: children,
    );
  }
}

class CustomStack extends StatelessWidget {
  final List<Widget> children;
  final AlignmentGeometry alignment;
  final StackFit fit;
  final TextDirection? textDirection;
  final Clip clipBehavior;

  const CustomStack({
    super.key,
    required this.children,
    this.alignment = AlignmentDirectional.topStart,
    this.fit = StackFit.loose,
    this.textDirection,
    this.clipBehavior = Clip.hardEdge,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: alignment,
      fit: fit,
      textDirection: textDirection,
      clipBehavior: clipBehavior,
      children: children,
    );
  }
}

class CustomExpanded extends StatelessWidget {
  final Widget child;
  final int flex;

  const CustomExpanded({
    super.key,
    required this.child,
    this.flex = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: child,
    );
  }
}

class CustomFlexible extends StatelessWidget {
  final Widget child;
  final int flex;
  final FlexFit fit;

  const CustomFlexible({
    super.key,
    required this.child,
    this.flex = 1,
    this.fit = FlexFit.loose,
  });

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: flex,
      fit: fit,
      child: child,
    );
  }
}
