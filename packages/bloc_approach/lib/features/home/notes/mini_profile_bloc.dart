import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_firebase_auth_blueprint_common/data/model/auth_state.dart';
import 'package:flutter_firebase_auth_blueprint_common/data/model/user.dart';
import 'package:flutter_firebase_auth_blueprint_common/data/repository/auth_repository.dart';

abstract class MiniProfileState {}

class EmptyUser extends MiniProfileState {}

class ProfileInfo extends MiniProfileState {
  final User user;

  ProfileInfo(this.user);
}

class MiniProfileBloc extends Bloc<AuthState, MiniProfileState> {
  final AuthRepository _authRepository;

  StreamSubscription _authSubscription;

  MiniProfileBloc(this._authRepository) {
    _observeAuthChanges();
  }

  @override
  MiniProfileState get initialState => EmptyUser();

  @override
  Stream<MiniProfileState> mapEventToState(AuthState event) async* {
    switch (event.runtimeType) {
      case Unauthenticated:
        yield EmptyUser();
        break;

      case Authenticated:
        final user = (event as Authenticated).user;
        yield ProfileInfo(user);
        break;
    }
  }

  @override
  Future<void> close() {
    _authSubscription?.cancel();
    return super.close();
  }

  void _observeAuthChanges() {
    _authSubscription = _authRepository.authState().listen(add);
  }
}
