import 'package:fish_redux/fish_redux.dart';

//TODO replace with your own action
enum BangtalboardAction {
  action,
  loadMore,
  startFromFirebase,
  
  reflash,
  loadFromFirebase,
  createList,
  detailList,
  reflashFromFirebase,
  stopLodingbar,
  mediaTypeChange,
  sortChanged,
  videoCellTapped,
  refreshData,
  busyChanged,
  filterTap,
  applyFilter,
  getCVS,
}

class BangtalboardActionCreator {
  static Action onAction() {
    return const Action(BangtalboardAction.action);
  }

  static Action startFromFirebase() {
    return const Action(BangtalboardAction.startFromFirebase);
  }
 
  static Action reflash() {
    return Action(BangtalboardAction.reflash);
  }

  static Action loadFromFirebase(List d) {
    return Action(BangtalboardAction.loadFromFirebase, payload: d);
  }

  static Action createList({Object d}) {
    return Action(BangtalboardAction.createList, payload: d);
  }

  static Action detailList({Object d}) {
    return Action(BangtalboardAction.detailList, payload: d);
  }

  static Action stopLodingbar() {
    return Action(BangtalboardAction.stopLodingbar);
  }

  static Action reflashFromFirebase(List d) {
    return Action(BangtalboardAction.reflashFromFirebase, payload: d);
  }

  static Action mediaTypeChange(bool isCharger) {
    return Action(BangtalboardAction.mediaTypeChange, payload: isCharger);
  }

  static Action filterTap() {
    return const Action(BangtalboardAction.filterTap);
  }

  static Action applyFilter() {
    return const Action(BangtalboardAction.applyFilter);
  }

  static Action getCVS() {

     return const Action(BangtalboardAction.getCVS);
  }


}
