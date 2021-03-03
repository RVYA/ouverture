import 'package:flutter/material.dart';

import '../widgets/custom_borders/outlined_gradient_border.dart';
import 'colours.dart';


InputDecoration kGetInputDecorationFor({
  Brightness brightness = Brightness.light,
}) {
  final OutlinedGradientInputBorder
    fadingBorder = OutlinedGradientInputBorder(
                    gradient: (brightness == Brightness.light)? kBlackFade : kWhiteFade,
                    gapPadding: 5.0,
                    radii: const BorderRadius.all(Radius.circular(50.0)),
                    width: 2.0,
                   );

  return
    InputDecoration(
      enabledBorder: fadingBorder,
      focusedBorder: fadingBorder,
    );
}
