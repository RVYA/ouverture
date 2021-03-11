import 'package:flutter/material.dart';

import '../values/colours.dart';
import '../values/text_styles.dart';


class SecondaryActionButton extends StatelessWidget {
  const SecondaryActionButton({
    this.brightness = Brightness.light,
    @required this.icon,
    @required this.onPressed,
  });

  final Brightness brightness;
  final Icon icon;
  final void Function() onPressed;


  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: icon,
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.zero,
        onPrimary: (brightness == Brightness.light)? kOnPrimary : kPrimary,
        primary: (brightness == Brightness.light)? kPrimary : kOnPrimary,
        shape: CircleBorder(),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        textStyle: kGetButtonStyleFor(brightness: Brightness.light,),
      ),
    );
  }  
}