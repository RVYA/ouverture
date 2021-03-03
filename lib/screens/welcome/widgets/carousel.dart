import 'dart:math' as math;

import 'package:flutter/material.dart';


enum MovementDirection { down, left, right, up, }

const MovementDirection
  _kD = MovementDirection.down, _kL = MovementDirection.left,
  _kU = MovementDirection.up;


class Carousel extends StatefulWidget {
  const Carousel({
    @required this.changeAnimationCurve,
    @required this.changeAnimationDuration,
    @required this.children,
    @required this.childShowcaseDuration,
    this.direction = MovementDirection.up,
    this.initialPage = 0,
    this.padding = const EdgeInsets.all(8.0),
  });

  final Duration changeAnimationDuration;
  final Curve changeAnimationCurve;
  final List<Widget> children;
  final Duration childShowcaseDuration;
  final MovementDirection direction;
  final int initialPage;
  final EdgeInsetsGeometry padding;

  @override
  _CarouselState createState() => _CarouselState();
}

class _CarouselState extends State<Carousel>
    with SingleTickerProviderStateMixin {
  PageController controller;
  AnimationController animController;
  Animation<double> animation;
  int pageIndex = 0;

  @override
  void initState() {
    super.initState();

    final int childCount = widget.children.length;

    controller = PageController(
                  initialPage: widget.initialPage, keepPage: false,
                );
    animController = AnimationController(
                      duration: widget.childShowcaseDuration * childCount,
                      vsync: this,
                     );
    animation = Tween<double>(begin: 0.0, end: childCount.toDouble(),)
                    .animate(animController)
                    ..addListener(
                      () {
                        int flooredValue = step(animation.value);

                        if (pageIndex != flooredValue) {
                          pageIndex = flooredValue;
                          controller.animateToPage(
                              pageIndex,
                              curve: widget.changeAnimationCurve,
                              duration: widget.changeAnimationDuration,
                            );
                        }
                      }
                    );
    animController.repeat();
  }

  @override
  void dispose() {
    controller.dispose();
    animController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Padding(
        padding: widget.padding,
        child  : PageView(
          children       : widget.children,
          controller     : controller,
          physics        : const NeverScrollableScrollPhysics(),
          reverse        : (widget.direction == _kL) || (widget.direction == _kU),
          scrollDirection: (widget.direction == _kU || widget.direction == _kD)?
                              Axis.vertical : Axis.horizontal,
        ),
      ),
    );
  }
}


double pausingRamp(double t) {
  int period = (t ~/ 2).floor();
  return math.min<double>(t - (period * 2), 1) + period;
}

int step(double t) {
  return t.floor();
}