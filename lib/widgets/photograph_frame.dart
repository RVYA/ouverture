import 'dart:io' as io;

import 'package:flutter/material.dart';

import '../values/decorations.dart';


const EdgeInsetsGeometry
    _kFrameMargin = const EdgeInsets.all(8.0),  // Outer
    _kFramePadding = const EdgeInsets.all(4.0); // Inner

const String _kFrameDefaultPhotographPath = "assets/images/tiger_closeup.png";


class PhotographFrame extends StatelessWidget {
  const PhotographFrame({
    Key key,
    this.brightness = Brightness.light,
    this.flex = 1,
    this.photograph,
    this.margin = _kFrameMargin,
  })
    : super(key: key,);

  final Brightness brightness;
  final int flex;
  final io.File photograph;
  final EdgeInsetsGeometry margin;


  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Container(
        alignment: Alignment.center,
        decoration: kGetBoxDecorationFor(
          brightness: brightness,
          isFilled: false,
          shape: BoxShape.circle,
        ),
        margin: margin,
        padding: _kFramePadding,
        child: ClipOval(
          child: (photograph != null)?
            Image.file( photograph,
              filterQuality: FilterQuality.high,
              // TODO: Work on this Image. There may be a need to use a scale.
            )
            : Image.asset( _kFrameDefaultPhotographPath,
                filterQuality: FilterQuality.high,
              ),
          clipBehavior: Clip.antiAlias,
          clipper: _CircleClipper(),
        ),
      ),
    );
  }
}


class _CircleClipper extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) {
    final double diameter = (size.width < size.height)? size.width : size.height;

    return Rect.fromLTWH(0, 0, diameter, diameter);
  }

  @override
  bool shouldReclip(covariant CustomClipper<Rect> oldClipper) => false;
}