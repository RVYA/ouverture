import 'dart:async';
import 'package:flutter/foundation.dart' show required;

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ouverture/repositories/user_repository.dart';

import '../../data/user_cache.dart';
import '../../models/user.dart';
import '../../repositories/authentication_repository.dart';


part 'authentication_state.dart';
part 'authentication_event.dart';


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


  // TODO(me): Refactor to use an ID for users instead of phone number.
  @override
  Stream<AuthenticationState> mapEventToState(AuthenticationEvent event) async* {
    switch (event.type) {
      case AuthenticationEventType.appInitialized: {
        if (authRepository.currentUser != null) {
          this.add(
            AuthenticationEvent(
              type: AuthenticationEventType.userReturned,
              phoneNumber: authRepository.currentUser.phoneNumber,
            ),
          );
        } else {
          yield AuthenticationInitial();
        }
      } break;

      case AuthenticationEventType.signInRequested: {
        // TODO: Handle this case.
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