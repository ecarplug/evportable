import 'package:fish_redux/fish_redux.dart';

//TODO replace with your own action
enum EcarplugFindAction { action }

class EcarplugFindActionCreator {
  static Action onAction() {
    return const Action(EcarplugFindAction.action);
  }
}
