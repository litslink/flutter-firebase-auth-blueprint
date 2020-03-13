abstract class EditProfileEvent {}

class NameChanged extends EditProfileEvent {
  final String name;

  NameChanged(this.name);
}

class ConfirmChanges extends EditProfileEvent {}
