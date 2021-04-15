import 'package:fish_redux/fish_redux.dart';

enum StartPageAction { action, setIsFirst, onStart, onGoogleSignIn }

class StartPageActionCreator {
  static Action onAction() {
    return const Action(StartPageAction.action);
  }

  static Action onStart() {
    return const Action(StartPageAction.onStart);
  }

  static Action onGoogleSignIn() {
    return Action(StartPageAction.onGoogleSignIn);
  }

  static Action setIsFirst(bool isFirst) {
    return Action(StartPageAction.setIsFirst, payload: isFirst);
  }
}
