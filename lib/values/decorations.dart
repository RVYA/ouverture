import 'package:flutter/material.dart';

import '../widgets/custom_borders/outlined_gradient_border.dart';
import 'colours.dart';
import 'text_styles.dart';


const Radius
  kMaterialSmallComponentRadii = const Radius.circular(4.0),  //dp
  kMaterialLargeComponentRadii = const Radius.circular(24.0); //dp


InputDecoration kGetInputDecorationFor({
  Brightness brightness = Brightness.light,
  required String labelText,
}) {
  final OutlinedGradientInputBorder
      fadingBorder = OutlinedGradientInputBorder(
                      gradient: (brightness == Brightness.light)? kBlackFade : kWhiteFade,
                      gapPadding: 5.0,
                      radii: const BorderRadius.all(Radius.circular(50.0)),
                      width: 2.0,
                     );

  final TextStyle
      inputStyle = kGetBodyStyleFor(brightness: brightness),
      labelStyle = inputStyle.copyWith(
                    color: inputStyle.color!.withOpacity(0.6),
                   );


  return
    InputDecoration(
      enabledBorder: fadingBorder,
      focusedBorder: fadingBorder,
      isDense: true,
      labelText: labelText,
      labelStyle: labelStyle,
    );
}

BoxDecoration kGetBoxDecorationFor({
  Brightness brightness = Brightness.light,
  BoxShape shape = BoxShape.rectangle,
  bool isFilled = true,
}) {
  final BorderRadiusGeometry? borderRadius = (shape == BoxShape.rectangle)?
      const BorderRadius.all(kMaterialLargeComponentRadii)
      : null;

  BoxBorder? border;
  Color? color;
  if (isFilled) {
    border = null;
    color = (brightness == Brightness.light)? kPrimary : kBackground;
  } else {
    color = null;
    border = Border.all(color: Colors.white); // TODO: Implement GradientBoxBorder.
  }


  return BoxDecoration(
    borderRadius: borderRadius,
    border: border,
    color: color,
    shape: shape,
  );
}