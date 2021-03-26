import 'package:flutter/material.dart';
import 'package:ouverture/values/decorations.dart';

import '../../../values/text_styles.dart';


const int _kSmsCodeLength = 6;
const int
    _kSmsCodeFieldRowCount = 2,
    _kSmsCodeFieldColumnCount = _kSmsCodeLength ~/ _kSmsCodeFieldRowCount;


class SmsCodeField extends StatefulWidget {
  const SmsCodeField({
    required this.controller,
    required this.onChanged,
  });

  final SmsCodeFieldController controller;
  final void Function(String value) onChanged;

  @override
  _SmsCodeFieldState createState() => _SmsCodeFieldState();
}

class _SmsCodeFieldState extends State<SmsCodeField> {
  final BoxDecoration
      decorationEmptyDigit = BoxDecoration(border: Border.all(style: BorderStyle.none),),
      decorationDigit = kGetBoxDecorationFor(brightness: Brightness.dark);

  final List<String> values =
      List<String>.filled(_kSmsCodeLength, _kEmptyFieldCharacter);

  bool isFilled = false;


  @override
  void initState() {
    super.initState();

    widget.controller.addListener(
      () {
        setState(
          () {
            isFilled = widget.controller.isFieldFilled();
            values[widget.controller.currentIndex] = widget.controller.value;

            widget.onChanged(values.join());
          }
        );
      }
    );
  }
/* Dispose in owner widget - Verification screen.
  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }
*/
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: List<Widget>.generate(
        _kSmsCodeFieldRowCount,
        (int row) {
          return Padding(
            padding: EdgeInsets.only(bottom: (row.isEven)? 10.0 : 0.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: List<Widget>.generate(
                _kSmsCodeFieldColumnCount + 1,
                (int column) {
                  final int inputDigitIndex = (row * 2) + column;
                  final bool isDecorativeDigit =
                      (row == 0 && column == (_kSmsCodeFieldColumnCount))
                      || (row == 1 && column == 0);

                  return Expanded(
                    child: DecoratedBox(
                      decoration: (isDecorativeDigit)?
                          decorationEmptyDigit : decorationDigit,
                      child: Text(
                        (isDecorativeDigit)?
                            _kEmptyFieldCharacter : values[inputDigitIndex],
                        style: kGetDisplayStyleFor(brightness: Brightness.light), // Background is filled with kBackground.
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }
              ),
            ),
          );
        }
      ),
    );
  }
}


const String _kEmptyFieldCharacter = "\u{2022}";

class SmsCodeFieldController extends ChangeNotifier {
  int _currentIndex = 0;
  int get currentIndex => _currentIndex;

  String _value = _kEmptyFieldCharacter;
  String get value => _value;


  bool isFieldFilled() => !(_currentIndex < _kSmsCodeLength);

  void write(String text) {
    if (!isFieldFilled()) {
      _value = text;
      notifyListeners();
      _currentIndex++;
    }
  }

  void remove() {
    if (_currentIndex > 0) {
      _currentIndex--;
      _value = _kEmptyFieldCharacter;
      notifyListeners();
    }
  }
}