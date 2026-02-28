import 'package:flutter/material.dart';
import '../utils/responsive_config.dart';

class CustomText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final int? maxLines;
  final TextOverflow? overflow;
  final double? textScaleFactor;
  final String? semanticsLabel;
  final bool? softWrap;
  final StrutStyle? strutStyle;
  final TextWidthBasis? textWidthBasis;
  final Color? color;
  final double? fontSize;
  final FontWeight? fontWeight;
  final String? fontFamily;
  final double? letterSpacing;
  final double? wordSpacing;
  final double? height;
  final TextDecoration? decoration;
  final Color? decorationColor;
  final TextDecorationStyle? decorationStyle;
  final double? decorationThickness;

  const CustomText(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.textDirection,
    this.maxLines,
    this.overflow,
    this.textScaleFactor,
    this.semanticsLabel,
    this.softWrap,
    this.strutStyle,
    this.textWidthBasis,
    this.color,
    this.fontSize,
    this.fontWeight,
    this.fontFamily,
    this.letterSpacing,
    this.wordSpacing,
    this.height,
    this.decoration,
    this.decorationColor,
    this.decorationStyle,
    this.decorationThickness,
  });

  factory CustomText.heading(
    String text, {
    BuildContext? context,
    Color? color,
    double? fontSize,
    FontWeight? fontWeight,
    TextAlign? textAlign,
    int? maxLines,
  }) {
    return CustomText(
      text,
      style: (context != null 
          ? AppTextStyles.getHeading(context)
          : const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            )
      ).copyWith(
        color: color,
        fontSize: fontSize,
        fontWeight: fontWeight,
      ),
      textAlign: textAlign,
      maxLines: maxLines,
    );
  }

  factory CustomText.subheading(
    String text, {
    BuildContext? context,
    Color? color,
    double? fontSize,
    FontWeight? fontWeight,
    TextAlign? textAlign,
    int? maxLines,
  }) {
    return CustomText(
      text,
      style: (context != null 
          ? AppTextStyles.getSubheading(context)
          : const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            )
      ).copyWith(
        color: color,
        fontSize: fontSize,
        fontWeight: fontWeight,
      ),
      textAlign: textAlign,
      maxLines: maxLines,
    );
  }

  factory CustomText.body(
    String text, {
    BuildContext? context,
    Color? color,
    double? fontSize,
    FontWeight? fontWeight,
    TextAlign? textAlign,
    int? maxLines,
  }) {
    return CustomText(
      text,
      style: (context != null 
          ? AppTextStyles.getBody(context)
          : const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.normal,
            )
      ).copyWith(
        color: color,
        fontSize: fontSize,
        fontWeight: fontWeight,
      ),
      textAlign: textAlign,
      maxLines: maxLines,
    );
  }

  factory CustomText.caption(
    String text, {
    BuildContext? context,
    Color? color,
    double? fontSize,
    FontWeight? fontWeight,
    TextAlign? textAlign,
    int? maxLines,
  }) {
    return CustomText(
      text,
      style: (context != null 
          ? AppTextStyles.getCaption(context)
          : const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.normal,
            )
      ).copyWith(
        color: color,
        fontSize: fontSize,
        fontWeight: fontWeight,
      ),
      textAlign: textAlign,
      maxLines: maxLines,
    );
  }

  factory CustomText.small(
    String text, {
    BuildContext? context,
    Color? color,
    double? fontSize,
    FontWeight? fontWeight,
    TextAlign? textAlign,
    int? maxLines,
  }) {
    return CustomText(
      text,
      style: (context != null 
          ? AppTextStyles.getSmall(context)
          : const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.normal,
            )
      ).copyWith(
        color: color,
        fontSize: fontSize,
        fontWeight: fontWeight,
      ),
      textAlign: textAlign,
      maxLines: maxLines,
    );
  }

  @override
  Widget build(BuildContext context) {
    TextStyle effectiveStyle = style ?? const TextStyle();
    
    if (color != null) {
      effectiveStyle = effectiveStyle.copyWith(color: color);
    }
    if (fontSize != null) {
      effectiveStyle = effectiveStyle.copyWith(fontSize: fontSize);
    }
    if (fontWeight != null) {
      effectiveStyle = effectiveStyle.copyWith(fontWeight: fontWeight);
    }
    if (fontFamily != null) {
      effectiveStyle = effectiveStyle.copyWith(fontFamily: fontFamily);
    }
    if (letterSpacing != null) {
      effectiveStyle = effectiveStyle.copyWith(letterSpacing: letterSpacing);
    }
    if (wordSpacing != null) {
      effectiveStyle = effectiveStyle.copyWith(wordSpacing: wordSpacing);
    }
    if (height != null) {
      effectiveStyle = effectiveStyle.copyWith(height: height);
    }
    if (decoration != null) {
      effectiveStyle = effectiveStyle.copyWith(decoration: decoration);
    }
    if (decorationColor != null) {
      effectiveStyle = effectiveStyle.copyWith(decorationColor: decorationColor);
    }
    if (decorationStyle != null) {
      effectiveStyle = effectiveStyle.copyWith(decorationStyle: decorationStyle);
    }
    if (decorationThickness != null) {
      effectiveStyle = effectiveStyle.copyWith(decorationThickness: decorationThickness);
    }

    return Text(
      text,
      style: effectiveStyle,
      textAlign: textAlign,
      textDirection: textDirection,
      maxLines: maxLines,
      overflow: overflow,
      textScaleFactor: textScaleFactor,
      semanticsLabel: semanticsLabel,
      softWrap: softWrap,
      strutStyle: strutStyle,
      textWidthBasis: textWidthBasis,
    );
  }
}

class CustomRichText extends StatelessWidget {
  final InlineSpan text;
  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final bool? softWrap;
  final TextOverflow? overflow;
  final double? textScaleFactor;
  final int? maxLines;
  final Locale? locale;
  final StrutStyle? strutStyle;
  final TextWidthBasis? textWidthBasis;
  final TextHeightBehavior? textHeightBehavior;

  const CustomRichText({
    super.key,
    required this.text,
    this.textAlign,
    this.textDirection,
    this.softWrap,
    this.overflow,
    this.textScaleFactor,
    this.maxLines,
    this.locale,
    this.strutStyle,
    this.textWidthBasis,
    this.textHeightBehavior,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: text,
      textAlign: textAlign ?? TextAlign.start,
      textDirection: textDirection,
      softWrap: softWrap ?? true,
      overflow: overflow ?? TextOverflow.clip,
      textScaleFactor: textScaleFactor ?? 1.0,
      maxLines: maxLines,
      locale: locale,
      strutStyle: strutStyle,
      textWidthBasis: textWidthBasis ?? TextWidthBasis.parent,
      textHeightBehavior: textHeightBehavior,
    );
  }
}

class CustomTextSpan extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final List<InlineSpan>? children;

  const CustomTextSpan({
    super.key,
    required this.text,
    this.style,
    this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: style,
    );
  }
}
