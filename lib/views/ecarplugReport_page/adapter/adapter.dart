import '../itemDetail_component/component.dart';
import 'package:fish_redux/fish_redux.dart';

import '../state.dart';
import 'reducer.dart';

class BantalboardAdapter extends SourceFlowAdapter<BangtalboardState> {
  BantalboardAdapter()
      : super(
          pool: <String, Component<Object>>{'detail': ItemDetailComponent()},
          reducer: buildReducer(),
        );
}
