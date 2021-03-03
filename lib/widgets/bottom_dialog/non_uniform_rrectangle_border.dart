import 'package:flutter/material.dart' show Colors, required;
import 'package:flutter/painting.dart';

import 'package:ouverture/helper_classes/extensions.dart' show DeflateOnlyFor, IsTransparent;


const Radius
  kMaterialSmallComponentRadii = const Radius.circular(4.0),  //dp
  kMaterialLargeComponentRadii = const Radius.circular(24.0); //dp

class NonUniformRRectangleBorder extends BoxBorder {
  const NonUniformRRectangleBorder({
    @required this.width,
    this.color = Colors.transparent,
    this.hasTop = true,
    this.hasLeft = true,
    this.hasBottom = true,
    this.hasRight = true,
    this.radii       = const BorderRadius.all(kMaterialSmallComponentRadii),
  });

  final Color color;
  final bool
    hasTop,
    hasLeft,
    hasRight,
    hasBottom;
  final BorderRadius radii;
  final double width;

  @override
  EdgeInsetsGeometry get dimensions
    => EdgeInsets.all(width);

  @override
  BorderSide get bottom
      => (hasBottom)? BorderSide(color: color, width: width) : BorderSide.none;

  @override
  bool get isUniform => (hasTop && hasLeft && hasRight && hasBottom);

  @override
  BorderSide get top
      => (hasTop)? BorderSide(color: color, width: width) : BorderSide.none;

  @override
  Path getInnerPath(Rect rect, {TextDirection textDirection}) {
    return Path()
        ..addRRect(
            radii.resolve(textDirection)
              .toRRect(rect).deflateOnlyFor(
                              width,
                              doDeflateLeft: hasLeft,
                              doDeflateTop: hasTop,
                              doDeflateRight: hasRight,
                              doDeflateBottom: hasBottom,
                            ),
          );
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection textDirection}) {
    return Path()
      ..addRRect(radii.resolve(textDirection).toRRect(rect));
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection textDirection,
      BoxShape shape = BoxShape.rectangle, BorderRadius borderRadius
  }) {
    if ((width <= 0) || color.isTransparent) return;

    final RRect outer = radii.resolve(textDirection).toRRect(rect);
    final RRect inner = outer.deflateOnlyFor(
                            width,
                            doDeflateLeft: hasLeft,
                            doDeflateTop: hasTop,
                            doDeflateRight: hasRight,
                            doDeflateBottom: hasBottom,
                          );

    final Paint paint = Paint()
                          ..isAntiAlias = true // May solve jagged edges.
                          ..color = color
                          ;

    canvas.drawDRRect(outer, inner, paint);
  }

  @override
  ShapeBorder scale(double t) {
    return NonUniformRRectangleBorder(
      color          : color,
      hasBottom: hasBottom,
      hasLeft  : hasLeft,
      hasRight : hasRight,
      hasTop   : hasTop,
      radii          : radii * t,
      width          : width * t,
    );
  }
}