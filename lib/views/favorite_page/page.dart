import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class FavoritePage extends Page<FavoriteState, Map<String, dynamic>> {
  FavoritePage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<FavoriteState>(
                adapter: null,
                slots: <String, Dependent<FavoriteState>>{
                }),
            middleware: <Middleware<FavoriteState>>[
            ],);

}
