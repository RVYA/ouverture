import 'package:flutter/material.dart';

import '../../values/colours.dart';
import '../../values/strings.dart';
import '../../values/text_styles.dart';
import '../../widgets/fading_outlined_button.dart';
import '../../widgets/screen_horizontal_padding.dart';
import 'widgets/sms_code_field.dart';
import 'widgets/sms_code_numpad.dart';


class Verification extends StatefulWidget {
  @override
  _VerificationState createState() => _VerificationState();
}

class _VerificationState extends State<Verification> {
  final SmsCodeFieldController controller = SmsCodeFieldController();

  String? smsCodeInput;
// TODO: Implement verification. Integrate with Welcome screen. Add Sign Up Screen. Thank you future me. /tableflip
// TODO: Use User's name to greet them.
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimary,
      body: ScreenHorizontalPadding(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Column(
              children: <Widget>[
                Text( kVerificationTitle,
                  style: kGetMenuTitleStyleFor(brightness: Brightness.dark,),
                ),
                Text( kVerificationCallToAction,
                  style: kGetBodyStyleFor(brightness: Brightness.dark,),
                ),
              ],
            ),

            SmsCodeField(
              controller: controller,
              onChanged: (String value) => setState(() => smsCodeInput = value),
            ),

            SmsCodeNumpad(
              onPressed: (int number) {
                if (number == kNumpadRemoveValue) {
                  controller.remove();
                } else {
                  controller.write("$number");
                }
              },
            ),
          
            FadingOutlinedButton(
              brightness: Brightness.dark,
              text: kVerificationButtonVerify,
              onPressed: (controller.isFieldFilled())?
                  () {/*TODO: Implement.*/}
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}