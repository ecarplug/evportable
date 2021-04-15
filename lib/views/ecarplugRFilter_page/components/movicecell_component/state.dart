import 'package:fish_redux/fish_redux.dart';
import 'package:ecarplugapp/models/video_list.dart';

class VideoCellState implements Cloneable<VideoCellState> {
  // VideoListResult videodata;
  bool isMovie;
  dynamic item;
  @override
  VideoCellState clone() {
    return VideoCellState()
      // ..videodata = videodata
      ..item = item
      ..isMovie = isMovie;
  }
}

VideoCellState initState(Map<String, dynamic> args) {
  return VideoCellState();
}
