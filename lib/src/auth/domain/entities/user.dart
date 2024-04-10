// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class LocalUser extends Equatable {
  const LocalUser({
    required this.fullName,
    required this.email,
    required this.uid,
    required this.point,
    this.groups = const [],
    this.enrolledCourses = const [],
    this.following = const [],
    this.followers = const [],
    this.profilePic = '',
    this.bio = '',
  });

  LocalUser.empty()
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

  final String fullName;
  final String email;
  final String uid;
  final String? profilePic;
  final String? bio;
  final int point;
  final List<String>? groups;
  final List<String>? enrolledCourses;
  final List<String>? following;
  final List<String>? followers;

  @override
  List<Object?> get props => [
        uid,
        email,
        fullName,
        profilePic,
        bio,
        groups,
        enrolledCourses,
        followers,
        following,
        profilePic,
      ];

  @override
  bool get stringify => true;
}
