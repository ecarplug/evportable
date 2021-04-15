import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' hide Action;
import 'action.dart';
import 'state.dart';

Effect<ProfileViewState> buildEffect() {
  return combineEffects(<Object, Effect<ProfileViewState>>{
    ProfileViewAction.action: _onAction,
    ProfileViewAction.showSnackBar: _showSnackBar,
    ProfileViewAction.onComment: _onComment,
    ProfileViewAction.gotoNext: _gotoNext,

    Lifecycle.initState: _onInit,
    //Lifecycle.dispose: _onDispose,
  });
}

void _onAction(Action action, Context<ProfileViewState> ctx) {}

void _onInit(Action action, Context<ProfileViewState> ctx) {
  Firestore.instance
      .collection("profileComment")
      .document(ctx.state.userId)
      .collection('comment')
      .document(ctx.state.user.firebaseUser.uid)
      .get()
      .then((value) => {
            if (value.data.isNotEmpty)
              {
                ctx.state.like = value.data['like'] ?? false,
                ctx.state.reco = value.data['reco'] ?? false,
                ctx.state.manner = value.data['manner'] ?? false,
              },
            ctx.dispatch(ProfileViewActionCreator.refresh())
          });

  Firestore.instance
      .collection("users") //NOSQL RDB TABLE ROWS FIELD    COLLECTION DOCUMENTS
      .document(ctx.state.userId)
      .get()
      .then((value) => {
            if (value.data.isNotEmpty)
              {
                ctx.state.likeCount = value.data['like'] ?? 0,
                ctx.state.mannerCount = value.data['manner'] ?? 0,
                ctx.state.recoCount = value.data['reco'] ?? 0,
                ctx.state.statusMessage =
                    value.data['status_mssage'] ?? '상태 메세지가 없습니다.',
              },
            ctx.dispatch(ProfileViewActionCreator.refresh())
          });
}

Future<void> _onComment(Action action, Context<ProfileViewState> ctx) async {
  if ((ctx.state.userId == ctx.state.user.firebaseUser.uid)) {
    if (ctx.state.contsCon.text == '') {
      ctx.broadcast(ProfileViewActionCreator.showSnackBar('상태메세지를 입력해 주세요^^'));
      Future.delayed(Duration(seconds: 1)).then((_) {});
      return;
    } else {
      Firestore.instance
          .collection("users")
          .document(ctx.state.userId)
          .setData({
        'status_mssage': ctx.state.contsCon.text,
        'CDATE': Timestamp.now(),
      }, merge: true);
      ctx.state.statusMessage = ctx.state.contsCon.text;
      ctx.dispatch(ProfileViewActionCreator.refresh());
    }
    //.  자신의 상태메세지 변경

  } else {
    if (ctx.state.contsCon.text == '') {
      ctx.broadcast(
          ProfileViewActionCreator.showSnackBar('간단한 참여글을 작성해 주세요^^'));
      Future.delayed(Duration(seconds: 1)).then((_) {});
      return;
    } else {
      Firestore.instance
          .collection("profileComment")
          .document(ctx.state.userId)
          .collection('comment')
          .document(ctx.state.user.firebaseUser.uid)
          .setData({
        'USER_NAME': ctx.state.user.firebaseUser.displayName,
        'USER_ID': ctx.state.user.firebaseUser.uid,
        'photoUrl': ctx.state.user.firebaseUser.photoUrl,
        'commentDesc': ctx.state.contsCon.text,
        'CDATE': Timestamp.now(),
      }, merge: true).then((value) {
        //  ctx.broadcast(ProfileViewActionCreator.showSnackBar('등록되었습니다.'));
      });
    }
  }
}

void _gotoNext(Action action, Context<ProfileViewState> ctx) async {
  print('다음페이지로 갑시다 ');

  await Navigator.of(ctx.context)
      .pushNamed('profileViewNextPage', arguments: action.payload);
}

void _showSnackBar(Action action, Context<ProfileViewState> ctx) {
  ctx.state.scaffoldkey.currentState.showSnackBar(SnackBar(
    content: Text(action.payload ?? ''),
  ));
}
