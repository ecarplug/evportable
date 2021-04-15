import 'package:fish_redux/fish_redux.dart';
import 'package:ecarplugapp/models/video_list.dart';

import 'action.dart';
import 'state.dart';

Reducer<EcarplugReportPageState> buildReducer() {
  return asReducer(
    <Object, Reducer<EcarplugReportPageState>>{
      EcarplugReportPageAction.action: _onAction,
      EcarplugReportPageAction.loadData: _onLoadData,
      EcarplugReportPageAction.loadMore: _onLoadMore,
      EcarplugReportPageAction.busyChanged: _busyChanged,
      EcarplugReportPageAction.loadFromFirebase: _loadFromFirebase,
      EcarplugReportPageAction.reflashFromFirebase: _reflashFromFirebase,
    },
  );
}

EcarplugReportPageState _onAction(
    EcarplugReportPageState state, Action action) {
  final EcarplugReportPageState newState = state.clone();
  return newState;
}

EcarplugReportPageState _busyChanged(
    EcarplugReportPageState state, Action action) {
  final bool _isBusy = action.payload;
  final EcarplugReportPageState newState = state.clone();
  newState.isbusy = _isBusy;
  return newState;
}

EcarplugReportPageState _onLoadData(
    EcarplugReportPageState state, Action action) {
  VideoListModel m = action.payload ??
      VideoListModel.fromParams(results: List<VideoListResult>());
  final EcarplugReportPageState newState = state.clone();
  newState.videoListModel = m;
  return newState;
}

EcarplugReportPageState _onLoadMore(
    EcarplugReportPageState state, Action action) {
  final List<VideoListResult> m = action.payload ?? List<VideoListResult>();
  final EcarplugReportPageState newState = state.clone();
  newState.videoListModel.page++;
  newState.videoListModel.results.addAll(m);
  return newState;
}

EcarplugReportPageState _loadFromFirebase(
    EcarplugReportPageState state, Action action) {
  final List _model = action.payload;
  final EcarplugReportPageState newState = state.clone();

  if (_model != null) {
    newState.data.addAll(_model);
  }

  return newState;
}

EcarplugReportPageState _reflashFromFirebase(
    EcarplugReportPageState state, Action action) {
  final List _model = action.payload;
  final EcarplugReportPageState newState = state.clone();
  newState.data = [];
  if (_model != null) {
    newState.data.addAll(_model);
  }

  return newState;
}

EcarplugReportPageState _stopLodingbar(
    EcarplugReportPageState state, Action action) {
  final EcarplugReportPageState newState = state.clone();
  // newState.isLoading = false;
  return newState;
}
