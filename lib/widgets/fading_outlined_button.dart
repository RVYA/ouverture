import 'package:flutter/material.dart';

import '../values/colours.dart';
import '../values/decorations.dart' show kMaterialSmallComponentRadii;
import '../values/text_styles.dart';
import 'custom_borders/outlined_gradient_border.dart';


class FadingOutlinedButton extends StatelessWidget {
  const FadingOutlinedButton({
    Key? key,
    this.brightness = Brightness.light,
    this.onPressed,
    this.icon,
    this.text,
    this.isHorizontallyExpanded = true,
    this.isTextBold = false,
  })
    : assert((icon != null) ^ (text != null)),
      super(key: key);

  final Brightness brightness;
  final VoidCallback? onPressed;
  final Icon? icon;
  final String? text;
  final bool isHorizontallyExpanded;
  final bool isTextBold;


  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = kGetButtonStyleFor(brightness: brightness);
    if (isTextBold) textStyle = textStyle.copyWith(fontWeight: FontWeight.bold);

    final BorderRadius radii = const BorderRadius.all(kMaterialSmallComponentRadii);

    return OutlinedButton(
      child: SizedBox(
        child: (text != null)? Text(text!, textAlign: TextAlign.center,) : icon,
        width: (isHorizontallyExpanded)? double.maxFinite : null,
      ),
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        onSurface: (brightness == Brightness.light)? kOnBackground : kBackground,
        primary: (brightness == Brightness.light)? kOnBackground : kBackground,
        padding: EdgeInsets.zero,
        shape: OutlinedGradientBorder(
          gradient: (brightness == Brightness.light)? kBlackFade : kWhiteFade,
          radii: radii,
          width: 1.25,
        ),
        tapTargetSize: MaterialTapTargetSize.padded,
        textStyle: textStyle,
      ),
    );
  }
}