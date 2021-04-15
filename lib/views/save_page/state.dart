import 'package:fish_redux/fish_redux.dart';

class SaveState implements Cloneable<SaveState> {

  @override
  SaveState clone() {
    return SaveState();
  }
}

SaveState initState(Map<String, dynamic> args) {
  return SaveState();
}
