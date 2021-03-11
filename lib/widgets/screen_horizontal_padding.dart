import 'package:flutter/material.dart';


const EdgeInsets _kScreenHorizontalMargin = EdgeInsets.symmetric(
                                              horizontal: 25.0,
                                            );


class ScreenHorizontalPadding extends StatelessWidget {
  const ScreenHorizontalPadding({
    Key key,
    @required this.child,
  })
    : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return
      Padding(
        child: child,
        padding: _kScreenHorizontalMargin,
      );
  }
}