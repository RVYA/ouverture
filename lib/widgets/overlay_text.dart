import 'package:flutter/material.dart';


const double _kTextStructHeightOffset = 1.75; // Depending on the font, letters
                                          // lines can be beneath or above the
                                          // specified baseline.

// TODO: Check the performance of this widget. It may be better to use a CustomPainter.
// But ShaderMask is rendered by CustomPainter too, it may be unnecessary: https://github.com/flutter/flutter/blob/32741c0ec822599c17abd8d80ebeb53c143cc818/packages/flutter/lib/src/rendering/proxy_box.dart
class OverlayText extends StatelessWidget {
  const OverlayText({
    this.gradient,
    this.imageShader,
    @required this.padding,
    @required this.text,
    this.textAlignment = Alignment.centerLeft,
    this.textFit = BoxFit.none,
    @required this.textStyle,
  })
    : assert(
        (gradient == null) ^ (imageShader == null),
        "Both of \"gradient\" and \"imageShader\" can't be \"null\";"
        " one of the values must be defined.",
      )
    ;  

  final TextStyle textStyle;
  final EdgeInsetsGeometry padding;
  final Gradient gradient;
  final ImageShader imageShader;
  final String text;
  final Alignment textAlignment;
  final BoxFit textFit;


  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Padding(
        padding: padding,
        child: FittedBox(
          alignment: textAlignment,
          fit: textFit,
          child: ShaderMask(
            blendMode: BlendMode.modulate,
            shaderCallback: (Rect bounds) {
                return gradient?.createShader(Offset.zero & bounds.size)
                        ?? imageShader;
              },
            child: Text( text,
              //textAlign: textAlignment,
              strutStyle: StrutStyle(
                fontFamily: textStyle.fontFamily,
                fontSize  : textStyle.fontSize,
                fontStyle : textStyle.fontStyle,
                fontWeight: textStyle.fontWeight,
                height    : _kTextStructHeightOffset,
              ),
              style: textStyle.copyWith(color: const Color(0xFFFFFFFF),),
            ),
          ),
        ),
      ),
    );
  }
}