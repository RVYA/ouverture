part of 'authentication_bloc.dart';


enum AuthenticationEventType {
  appInitialized,
  signInRequested,
  signInScreenBuilt,
  smsCodeEntered,
  signOutRequested,
  signUpRequested,
  signUpScreenBuilt,
  signUpDataSupplied,
  userReturned,
}


class AuthenticationEvent<T extends Object?> extends Equatable {
  const AuthenticationEvent({
    required this.type,
    required this.data,
  });

  final AuthenticationEventType type;
  final T? data;
  
  
  @override
  List<Object> get props => <Object>[ this.type, this.data ?? "UNKNOWN", ];
}


class AuthenticationAppInitialized extends AuthenticationEvent<String> {
  const AuthenticationAppInitialized()
    : super(
        type: AuthenticationEventType.appInitialized,
        data: null,
      );
}

class AuthenticationSignInRequested extends AuthenticationEvent<String> {
  const AuthenticationSignInRequested({required String phoneNumber,})
    : super(
        type: AuthenticationEventType.signInRequested,
        data: phoneNumber,
      );
}

class AuthenticationSignInScreenBuilt extends AuthenticationEvent<Object> {
  const AuthenticationSignInScreenBuilt()
    : super(
        type: AuthenticationEventType.signInScreenBuilt,
        data: null,
      );
}

class AuthenticationSmsCodeEntered
    extends AuthenticationEvent<
        Map<PhoneNumberVerificationRequirement, String>
    > {
  AuthenticationSmsCodeEntered({
    required String verificationId,
    required String smsCode,
  })
    : super(
        type: AuthenticationEventType.smsCodeEntered,
        data: <PhoneNumberVerificationRequirement, String>{
          _kReqVerificationId: verificationId,
          _kReqSmsCode       : smsCode,
        },
      );
}

class AuthenticationSignOutRequested extends AuthenticationEvent<String> {
  const AuthenticationSignOutRequested()
    : super(
        type: AuthenticationEventType.signOutRequested,
        data: null,
      );
}

class AuthenticationSignUpRequested extends AuthenticationEvent<String> {
  const AuthenticationSignUpRequested({required String phoneNumber})
    : super(
        type: AuthenticationEventType.signOutRequested,
        data: phoneNumber,
      );
}

class AuthenticationSignUpScreenBuilt extends AuthenticationEvent<Object> {
  const AuthenticationSignUpScreenBuilt()
    : super(
        type: AuthenticationEventType.signUpScreenBuilt,
        data: null,
      );
}

class AuthenticationSignUpDataSupplied
    extends AuthenticationEvent<Map<IntroductionData, dynamic>> {
  AuthenticationSignUpDataSupplied({
    required String forename,
    required String surname,
    required String phoneNumber,
    required io.File photograph,
    required Place place,
  })
    : super(
        type: AuthenticationEventType.signUpDataSupplied,
        data: <IntroductionData, dynamic>{
          IntroductionData.forename   : forename,
          IntroductionData.surname    : surname,
          IntroductionData.phoneNumber: phoneNumber,
          IntroductionData.photograph : photograph,
          IntroductionData.place      : place,
        },
      );
}

class AuthenticationUserReturned extends AuthenticationEvent<String> {
  const AuthenticationUserReturned({required String id,})
    : super(
        type: AuthenticationEventType.userReturned,
        data: id,
      );
}