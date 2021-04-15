import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/cupertino.dart' hide Action, Page;
import 'action.dart';
import 'state.dart';
import 'package:basic_utils/basic_utils.dart';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:toast/toast.dart';

Effect<BangtalboardState> buildEffect() {
  return combineEffects(<Object, Effect<BangtalboardState>>{
    BangtalboardAction.action: _onAction, 
    BangtalboardAction.reflash: _reflash,
    BangtalboardAction.mediaTypeChange: _mediaTypeChange,
    BangtalboardAction.filterTap: _filterTap,
    BangtalboardAction.applyFilter: _applyFilter,
    BangtalboardAction.getCVS: _getCVS,
    Lifecycle.initState: _onInit,
    Lifecycle.dispose: _onDispose,
  });
}

void _onInit(Action action, Context<BangtalboardState> ctx) {
  final Object _ticker = ctx.stfState;
  // _clickFromFirebase(ctx);
  // final Object ticker = ctx.stfState;
  ctx.state.animationController = AnimationController(
      vsync: _ticker, duration: Duration(milliseconds: 300));
  ctx.state.cellAnimationController = AnimationController(
      vsync: _ticker, duration: Duration(milliseconds: 1000));
  ctx.state.refreshController = AnimationController(
      vsync: _ticker, duration: Duration(milliseconds: 100));
  ctx.state.controller = ScrollController()
    ..addListener(() {
      if (ctx.state.controller.position.pixels ==
          ctx.state.controller.position.maxScrollExtent) {
        FirebaseAuth auth = FirebaseAuth.instance;
        //state.user.firebaseUser = user;
        auth.currentUser().then((firebaseUser) async {
          ctx.state.user.firebaseUser = firebaseUser;
          
          if( ctx.state.userId==null) {
            ctx.state.userId=  ctx.state.user.firebaseUser.uid;
          }
          _reflash(action,ctx);
        });
      } //_loadMore(ctx);
    }); 
 
 FirebaseAuth auth = FirebaseAuth.instance;
  auth.currentUser().then((firebaseUser) async {
          ctx.state.user.firebaseUser = firebaseUser;
          
          if( ctx.state.userId==null) {
            ctx.state.userId=  ctx.state.user.firebaseUser.uid;
             
          }
          _reflash(action,ctx);
        });
 

}

Future _onDispose(Action action, Context<BangtalboardState> ctx) async {}

void _onAction(Action action, Context<BangtalboardState> ctx) {
  ctx.state.controller.dispose();
}

 
 

Future _reflash(Action action, Context<BangtalboardState> ctx) async {
 // DateTime _new = DateTime.now();
 //_new = _new.subtract(Duration(days: 30));
 
  ctx.state.startDate = DateTime(ctx.state.startDate.year,
      ctx.state.startDate.month, ctx.state.startDate.day);
  ctx.state.endDate = DateTime(ctx.state.endDate.year, ctx.state.endDate.month,
      ctx.state.endDate.day, 23, 59, 59);

  var r; 
 
      r = await Firestore.instance
              .collection('chargeTable')
              .document(ctx.state.userId)
              .collection('chargeData')
              .where('start', isGreaterThanOrEqualTo: ctx.state.startDate)
              .where('start', isLessThan: ctx.state.endDate)
              .orderBy('start', descending: ctx.state.sortDesc)
              .limit(15)
              .getDocuments();
  
  // if (r.documents.length > 0) {
    double get_energy=0.0;
    int chargedSec=0;
  r.documents.forEach((data) {
    print(data['get_energy']);
    print(data['chargedSec']);
    
                      get_energy=(get_energy+  (data['get_energy']??0.0));
                     chargedSec=chargedSec+ int.parse((data['chargedSec']??"0").toString());

      });
 


  int hour = (chargedSec / 3600).floor();
        String h = "00";
        if (hour < 10)
          h = "0" + hour.toString();
        else
          h = hour.toString();
        int min = ((chargedSec - hour * 3600) / 60).floor();
        String m = "00";
        if (min < 10)
          m = "0" + min.toString();
        else
          m = min.toString();
        int sec = chargedSec % 60;
        String s = "00";

        if (sec < 10)
          s = "0" + sec.toString();
        else
          s = sec.toString();

  
      ctx.state.totalpwr=get_energy;
      ctx.state.totalTimeText=h + ":" + m + ":" + s;
    

    
  ctx.state.isLoading = false;
  ctx.dispatch(BangtalboardActionCreator.reflashFromFirebase(r.documents));

  
  //}
}


Future _loadMore(Action action, Context<BangtalboardState> ctx) async {
 // DateTime _new = DateTime.now();
 //_new = _new.subtract(Duration(days: 30));
 
  ctx.state.startDate = DateTime(ctx.state.startDate.year,
      ctx.state.startDate.month, ctx.state.startDate.day);
  ctx.state.endDate = DateTime(ctx.state.endDate.year, ctx.state.endDate.month,
      ctx.state.endDate.day, 23, 59, 59);

  var r; 
   if(ctx.state.data.length>0){
      r = await Firestore.instance
              .collection('chargeTable')
              .document(ctx.state.userId)
              .collection('chargeData')
              .where('start', isGreaterThanOrEqualTo: ctx.state.startDate)
              .where('start', isLessThan: ctx.state.endDate)
              .orderBy('start', descending: ctx.state.sortDesc)
              .startAfterDocument(ctx.state.data[ctx.state.data.length - 1])
              .limit(15)
              .getDocuments();
    }
    // if (r.documents.length > 0) {
    double get_energy=0.0;
    int chargedSec=0;
  r.documents.forEach((data) {
    print(data['get_energy']);
    print(data['chargedSec']);
    
                      get_energy=(get_energy+  (data['get_energy']??0.0));
                     chargedSec=chargedSec+ int.parse((data['chargedSec']??"0").toString());

      });
 


  int hour = (chargedSec / 3600).floor();
        String h = "00";
        if (hour < 10)
          h = "0" + hour.toString();
        else
          h = hour.toString();
        int min = ((chargedSec - hour * 3600) / 60).floor();
        String m = "00";
        if (min < 10)
          m = "0" + min.toString();
        else
          m = min.toString();
        int sec = chargedSec % 60;
        String s = "00";

        if (sec < 10)
          s = "0" + sec.toString();
        else
          s = sec.toString();

  
      ctx.state.totalpwr=get_energy;
      ctx.state.totalTimeText=h + ":" + m + ":" + s;
    

    
  ctx.state.isLoading = false;

ctx.dispatch(BangtalboardActionCreator.loadFromFirebase(r.documents));

 


   


  //}
}









 



Future _mediaTypeChange(Action action, Context<BangtalboardState> ctx) async {
  final bool _isCharger = action.payload ?? true;
  //if (ctx.state.isCharger == _isCharger) return;
  ctx.state.isCharger = _isCharger;
  ctx.state.currentGenres = _isCharger
      ? ctx.state.filterState.movieGenres
      : ctx.state.filterState.tvGenres;
  //await _onLoadData(action, ctx);
  await _reflash(action, ctx);
}

void _filterTap(Action action, Context<BangtalboardState> ctx) async {
  ctx.state.filterState.isCharger = ctx.state.isCharger;
  ctx.state.filterState.selectedSort = ctx.state.selectedSort;
  ctx.state.filterState.currentGenres = ctx.state.currentGenres;
  ctx.state.filterState.lVote = ctx.state.lVote;
  ctx.state.filterState.rVote = ctx.state.rVote;
  Navigator.of(ctx.context)
      .push(PageRouteBuilder(pageBuilder: (_, animation, ___) {
    return SlideTransition(
        position: Tween<Offset>(begin: Offset(0, 1), end: Offset.zero)
            .animate(CurvedAnimation(parent: animation, curve: Curves.ease)),
        child: FadeTransition(
            opacity: animation, child: ctx.buildComponent('filter')));
  }));
}

void _applyFilter(Action action, Context<BangtalboardState> ctx) {
  ctx.state.currentGenres = ctx.state.filterState.currentGenres;
  ctx.state.selectedSort = ctx.state.filterState.selectedSort;
  ctx.state.sortDesc = ctx.state.filterState.sortDesc;
  ctx.state.isCharger = ctx.state.filterState.isCharger;
  ctx.state.lVote = ctx.state.filterState.lVote;
  ctx.state.rVote = ctx.state.filterState.rVote;

  ctx.state.startDate = ctx.state.filterState.startDate;
  ctx.state.endDate = ctx.state.filterState.endDate;

  print("apply Test");
  _reflash(action, ctx);
}

String filePath;
String currentProcess;
bool isProcessing = false;

Future<String> get _localPath async {
  final directory = await getApplicationSupportDirectory();

  return directory.absolute.path;
}

Future<File> get _localFile async {
  final path = await _localPath;
  filePath = '$path/clouddata.csv';
  return File('$path/clouddata.csv').create();
}

void _getCVS(Action action, Context<BangtalboardState> ctx) async {
  List<List<dynamic>> rows = List<List<dynamic>>();
  rows.add([
    "Name",
    "Charger ID",
    "Start Time",
    "Chg. Time",
    "PWR(kW)",
  ]);
  File f = await _localFile;

  String csv;
  await Firestore.instance
      .collection('chargeTable')
      .document(ctx.state.user.firebaseUser.uid)
      .collection('chargeData')
      .orderBy('start', descending: ctx.state.sortDesc)
      .limit(10)
      .getDocuments()
      .then((value) => {
            value.documents.forEach((element) {
              List<dynamic> row = List<dynamic>();
              row.add(element["user_nm"]);
              row.add(element["deviceName"]);
              row.add(element["start"].toDate().toString().substring(5, 16));
              row.add(element["chargedTime"] ?? "00:00:00".toString());
              row.add(element["get_energy"] ?? "0.00");
              rows.add(row);
            }),
            csv = const ListToCsvConverter().convert(rows),
            f.writeAsString(csv).then((value) => sendMailAndAttachment(ctx)),
          });
}



sendMailAndAttachment(ctx) async {
  final Email email = Email(
    body: 'CVS.TEXT FILE',
    subject: 'Report download file',
    recipients: [ctx.state.user.firebaseUser.email],
    isHTML: true,
    attachmentPath: filePath,
  );

  await FlutterEmailSender.send(email).then((value) => Toast.show(
      "send Mail Ok!", ctx.context,
      duration: 5, gravity: Toast.BOTTOM));
}
