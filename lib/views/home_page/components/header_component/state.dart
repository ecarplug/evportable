import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:ecarplugapp/models/video_list.dart';
import 'package:ecarplugapp/views/home_page/state.dart';

class HeaderState implements Cloneable<HeaderState> {
  VideoListModel movie;
  VideoListModel tv;
  List<DocumentSnapshot> banktaltok;
  List<DocumentSnapshot> banktalNewThema;
  String userName="";

  bool showHeaderMovie;
  @override
  HeaderState clone() {
    return HeaderState()
      ..movie = movie
      ..tv = tv
      ..banktaltok = banktaltok
      ..banktalNewThema = banktalNewThema
       ..showHeaderMovie = showHeaderMovie;
  }
}

class HeaderConnector extends ConnOp<HomePageState, HeaderState> {
  @override
  HeaderState get(HomePageState state) {
    HeaderState mstate = HeaderState();
    mstate.movie = state.movie;
    mstate.tv = state.tv;
    mstate.banktaltok = state.banktaltok;
    mstate.banktalNewThema = state.banktalNewThema;
    mstate.showHeaderMovie = state.showHeaderMovie;
   if(state.userName!=""){
    mstate.userName =state.userName;
     }
     
    return mstate;
  }

  @override
  void set(HomePageState state, HeaderState subState) {
    state.showHeaderMovie = subState.showHeaderMovie;
  }
}
