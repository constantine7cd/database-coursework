class PostModel {

  List <PostItem> _posts = [];

  PostModel.fromJson(List<Map<String, dynamic>> data) {

    for (int i=0; i < data.length; i++) {
      PostItem item = PostItem.fromJson(data[i]);
      posts.add(item);
    }
  }

  List <PostItem> get posts => _posts;
}


class PostItem {
  final int postId;
  final int ownerId;
  final int profileId;

  final String mediaUrl;
  final String avatarUrl;

  final String username;
  final String location;
  final String description;

  final likes;
  final int likesCount;

  const PostItem({
    this.postId,
    this.ownerId,
    this.profileId,

    this.mediaUrl,
    this.avatarUrl,

    this.username,
    this.location,
    this.description,

    this.likes,
    this.likesCount,
  });

  factory PostItem.fromJson(Map<String, dynamic> json) {

    return PostItem(
        postId: json['id'],
        ownerId: json['owner']['id'],
        profileId: json['owner']['profile']['id'],

        mediaUrl: json['asset_bundle']['asset_urls']['original'],
        avatarUrl: json['owner']['profile']['avatar_url'],

        username: json['owner']['username'],
        description: json['description'],

        location: json['location'],

        likes: new List<String>.from(json['likes']),
        likesCount: json['likes_count'],
    );
  }
}