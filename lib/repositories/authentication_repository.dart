import 'package:flutter/material.dart' show BuildContext, required;

import 'package:country_codes/country_codes.dart';
import 'package:firebase_auth/firebase_auth.dart';


class AuthenticationRepository {
  AuthenticationRepository()
    : this._auth = FirebaseAuth.instance
                    ..setLanguageCode(CountryCodes.deviceLocale.languageCode);
  

  final FirebaseAuth _auth;

  User get currentUser => _auth.currentUser;


  Future<void> signInWithPhoneNumber(
    String phoneNumber,{
    @required void Function(String verificationID) onCodeAutoRetrievalTimeout,
    @required void Function(String verificationID, int foreceResendingToken) onCodeSent,
    @required void Function(UserCredential) onVerificationCompleted,
    @required void Function(FirebaseAuthException) onVerificationFailed,
    Duration timeoutDuration,
  }) {
    return
      _verifyPhoneNumber( phoneNumber,
        onCodeAutoRetrievalTimeout: onCodeAutoRetrievalTimeout,
        onCodeSent                : onCodeSent,
        onVerificationCompleted   : (AuthCredential authCredential) async {
          onVerificationCompleted(await _signIn(authCredential: authCredential));
        },
        onVerificationFailed: onVerificationFailed,
        timeoutDuration: timeoutDuration,
      );
  }

  Future<void> signOut() => _auth.signOut();

  Future<UserCredential> _signIn({
    @required AuthCredential authCredential,
  }) async {
    return
      await _auth.signInWithCredential(authCredential);
  }

  Future<void> _verifyPhoneNumber(
    phoneNumber, {
    //@required BuildContext context, // ???
    @required void Function(String verificationID) onCodeAutoRetrievalTimeout,
    @required void Function(String verificationID, int forceResendingToken) onCodeSent,
    @required void Function(PhoneAuthCredential) onVerificationCompleted,
    @required void Function(FirebaseAuthException) onVerificationFailed,
    Duration timeoutDuration = const Duration(minutes: 1),
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