// ignore_for_file: one_member_abstracts

import 'package:course_app/core/utils/typedef.dart';

abstract class UseCaseswithParams<Type, Parmas> {
  FutureResult<Type> call(Parmas parmas);
}

abstract class UseCaseswithOutParams<Type> {
  FutureResult<Type> call();
}
