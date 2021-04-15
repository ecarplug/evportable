import 'package:fish_redux/fish_redux.dart';

//TODO replace with your own action
enum EcarplugBLEAction { action }

class EcarplugBLEActionCreator {
  static Action onAction() {
    return const Action(EcarplugBLEAction.action);
  }
}
