import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class ItemDetailComponent extends Component<ItemDetailState> {
  ItemDetailComponent()
      : super(
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<ItemDetailState>(
                adapter: null,
                slots: <String, Dependent<ItemDetailState>>{
                }),);

}
