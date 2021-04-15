import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:ecarplugapp/models/base_api_model/base_movie.dart';
import 'package:ecarplugapp/models/base_api_model/base_tvshow.dart';
import 'package:ecarplugapp/models/enums/media_type.dart';
import 'package:ecarplugapp/models/search_result.dart';
import 'package:ecarplugapp/models/video_list.dart';

enum HomePageAction {
  action,
  initMovie,
  initTV,
  initPopularMovies,
  initPopularTVShows,
  moreTapped,
  initTrending,
  searchBarTapped,
  cellTapped,
  trendingMore,
  shareMore,
  initShareMovies,
  initShareTvShows,
  initecarplugapp,
  initBangTalNewThema,
  initBoardList,
  onCellTappedThema,
  reflash
}

class HomePageActionCreator {
  static Action onAction() {
    return const Action(HomePageAction.action);
  }

  static Action onInitMovie(VideoListModel movie) {
    return Action(HomePageAction.initMovie, payload: movie);
  }

  static Action onInitTV(VideoListModel tv) {
    return Action(HomePageAction.initTV, payload: tv);
  }

  static Action onInitPopularMovie(VideoListModel pop) {
    return Action(HomePageAction.initPopularMovies, payload: pop);
  }

  static Action onInitPopularTV(VideoListModel pop) {
    return Action(HomePageAction.initPopularTVShows, payload: pop);
  }

  static Action onMoreTapped(VideoListModel model, MediaType t) {
    return Action(HomePageAction.moreTapped, payload: [model, t]);
  }

  static Action initTrending(SearchResultModel d) {
    return Action(HomePageAction.initTrending, payload: d);
  }

  static Action onSearchBarTapped() {
    return const Action(HomePageAction.searchBarTapped);
  }

  static Action onCellTapped(
      String id, String bgpic, String title, String posterpic, MediaType type) {
    return Action(HomePageAction.cellTapped,
        payload: [id, bgpic, title, posterpic, type]);
  }

  static Action onCellTappedThema(DocumentSnapshot document) {
    return Action(HomePageAction.onCellTappedThema, payload: [document]);
  }

  static Action onTrendingMore() {
    return const Action(HomePageAction.trendingMore);
  }

  static Action reflash() {
    return const Action(HomePageAction.reflash);
  }

  static Action onShareMore() {
    return const Action(HomePageAction.shareMore);
  }

  static Action initShareMovies(BaseMovieModel d) {
    return Action(HomePageAction.initShareMovies, payload: d);
  }

  static Action initShareTvShows(BaseTvShowModel d) {
    return Action(HomePageAction.initShareTvShows, payload: d);
  }

  static Action onInitBangTaktok(List d) {
    return Action(HomePageAction.initecarplugapp, payload: d);
  }

  static Action onInitBangTakNewThema(List d) {
    return Action(HomePageAction.initBangTalNewThema, payload: d);
  }

  static Action onInitBoardList(List d) {
    return Action(HomePageAction.initBoardList, payload: d);
  }
}
