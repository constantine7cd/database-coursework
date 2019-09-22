import 'package:rxdart/rxdart.dart';
import 'package:fab_hub/src/resources/repository.dart';
import 'package:fab_hub/src/models/post_model.dart';
import 'package:fab_hub/src/blocs/login_register_bloc.dart';

class PostsBlock {
  final _repository = Repository();
  final _postsFetcher = PublishSubject<PostModel>();

  Observable<PostModel> get allPosts => _postsFetcher.stream;

  Future<void> fetchPosts() async {
    PostModel postModel = await _repository.fetchPosts();
    _postsFetcher.sink.add(postModel);

    return;
  }

  dispose() {
    _postsFetcher.close();
  }

}

final bloc = PostsBlock();