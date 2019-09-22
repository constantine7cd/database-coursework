import 'dart:async';
import 'dart:io';

import 'package:fab_hub/src/models/post_model.dart';
import 'package:fab_hub/src/models/comment_model.dart';
import 'package:fab_hub/src/models/profile_model.dart';

import 'package:fab_hub/src/resources/posts_api_provider.dart';
import 'package:fab_hub/src/resources/comments_api_provider.dart';
import 'package:fab_hub/src/resources/likes_api_provider.dart';
import 'package:fab_hub/src/resources/profile_api_provider.dart';
import 'package:fab_hub/src/resources/image_uploader.dart';
import 'package:fab_hub/src/resources/logger.dart';

class Repository {

  final postApiProvider = PostApiProvider();
  final commentApiProvider = CommentApiProvider();
  final likesApiProvider = LikesApiProvider();
  final profileApiProvider = ProfileApiProvider();
  final imageUploader = ImageUploader();

  final logger = Logger();

  Future <PostModel> fetchPosts() => postApiProvider.fetchPostList();

  Future <PostModel> fetchSearchPosts() => postApiProvider.fetchSearchPostList();

  Future <PostModel> fetchPostsProfile(profileId) => postApiProvider.fetchPostsProfile(profileId);

  Future <CommentModel> fetchCommentByPostId(postId) => commentApiProvider.fetchCommentList(postId);

  Future <bool> addComment(postId, body) => commentApiProvider.addComment(postId, body);

  Future <void> likeItem(postId) => likesApiProvider.likeItem(postId);

  Future <void> unlikeItem(postId) => likesApiProvider.unlikeItem(postId);

  Future <ProfileModel> fetchProfile(profileId) => profileApiProvider.fetchProfile(profileId);

  Future <void> editProfile({String username, String fName, String lName,
    String bio, String website, String avatarUrl}) => profileApiProvider.editProfile(username: username,
      fName: fName, lName: lName, bio: bio, website: website, avatarUrl: avatarUrl);

  Future <void> followProfile(int subscribingProfileId) =>
      profileApiProvider.followProfile(subscribingProfileId);

  Future <void> unfollowProfile(int subscribingProfileId) =>
      profileApiProvider.unfollowProfile(subscribingProfileId);


  Future <void> uploadPost(File file, String description,
      String location) => imageUploader.uploadPost(file, description, location);

  Future <void> uploadImage(File file) => imageUploader.uploadImage(file);


  Future<Map<String, dynamic>> register(String email, String username, String password, String firstName,
      String lastName) => logger.register(email, username, password, firstName, lastName);

  Future<Map<String, dynamic>>login(String email, String password) => logger.login(email, password);

  Future<void> logout() => logger.logout();

}