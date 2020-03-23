import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String email;
  final String displayName;
  final String photoUrl;
  final String phoneNumber;
  final String id;

  User(this.email, this.displayName, this.photoUrl, this.phoneNumber, this.id);

  @override
  List<Object> get props => [email, displayName, photoUrl, phoneNumber, id];

  User copyWith({
    String displayName,
    String photoUrl
  }) => User(
      email,
      displayName ?? this.displayName,
      photoUrl ?? this.photoUrl,
      phoneNumber,
      id
  );
}
