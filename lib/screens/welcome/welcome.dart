import 'package:flutter/material.dart';

import '../../values/colours.dart';
import '../../values/strings.dart';
import '../../values/text_styles.dart';
import '../../widgets/finite_state_button.dart';
import '../../widgets/overlay_text.dart';
import 'widgets/carousel.dart';
import 'widgets/phone_input_field/phone_input_field.dart';


const String _kTigerImagePath = "assets/images/tiger_closeup.png";
const double _kTigerScale = 3.25; // Higher the scale is, smaller the image.


class Welcome extends StatefulWidget {
  const Welcome();

  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  final Brightness brightness = Brightness.dark;

  final FiniteStateButtonController finiteStateButtonController = FiniteStateButtonController();
  final TextEditingController phoneInputController = TextEditingController();

  bool isActionEnabled;


  @override
  void initState() {
    super.initState();

    this.isActionEnabled = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: DecoratedBox(
        decoration: BoxDecoration(gradient: kDarkGradient,),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Spacer(flex: 3,),

              // Values Carousel
              SizedBox(
                height: 85.0,
                child: Carousel(
                  changeAnimationCurve: Curves.easeInSine,
                  changeAnimationDuration: const Duration(milliseconds: 900),
                  childShowcaseDuration: const Duration(milliseconds: 2000),
                  direction: MovementDirection.down,
                  initialPage: 1,
                  children: List<Widget>.generate(
                    kWelcomeValues.length,
                    (int index)
                      => OverlayText(
                          gradient: kLightGradient,
                          padding: const EdgeInsets.all(4.0),
                          text: kWelcomeValues[index],
                          textAlignment: Alignment.centerLeft,
                          textFit: BoxFit.contain,
                          textStyle: kGetDisplayStyleFor(brightness: Brightness.dark),
                         ),
                    ),
                ),
              ),
              // end: Values Carousel

              Spacer(flex: 6,),

              // Phone Input Field
              RepaintBoundary(
                child: PhoneInputField(
                  controller: phoneInputController,
                  onInputFieldEnabled: () => finiteStateButtonController.nextState(),
                  onInputValidation: (bool isValidated) {
                    if (isActionEnabled && !isValidated) {
                      finiteStateButtonController.previousState();
                      setState(() => isActionEnabled = false);
                    } else if (!isActionEnabled && isValidated) {
                      finiteStateButtonController.nextState();
                      setState(() => isActionEnabled = true);
                    }
                  },
                ),
              ),
              // end: Phone Input Field

              Spacer(flex: 1,),

              // Call to Action
              RepaintBoundary(
                child: FiniteStateButton(
                  brightness: brightness,
                  controller: finiteStateButtonController,
                  states: <ButtonState>[
                    // Initial
                    const ButtonState(
                      value: kWelcomeCallToActionInitial,
                      onPressed: null,  // Not Enabled.
                    ),

                    // Waiting for Phone Number
                    const ButtonState(
                      value: kWelcomeCallToActionAwaiting,
                      isLabelBold: true,
                      onPressed: null,  // Not Enabled.
                    ),

                    // Validated Phone Number
                    ButtonState(
                      value: kWelcomeCallToActionContinue,
                      onPressed: () {/* Execute Sign In or Sign Up flow. */}
                    ),
                  ],
                ),
              ),
              // end: Call to Action

              Spacer(flex: 9,),

              // Branding
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                textDirection: TextDirection.ltr,
                verticalDirection: VerticalDirection.down,
                children: <Widget>[

                  // Tagline
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: SizedBox(
                      width: double.infinity, // Hack to expand Column - horizontally.
                      child: RichText(
                        text: TextSpan(
                          text: kWelcomeBrandTagline,
                          style: kGetDetailStyleFor(brightness: brightness),
                          children: <InlineSpan>[
                            TextSpan(
                              text: kWelcomeBrandTaglineName,
                              style: kGetDetailStyleFor(brightness: brightness)
                                        .copyWith(fontWeight: FontWeight.w600),
                            ),
                            TextSpan(text: kWelcomeBrandTaglineQuestionMark),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Tiger
                  Image.asset( _kTigerImagePath,
                    filterQuality: FilterQuality.high,
                    scale: _kTigerScale,
                  ),
                ],
              )
              // end: Branding
            ],
          ),
        ),
      ),
    );
  }
}