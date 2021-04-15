import 'package:fish_redux/fish_redux.dart';

enum HeaderAction { action, headerFilterChanged, onCellTapped }

class HeaderActionCreator {
  static Action onAction() {
    return const Action(HeaderAction.action);
  }

  static Action cellTapped(int index) {
    return Action(HeaderAction.onCellTapped, payload: [index]);
  }

  static Action onHeaderFilterChanged(bool e) {
    return Action(HeaderAction.headerFilterChanged, payload: e);
  }
}
