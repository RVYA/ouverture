import 'dart:math' as math;

import 'package:flutter/foundation.dart' show objectRuntimeType;
import 'package:flutter/painting.dart';


class ArcBorder extends OutlinedBorder {
  const ArcBorder({
    this.side = BorderSide.none,
    this.startAngle = 0,
    this.sweepAngle = 2 * math.pi,
  })
    : super(side: side);

  final double startAngle, sweepAngle;
  final BorderSide side;


  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.all(side.width);

  @override
  ShapeBorder scale(double t) => ArcBorder(side: side.scale(t));

  @override
  ShapeBorder? lerpFrom(ShapeBorder? a, double t) {
    if (a is ArcBorder)
      return ArcBorder(side: BorderSide.lerp(a.side, side, t));
    return super.lerpFrom(a, t);
  }

  @override
  ShapeBorder? lerpTo(ShapeBorder? b, double t) {
    if (b is ArcBorder)
      return ArcBorder(side: BorderSide.lerp(side, b.side, t));
    return super.lerpTo(b, t);
  }

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return Path()
      ..addArc(rect, startAngle, sweepAngle)
      ;
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    return Path()
      ..addArc(rect, startAngle, sweepAngle)
      ;
  }

  @override
  ArcBorder copyWith({ BorderSide? side }) {
    return ArcBorder(side: side ?? this.side);
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    switch (side.style) {
      case BorderStyle.none:
        break;
      case BorderStyle.solid:
        canvas.drawArc(rect, startAngle, sweepAngle, false, side.toPaint());
    }
  }

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType)
      return false;
    return other is ArcBorder
        && other.side == side;
  }

  @override
  int get hashCode => side.hashCode;

  @override
  String toString() => "${objectRuntimeType(this, 'CutCircleBorder')}($side)";
}