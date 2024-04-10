import 'package:course_app/core/common/app/providers/user_provider.dart';
import 'package:course_app/src/auth/domain/entities/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

extension ContextExtintion on BuildContext {
  ThemeData get theme => Theme.of(this);

  MediaQueryData get mediaQuery => MediaQuery.of(this);
  ScaffoldMessengerState get scaffoldMessenger => ScaffoldMessenger.of(this);
  Size get size => mediaQuery.size;
  double get width => size.width;
  double get height => size.height;
  UserProvider get userProvider => read<UserProvider>();
  LocalUser? get currentLocalUser => read<UserProvider>().user;
}
