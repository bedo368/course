import 'dart:convert';

import 'package:course_app/core/utils/typedef.dart';
import 'package:course_app/src/auth/domain/entities/user.dart';

class UserModel extends LocalUser {
  const UserModel({
    required super.fullName,
    required super.email,
    required super.uid,
    required super.point,
    super.groups,
    super.enrolledCourses,
    super.following,
    super.followers,
    super.bio,
    super.profilePic,
  });

  factory UserModel.fromMap(DataMap data) {
    return UserModel(
      email: data['email'] as String,
      fullName: data['fullName'] as String,
      uid: data['uid'] as String,
      point: (data['point'] as num).toInt(),
      enrolledCourses: data['enrolledCourses'] != null
          ? (data['enrolledCourses'] as List<dynamic>).cast<String>()
          : [],
      profilePic:
          data['profilePic'] != null ? data['profilePic'] as String : '',
      followers: data['followrs'] != null
          ? (data['followrs'] as List<dynamic>).cast<String>()
          : [],
      following: data['following'] != null
          ? (data['following'] as List<dynamic>).cast<String>()
          : [],
      groups: data['groups'] != null
          ? (data['groups'] as List<dynamic>).cast<String>()
          : [],
    );
  }

  UserModel.empty()
      : this(
          email: '',
          uid: '',
          followers: [],
          following: [],
          fullName: '',
          enrolledCourses: [],
          point: 0,
          profilePic: '',
          bio: '',
          groups: [],
        );

  DataMap toMap({bool forJson = false}) {
    return {
      'email': email,
      'fullName': fullName,
      'bio': bio,
      'uid': uid,
      'profilePic': profilePic,
      'followers': forJson ? followers.toString() : followers,
      'following': forJson ? following.toString() : following,
      'point': point,
      'enrolledCourses': forJson ? enrolledCourses.toString() : enrolledCourses,
      'groups': forJson ? groups.toString() : groups,
    };
  }

  LocalUser copyWith({
    String? fullName,
    String? email,
    String? uid,
    String? profilePic,
    String? bio,
    int? point,
    List<String>? groups,
    List<String>? enrolledCourses,
    List<String>? following,
    List<String>? followers,
  }) {
    return LocalUser(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      uid: uid ?? this.uid,
      profilePic: profilePic ?? this.profilePic,
      bio: bio ?? this.bio,
      point: point ?? this.point,
      groups: groups ?? this.groups,
      enrolledCourses: enrolledCourses ?? this.enrolledCourses,
      following: following ?? this.following,
      followers: followers ?? this.followers,
    );
  }

  String toJson() => jsonEncode(toMap(forJson: true));
  @override
  List<Object?> get props => [uid];
}
