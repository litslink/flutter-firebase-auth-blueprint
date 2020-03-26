import 'package:flutter/foundation.dart';

abstract class BaseModel<State> extends ChangeNotifier {

  State get initialState;
  State _state;

  BaseModel() {
    _state = initialState;
  }

  State get state => _state;
  set state(State state) {
    _state = state;
    notifyListeners();
  }

  void notify(VoidCallback callback) {
    callback();
    notifyListeners();
  }
}
