import 'dart:io' as io;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:image_picker/image_picker.dart';

import '../../values/colours.dart';
import '../../values/decorations.dart';
import '../../values/strings.dart';
import '../../values/text_styles.dart';
import '../../widgets/fading_outlined_button.dart';
import '../../widgets/photograph_frame.dart';
import '../../widgets/screen_horizontal_padding.dart';
import '../../widgets/secondary_action_button.dart';


// Finish photo selection. Finish dialog. Implement. Thank you future me ^.^
class Introduction extends StatefulWidget {
  @override
  _IntroductionState createState() => _IntroductionState();
}

class _IntroductionState extends State<Introduction> {
  String forename, surname;
  io.File image;


  bool isIntroductionCompleted() {
    return
      (forename != null && forename.isNotEmpty)
      && (surname != null && surname.isNotEmpty)
      && image != null;
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle
        styleTitle = kGetMenuTitleStyleFor(brightness: Brightness.dark),
        styleBody = kGetBodyStyleFor(brightness: Brightness.dark);

    return Scaffold(
      backgroundColor: kPrimary,
      body: ScreenHorizontalPadding(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            // Title & Call to Action
            Flexible(
              flex: 1,
              child: Column(
                children: <Widget>[
                  Text( kIntroductionTitle,
                    style: styleTitle,
                  ),
                  RichText(
                    text: TextSpan(
                      style: styleBody,
                      text: kIntroductionGreeting,
                      children: <InlineSpan>[
                        TextSpan(
                          style: styleBody.copyWith(fontStyle: FontStyle.italic,),
                          text: kIntroductionSelfIntroduction,
                        ),
                      ],
                    ),
                  ),
                  Text( kIntroductionCallToAction,
                    style: styleBody,
                  ),
                ],
              ),
            ),

            // Details
            Flexible(
              flex: 2,
              child: _DetailField(
                hintText: kIntroductionDetailForename,
                onSubmitted: (String input) {
                  setState(() => forename = input);
                },
              ),
            ),
            Flexible(
              flex: 2,
              child: _DetailField(
                hintText: kIntroductionDetailSurname,
                onSubmitted: (String input) {
                  setState(() => surname = input);
                },
              ),
            ),
            Flexible(
              flex: 2,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Flexible(
                    flex: 1,// TODO: Implement image picker
                    child: SecondaryActionButton(   // TODO: Add a secondary colour.
                      brightness: Brightness.dark,
                      icon: Icon(Icons.add_a_photo_rounded,),
                      onPressed: () {/*TODO:Implement take photo function*/},
                    ),
                  ),
                  PhotographFrame(
                    flex: 2,
                    brightness: Brightness.dark,
                    photograph: image,
                  ),
                  //Spacer(),
                ],
              ),
            ),

            // Request Consent
            Flexible(
              flex: 1,
              child: FadingOutlinedButton(
                brightness: Brightness.dark,
                text: kIntroductionButtonContinue,
                onPressed: (isIntroductionCompleted())?
                    () {}
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


const String
  _kDetailInputCharactersDenied = r"[^a-zA-ZçÇğıİöÖşŞüÜ ]";

class _DetailField extends StatelessWidget {
  const _DetailField({
    @required this.hintText,
    @required this.onSubmitted,
  });

  final String hintText;
  final void Function(String) onSubmitted;


  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: kGetInputDecorationFor(
        brightness: Brightness.dark,
        labelText: hintText,
      ),
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.deny(RegExp(_kDetailInputCharactersDenied,),),
      ],
      keyboardType: TextInputType.name,
      onSubmitted: (String value) => onSubmitted(value),
      textCapitalization: TextCapitalization.words,
      textInputAction: TextInputAction.next,
      style: kGetBodyStyleFor(brightness: Brightness.dark,),
    );
  }
}


// TODO: Implement this after designing the screen.
// *Reference: https://api.flutter.dev/flutter/widgets/SingleChildScrollView-class.html
// ignore: unused_element
class _ScrollingColumn extends StatelessWidget {
  const _ScrollingColumn({
    @required this.children,
  });

  final List<Widget> children;


  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext buildContext, BoxConstraints viewportConstraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: viewportConstraints.maxHeight,
            ),
            child: IntrinsicHeight(
              child: ScreenHorizontalPadding(
                child: Column(children: children,),
              ),
            ),
          ),
        );
      },
    );
  }
}