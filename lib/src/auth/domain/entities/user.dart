// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class LocalUser extends Equatable {
  const LocalUser({
    required this.fullName,
    required this.email,
    required this.uid,
    this.bio = '',
    this.profilePic = '',
    // this.point,
    // this.groups = const [],
    // this.enrolledCourses = const [],
    // this.following = const [],
    // this.followers = const [],
  });

  const LocalUser.empty()
      : this(
          email: '',
          uid: '',
          fullName: '',
          bio: '',
          profilePic: '',
          // followers: [],
          // following: [],
          // enrolledCourses: [],
          // point: 0,
          // groups: [],
        );

  final String fullName;
  final String email;
  final String uid;
  final String? profilePic;
  final String bio;
  // final int? point;
  // final List<String>? groups;
  // final List<String>? enrolledCourses;
  // final List<String>? following;
  // final List<String>? followers;

  @override
  List<Object?> get props => [
        uid,
        email,
        fullName,
        profilePic,
        bio,
        // groups,
        // enrolledCourses,
        // followers,
        // following,
      ];

  @override
  bool get stringify => true;
}
