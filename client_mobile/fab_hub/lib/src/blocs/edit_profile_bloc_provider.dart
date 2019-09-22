import 'package:flutter/material.dart';
import 'package:fab_hub/src/blocs/edit_profile_bloc.dart';


class EditProfileBlockProvider extends InheritedWidget {
  final EditProfileBlock bloc;

  EditProfileBlockProvider({Key key, Widget child})
      : bloc = EditProfileBlock(),
        super(key: key, child: child);

  @override
  bool updateShouldNotify(_) {
    return true;
  }

  static EditProfileBlock of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(EditProfileBlockProvider)
    as EditProfileBlockProvider)
        .bloc;
  }
}