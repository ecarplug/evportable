import 'package:fish_redux/fish_redux.dart';
import 'package:ecarplugapp/models/video_list.dart';

enum EcarplugReportPageAction {
  loadData,
  action,
  mediaTypeChange,
  sortChanged,
  videoCellTapped,
  refreshData,
  loadMore,
  busyChanged,
  filterTap,
  applyFilter,
  startFromFirebase,
  clickFromFirebase,
  reflash,
  loadFromFirebase,
  reflashFromFirebase
}

class EcarplugReportPageActionCreator {
  static Action onAction() {
    return const Action(EcarplugReportPageAction.action);
  }

  static Action onSortChanged(String s) {
    return Action(EcarplugReportPageAction.sortChanged, payload: s);
  }

  static Action onLoadData(VideoListModel p) {
    return Action(EcarplugReportPageAction.loadData, payload: p);
  }

  static Action onRefreshData() {
    return const Action(EcarplugReportPageAction.refreshData);
  }

  static Action onLoadMore(List<VideoListResult> p) {
    return Action(EcarplugReportPageAction.loadMore, payload: p);
  }

  static Action onVideoCellTapped(
      int p, String backpic, String name, String poster) {
    return Action(EcarplugReportPageAction.videoCellTapped,
        payload: [p, backpic, name, poster]);
  }

  static Action onBusyChanged(bool p) {
    return Action(EcarplugReportPageAction.busyChanged, payload: p);
  }

  static Action mediaTypeChange(bool isMovie) {
    return Action(EcarplugReportPageAction.mediaTypeChange, payload: isMovie);
  }

  static Action filterTap() {
    return const Action(EcarplugReportPageAction.filterTap);
  }

  static Action applyFilter() {
    return const Action(EcarplugReportPageAction.applyFilter);
  }

  static Action startFromFirebase() {
    return const Action(EcarplugReportPageAction.startFromFirebase);
  }

  static Action clickFromFirebase() {
    return Action(EcarplugReportPageAction.clickFromFirebase);
  }

  static Action reflash() {
    return Action(EcarplugReportPageAction.reflash);
  }

  static Action loadFromFirebase(List d) {
    return Action(EcarplugReportPageAction.loadFromFirebase, payload: d);
  }

  static Action reflashFromFirebase(List d) {
    return Action(EcarplugReportPageAction.reflashFromFirebase, payload: d);
  }
}
