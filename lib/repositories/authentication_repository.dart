import 'package:flutter/material.dart' show BuildContext, required;

import 'package:country_codes/country_codes.dart';
import 'package:firebase_auth/firebase_auth.dart';


class AuthenticationRepository {
  AuthenticationRepository()
    : this._auth = FirebaseAuth.instance
                    ..setLanguageCode(CountryCodes.deviceLocale.languageCode);
  

  final FirebaseAuth _auth;

  User get currentUser => _auth.currentUser;


  PhoneAuthCredential generatePhoneAuthCredential({
    @required String smsCode,
    @required String verificationId,
  }) {
    return
      PhoneAuthProvider.credential(
        smsCode: smsCode,
        verificationId: verificationId
      );
  }

  Future<UserCredential> signIn({@required AuthCredential authCredential,}) {
    return _auth.signInWithCredential(authCredential);
  }

  Future<void> signOut() => _auth.signOut();

  Future<void> verifyPhoneNumber(
    phoneNumber, {
    //@required BuildContext context, // ???
    @required void Function(String verificationID) onCodeAutoRetrievalTimeout,
    @required void Function(String verificationID, int forceResendingToken) onCodeSent,
    @required void Function(PhoneAuthCredential) onVerificationCompleted,
    @required void Function(FirebaseAuthException) onVerificationFailed,
    @required Duration timeoutDuration,
  }) {
    return
      _auth.verifyPhoneNumber(
        phoneNumber             : phoneNumber,
        codeAutoRetrievalTimeout: onCodeAutoRetrievalTimeout,
        codeSent                : onCodeSent,
        verificationCompleted   : onVerificationCompleted,
        verificationFailed      : onVerificationFailed,
        timeout                 : timeoutDuration,
      );
  }
}