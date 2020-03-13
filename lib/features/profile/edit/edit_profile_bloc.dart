import 'package:bloc/bloc.dart';

import '../../../model/user.dart';
import '../../../repository/auth_repository.dart';
import 'edit_profile_event.dart';
import 'edit_profile_state.dart';

class EditProfileBloc extends Bloc<EditProfileEvent, EditProfileState> {

  final User user;
  final AuthRepository authRepository;
  User _currentUser;

  EditProfileBloc(this.user, this.authRepository) {
    _currentUser = user;
  }

  @override
  EditProfileState get initialState => ProfileInfo(user);

  @override
  Stream<EditProfileState> mapEventToState(EditProfileEvent event) async* {
    if (event is NameChanged) {
      _currentUser = _currentUser.copyWith(
        displayName: event.name
      );
    } else if (event is ConfirmChanges) {
      yield Loading();
      var containsChanges = false;
      containsChanges |= await authRepository
          .updateUserName(_currentUser.displayName);
      containsChanges |= await authRepository
          .updatePhotoUrl(_currentUser.photoUrl);
      yield EditCompleted(containsChanges);
    }
  }
}
