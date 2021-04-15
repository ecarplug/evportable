import 'package:fish_redux/fish_redux.dart';

import 'package:fish_redux/fish_redux.dart';

enum ProfileViewAction {
  action,
  uploadBackground,
  setBackground,
  setLoading,
  submit,
  onComment,
  onLikeButtonTapped,
  onJoinDelete,
  onDelete,
  joinCount,
  themaList,
  showSnackBar,
  goChat,
  refresh,
  gotoNext,
}

class ProfileViewActionCreator {
  static Action onAction() {
    return const Action(ProfileViewAction.action);
  }

  static Action onSubmit() {
    return const Action(ProfileViewAction.submit);
  }

  static Action onComment() {
    return const Action(ProfileViewAction.onComment);
  }

  static Action onDelete({Object d}) {
    return Action(ProfileViewAction.onDelete, payload: d);
  }

  static Action onJoinDelete() {
    return const Action(ProfileViewAction.onJoinDelete);
  }

  static Action joinCount(String joinCount) {
    return const Action(ProfileViewAction.joinCount);
  }

  static Action onLikeButtonTapped(String message) {
    return const Action(ProfileViewAction.onLikeButtonTapped);
  }

  static Action themaList() {
    return const Action(ProfileViewAction.themaList);
  }

  static Action uploadBackground() {
    return const Action(ProfileViewAction.uploadBackground);
  }

  static Action setBackground(String url) {
    return Action(ProfileViewAction.setBackground, payload: url);
  }

  static Action refresh() {
    return Action(ProfileViewAction.refresh);
  }

  static Action goChat({Object d}) {
    return Action(ProfileViewAction.goChat, payload: d);
  }

  static Action setLoading(bool loading) {
    return Action(ProfileViewAction.setLoading, payload: loading);
  }

  static Action showSnackBar(String message) {
    return Action(ProfileViewAction.showSnackBar, payload: message);
  }

  static Action gotoNextPage() {
    return Action(ProfileViewAction.gotoNext);
  }
}
