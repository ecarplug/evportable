import 'package:fish_redux/fish_redux.dart';

//TODO replace with your own action
enum ItemDetailAction { action, detailList, reflash, reflashFromFirebase }

class ItemDetailActionCreator {
  static Action onAction() {
    return const Action(ItemDetailAction.action);
  }

  static Action detailList({Object d}) {
    return Action(ItemDetailAction.detailList, payload: d);
  }

  static Action reflash({Object d}) {
    return Action(ItemDetailAction.reflash, payload: d);
  }

  static Action reflashFromFirebase(List d) {
    return Action(ItemDetailAction.reflashFromFirebase, payload: d);
  }
}
