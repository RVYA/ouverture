part of 'authentication_bloc.dart';


enum AuthenticationStatus { authenticated, unauthenticated, }


abstract class AuthenticationState<D extends Object> extends Equatable {
  const AuthenticationState({required this.data,});

  final D? data;

  @override
  List<Object?> get props => (data != null)? <D>[data!,] : List<Object>.empty();
}


class AuthenticationInitial extends AuthenticationState<Object> {
  const AuthenticationInitial()
    : super(data: null,);
}


class AuthenticationSignInFailure extends AuthenticationState<Exception> {
  const AuthenticationSignInFailure({required Exception exception,})
    : super(data: exception,);
}
// TODO: Check AuthSignInInProgress state when other sign-in methods are implemented.
class AuthenticationSignInInProgress extends AuthenticationState<String> {
  const AuthenticationSignInInProgress({required String phoneNumber,})
    : super(data: phoneNumber,);
}

class AuthenticationSignInSuccessful extends AuthenticationState<User> {
  const AuthenticationSignInSuccessful({required User user,})
    : super(data: user,);
}


class AuthenticationPhoneNumberVerificationInProgress
    extends AuthenticationState<String> {
  const AuthenticationPhoneNumberVerificationInProgress({
    required String verificationId,
  })
    : super(data: verificationId,);
}

class AuthenticationPhoneNumberVerificationSuccessful
    extends AuthenticationState<Object> {
  const AuthenticationPhoneNumberVerificationSuccessful()
    : super(data: null);
}

class AuthenticationPhoneNumberVerificationFailure
    extends AuthenticationState<Exception> {
  const AuthenticationPhoneNumberVerificationFailure({
    required Exception exception,
  })
    : super(data: exception,);
}


class AuthenticationSignUpFailure extends AuthenticationState<Exception> {
  const AuthenticationSignUpFailure({required Exception exception,})
    : super(data: exception,);
}

class AuthenticationSignUpInProgress extends AuthenticationState<String> {
  const AuthenticationSignUpInProgress({required String phoneNumber,})
    : super(data: phoneNumber,);
}

class AuthenticationSignUpSuccessful extends AuthenticationState<User> {
  const AuthenticationSignUpSuccessful({required User user,})
    : super(data: user,);
}


class AuthenticationSignOutInProgress extends AuthenticationState<Object> {
  const AuthenticationSignOutInProgress()
    : super(data: null,);
}

class AuthenticationSignOutSuccessful extends AuthenticationState<Object> {
  const AuthenticationSignOutSuccessful()
    : super(data: null,);
}