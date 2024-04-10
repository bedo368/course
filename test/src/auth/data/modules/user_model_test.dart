import 'dart:convert';

import 'package:course_app/core/utils/typedef.dart';
import 'package:course_app/src/auth/data/modules/user_model.dart';
import 'package:course_app/src/auth/domain/entities/user.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture.dart';

void main() {
  late UserModel user;

  setUp(() {
    user = UserModel.empty();
  });
  test('test the user model should be a sub class of the local user  ',
      () async {
    //  arrange

    expect(user, isA<LocalUser>());
  });
  final tmap = jsonDecode(fixture('user_model.json')) as DataMap;
  group('fromMap', () {
    test('should retrun a user from map ', () {
      final reault = UserModel.fromMap(tmap);

      expect(reault, user);
    });

    test('fail when one of the main element is not valid', () {
      final newmap = tmap..remove('uid');
      const res = UserModel.fromMap;

      expect(() => res(newmap), throwsA(isA<Error>()));
    });
  });

  group('toMap', () {
    test('should retrun a user map  ', () {
      final emptyUserMap = {
        'email': '',
        'uid': '',
        'followers': <String>[],
        'following': <String>[],
        'fullName': '',
        'enrolledCourses': <String>[],
        'point': 0,
        'profilePic': '',
        'bio': '',
        'groups': <String>[],
      };

      final emptyUser = UserModel.empty();
      final reault = emptyUser.toMap();

      expect(reault, emptyUserMap);
    });
  });
}
