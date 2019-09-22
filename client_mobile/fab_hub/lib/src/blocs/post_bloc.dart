import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:fab_hub/src/resources/repository.dart';
import 'package:fab_hub/src/blocs/login_register_bloc.dart';

class PostBlock {

  final int postId;
  final String username;

  final _repository = Repository();

  final _likes = BehaviorSubject<List<String>>();
  final _likesCount = BehaviorSubject<int>();
  final _isLiked = BehaviorSubject<bool>();
  final _showHeart = BehaviorSubject<bool>();

  get isLiked => _isLiked.stream;
  get showHeart => _showHeart.stream;
  get likesCount => _likesCount.stream;
  get likes => _likes.stream;


  PostBlock(this.postId, this.username, List<String> likes, int likesCount) {

    _likes.sink.add(likes);
    _likesCount.sink.add(likesCount);

    _isLiked.sink.add(_checkIsLiked(likes));
    _showHeart.sink.add(false);
  }

  _checkIsLiked(List<String> likes) {
    return likes.contains(username);
  }

  likePost() async {
    try {
      if (!_isLiked.value) {
        await _repository.likeItem(postId);

        _isLiked.sink.add(true);
        _likesCount.sink.add(_likesCount.value + 1);
        _likes.value.add(username);

      } else {
        await _repository.unlikeItem(postId);

        _isLiked.sink.add(false);
        _likesCount.sink.add(_likesCount.value - 1);

        //TODO: Reduce complexity using maps
        _likes.value.remove(username);
      }
    } catch(e) {
      throw(e);
    }
  }

  likePostAndShowHeart() async {
    try {
      await likePost();

      if (_isLiked.value) {
        _showHeart.sink.add(true);

        Timer(const Duration(milliseconds: 700), () {
          _showHeart.sink.add(false);
        });
      }
    } catch(e) {
      throw(e);
    }
  }

  dispose() {
    _likes.close();
    _likesCount.close();
    _isLiked.close();
    _showHeart.close();
  }
}
