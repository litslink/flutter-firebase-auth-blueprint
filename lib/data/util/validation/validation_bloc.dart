import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_firebase_auth_blueprint/data/util/validation/validation_state.dart';
import 'package:flutter_firebase_auth_blueprint/data/util/validation/validators.dart';

class ValidationBloc extends Bloc<String, ValidationState> {

  final Validator validator;

  ValidationBloc(this.validator);

  @override
  ValidationState get initialState => Empty();

  @override
  Stream<ValidationState> mapEventToState(String event) async* {
    if (validator.validate(event)) {
      yield Valid(event);
    } else {
      yield Invalid();
    }
  }
}
