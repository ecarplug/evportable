import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecarplugapp/const/const.dart';
import 'package:ecarplugapp/views/profileView_page/action.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:like_button/like_button.dart';
import 'state.dart';

Widget buildView(
    ProfileViewState state, Dispatch dispatch, ViewService viewService) {
  return Scaffold(
    key: state.scaffoldkey,
    appBar: AppBar(
      backgroundColor: Colors.black87,
      title: Text(
        '참여자 프로필',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
    ),
    body: SettingsScreen(state: state, dispatch: dispatch),
  );
}

class SettingsScreen extends StatefulWidget {
  final ProfileViewState state;
  final Dispatch dispatch;

  const SettingsScreen({this.state, this.dispatch});

  @override
  State createState() => SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> {
  TextEditingController controllerNickname;
  TextEditingController controllerAboutMe;

  SharedPreferences prefs;

  String id = '';
  String nickname = '';
  String aboutMe = '';

  bool isLoading = false;
  File avatarImageFile;

  final GlobalKey<LikeButtonState> _globalKey = GlobalKey<LikeButtonState>();
  final int likeCount = 999;
  final FocusNode focusNodeNickname = FocusNode();
  final FocusNode focusNodeAboutMe = FocusNode();

  @override
  void initState() {
    super.initState();
    readLocal();
  }

  void readLocal() async {
    controllerNickname = TextEditingController(text: nickname);
    controllerAboutMe = TextEditingController(text: aboutMe);

    // Force refresh input
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    const double buttonSize = 25.0;
    return Stack(
      children: <Widget>[
        SingleChildScrollView(
          child: Column(
            children: <Widget>[
              // Avatar
              Container(
                child: Center(
                  child: Stack(
                    children: <Widget>[
                      (avatarImageFile == null)
                          ? (widget.state.photoUrl != ''
                              ? Material(
                                  child: CachedNetworkImage(
                                    placeholder: (context, url) => Container(
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.0,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                themeColor),
                                      ),
                                      width: 90.0,
                                      height: 90.0,
                                      padding: EdgeInsets.all(20.0),
                                    ),
                                    imageUrl: widget.state.photoUrl,
                                    width: 90.0,
                                    height: 90.0,
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(45.0)),
                                  clipBehavior: Clip.hardEdge,
                                )
                              : Icon(
                                  Icons.account_circle,
                                  size: 90.0,
                                  color: greyColor,
                                ))
                          : Material(
                              child: Image.file(
                                avatarImageFile,
                                width: 90.0,
                                height: 90.0,
                                fit: BoxFit.cover,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(45.0)),
                              clipBehavior: Clip.hardEdge,
                            ),
                    ],
                  ),
                ),
                width: double.infinity,
                margin: EdgeInsets.all(20.0),
              ),

              // Input
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  // Username
                  Container(
                    child: Text(
                      '닉네임.    ' + widget.state.userName,
                      style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                          color: primaryColor),
                    ),
                    margin: EdgeInsets.only(left: 10.0, bottom: 0, top: 5.0),
                  ),
                  // About me
                  Container(
                    child: Text(
                      widget.state.statusMessage,
                      style: TextStyle(
                          fontStyle: FontStyle.italic,
                          //fontWeight: FontWeight.bold,
                          color: primaryColor),
                    ),
                    margin: EdgeInsets.only(left: 10.0, top: 5.0, bottom: 25.0),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      LikeButton(
                        isLiked: widget.state.reco,
                        size: buttonSize,
                        likeCount: widget.state.recoCount,
                        key: _globalKey,
                        countBuilder: (int count, bool isLiked, String text) {
                          final ColorSwatch<int> color =
                              isLiked ? Colors.pinkAccent : Colors.grey;
                          Widget result;
                          if (count == 0) {
                            result = Text(
                              '0',
                              style: TextStyle(color: color, fontSize: 12),
                            );
                          } else
                            result = Text(
                              count >= 1000
                                  ? (count / 1000.0).toStringAsFixed(1) + 'k'
                                  : text,
                              style: TextStyle(color: color, fontSize: 12),
                            );
                          return Column(children: [
                            Text(
                              '추천하기',
                              style: TextStyle(color: color, fontSize: 12),
                            ),
                            result
                          ]);
                        },
                        likeCountAnimationType: LikeCountAnimationType.all,
                        likeCountPadding: const EdgeInsets.only(left: 15.0),
                        onTap: onLikeButtonTapped1,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      LikeButton(
                        isLiked: widget.state.like,
                        size: buttonSize,
                        circleColor: const CircleColor(
                            start: Color(0xff00ddff), end: Color(0xff0099cc)),
                        bubblesColor: const BubblesColor(
                          dotPrimaryColor: Color(0xff33b5e5),
                          dotSecondaryColor: Color(0xff0099cc),
                        ),
                        likeBuilder: (bool isLiked) {
                          return Icon(
                            Icons.thumb_up,
                            color: isLiked ? Colors.deepOrange : Colors.grey,
                            size: buttonSize,
                          );
                        },
                        likeCount: widget.state.likeCount,
                        likeCountAnimationType: LikeCountAnimationType.all,
                        countBuilder: (int count, bool isLiked, String text) {
                          final MaterialColor color =
                              isLiked ? Colors.deepOrange : Colors.grey;
                          Widget result;
                          if (count == 0) {
                            result = Text(
                              '0',
                              style: TextStyle(color: color, fontSize: 12),
                            );
                          } else
                            result = Text(
                              text,
                              style: TextStyle(color: color, fontSize: 12),
                            );
                          return Column(children: [
                            Text('좋아요',
                                style: TextStyle(color: color, fontSize: 12)),
                            result
                          ]);
                        },
                        likeCountPadding: const EdgeInsets.only(left: 15.0),
                        onTap: onLikeButtonTapped2,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      LikeButton(
                        isLiked: widget.state.manner,
                        size: buttonSize,
                        circleColor: const CircleColor(
                            start: Color(0xff669900), end: Color(0xff669900)),
                        bubblesColor: const BubblesColor(
                          dotPrimaryColor: Color(0xff669900),
                          dotSecondaryColor: Color(0xff99cc00),
                        ),
                        likeBuilder: (bool isLiked) {
                          return Icon(
                            Icons.face_retouching_natural,
                            color: isLiked ? Colors.green : Colors.grey,
                            size: buttonSize,
                          );
                        },
                        likeCount: widget.state.mannerCount,
                        likeCountAnimationType: LikeCountAnimationType.all,
                        countBuilder: (int count, bool isLiked, String text) {
                          final MaterialColor color =
                              isLiked ? Colors.green : Colors.grey;
                          Widget result;
                          if (count == 0) {
                            result = Text(
                              '0',
                              style: TextStyle(color: color, fontSize: 12),
                            );
                          } else
                            result = Text(
                              text,
                              style: TextStyle(color: color, fontSize: 12),
                            );
                          return Column(children: [
                            Text('매너있어요',
                                style: TextStyle(color: color, fontSize: 12)),
                            result
                          ]);
                        },
                        likeCountPadding: const EdgeInsets.only(left: 15.0),
                        onTap: onLikeButtonTapped3,
                      ),
                    ],
                  ),
                ],
              ),

              // Loading
              Positioned(
                child: isLoading
                    ? Container(
                        child: Center(
                          child: CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(themeColor)),
                        ),
                        color: Colors.white.withOpacity(0.8),
                      )
                    : Container(),
              ),

              Container(
                  //  width: 300,
                  padding: const EdgeInsets.all(5.0),
                  child: TextFormField(
                    //  readOnly: true,
                    controller: widget.state.contsCon,
                    focusNode: widget.state.descriptionFoucsNode,
                    maxLines: 1,
                    maxLength: 20,
                    maxLengthEnforced: true,

                    autofocus: false,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: const EdgeInsets.all(10.0),
                      labelText: (widget.state.userId ==
                              widget.state.user.firebaseUser.uid)
                          ? '상태메세지를 등록하세요'
                          : '당신의 인사말 남기기',
                      //  hintText: '간단한 참여 작성해 주세요.',
                    ),
                    onSaved: (value) {
                      widget.state.commentDesc = value;
                    },
                  )),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  SizedBox(
                    width: 10,
                  ),
                  /*
                  SizedBox.fromSize(
                    size: Size(56, 56), // button width and height
                    child: ClipOval(
                      child: Material(
                        //  color: Colors.orange[100], // button color
                        child: InkWell(
                          splashColor: Colors.black, // splash color
                          onTap: () => widget.dispatch(ProfileViewActionCreator
                              .gotoNextPage()), // button pressed
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(Icons.queue_play_next), // icon
                              Text("Next"), // text
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  */
                  SizedBox.fromSize(
                    size: Size(56, 56), // button width and height
                    child: ClipOval(
                      child: Material(
                        //  color: Colors.orange[100], // button color
                        child: InkWell(
                          splashColor: Colors.black, // splash color
                          onTap: () => widget.dispatch(ProfileViewActionCreator
                              .onComment()), // button pressed
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(Icons.control_point), // icon
                              Text("등록"), // text
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  // give it width
                ],
              ),
              Container(
                padding: const EdgeInsets.all(2),
                color: Colors.black54,
                alignment: Alignment.center,
                child: Text(
                  widget.state.userName + ' 님께 남긴 인사말',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              //  Text(widget.state.userName + ' 님께 남긴 인사말'),
              Container(
                height: MediaQuery.of(context).size.height - 510,
                child: StreamBuilder<QuerySnapshot>(
                  stream: Firestore.instance
                      .collection("profileComment")
                      .document(widget.state.userId)
                      .collection('comment')
                      .where('comment', isNull: true)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.data == null)
                      return CircularProgressIndicator();
                    if (snapshot.hasError)
                      return Text("Error: ${snapshot.error}");
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                      //  return Text("Loading...");
                      default:
                        return ListView(
                          children: snapshot.data.documents
                              .map((DocumentSnapshot document) {
                            Timestamp ts = document["CDATE"];
                            String dt = timestampToStrDateTime(ts);
                            return Card(
                              elevation: 0,
                              child: Column(
                                children: <Widget>[
                                  ListTile(
                                    leading: CircleAvatar(
                                      backgroundImage:
                                          NetworkImage(document["photoUrl"]),
                                    ),
                                    title: Text(document["USER_NAME"]),
                                    subtitle: Text(document["commentDesc"]),
                                    trailing: document["USER_ID"] ==
                                            widget.state.userId
                                        ? InkWell(
                                            splashColor:
                                                Colors.green, // splash color
                                            onTap: () => {
                                              _asyncCancelJoinConfirmDialog(
                                                      context,
                                                      "참여취소",
                                                      '',
                                                      widget.dispatch,
                                                      widget.state)
                                                  .then((value) => {
                                                        print('삭제 완료')
                                                        //Navigator.pop(context)
                                                      })
                                            }, // button pressed
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                Icon(Icons.delete), // icon
                                                Text("취소"), // text
                                              ],
                                            ),
                                          )
                                        : Text('-'),
                                  )
                                ],
                              ),
                            );
                          }).toList(),
                        );
                    }
                  },
                ),
              ),
            ],
          ),
          padding: EdgeInsets.only(left: 15.0, right: 15.0),
        ),
      ],
    );
  }

  Future<bool> onLikeButtonTapped1(isLiked) async {
    /// send your request here
    // final bool success= await sendRequest();

    /// if failed, you can do nothing
    // return success? !isLiked:isLiked;

    if (!isLiked)
      widget.state.recoCount = widget.state.recoCount + 1;
    else
      widget.state.recoCount = widget.state.recoCount - 1;
/**해당유저에 추선건수 증감*/
    Firestore.instance
        .collection("users")
        .document(widget.state.userId)
        .setData({
      'reco': widget.state.recoCount,
      'CDATE': Timestamp.now(),
    }, merge: true);

/**내가 상대방 추선을 했는지 적용 */
    Firestore.instance
        .collection("profileComment")
        .document(widget.state.userId)
        .collection('comment')
        .document(widget.state.user.firebaseUser.uid)
        .setData({
      'USER_NAME': widget.state.user.firebaseUser.displayName,
      'USER_ID': widget.state.user.firebaseUser.uid,
      'photoUrl': widget.state.user.firebaseUser.photoUrl,
      'reco': !isLiked,
      'CDATE': Timestamp.now(),
    }, merge: true);

    return !isLiked;
  }

  Future<bool> onLikeButtonTapped2(isLiked) async {
    if (!isLiked)
      widget.state.likeCount = widget.state.likeCount + 1;
    else
      widget.state.likeCount = widget.state.likeCount - 1;
/**해당유저에 추선건수 증감*/
    Firestore.instance
        .collection("users")
        .document(widget.state.userId)
        .setData({
      'like': widget.state.likeCount,
      'CDATE': Timestamp.now(),
    }, merge: true);

/**내가 상대방 추선을 했는지 적용 */

    Firestore.instance
        .collection("profileComment")
        .document(widget.state.userId)
        .collection('comment')
        .document(widget.state.user.firebaseUser.uid)
        .setData({
      'USER_NAME': widget.state.user.firebaseUser.displayName,
      'USER_ID': widget.state.user.firebaseUser.uid,
      'photoUrl': widget.state.user.firebaseUser.photoUrl,
      'like': !isLiked,
      'CDATE': Timestamp.now(),
    }, merge: true);

    return !isLiked;
  }

  Future<bool> onLikeButtonTapped3(isLiked) async {
    if (!isLiked)
      widget.state.mannerCount = widget.state.mannerCount + 1;
    else
      widget.state.mannerCount = widget.state.mannerCount - 1;
/**해당유저에 추선건수 증감*/
    Firestore.instance
        .collection("users")
        .document(widget.state.userId)
        .setData({
      'manner': widget.state.mannerCount,
      'CDATE': Timestamp.now(),
    }, merge: true);

    Firestore.instance
        .collection("profileComment")
        .document(widget.state.userId)
        .collection('comment')
        .document(widget.state.user.firebaseUser.uid)
        .setData({
      'USER_NAME': widget.state.user.firebaseUser.displayName,
      'USER_ID': widget.state.user.firebaseUser.uid,
      'photoUrl': widget.state.user.firebaseUser.photoUrl,
      'manner': !isLiked,
      'CDATE': Timestamp.now(),
    }, merge: true);

    return !isLiked;
  }

  String timestampToStrDateTime(Timestamp ts) {
    return DateTime.fromMicrosecondsSinceEpoch(ts.microsecondsSinceEpoch)
        .toString();
  }
}
/*참여 취소*/

Future<void> _asyncCancelJoinConfirmDialog(
    BuildContext context, cafe_thema, docuId, dispatch, state) async {
  return showDialog<void>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Container(
          child: Row(
            children: [
              Icon(Icons.delete, color: Colors.red),
              Text(
                cafe_thema.toString().length < 15
                    ? cafe_thema
                    : cafe_thema.toString().substring(0, 15) + '..',
                style: TextStyle(fontSize: 15),
                maxLines: 1,
                softWrap: false,
                overflow: TextOverflow.ellipsis,
              )
            ],
          ),
        ),
        //title: Text(cafe_thema),
        content: Text('참여취소 하시겠습니까?'),
        actions: <Widget>[
          FlatButton(
            child: Text('닫기'),
            onPressed: () {
              Navigator.pop(context);
              print('취소되었습');
            },
          ),
          FlatButton(
            child: Text(
              '참여취소',
              style: TextStyle(color: Colors.red),
            ),
            onPressed: () =>
                {dispatch(ProfileViewActionCreator.onJoinDelete())},

            // Navigator.of(context).pop('삭제되었습니다.');
          )
        ],
      );
    },
  );
}
