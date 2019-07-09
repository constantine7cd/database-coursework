import 'post.dart';

class PostsShow {
  static Post BeyoncePost = Post(
      mediaUrl: "https://fabhub-ui-test.s3.eu-west-2.amazonaws.com/beyPost.jpg",
      username: "beyonce",
      location: "CA",
      description: "it's beyonce's description",
      likes: null,
      postId: "32",
      ownerId: "1");

  static Post LeoPost = Post(
      mediaUrl: "https://fabhub-ui-test.s3.eu-west-2.amazonaws.com/diPost.jpg",
      username: "leo",
      location: "SA",
      description: "it's leo's description",
      likes: null,
      postId: "33",
      ownerId: "2");

  static Post AriPost = Post(
      mediaUrl: "https://fabhub-ui-test.s3.eu-west-2.amazonaws.com/grandePost.png",
      username: "ari",
      location: "WA",
      description: "it's my description",
      likes: null,
      postId: "34",
      ownerId: "3");

  static List<Post> postItems = [BeyoncePost, LeoPost, AriPost];

}