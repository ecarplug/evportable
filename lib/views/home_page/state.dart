import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecarplugapp/globalbasestate/state.dart';
import 'package:ecarplugapp/globalbasestate/store.dart';
import 'package:ecarplugapp/models/app_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/widgets.dart';
import 'package:ecarplugapp/models/base_api_model/base_movie.dart';
import 'package:ecarplugapp/models/base_api_model/base_tvshow.dart';
import 'package:ecarplugapp/models/search_result.dart';
import 'package:ecarplugapp/models/video_list.dart';

class HomePageState implements GlobalBaseState, Cloneable<HomePageState> {
  VideoListModel movie;
  VideoListModel tv;
  VideoListModel popularMovies;
  VideoListModel popularTVShows;
  BaseMovieModel shareMovies;
  BaseTvShowModel shareTvshows;
  SearchResultModel trending;
  ScrollController scrollController;
  bool showHeaderMovie;
  bool showPopMovie;
  bool showShareMovie;
  String userName="";
  List<DocumentSnapshot> banktaltok;
  List<DocumentSnapshot> banktalNewThema;
  List<DocumentSnapshot> boardList = [];
  AnimationController animatedController;

  @override
  HomePageState clone() {
    return HomePageState()
      ..user = user
      ..themeColor = themeColor
      ..locale = locale
      ..tv = tv
      ..movie = movie
      ..banktaltok = banktaltok
      ..boardList = boardList
      ..banktalNewThema = banktalNewThema
      ..popularMovies = popularMovies
      ..popularTVShows = popularTVShows
      ..showHeaderMovie = showHeaderMovie
      ..showPopMovie = showPopMovie
      ..shareMovies = shareMovies
      ..shareTvshows = shareTvshows
      ..showShareMovie = showShareMovie
      ..trending = trending
      ..userName=userName
      ..scrollController = scrollController
      ..animatedController = animatedController;
  }

  @override
  Locale locale;

  @override
  Color themeColor;

  @override
  AppUser user;
}

HomePageState initState(Map<String, dynamic> args) {
  var state = HomePageState();

  state.movie = new VideoListModel.fromParams(results: List<VideoListResult>());
  state.banktaltok = [];
  state.banktalNewThema = [];

  state.tv = new VideoListModel.fromParams(results: List<VideoListResult>());
  state.popularMovies =
      new VideoListModel.fromParams(results: List<VideoListResult>());
  state.popularTVShows =
      new VideoListModel.fromParams(results: List<VideoListResult>());
  state.trending = SearchResultModel.fromParams(results: []);
  state.showPopMovie = true;
  state.showHeaderMovie = true;
  state.showShareMovie = true;
  //state.userName="";
  return state;
}
