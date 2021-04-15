import 'package:fish_redux/fish_redux.dart';

class EcarplugBLEState implements Cloneable<EcarplugBLEState> {

  @override
  EcarplugBLEState clone() {
    return EcarplugBLEState();
  }
}

EcarplugBLEState initState(Map<String, dynamic> args) {
  return EcarplugBLEState();
}
