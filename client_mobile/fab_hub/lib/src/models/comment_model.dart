class CommentModel {

  List <CommentItem> _comments;


  CommentModel.fromJson(List<Map<String, dynamic>> data) {

    List<CommentItem> comments_ = [];

    for (int i=0; i < data.length; i++) {
      CommentItem item = CommentItem.fromJson(data[i]);
      print("Item body " + item.body);

      comments_.add(item);
    }

    _comments = comments_;

  }

  get comments => _comments;
}

class CommentItem {
  final String username;
  final String avatarUrl;
  final String body;
  final String createdAt;

  const CommentItem({
    this.username,
    this.avatarUrl,
    this.body,
    this.createdAt
  });

  factory CommentItem.fromJson(Map<String, dynamic> json) {
    return CommentItem(
        username: json['owner']['username'],
        avatarUrl: json['owner']['profile']['avatar_url'],
        body: json['body'],
        createdAt: json['created_at']
    );
  }
}