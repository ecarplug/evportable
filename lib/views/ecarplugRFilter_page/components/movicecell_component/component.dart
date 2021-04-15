import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class MovieCellComponent extends Component<VideoCellState> {
  MovieCellComponent()
      : super(
          shouldUpdate: (oldState, newState) {
            return oldState.isMovie != newState.isMovie ||
                oldState.item != newState.item;
          },
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          dependencies: Dependencies<VideoCellState>(
              adapter: null, slots: <String, Dependent<VideoCellState>>{}),
        );
}
