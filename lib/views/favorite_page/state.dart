import 'package:fish_redux/fish_redux.dart';

class FavoriteState implements Cloneable<FavoriteState> {

  @override
  FavoriteState clone() {
    return FavoriteState();
  }
}

FavoriteState initState(Map<String, dynamic> args) {
  return FavoriteState();
}
