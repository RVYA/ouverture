import 'dart:async';
import 'dart:io' as io;

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart'
    show FirebaseAuthException, PhoneAuthCredential, UserCredential;
import 'package:ouverture/screens/introduction/introduction.dart';

import '../../data/user_cache.dart';
import '../../models/place.dart';
import '../../models/user.dart';
import '../../repositories/authentication_repository.dart';
import '../../repositories/user_repository.dart';


part 'authentication_state.dart';
part 'authentication_event.dart';


enum PhoneNumberVerificationRequirement {
  verificationId, smsCode,
}

const PhoneNumberVerificationRequirement
  _kReqVerificationId = PhoneNumberVerificationRequirement.verificationId,
  _kReqSmsCode = PhoneNumberVerificationRequirement.smsCode;


const Duration kAuthenticationTimeoutDuration = const Duration(minutes: 1);


class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc()
    : this.authRepository = AuthenticationRepository(),
      this.userCache = UserCache(),
      this.userRepository = UserRepository(),
      super(AuthenticationInitial());

  final AuthenticationRepository authRepository;
  final UserCache userCache;
  final UserRepository userRepository;


  @override
  Stream<AuthenticationState> mapEventToState(AuthenticationEvent event) async* {
    switch (event.type) {
      case AuthenticationEventType.appInitialized: {
        if (authRepository.currentUser != null) {
          this.add(
            AuthenticationEvent(
              type: AuthenticationEventType.userReturned,
              data: authRepository.currentUser!.phoneNumber!,
            ),
          );
        } else {
          yield AuthenticationInitial();
        }
      } break;

      case AuthenticationEventType.signInRequested: {
        yield AuthenticationSignInInProgress(phoneNumber: event.data! as String,);

        String? _verificationId;

        // TODO: Implement empty callback related to automatic SMS code resolution.
        await authRepository.verifyPhoneNumber(
            event.data,
            onCodeAutoRetrievalTimeout: (_) {}, // Only be called on Android devices which support automatic SMS code resolution
            onCodeSent: (String verificationId, int? resendToken) {
              _verificationId = verificationId;
            },
            onVerificationCompleted: (_) {}, // Only be called on Android devices which support automatic SMS code resolution
            onVerificationFailed: (FirebaseAuthException exception) {
              print(exception.toString());
            },
            timeoutDuration: kAuthenticationTimeoutDuration,
          );

        yield AuthenticationPhoneNumberVerificationInProgress(
            verificationId: _verificationId!
          );
      } break;

      case AuthenticationEventType.smsCodeEntered: {
        final Map<PhoneNumberVerificationRequirement, String>
          requirements = event.data!
              as Map<PhoneNumberVerificationRequirement, String>;

        final PhoneAuthCredential phoneAuthCredential =
            authRepository.generatePhoneAuthCredential(
              smsCode: requirements[_kReqSmsCode]!,
              verificationId: requirements[_kReqVerificationId]!,
            );
        
        UserCredential userCredential;
        try {
          userCredential =
            await authRepository.signIn(authCredential: phoneAuthCredential);
        } catch (e) {
          yield AuthenticationSignInFailure(exception: e as Exception,);
          return;
        }
        
        // TODO: Remove after testing.
        print("UID: ${userCredential.user!.uid}, Phone Number: ${userCredential.user!.phoneNumber}");
        print("Token: ${userCredential.credential!.token}");

        User signedUser = User.unknown;
        if (userCredential.additionalUserInfo!.isNewUser) {
          signedUser = userRepository.signedUser;
        } else {
          signedUser =
              await userRepository.getUserWith(id: userCredential.user!.uid);
        }
        
        yield AuthenticationSignInSuccessful(user: signedUser);
      } break;

      case AuthenticationEventType.signOutRequested: {
        yield AuthenticationSignOutInProgress();

        await authRepository.signOut();
        await userCache.wipeUserCache();
              userRepository.signedUser = User.unknown;

        yield AuthenticationSignOutSuccessful();
      } break;

      case AuthenticationEventType.signUpRequested: {
        yield AuthenticationSignUpInProgress(
            phoneNumber: event.data! as String,
          );
      } break;

      case AuthenticationEventType.signUpDataSupplied: {
        final User recordedUser =
            await userRepository.addUser(event.data! as User,);

        userRepository.signedUser = recordedUser;

        yield AuthenticationSignUpSuccessful(user: recordedUser);

        this.add(
          AuthenticationSignInRequested(phoneNumber: recordedUser.phoneNumber,),
        );
      } break;

      case AuthenticationEventType.userReturned: {
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