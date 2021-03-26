import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart' show objectRuntimeType;
import 'package:flutter/material.dart';

import '../../values/decorations.dart' show kMaterialSmallComponentRadii;


class OutlinedGradientBorder extends OutlinedBorder {
  const OutlinedGradientBorder({
    required this.gradient,
    this.radii = BorderRadius.zero,
    this.width = 1.0,
  });

  final Gradient gradient;
  final BorderRadius radii;
  final double width;

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.all(width);


  @override
  OutlinedGradientBorder copyWith({
    Gradient? gradient,
    BorderRadius? radii,
    BorderSide? side,
    double? width,
  }) {
    return OutlinedGradientBorder(
      gradient: gradient ?? this.gradient,
      radii: radii ?? this.radii,
      width: width ?? this.width,
    );
  }

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return Path()
            ..addRRect(
                radii.resolve(textDirection)
                  .toRRect(rect).deflate(width)
              );
  }
  
  @override
  Path getOuterPath(Rect rect, { TextDirection? textDirection }) {
    return Path()
            ..addRRect(radii.resolve(textDirection).toRRect(rect));
  }
  
  @override
  void paint(Canvas canvas, Rect rect, { TextDirection? textDirection }) {
    if (width == 0) return;

    final RRect outer = radii.resolve(textDirection).toRRect(rect);
    final RRect inner = outer.deflate(width);
    final Paint paint = Paint()
                          ..shader = gradient.createShader(
                                                rect,
                                                textDirection: textDirection
                                              )
                          ..isAntiAlias = true
                          ;

    canvas.drawDRRect(outer, inner, paint);
  }

  @override
  ShapeBorder scale(double t) {
    return OutlinedGradientBorder(
      gradient: gradient,
      radii: radii * t,
      width: width * t,
    );
  }

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) {
      return false;
    } else {
      return (other is OutlinedGradientBorder) &&
             (other.gradient == gradient) &&
             (other.radii == radii) &&
             (other.width == width);
    }
  }

  @override
  int get hashCode => hashValues(gradient, width, radii);

  @override
  String toString() {
    return "${objectRuntimeType(this, "OutlinedGradientBorder")}"
           "($gradient, $radii, $width)";
  }
}


class OutlinedGradientInputBorder extends InputBorder {
  const OutlinedGradientInputBorder({
    this.gapPadding = 4.0,
    required this.gradient,
    this.radii = const BorderRadius.all(kMaterialSmallComponentRadii),
    this.width = 1.0,
  })
    : assert(gapPadding >= 0.0),
      super(borderSide: BorderSide.none); // I am not sure if this has side effects.

  final double gapPadding;
  final Gradient gradient;
  final BorderRadius radii;
  final double width;

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.all(width);

  @override
  bool get isOutline => true;


  @override
  OutlinedGradientInputBorder copyWith({
    BorderSide? borderSide,
    double? gapPadding,
    Gradient? gradient,
    BorderRadius? radii,
    double? width,
  }) {
    return OutlinedGradientInputBorder(
      gapPadding: gapPadding ?? this.gapPadding,
      gradient: gradient ?? this.gradient,
      radii: radii ?? this.radii,
      width: width ?? this.width,
    );
  }

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return Path()
            ..addRRect(
                radii.resolve(textDirection)
                  .toRRect(rect).deflate(width)
              );
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    return Path()
            ..addRRect(radii.resolve(textDirection).toRRect(rect));
  }

  @override
  void paint(
    Canvas canvas, Rect rect, {
    double? gapStart, double gapExtent = 0.0, double gapPercentage = 0.0,
    TextDirection? textDirection
  }) {
    assert((gapPercentage >= 0.0) && (gapPercentage <= 1.0));
    assert(_cornersAreCircular(radii));

    final Paint paint = Paint()
                          ..isAntiAlias = true
                          ..shader = gradient.createShader(rect, textDirection: textDirection)
                          ..strokeWidth = width
                          ..style = PaintingStyle.stroke
                          ;
    final RRect outer = radii.toRRect(rect);
    final RRect center = outer.deflate(width / 2.0);

    if (gapStart == null || gapExtent <= 0.0 || gapPercentage == 0.0) {
      canvas.drawRRect(center, paint);
    } else {
      final double extent = ui.lerpDouble(0.0, gapExtent + gapPadding * 2.0, gapPercentage)!;
      
      switch (textDirection) {
        case TextDirection.rtl:
          final Path path = _gapBorderPath(canvas, center, math.max(0.0, gapStart + gapPadding - extent), extent);
          canvas.drawPath(path, paint);
          break;
        case TextDirection.ltr:
          final Path path = _gapBorderPath(canvas, center, math.max(0.0, gapStart - gapPadding), extent);
          canvas.drawPath(path, paint);
          break;
        default:
          // I am not sure if it is required to support this clause.
          break;
      }
    }
  }

  @override
  OutlinedGradientInputBorder scale(double t) {
    return OutlinedGradientInputBorder(
      gapPadding: gapPadding * t,
      gradient: gradient,
      radii: radii * t,
      width: width * t,
    );
  }

  // From 'material/input_border.dart'
  static bool _cornersAreCircular(BorderRadius borderRadius) {
    return borderRadius.topLeft.x == borderRadius.topLeft.y
        && borderRadius.bottomLeft.x == borderRadius.bottomLeft.y
        && borderRadius.topRight.x == borderRadius.topRight.y
        && borderRadius.bottomRight.x == borderRadius.bottomRight.y;
  }

  Path _gapBorderPath(Canvas canvas, RRect center, double start, double extent) {
    // When the corner radii on any side add up to be greater than the
    // given height, each radius has to be scaled to not exceed the
    // size of the width/height of the RRect.
    final RRect scaledRRect = center.scaleRadii();

    final Rect tlCorner = Rect.fromLTWH(
      scaledRRect.left,
      scaledRRect.top,
      scaledRRect.tlRadiusX * 2.0,
      scaledRRect.tlRadiusY * 2.0,
    );
    final Rect trCorner = Rect.fromLTWH(
      scaledRRect.right - scaledRRect.trRadiusX * 2.0,
      scaledRRect.top,
      scaledRRect.trRadiusX * 2.0,
      scaledRRect.trRadiusY * 2.0,
    );
    final Rect brCorner = Rect.fromLTWH(
      scaledRRect.right - scaledRRect.brRadiusX * 2.0,
      scaledRRect.bottom - scaledRRect.brRadiusY * 2.0,
      scaledRRect.brRadiusX * 2.0,
      scaledRRect.brRadiusY * 2.0,
    );
    final Rect blCorner = Rect.fromLTWH(
      scaledRRect.left,
      scaledRRect.bottom - scaledRRect.blRadiusY * 2.0,
      scaledRRect.blRadiusX * 2.0,
      scaledRRect.blRadiusX * 2.0,
    );

    const double cornerArcSweep = math.pi / 2.0;
    final double tlCornerArcSweep = start < scaledRRect.tlRadiusX
      ? math.asin((start / scaledRRect.tlRadiusX).clamp(-1.0, 1.0))
      : math.pi / 2.0;

    final Path path = Path()
      ..addArc(tlCorner, math.pi, tlCornerArcSweep)
      ..moveTo(scaledRRect.left + scaledRRect.tlRadiusX, scaledRRect.top);

    if (start > scaledRRect.tlRadiusX)
      path.lineTo(scaledRRect.left + start, scaledRRect.top);

    const double trCornerArcStart = (3 * math.pi) / 2.0;
    const double trCornerArcSweep = cornerArcSweep;
    if (start + extent < scaledRRect.width - scaledRRect.trRadiusX) {
      path
        ..relativeMoveTo(extent, 0.0)
        ..lineTo(scaledRRect.right - scaledRRect.trRadiusX, scaledRRect.top)
        ..addArc(trCorner, trCornerArcStart, trCornerArcSweep);
    } else if (start + extent < scaledRRect.width) {
      final double dx = scaledRRect.width - (start + extent);
      final double sweep = math.acos(dx / scaledRRect.trRadiusX);
      path.addArc(trCorner, trCornerArcStart + sweep, trCornerArcSweep - sweep);
    }

    return path
      ..moveTo(scaledRRect.right, scaledRRect.top + scaledRRect.trRadiusY)
      ..lineTo(scaledRRect.right, scaledRRect.bottom - scaledRRect.brRadiusY)
      ..addArc(brCorner, 0.0, cornerArcSweep)
      ..lineTo(scaledRRect.left + scaledRRect.blRadiusX, scaledRRect.bottom)
      ..addArc(blCorner, math.pi / 2.0, cornerArcSweep)
      ..lineTo(scaledRRect.left, scaledRRect.top + scaledRRect.tlRadiusY);
  }
  // end: Borrowed Methods

  @override
  bool operator ==(Object other) {
    if (identical(this ,other)) {
      return true;
    } else if (other.runtimeType != runtimeType) {
      return false;
    } else {
      return other is OutlinedGradientInputBorder
          && other.gapPadding == gapPadding
          && other.gradient == gradient
          && other.radii == radii
          && other.width == width;
    }
  }

  @override
  int get hashCode => hashValues(gapPadding, gradient, radii, width);
}