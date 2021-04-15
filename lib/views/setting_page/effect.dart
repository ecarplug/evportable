import 'package:firebase_storage/firebase_storage.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:ecarplugapp/globalbasestate/action.dart';
import 'package:ecarplugapp/globalbasestate/store.dart';
import 'package:ecarplugapp/models/item.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;
import 'action.dart';
import 'state.dart';

Effect<SettingPageState> buildEffect() {
  return combineEffects(<Object, Effect<SettingPageState>>{
    SettingPageAction.action: _onAction,
    SettingPageAction.openPhotoPicker: _openPhotoPicker,
    SettingPageAction.languageTap: _languageTap,
    Lifecycle.initState: _onInit,
    Lifecycle.build: _onBuild,
    Lifecycle.dispose: _onDispose,
  });
}

void _onAction(Action action, Context<SettingPageState> ctx) {}

Future<void> _onInit(Action action, Context<SettingPageState> ctx) async {
  Object ticker = ctx.stfState;
  ctx.state.pageAnimation = AnimationController(
      vsync: ticker,
      duration: Duration(milliseconds: 800),
      reverseDuration: Duration(milliseconds: 300));
  ctx.state.userEditAnimation =
      AnimationController(vsync: ticker, duration: Duration(milliseconds: 300));

  ctx.state.userNameController =
      TextEditingController(text: ctx.state.userName ?? '')
        ..addListener(() {
          ctx.state.userName = ctx.state.userNameController.text;
        });
  ctx.state.phoneController = TextEditingController(text: ctx.state.phone ?? '')
    ..addListener(() {
      ctx.state.phone = ctx.state.phoneController.text;
    });
  ctx.state.photoController =
      TextEditingController(text: ctx.state.photoUrl ?? '')
        ..addListener(() {
          ctx.state.photoUrl = ctx.state.photoController.text;
        });

  SharedPreferences prefs = await SharedPreferences.getInstance();
  final _adultItem = prefs.getBool('adultItems');
  if (_adultItem != null) if (_adultItem != ctx.state.adultSwitchValue)
    ctx.dispatch(SettingPageActionCreator.adultValueUpadte(_adultItem));
  final _appLanguage = prefs.getString('appLanguage');
  if (_appLanguage != null)
    ctx.dispatch(SettingPageActionCreator.setLanguage(Item(_appLanguage)));
}

void _onDispose(Action action, Context<SettingPageState> ctx) {
  ctx.state.pageAnimation?.dispose();
  ctx.state.userEditAnimation?.dispose();
  ctx.state.userNameController.dispose();
  ctx.state.phoneController.dispose();
  ctx.state.photoController.dispose();
}

void _onBuild(Action action, Context<SettingPageState> ctx) {
  ctx.state.pageAnimation.forward();
}

Future _openPhotoPicker(Action action, Context<SettingPageState> ctx) async {
  final ImagePicker _imagePicker = ImagePicker();
  final _image = await _imagePicker.getImage(
      source: ImageSource.gallery, maxHeight: 100, maxWidth: 100);
  if (_image != null) {
    ctx.dispatch(SettingPageActionCreator.onUploading(true));
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child('avatar/${Path.basename(_image.path)}');
    StorageUploadTask uploadTask =
        storageReference.putData(await _image.readAsBytes());
    await uploadTask.onComplete;
    print('File Uploaded');
    storageReference.getDownloadURL().then((fileURL) {
      if (fileURL != null) {
        ctx.state.photoController.text = fileURL;
        ctx.dispatch(SettingPageActionCreator.userPanelPhotoUrlUpdate(fileURL));
      }
      ctx.dispatch(SettingPageActionCreator.onUploading(false));
    });
  }
}

void _languageTap(Action action, Context<SettingPageState> ctx) async {
  final Item _language = action.payload;
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (_language.name == 'System Default')
    prefs.remove('appLanguage');
  else
    prefs.setString('appLanguage', _language.toString());
  ctx.dispatch(SettingPageActionCreator.setLanguage(_language));
  GlobalStore.store.dispatch(GlobalActionCreator.changeLocale(
      _language.value == null ? null : Locale(_language.value)));
}
