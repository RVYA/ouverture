import 'package:flutter/material.dart';

import '../values/colours.dart';
import '../values/decorations.dart' show kMaterialSmallComponentRadii;
import '../values/text_styles.dart';


class FadingElevatedButton extends StatelessWidget {
  const FadingElevatedButton({
    Key key,
    this.brightness = Brightness.light,
    @required this.onPressed,
    this.icon,
    this.text,
    this.isHorizontallyExpanded = true,
    this.isTextBold = false,
  })
    : assert((icon != null) ^ (text != null)),
      super(key: key);

  final Brightness brightness;
  final VoidCallback onPressed;
  final Icon icon;
  final String text;
  final bool isHorizontallyExpanded;
  final bool isTextBold;
  
  
  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = kGetButtonStyleFor(brightness: brightness);
    if (isTextBold) textStyle = textStyle.copyWith(fontWeight: FontWeight.bold);

    final BorderRadiusGeometry borderRadius =
        const BorderRadius.all(kMaterialSmallComponentRadii);

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: (brightness == Brightness.light)? kBlackFade : kWhiteFade,
        borderRadius: borderRadius,
      ),
      child: TextButton(
        child: SizedBox(
          child: (text != null)? Text(text, textAlign: TextAlign.center) : icon,
          width: (isHorizontallyExpanded)? double.maxFinite : null,
        ),
        onPressed: onPressed,
        style: TextButton.styleFrom(
          onSurface: (brightness == Brightness.light)? kOnBackground : kBackground,
          padding: EdgeInsets.zero,
          primary: (brightness == Brightness.light)? kOnBackground : kBackground,
          shape: RoundedRectangleBorder(borderRadius: borderRadius,),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          textStyle: textStyle,
        ),
      ),
    );
  }
}