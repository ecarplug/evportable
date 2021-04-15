import 'package:fish_redux/fish_redux.dart';

//TODO replace with your own action
enum ToolsRentAction { action }

class ToolsRentActionCreator {
  static Action onAction() {
    return const Action(ToolsRentAction.action);
  }
}
