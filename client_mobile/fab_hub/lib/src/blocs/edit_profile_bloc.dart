import 'package:rxdart/rxdart.dart';

import 'package:fab_hub/src/models/profile_model.dart';
import 'package:fab_hub/src/resources/repository.dart';


class EditProfileBlock {

  final _repository = Repository();
  final _profileId = PublishSubject<int>();
  final _profile = BehaviorSubject<Future<ProfileModel>>();

  Observable<Future<ProfileModel>> get profile => _profile.stream;

  EditProfileBlock() {
    _profileId.stream.transform(_profileTransformer()).pipe(_profile);
  }

  Future<void> editProfile({int profileId, String uname, String fName, String lName, String bio,
    String wsite, String aUrl}) async {

    try {
      await _repository.editProfile(username: uname, fName: fName,
          lName: lName, bio: bio, website: wsite, avatarUrl: aUrl);
    } catch(e) {
      throw(e);
    }
  }


  Function(int) get fetchProfileById {
    return _profileId.sink.add;
  }

  _profileTransformer() {
    return ScanStreamTransformer(
          (Future<ProfileModel> profile, int id, int idx) {

        profile = _repository.fetchProfile(id);

        return profile;
      },
    );
  }

  void dispose() async {
    _profileId.close();


    await _profile.drain();
    _profile.close();
  }
}
