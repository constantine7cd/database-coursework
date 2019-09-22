class ProfileModel {

  ProfileItem _profile;


  ProfileModel.fromJson(Map<String, dynamic> data) {

    _profile = ProfileItem.fromJson(data);

  }

  ProfileItem get profile => _profile;

}

class ProfileItem {
  final int id;
  final String username;
  final String avatarUrl;
  final String firstName;
  final String lastName;
  final String website;
  final String bio;

  final List<Map<String, dynamic>> followers;
  final List<Map<String, dynamic>> following;

  const ProfileItem({
    this.id,
    this.username,
    this.avatarUrl,
    this.firstName,
    this.lastName,
    this.bio,
    this.website,
    this.followers,
    this.following
  });

  factory ProfileItem.fromJson(Map<String, dynamic> json) {
    return ProfileItem(
      id: json['id'],
      username: json['username'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      website: json['website_url'],
      avatarUrl: json['avatar_url'],
      bio: json['bio'],
      followers: List<Map<String, dynamic>>.from(json['followers']),
      following: List<Map<String, dynamic>>.from(json['following']),
    );
  }
}