import 'package:flutter/material.dart';
import 'package:fab_hub/src/blocs/profile_bloc.dart';


class ProfileBlockProvider extends InheritedWidget {
  final ProfileBlock bloc;

  ProfileBlockProvider({Key key, Widget child})
      : bloc = ProfileBlock(),
        super(key: key, child: child);

  @override
  bool updateShouldNotify(_) {
    return true;
  }

  static ProfileBlock of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(ProfileBlockProvider)
    as ProfileBlockProvider)
        .bloc;
  }
}
