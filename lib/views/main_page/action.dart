import 'package:fish_redux/fish_redux.dart';

enum MainPageAction { action, tabchanged, showSnackBar }

class MainPageActionCreator {
  static Action onAction() {
    return const Action(MainPageAction.action);
  }

  static Action onTabChanged(int index) {
    return Action(MainPageAction.tabchanged, payload: index);
  }

  static Action showSnackBar(String message) {
    return Action(MainPageAction.showSnackBar, payload: message);
  }
}
