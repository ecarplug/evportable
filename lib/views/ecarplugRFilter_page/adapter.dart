import 'package:fish_redux/fish_redux.dart';
import './components/movicecell_component/component.dart';
import 'reducer.dart';
import 'state.dart';

class DiscoverListAdapter extends SourceFlowAdapter<EcarplugReportPageState> {
  DiscoverListAdapter()
      : super(
          pool: <String, Component<Object>>{
            'moviecell': MovieCellComponent(),
          },
          reducer: buildReducer(),
        );
}
