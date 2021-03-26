import 'package:flutter/material.dart';

import 'package:equatable/equatable.dart';

import 'package:ouverture/widgets/fading_outlined_button.dart';


enum FiniteStateButtonCommand { next, previous, }

class FiniteStateButtonController extends ChangeNotifier {
  FiniteStateButtonController();

  FiniteStateButtonCommand? _command;
  FiniteStateButtonCommand? get command => _command;


  void nextState() {
    _command = FiniteStateButtonCommand.next;
    notifyListeners();
  }

  void previousState() {
    _command = FiniteStateButtonCommand.previous;
    notifyListeners();
  }
}


class ButtonState extends Equatable {
  const ButtonState({
    required this.value,
    this.isLabelBold = false,
    this.onPressed,
  });

  final String value;
  final bool isLabelBold;
  final VoidCallback? onPressed;
  bool get isInteractable => (onPressed != null);

  @override
  List<Object> get props => <Object>[ value, ];
}


const Duration _kStateChangeTransitionDuration = const Duration(milliseconds: 750);

class FiniteStateButton extends StatefulWidget {
  const FiniteStateButton({
    this.brightness = Brightness.light,
    required this.controller,
    required this.states,
  });

  final Brightness brightness;
  final FiniteStateButtonController controller;
  final List<ButtonState> states;

  @override
  _FiniteStateButtonState createState() => _FiniteStateButtonState();
}

class _FiniteStateButtonState extends State<FiniteStateButton> {
  int stateIndex = 0;
  
  @override
  void initState() {
    super.initState();

    assert(widget.states.length > 1);

    widget.controller.addListener(
      () {
        switch (widget.controller.command!) {
          case FiniteStateButtonCommand.next:
            if (stateIndex < widget.states.length - 1) {
              setState(() => stateIndex++);
            }
            break;
          case FiniteStateButtonCommand.previous:
            if (stateIndex > 0) {
              setState(() => stateIndex--);
            }
            break;
        }
      }
    );
  }

  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: _kStateChangeTransitionDuration,
      switchInCurve: Curves.decelerate,
      switchOutCurve: Curves.easeInSine,
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(child: child, opacity: animation);
      },
      child: FadingOutlinedButton(
        key: ValueKey<String>(widget.states[stateIndex].value),
        brightness: widget.brightness,
        onPressed: widget.states[stateIndex].onPressed,
        text: widget.states[stateIndex].value,
        isTextBold: widget.states[stateIndex].isLabelBold,
      ),
    );
  }
}