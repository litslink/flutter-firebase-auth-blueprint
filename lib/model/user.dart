import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String email;
  final String displayName;
  final String photoUrl;
  final String phoneNumber;

  User(this.email, this.displayName, this.photoUrl, this.phoneNumber);

  @override
  List<Object> get props => [email, displayName, photoUrl, phoneNumber];

  User copyWith({
    String displayName,
    String photoUrl
  }) => User(
      email,
      displayName ?? this.displayName,
      photoUrl ?? this.photoUrl,
      phoneNumber
  );
}
