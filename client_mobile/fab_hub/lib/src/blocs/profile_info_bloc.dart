import 'package:rxdart/rxdart.dart';

import 'package:fab_hub/src/resources/repository.dart';
import 'package:fab_hub/src/models/profile_model.dart';


class ProfileInfoBlock {
  final _repository = Repository();

  final _profileInfoFetcher = BehaviorSubject<ProfileModel>();

  Observable<ProfileModel> get profile => _profileInfoFetcher.stream;

  fetchProfile(int profileId) async {
    var _profile = await _repository.fetchProfile(profileId);

    _profileInfoFetcher.sink.add(_profile);
  }

  void dispose() async {
    _profileInfoFetcher.close();
  }

}

final profileInfoBloc = ProfileInfoBlock();