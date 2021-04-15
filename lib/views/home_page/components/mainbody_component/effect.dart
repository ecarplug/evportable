import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/widgets.dart' hide Action;
import 'action.dart';
import 'state.dart';

Effect<PopularPosterState> buildEffect() {
  return combineEffects(<Object, Effect<PopularPosterState>>{
    PopularPosterAction.action: _onAction,
    PopularPosterAction.cellTapped: _onCellTapped
  });
}

void _onAction(Action action, Context<PopularPosterState> ctx) {}

Future _onCellTapped(Action action, Context<PopularPosterState> ctx) async {
 //
}
//Routes.routes.buildPage('bangtalboardPage', null)
