import 'package:fish_redux/fish_redux.dart';

//TODO replace with your own action
enum SaveAction { action }

class SaveActionCreator {
  static Action onAction() {
    return const Action(SaveAction.action);
  }
}
