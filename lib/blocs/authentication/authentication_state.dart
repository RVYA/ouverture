part of 'authentication_bloc.dart';


enum AuthenticationStatus { authenticated, unauthenticated, }


abstract class AuthenticationState extends Equatable {
  const AuthenticationState({
    @required this.status,
    @required this.user,
  });

  final AuthenticationStatus status;
  final User user;

  @override
  List<Object> get props => <Object>[ status, user, ];
}


class AuthenticationInitial extends AuthenticationState {
  const AuthenticationInitial()
    : super(
        status: AuthenticationStatus.unauthenticated,
        user: null,
      );
}


class AuthenticationSignInFailure extends AuthenticationState {
  const AuthenticationSignInFailure()
    : super(
        status: AuthenticationStatus.unauthenticated,
        user: null,
      );
}

class AuthenticationSignInInProgress extends AuthenticationState {
  const AuthenticationSignInInProgress()
    : super(
        status: AuthenticationStatus.unauthenticated,
        user: null,
      );
}

class AuthenticationSignInSuccessful extends AuthenticationState {
  const AuthenticationSignInSuccessful({@required User user,})
    : super(
        status: AuthenticationStatus.authenticated,
        user: user,
      );
}


class AuthenticationSignUpFailure extends AuthenticationState {
  const AuthenticationSignUpFailure()
    : super(
        status: AuthenticationStatus.unauthenticated,
        user: null,
      );
}

class AuthenticationSignUpInProgress extends AuthenticationState {
  const AuthenticationSignUpInProgress()
    : super(
        status: AuthenticationStatus.unauthenticated,
        user: null,
      );
}

class AuthenticationSignUpSuccessful extends AuthenticationState {
  const AuthenticationSignUpSuccessful({@required User user,})
    : super(
        status: AuthenticationStatus.unauthenticated,
        user: user,
      );
}


class AuthenticationSignOutInProgress extends AuthenticationState {
  const AuthenticationSignOutInProgress({@required User user,})
    : super(
        status: AuthenticationStatus.authenticated,
        user: user,
      );
}

class AuthenticationSignOutSuccessful extends AuthenticationInitial {}