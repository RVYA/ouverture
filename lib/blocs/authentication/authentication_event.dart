part of 'authentication_bloc.dart';


enum AuthenticationEventType {
  appInitialized,
  signInRequested,
  signOutRequested,
  signUpRequested,
  userReturned,
}


class AuthenticationEvent extends Equatable {
  const AuthenticationEvent({
    @required this.type,
    @required this.phoneNumber,
  })
    : assert(
        phoneNumber != null,
        "Phone number is used for authentication; "
          "therefore, it should be specified.",
      );

  final AuthenticationEventType type;
  final String phoneNumber;
  
  
  @override
  List<Object> get props => <Object>[ this.type, this.phoneNumber, ];
}