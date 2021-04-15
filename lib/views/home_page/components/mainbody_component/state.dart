import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:ecarplugapp/models/video_list.dart';

import '../../state.dart';

class PopularPosterState implements Cloneable<PopularPosterState> {
  VideoListModel popularMoives;
  VideoListModel popularTVShows;
  List<DocumentSnapshot> boardList;
  bool showmovie;
  @override
  PopularPosterState clone() {
    return PopularPosterState()
      ..popularMoives = popularMoives
      ..popularTVShows = popularTVShows
      ..showmovie = showmovie;
  }
}

class PopularPosterConnector extends ConnOp<HomePageState, PopularPosterState> {
  @override
  PopularPosterState get(HomePageState state) {
    PopularPosterState mstate = PopularPosterState();
    mstate.popularMoives = state.popularMovies;
    mstate.popularTVShows = state.popularTVShows;
    mstate.showmovie = state.showPopMovie;
    mstate.boardList = state.boardList;

    return mstate;
  }

  @override
  void set(HomePageState state, PopularPosterState subState) {
    state.showPopMovie = subState.showmovie;
  }
}
