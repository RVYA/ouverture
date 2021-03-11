import 'dart:async';
import 'package:flutter/foundation.dart' show required;

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuthException, PhoneAuthCredential, UserCredential;

import '../../data/user_cache.dart';
import '../../models/user.dart';
import '../../repositories/authentication_repository.dart';
import '../../repositories/user_repository.dart';


part 'authentication_state.dart';
part 'authentication_event.dart';


const Duration kAuthenticationTimeoutDuration = const Duration(minutes: 1);


class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc({
    @required this.authRepository,
    @required this.userCache,
    @required this.userRepository,
  })
    : super(AuthenticationInitial());

  final AuthenticationRepository authRepository;
  final UserCache userCache;
  final UserRepository userRepository;

  String _verificationId = kUnknown;


  @override
  Stream<AuthenticationState> mapEventToState(AuthenticationEvent event) async* {
    switch (event.type) {
      case AuthenticationEventType.appInitialized: {
        if (authRepository.currentUser != null) {
          this.add(
            AuthenticationEvent(
              type: AuthenticationEventType.userReturned,
              data: authRepository.currentUser.phoneNumber,
            ),
          );
        } else {
          yield AuthenticationInitial();
        }
      } break;

      case AuthenticationEventType.signInRequested: {
        yield AuthenticationSignInInProgress();

        // TODO: Implement empty callback related to automatic SMS code resolution.
        await authRepository.verifyPhoneNumber(
            event.data,
            onCodeAutoRetrievalTimeout: (_) {}, // Only be called on Android devices which support automatic SMS code resolution
            onCodeSent: (String verificationId, int resendToken) {
              _verificationId = verificationId;
            },
            onVerificationCompleted: (_) {}, // Only be called on Android devices which support automatic SMS code resolution
            onVerificationFailed: (FirebaseAuthException exception) {
              print(exception.toString());
            },
            timeoutDuration: kAuthenticationTimeoutDuration,
          );

        yield AuthenticationPhoneNumberVerificationInProgress();
      } break;

      case AuthenticationEventType.smsCodeEntered: {
        final PhoneAuthCredential phoneAuthCredential =
            authRepository.generatePhoneAuthCredential(
              smsCode: event.data,
              verificationId: _verificationId,
            );
        final UserCredential userCredential =
            await authRepository.signIn(authCredential: phoneAuthCredential);
        
        // TODO: Remove after testing.
        print("UID: ${userCredential.user.uid}, Phone Number: ${userCredential.user.phoneNumber}");
        print("Token: ${userCredential.credential.token}");

        // TODO: Continue implementing Sign-In flow.
      } break;

      case AuthenticationEventType.signOutRequested: {
        yield AuthenticationSignOutInProgress(user: userRepository.signedUser);

        await authRepository.signOut();
        await userCache.wipeUserCache();
              userRepository.signedUser = User.unknown;

        yield AuthenticationSignOutSuccessful();
      } break;

      case AuthenticationEventType.signUpRequested: {
        // TODO: Handle this case.
      } break;

      case AuthenticationEventType.userReturned: {
        yield AuthenticationSignInInProgress();

        final User cachedUser = await userCache.recoverUser();
        userRepository.signedUser = cachedUser;

        yield AuthenticationSignInSuccessful(user: cachedUser);
      } break;
    }
  }

  @override
  void onTransition(Transition<AuthenticationEvent, AuthenticationState> transition) {
    // TODO: Delete before production.
    super.onTransition(transition);
    print(transition);
  }
}