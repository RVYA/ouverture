import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show TextInputFormatter, FilteringTextInputFormatter, LengthLimitingTextInputFormatter;

import 'package:country_codes/country_codes.dart';

import 'package:ouverture/values/colours.dart';
import 'package:ouverture/values/interaction_styles.dart';
import 'package:ouverture/values/strings.dart';
import 'package:ouverture/values/text_styles.dart';
import 'package:ouverture/widgets/bottom_dialog/bottom_dialog.dart';
import 'package:ouverture/widgets/custom_borders/arc_border.dart';


part 'country_selector/country_search_grid.dart';
part 'country_selector/country_selector.dart';
part 'phone_input_field_button.dart';


const int
  _kPhoneNumberMinDigitLength =  5,
  _kPhoneNumberMaxDigitLength = 15;

const EdgeInsetsGeometry _kHorizontalOffset = const EdgeInsets.symmetric(horizontal: 35.0);

final TextStyle
  _kSignInScreenTextStyle = kGetBodyStyleFor(brightness: Brightness.dark),
  _kCountryDialCodeStyle = _kSignInScreenTextStyle
                            .copyWith(color: _kSignInScreenTextStyle.color.withOpacity(0.7),);

const Duration _kPhoneInputFieldTransitionDuration = const Duration(milliseconds: 1500);


class PhoneInputField extends StatefulWidget {
  const PhoneInputField({
    @required this.controller,
    this.onInputFieldEnabled,
    this.onInputValidation,
  });

  final TextEditingController controller;
  final void Function() onInputFieldEnabled;
  final void Function(bool) onInputValidation;

  @override
  _PhoneInputFieldState createState() => _PhoneInputFieldState();
}

class _PhoneInputFieldState extends State<PhoneInputField> {
  String countryCode;
  bool isButtonPressed;

  final FocusNode inputFieldFocusNode = FocusNode(canRequestFocus: true);


  @override
  void initState() {
    super.initState();

    this.countryCode = CountryCodes.deviceLocale.countryCode;
    this.isButtonPressed = false;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: _kPhoneInputFieldTransitionDuration,
      switchInCurve: Curves.easeInSine,
      switchOutCurve: Curves.decelerate,
      transitionBuilder: (Widget child, Animation<double> animation)
          => FadeTransition(child: child, opacity: animation,),
      child: (!isButtonPressed)?
          Padding(
            key: ValueKey<String>("InputFieldActivationButtonKey"),
            padding: const EdgeInsets.all(0.0),
            child: PhoneInputFieldButton(
              onPressed: () {
                setState(() => isButtonPressed = true);
                FocusScope.of(context).requestFocus(inputFieldFocusNode);
                if (widget.onInputFieldEnabled != null) widget.onInputFieldEnabled();
              },
            ),
          )
        : Padding(
            key: ValueKey<String>("InputFieldKey"),
            padding: _kHorizontalOffset,
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50.0),
                gradient: const LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: const <Color>[const Color(0x64FCF7F4), const Color(0x00000000)],
                  stops: const <double>[0.0, 0.275,],
                ),
              ),
              child: TextField(
                cursorColor: kBackground,
                controller: widget.controller,
                decoration: kGetInputDecorationFor(brightness: Brightness.dark)
                              .copyWith(  // TODO: Decide on height of the button and input field.
                                contentPadding: const EdgeInsets.symmetric(vertical: 15.0),
                                prefix: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    CountrySelector(
                                      textPadding: EdgeInsets.zero,
                                      initialCountry: CountryCodes.deviceLocale.countryCode,
                                      onSelection: (String selection) => setState(() => this.countryCode =  selection),
                                    ),
                                    Text(CountryCodes.getDialCodeOf(countryCode: countryCode)),
                                  ]
                                ),
                                prefixStyle: _kCountryDialCodeStyle,
                              ),
                enableInteractiveSelection: false,
                focusNode: inputFieldFocusNode,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(_kPhoneNumberMaxDigitLength),
                ],
                keyboardType: TextInputType.number,
                onChanged: (String input) {
                  if (widget.onInputValidation != null) {
                    widget.onInputValidation(
                      (input.length >= _kPhoneNumberMinDigitLength)
                      && (input.length <= _kPhoneNumberMaxDigitLength)
                    );
                  }
                },
                style: _kSignInScreenTextStyle,
                textAlignVertical: TextAlignVertical.top,
                //toolbarOptions: ToolbarOptions(copy: false, cut: false, paste: false, selectAll: false,),
              ),
            ),
          ),
    );
  }
}


String _countryCodeToRegionalIndicator(String alpha2CountryCode) {
  // 0x41 is Unicode uppercase "A"; and, 0x1F1E6 is REGIONAL INDICATOR SYMBOL LETTER A

  final int firstLetter = alpha2CountryCode.codeUnitAt(0) - 0x41 + 0x1F1E6;
  final int secondLetter = alpha2CountryCode.codeUnitAt(1) - 0x41 + 0x1F1E6;
    
  return String.fromCharCodes(<int>[firstLetter, secondLetter]);
}