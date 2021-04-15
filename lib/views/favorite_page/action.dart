import 'package:fish_redux/fish_redux.dart';

//TODO replace with your own action
enum FavoriteAction { action }

class FavoriteActionCreator {
  static Action onAction() {
    return const Action(FavoriteAction.action);
  }
}
