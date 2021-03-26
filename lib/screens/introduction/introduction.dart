import 'dart:io' as io;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../blocs/authentication/authentication_bloc.dart';
import '../../models/place.dart';
import '../../values/colours.dart';
import '../../values/decorations.dart';
import '../../values/routes.dart';
import '../../values/strings.dart';
import '../../values/text_styles.dart';
import '../../widgets/fading_outlined_button.dart';
import '../../widgets/fading_elevated_button.dart';
import '../../widgets/photograph_frame.dart';
import '../../widgets/screen_horizontal_padding.dart';
import '../../widgets/secondary_action_button.dart';
import '../../widgets/bottom_dialog/bottom_dialog.dart';


enum IntroductionData {
  forename,
  surname,
  phoneNumber,
  photograph,
  place,
}


// TODO: Add Image Cropping.
// TODO: Write an Terms & Services agreement on Sign-Up Consent Dialog.
// TODO: Customize CircleAvatar widget to a custom shape.
class Introduction extends StatefulWidget {
  @override
  _IntroductionState createState() => _IntroductionState();
}


class _IntroductionState extends State<Introduction> {
  String? phoneNumber;
  String? forename, surname;
  io.File? image;
  Place? place;


  bool isIntroductionCompleted() {
    return
      (forename != null && forename!.isNotEmpty)
      && (surname != null && surname!.isNotEmpty)
      && image != null;
  }

  Future<io.File?> pickImage(BuildContext context) {
    final ImagePicker imagePicker = ImagePicker();
    final TextStyle buttonLabelStyle =
        kGetDetailStyleFor(brightness: Brightness.light,);

    return
      BottomDialog.showBottomDialog<io.File>(
        context,
        innerPadding: EdgeInsets.symmetric(vertical: 9.0,),
        title: kIntroductionPickImageTitle,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            TextButton.icon(
              icon: Icon(Icons.photo_camera_rounded,),
              label: Text( kIntroductionPickImageButtonLabelTakePhoto,
                style: buttonLabelStyle,
              ),
              onPressed: () async {
                final PickedFile? pickedImage = await imagePicker.getImage(
                    source: ImageSource.camera,
                    imageQuality: 70,
                    preferredCameraDevice: CameraDevice.front,
                  );
                Navigator.pop(context, io.File(pickedImage!.path));
              }
            ),
            TextButton.icon(
              icon: Icon(Icons.photo_library_rounded,),
              label: Text( kIntroductionPickImageButtonLabelPickFromLibrary,
                style: buttonLabelStyle,
              ),
              onPressed: () async {
                final PickedFile? pickedImage = await imagePicker.getImage(
                    source: ImageSource.gallery,
                    imageQuality: 70,
                    preferredCameraDevice: CameraDevice.front,
                  );
                Navigator.pop(context, io.File(pickedImage!.path));
              }
            ),
          ],
        ),
      );
  }

  Future<void> requestConsent(BuildContext context) {
    final Brightness dialogBrightness = Brightness.light;

    return BottomDialog.showBottomDialog<void>(
      context,
      title: kIntroductionConsentDialogTitle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text( kIntroductionConsentBodyInformation,
            style: kGetBodyStyleFor(brightness: dialogBrightness,),
          ),
          FadingElevatedButton(
            brightness: dialogBrightness,
            isTextBold: true,
            text: kIntroductionConsentButtonAgree,
            onPressed: () {
              BlocProvider.of<AuthenticationBloc>(context)
                .add(
                  AuthenticationSignUpDataSupplied(
                    forename: forename!,
                    surname: surname!,
                    phoneNumber: phoneNumber!,
                    photograph: image!,
                    place: place!,
                  ),
                );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final AuthenticationBloc authBloc =
        BlocProvider.of<AuthenticationBloc>(context);

    final TextStyle
      styleTitle = kGetMenuTitleStyleFor(brightness: Brightness.dark),
      styleBody = kGetBodyStyleFor(brightness: Brightness.dark);

    return Scaffold(
      backgroundColor: kPrimary,
      body: BlocListener<AuthenticationBloc, AuthenticationState>(
        listener: (BuildContext lContext, AuthenticationState state) async {
          if (state is AuthenticationSignUpFailure) {
            throw state.data!;
          } else if (state is AuthenticationSignUpSuccessful) {
            await Navigator.popAndPushNamed<void, void>(
              lContext,
              Routes.verification.value,
            ); // TODO: Migrate to normal routing.

            authBloc.add(
              AuthenticationSignInRequested(phoneNumber: phoneNumber!,),
            );
          }
        },
        child: ScreenHorizontalPadding(
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
                        text: "$kIntroductionGreeting ",
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
                      flex: 1,
                      child: SecondaryActionButton(
                        brightness: Brightness.dark,
                        icon: Icon(Icons.add_a_photo_rounded,),
                        onPressed: () async {
                          final io.File? pickedFile = await pickImage(context);
                          setState(() => image = pickedFile);
                        },
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
                      () => requestConsent(context)
                      : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


const String
  _kDetailInputCharactersDenied = r"[^a-zA-ZçÇğıİöÖşŞüÜ ]";

class _DetailField extends StatelessWidget {
  const _DetailField({
    required this.hintText,
    required this.onSubmitted,
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
    required this.children,
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