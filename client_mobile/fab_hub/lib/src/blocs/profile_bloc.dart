import 'package:rxdart/rxdart.dart';
import 'package:fab_hub/src/resources/repository.dart';
import 'package:fab_hub/src/models/profile_model.dart';

import 'package:fab_hub/src/models/post_model.dart';
import 'package:fab_hub/src/blocs/login_register_bloc.dart';


class ProfileBlock {

  final _repository = Repository();

  final _profileId = PublishSubject<int>();
  final _profile = BehaviorSubject<Future<ProfileModel>>();
  final _posts = BehaviorSubject<Future<PostModel>>();

  final _followersCount = BehaviorSubject<int>();
  final _followingCount = BehaviorSubject<int>();
  final _postsCount = BehaviorSubject<int>();
  final _isFollowing = BehaviorSubject<bool>();

  Function(int) get fetchProfileById {


    return _profileId.sink.add;
  }
  Observable<Future<ProfileModel>> get profile => _profile.stream;
  Observable<Future<PostModel>> get posts => _posts.stream;

  Observable<int> get followersCount => _followersCount.stream;
  Observable<int> get followingCount => _followingCount.stream;
  Observable<int> get postsCount => _postsCount.stream;
  Observable<bool> get isFollowing => _isFollowing.stream;


  ProfileBlock() {

    _postsCount.sink.add(0);
    _followingCount.sink.add(0);
    _followersCount.sink.add(0);
    _isFollowing.sink.add(false);

    _profileId.stream.transform(_profileTransformer()).pipe(_profile);
    _profileId.stream.transform(_postsTransformer()).pipe(_posts);
  }


  Future<void> followProfile(int subscribingProfileId) async {

    try {
      await _repository.followProfile(subscribingProfileId);

      _isFollowing.sink.add(true);
      _followersCount.sink.add(_followersCount.value + 1);
    } catch(e) {
      throw e;
    }
  }

  Future<void> unfollowProfile(int subscribingProfileId) async {

    try {
      await _repository.unfollowProfile(subscribingProfileId);

      _isFollowing.sink.add(false);
      _followersCount.sink.add(_followersCount.value - 1);

    } catch(e) {
      throw e;
    }
  }

  _checkIsFollowing(followers, uname) {

    for (int i=0; i < followers.length; i += 1)
      if (followers[i]['username'] == uname)
        return true;

    return false;
  }

  _profileTransformer() {
    return ScanStreamTransformer(
          (Future<ProfileModel> profile, int id, int idx) {

        profile = _repository.fetchProfile(id);

        profile.then((v) async {
          _followersCount.sink.add(v.profile.followers.length);
          _followingCount.sink.add(v.profile.following.length);

          var username = await loginRegBloc.username;

          _isFollowing.sink.add(_checkIsFollowing(v.profile.followers, username));
        });

        return profile;
      },
    );
  }

  _postsTransformer() {
    return ScanStreamTransformer(
          (Future<PostModel> post, int id, int idx) {

        post = _repository.fetchPostsProfile(id);

        post.then((v) {
          _postsCount.sink.add(v.posts.length);
        });

        return post;
      },
    );
  }

  void dispose() async {
    _profileId.close();

    _followingCount.close();
    _followersCount.close();
    _postsCount.close();
    _isFollowing.close();

    await _profile.drain();
    _profile.close();

    await _posts.drain();
    _posts.close();
  }
}
