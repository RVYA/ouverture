import 'dart:io' as io;

import 'package:flutter/material.dart';

import '../values/decorations.dart';


const EdgeInsetsGeometry
    _kFrameMargin = const EdgeInsets.all(8.0),  // Outer
    _kFramePadding = const EdgeInsets.all(4.0); // Inner

const String _kFrameDefaultPhotographPath = "assets/images/tiger_closeup.png";
const double _kFrameReferenceRadius = 100;


class PhotographFrame extends StatelessWidget {
  const PhotographFrame({
    Key? key,
    this.brightness = Brightness.light,
    this.flex = 1,
    this.photograph,
    this.margin = _kFrameMargin,
  })
    : super(key: key,);

  final Brightness brightness;  // TODO: Implement borders.
  final int flex;
  final io.File? photograph;
  final EdgeInsetsGeometry margin;


  @override
  Widget build(BuildContext context) {
    final ImageProvider backgroundImage = (photograph == null)?
          AssetImage( _kFrameDefaultPhotographPath,)
          : FileImage( photograph!,) as ImageProvider<Object>;

    return Expanded(
      flex: flex,
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: _kFrameReferenceRadius,
        backgroundImage: backgroundImage,
      ),
    );
  }
}