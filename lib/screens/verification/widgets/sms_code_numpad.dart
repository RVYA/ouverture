import 'package:flutter/material.dart';

import '../../../values/colours.dart';
import '../../../values/text_styles.dart';


const double _kNumpadHeightFactor = 40 / 100;
const int
    _kNumpadColumnCount = 3,
    _kNumpadRowCount    = 4;
const int kNumpadRemoveValue = -1;


class SmsCodeNumpad extends StatelessWidget {
  const SmsCodeNumpad({required this.onPressed});

  final void Function(int number) onPressed;


  @override
  Widget build(BuildContext context) {
    final double height =
        MediaQuery.of(context).size.height * _kNumpadHeightFactor;

    return ConstrainedBox(
      constraints: BoxConstraints.expand(height: height),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        children: List<Widget>.generate(
          _kNumpadRowCount,
          (int row) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: (row < _kNumpadRowCount - 1)?
                List<Widget>.generate(
                  _kNumpadColumnCount,
                  (int column) {
                    final int padValue = (row*_kNumpadColumnCount)+(column+1);

                    return _NumpadButton(
                      onPressed: () => onPressed(padValue),
                      text: "$padValue",
                    );
                  },
                  growable: false,
                )
                : <Widget>[ // Bottom row has special functionality.
                    // Decorative
                    _NumpadButton(
                      icon: Icon(Icons.sentiment_very_satisfied_rounded),
                      onPressed: null,
                    ),

                    // 0 (zero)
                    _NumpadButton(
                      text: "0",
                      onPressed: () => onPressed(0),
                    ),

                    // Backspace
                    _NumpadButton(
                      icon: Icon(Icons.backspace_rounded),
                      onPressed: () => onPressed(kNumpadRemoveValue),
                    ),
                  ],
            );
          },
          growable: false,
        ),
      ),
    );
  }
}


const EdgeInsets _kPadPadding = const EdgeInsets.all(21.0);

class _NumpadButton extends StatelessWidget {
  const _NumpadButton({
    Key? key,
    this.icon,
    this.text,
    this.onPressed,
  })
    : assert((icon != null) ^ (text != null),),
      this.brightness = (icon == null)? Brightness.light : Brightness.dark,
      super(key: key,);

  final Brightness brightness;
  final Icon? icon;
  final String? text;
  final VoidCallback? onPressed;


  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: (text != null)? Text(text!) : icon!,
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: _kPadPadding,
        primary: (brightness == Brightness.light)? kBackground : kOnBackground,
        onPrimary: (brightness == Brightness.light)? kOnBackground : kBackground,
        shape: CircleBorder(),
        tapTargetSize: MaterialTapTargetSize.padded,
        textStyle: kGetButtonStyleFor(brightness: brightness)
                    .copyWith(fontFamily: "Red Hat Display"),
        visualDensity: VisualDensity.standard,
      ),
    );
  }
}