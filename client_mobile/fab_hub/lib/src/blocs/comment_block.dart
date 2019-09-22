import 'package:rxdart/rxdart.dart';
import 'package:fab_hub/src/resources/repository.dart';
import 'package:fab_hub/src/models/comment_model.dart';


class CommentsBlock {

  final _repository = Repository();
  final _postId = PublishSubject<int>();
  final _comments = BehaviorSubject<Future<CommentModel>>();


  Function(int) get fetchCommentsByPostId => _postId.sink.add;
  Observable<Future<CommentModel>> get comments => _comments.stream;


  CommentsBlock() {
    _postId.stream.transform(_commentTransformer()).pipe(_comments);
  }

  Future<bool> addComment(postId, body) async {
    bool res = await _repository.addComment(postId, body);


    return res;
  }

  _commentTransformer() {
    return ScanStreamTransformer(
        (Future<CommentModel> comment, int id, int idx) {

          comment = _repository.fetchCommentByPostId(id);

          return comment;
        },
    );
  }

  void dispose() async {
    _postId.close();
    await _comments.drain();
    _comments.close();
  }
}
