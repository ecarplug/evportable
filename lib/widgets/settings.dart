import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:ecarplugapp/const/const.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          '프로필 변경',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SettingsScreen(),
    );
  }
}

class SettingsScreen extends StatefulWidget {
  @override
  State createState() => SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> {
  TextEditingController controllername;
  TextEditingController controllerAboutMe;
  TextEditingController controllerStatusMessage;
  SharedPreferences prefs;

  String id = '';
  String name = '';
  String aboutMe = '';
  String photoUrl = '';
  String myGroup = '';

  bool isLoading = false;
  File avatarImageFile;

  final FocusNode focusNodename = FocusNode();
  final FocusNode focusNodeAboutMe = FocusNode();

  final FocusNode focusmyGroup = FocusNode();

  @override
  initState() {
    super.initState();

    readLocal();
  }

  void readLocal() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    //GoogleSignIn googleSignIn = GoogleSignIn();
    //GoogleSignInAccount account = await googleSignIn.signIn();
    //GoogleSignInAuthentication authentication = await account.authentication;
    //uthCredential credential = GoogleAuthProvider.getCredential(
    //  idToken: authentication.idToken,
    //  accessToken: authentication.accessToken);
    //AuthResult authResult = await auth.signInWithCredential(credential);
    //FirebaseUser firebaseUser = authResult.user;
    auth.currentUser().then((firebaseUser) => {
          Firestore.instance
              .collection('users')
              .where('id', isEqualTo: firebaseUser.uid)
              .getDocuments()
              .then((value) => {
                    id = firebaseUser.uid,
                    if (value.documents.length == 0)
                      {
                        // Update data to server if new user
                        Firestore.instance
                            .collection('users')
                            .document(firebaseUser.uid)
                            .setData({
                          'name': firebaseUser.displayName,
                          'photoUrl': firebaseUser.photoUrl,
                          'aboutMe': aboutMe,
                          'myGroup': myGroup,
                          'id': firebaseUser.uid,
                          'createdAt':
                              DateTime.now().millisecondsSinceEpoch.toString(),
                          'chattingWith': null
                        }).then((value) => {
                                  id = firebaseUser.uid,
                                  name = firebaseUser.displayName,
                                  aboutMe = '',
                                  myGroup = '',
                                  photoUrl = firebaseUser.photoUrl
                                })

                             
                                
                      }
                    else
                      {
                        id = firebaseUser.uid,
                        name = firebaseUser.displayName,
                        aboutMe = value.documents.first.data['aboutMe'] ?? '',
                        myGroup =
                            value.documents.first.data['myGroup'] ?? '',
                        photoUrl = firebaseUser.photoUrl,
                        controllername =
                            TextEditingController(text: name),
                        controllerAboutMe =
                            TextEditingController(text: aboutMe),
                        controllerStatusMessage =
                            TextEditingController(text: myGroup),
                        setState(() {})
                      }
                  }),
        
            SharedPreferences.getInstance().then((prefs) => {
                id = prefs.getString('id') ?? firebaseUser.uid,
                name = firebaseUser.displayName,
                aboutMe = prefs.getString('aboutMe') ?? '',
                myGroup = prefs.getString('myGroup') ?? '',
                photoUrl = firebaseUser.photoUrl,
                controllername = TextEditingController(text: name),
                controllerAboutMe = TextEditingController(text: aboutMe),
                controllerStatusMessage =
                    TextEditingController(text: myGroup),
                setState(() {})
              })
                   

        });




    // Force refresh input
  }

  Future getImage() async {
    File image = await ImagePicker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        avatarImageFile = image;
        isLoading = true;
      });
    }
    uploadFile();
  }

  Future uploadFile() async {
    String fileName = id;
    StorageReference reference = FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = reference.putFile(avatarImageFile);
    StorageTaskSnapshot storageTaskSnapshot;
    uploadTask.onComplete.then((value) {
      if (value.error == null) {
        storageTaskSnapshot = value;
        storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) {
          photoUrl = downloadUrl;
          Firestore.instance.collection('users').document(id).updateData({
            'name': name,
            'aboutMe': aboutMe,
            'myGroup': myGroup,
            'photoUrl': photoUrl
          }).then((data) async {
            //      await prefs.setString('photoUrl', photoUrl);
            setState(() {
              isLoading = false;
                prefs.setString('myGroup',myGroup) ;

            });
            Fluttertoast.showToast(msg: "Upload success");
          }).catchError((err) {
            setState(() {
              isLoading = false;
            });
            Fluttertoast.showToast(msg: err.toString());
          });
        }, onError: (err) {
          setState(() {
            isLoading = false;
          });
          Fluttertoast.showToast(msg: 'This file is not an image');
        });
      } else {
        setState(() {
          isLoading = false;
        });
        Fluttertoast.showToast(msg: 'This file is not an image');
      }
    }, onError: (err) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: err.toString());
    });
  }

  void handleUpdateData() {
    focusNodename.unfocus();
    focusNodeAboutMe.unfocus();
    focusmyGroup.unfocus();
    setState(() {
      isLoading = true;
    });

    Firestore.instance.collection('users').document(id).updateData({
      'name': name,
      'aboutMe': aboutMe,
      'myGroup': myGroup,
      'photoUrl': photoUrl
    }).then((data) async {
        final UserUpdateInfo _userInfo = UserUpdateInfo();
      _userInfo.displayName = name;
      _userInfo.photoUrl = photoUrl;

      final FirebaseAuth auth = FirebaseAuth.instance;
      GoogleSignIn googleSignIn = GoogleSignIn();
      GoogleSignInAccount account = await googleSignIn.signIn();
      GoogleSignInAuthentication authentication = await account.authentication;
      AuthCredential credential = GoogleAuthProvider.getCredential(
          idToken: authentication.idToken,
          accessToken: authentication.accessToken);
      AuthResult authResult = await auth.signInWithCredential(credential);
       FirebaseUser firebaseUser = authResult.user;
      SharedPreferences.getInstance().then((prefs) => {
            prefs.setString('name',firebaseUser.displayName ),
            prefs.setString('aboutMe', aboutMe),
            prefs.setString('myGroup', myGroup),
            prefs.setString('photoUrl', photoUrl),
          });

     
       
      
      auth
          .currentUser()
          .then((firebaseUser) => {firebaseUser.updateProfile(_userInfo)});

      setState(() {
        isLoading = false;
      });
/*
      Firestore.instance
          .collection('bangTalBoard')
          .where("USER_ID", isEqualTo: id)
          .getDocuments()
          .then((_bangtaktok) => {
                _bangtaktok.documents.forEach((element) {
                  Firestore.instance
                      .collection('bangTalBoard')
                      .document(element.documentID)
                      .updateData({'USER_photoUrl': photoUrl});
                })
              });
 
 */

      Fluttertoast.showToast(msg: "Update success");
    }).catchError((err) {
      setState(() {
        isLoading = false;
      });

      Fluttertoast.showToast(msg: err.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
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
                          ? (photoUrl != ''
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
                                    imageUrl: photoUrl,
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
                      IconButton(
                        icon: Icon(
                          Icons.camera_alt,
                          color: primaryColor.withOpacity(0.5),
                        ),
                        onPressed: getImage,
                        padding: EdgeInsets.all(30.0),
                        splashColor: Colors.transparent,
                        highlightColor: greyColor,
                        iconSize: 30.0,
                      ),
                    ],
                  ),
                ),
                width: double.infinity,
                margin: EdgeInsets.all(20.0),
              ),

              // Input
              Column(
                children: <Widget>[
                  // Username
                  Container(
                    child: Text(
                      'Name',
                      style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                          color: primaryColor),
                    ),
                    margin: EdgeInsets.only(left: 10.0, bottom: 5.0, top: 10.0),
                  ),
                  Container(
                    child: Theme(
                      data: Theme.of(context)
                          .copyWith(primaryColor: primaryColor),
                      child: TextField(
                        readOnly:true,
                        decoration: InputDecoration(
                          hintText: '....',
                          contentPadding: EdgeInsets.all(5.0),
                          hintStyle: TextStyle(color: greyColor),
                        ),
                        controller: controllername,
                        onChanged: (value) {
                          name = value;
                        },
                        focusNode: focusNodename,
                      ),
                    ),
                    margin: EdgeInsets.only(left: 30.0, right: 30.0),
                  ),

                  // About me
                  Container(
                    child: Text(
                      'My Info',
                      style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                          color: primaryColor),
                    ),
                    margin: EdgeInsets.only(left: 10.0, top: 30.0, bottom: 5.0),
                  ),
                  Container(
                    child: Theme(
                      data: Theme.of(context)
                          .copyWith(primaryColor: primaryColor),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Fun, like travel and play PES...',
                          contentPadding: EdgeInsets.all(5.0),
                          hintStyle: TextStyle(color: greyColor),
                        ),
                        controller: controllerAboutMe,
                        onChanged: (value) {
                          aboutMe = value;
                        },
                        focusNode: focusNodeAboutMe,
                      ),
                    ),
                    margin: EdgeInsets.only(left: 30.0, right: 30.0),
                  ),
                  Container(
                    child: Text(
                      'My Group',
                      style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                          color: primaryColor),
                    ),
                    margin: EdgeInsets.only(left: 10.0, top: 30.0, bottom: 5.0),
                  ),
                  Container(
                    child: Theme(
                      data: Theme.of(context)
                          .copyWith(primaryColor: primaryColor),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'My Group ....',
                          contentPadding: EdgeInsets.all(5.0),
                          hintStyle: TextStyle(color: greyColor),
                        ),
                        controller: controllerStatusMessage,
                        onChanged: (value) {
                          myGroup = value;
                        },
                        focusNode: focusmyGroup,
                      ),
                    ),
                    margin: EdgeInsets.only(left: 30.0, right: 30.0),
                  ),
                ],
                crossAxisAlignment: CrossAxisAlignment.start,
              ),

              // Button
              Container(
                child: FlatButton(
                  onPressed: handleUpdateData,
                  child: Text(
                    'UPDATE',
                    style: TextStyle(fontSize: 16.0),
                  ),
                  color: primaryColor,
                  highlightColor: Color(0xff8d93a0),
                  splashColor: Colors.transparent,
                  textColor: Colors.white,
                  padding: EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 10.0),
                ),
                margin: EdgeInsets.only(top: 50.0, bottom: 50.0),
              ),
            ],
          ),
          padding: EdgeInsets.only(left: 15.0, right: 15.0),
        ),

        // Loading
        Positioned(
          child: isLoading
              ? Container(
                  child: Center(
                    child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(themeColor)),
                  ),
                  color: Colors.white.withOpacity(0.8),
                )
              : Container(),
        ),
      ],
    );
  }
}
