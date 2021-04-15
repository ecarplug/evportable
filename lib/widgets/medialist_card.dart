import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ecarplugapp/actions/adapt.dart';
import 'package:ecarplugapp/globalbasestate/store.dart';
import 'package:ecarplugapp/models/base_api_model/user_list.dart';
import 'package:ecarplugapp/models/enums/media_type.dart';
import 'package:ecarplugapp/models/mylist_model.dart';
import 'package:ecarplugapp/models/response_model.dart';
import 'package:ecarplugapp/style/themestyle.dart';

class MediaListCardDialog extends StatefulWidget {
  final MediaType type;
  final int mediaId;
  final String name;
  final double rated;
  final String photourl;
  final int runtime;
  final int revenue;
  final String releaseDate;
  MediaListCardDialog(
      {@required this.type,
      @required this.mediaId,
      this.name,
      this.rated,
      this.photourl,
      this.runtime = 0,
      this.revenue = 0,
      this.releaseDate});
  @override
  MediaListCardDialogState createState() => MediaListCardDialogState();
}

class MediaListCardDialogState extends State<MediaListCardDialog> {
  Future<MyListModel> lists;
  ScrollController scrollController;
  Future<ResponseModel<UserListModel>> _userList;

  final _user = GlobalStore.store.getState().user;

  initUserlist() {
    if (_user != null) setState(() {});
  }

  void _createList(BuildContext context) async {
    if (_user != null) {
      setState(() {
        _userList = null;
      });
      await Navigator.of(context).pushNamed('createListPage');
      initUserlist();
    }
  }

  Future _submit() async {
    Navigator.of(context).pop();
  }

  void _onSelected(UserList userlist) async {
    final l = await _userList;
    l.result.data.forEach((f) {
      if (f.selected == 1) f.selected = 0;
    });
    userlist.selected = 1;
    setState(() {});
  }

  @override
  void initState() {
    initUserlist();
    scrollController = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    return SimpleDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Adapt.px(20))),
        title: _Title(onAdd: () => _createList(context)),
        children: <Widget>[
          Container(
            width: _size.width,
            height: _size.height / 2,
            child: FutureBuilder<ResponseModel<UserListModel>>(
              future: _userList,
              builder: (BuildContext context,
                  AsyncSnapshot<ResponseModel<UserListModel>> snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.active:
                  case ConnectionState.waiting:
                    return Container(
                      margin: EdgeInsets.only(top: Adapt.px(30)),
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(Colors.black),
                      ),
                    );
                  case ConnectionState.done:
                    if (snapshot.hasData && snapshot.data.success) {
                      final List<UserList> _list =
                          snapshot.data?.result?.data ?? [];
                      return ListView.separated(
                          padding: EdgeInsets.symmetric(
                              horizontal: 24, vertical: 10),
                          itemBuilder: (_, index) {
                            final d = _list[index];
                            return _ListCell(
                              data: d,
                              selected: d.selected == 1,
                              onTap: _onSelected,
                            );
                          },
                          separatorBuilder: (_, index) => SizedBox(height: 10),
                          itemCount: _list.length);
                    } else
                      return SizedBox();
                }
                return SizedBox();
              },
            ),
          ),
          _ButtonPanel(
            onSubmit: _submit,
            onCancel: () => Navigator.of(context).pop(),
          )
        ]);
  }
}

class _Title extends StatelessWidget {
  final Function onAdd;
  const _Title({this.onAdd});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Add to my list'),
        GestureDetector(
          onTap: onAdd,
          child: Icon(Icons.add_circle),
        ),
      ],
    );
  }
}

class _ListCell extends StatelessWidget {
  final UserList data;
  final bool selected;
  final Function(UserList) onTap;
  const _ListCell({this.data, this.selected, this.onTap});
  @override
  Widget build(BuildContext context) {
    final _theme = ThemeStyle.getTheme(context);
    return GestureDetector(
        onTap: () => onTap(data),
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: selected
              ? BoxDecoration(
                  border: Border.all(color: _theme.iconTheme.color),
                  borderRadius: BorderRadius.circular(5),
                )
              : null,
          child: Text(
            data.listName ?? '',
            style: TextStyle(fontSize: 18),
          ),
        ));
  }
}

class _ButtonPanel extends StatelessWidget {
  final Function onSubmit;
  final Function onCancel;
  const _ButtonPanel({this.onSubmit, this.onCancel});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _Button(
            text: 'cancel',
            onPress: onCancel,
          ),
          SizedBox(width: 24),
          _Button(
            text: 'ok',
            onPress: onSubmit,
          ),
        ],
      ),
    );
  }
}

class _Button extends StatelessWidget {
  final String text;
  final Function onPress;
  const _Button({this.onPress, this.text});
  @override
  Widget build(BuildContext context) {
    final _theme = ThemeStyle.getTheme(context);
    final _textStyle = TextStyle(
        fontSize: 16,
        color: _theme.brightness == Brightness.light
            ? const Color(0xFFFFFFFF)
            : const Color(0xFF000000));
    return InkWell(
      onTap: onPress,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        constraints: BoxConstraints(minWidth: 80),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: _theme.iconTheme.color),
        child: Center(
          child: Text(
            text,
            style: _textStyle,
          ),
        ),
      ),
    );
  }
}
