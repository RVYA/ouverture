import 'package:flutter/material.dart';

import '../values/colours.dart';
import '../values/text_styles.dart';
import 'custom_borders/outlined_gradient_border.dart';


const EdgeInsets _kFadingButtonMargin = EdgeInsets.symmetric(
                                          horizontal: 25.0,
                                          vertical: 10.0,
                                        );


class FadingOutlinedButton extends StatelessWidget {
  const FadingOutlinedButton({
    Key key,
    this.brightness = Brightness.light,
    @required this.onPressed,
    @required this.text,
    @required this.isTextBold,
  })
    : super(key: key);

  final Brightness brightness;
  final VoidCallback onPressed;
  final String text;
  final bool isTextBold;

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = kGetButtonStyleFor(brightness: brightness);
    if (isTextBold) textStyle = textStyle.copyWith(fontWeight: FontWeight.bold);

    return Padding(
      padding: _kFadingButtonMargin,
      child: OutlinedButton(
        child: SizedBox(
          width: double.maxFinite,
          child: Text(text, textAlign: TextAlign.center,)
        ),
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          onSurface: (brightness == Brightness.light)? kOnBackground : kBackground,
          primary: (brightness == Brightness.light)? kOnBackground : kBackground,
          shape: OutlinedGradientBorder(
            gradient: (brightness == Brightness.light)? kBlackFade : kWhiteFade,
            radii: BorderRadius.all(kMaterialSmallComponentRadii),
            width: 1.25,
          ),
          tapTargetSize: MaterialTapTargetSize.padded,
          textStyle: textStyle,
        ),
      ),
    );
  }
}