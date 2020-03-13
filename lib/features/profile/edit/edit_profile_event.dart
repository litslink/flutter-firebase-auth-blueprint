import 'dart:io';

abstract class EditProfileEvent {}

class NameChanged extends EditProfileEvent {
  final String name;

  NameChanged(this.name);
}

class PhotoChanged extends EditProfileEvent {
  final File photo;

  PhotoChanged(this.photo);
}

class ConfirmChanges extends EditProfileEvent {}
