import 'package:equatable/equatable.dart';

class Note extends Equatable {
  final String id;
  final String title;
  final String text;

  Note(
    this.id,
    this.title,
    this.text);

  @override
  List<Object> get props => [id, title, text];
}
