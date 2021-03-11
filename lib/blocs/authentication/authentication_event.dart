part of 'authentication_bloc.dart';


enum AuthenticationEventType {
  appInitialized,
  signInRequested,
  smsCodeEntered,
  signOutRequested,
  signUpRequested,
  userReturned,
}


class AuthenticationEvent extends Equatable {
  const AuthenticationEvent({
    @required this.type,
    @required this.data,
  })
    : assert(data != null,);

  final AuthenticationEventType type;
  final String data;
  
  
  @override
  List<Object> get props => <Object>[ this.type, this.data, ];
}