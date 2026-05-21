import 'package:flutter/material.dart';

import '../presentation/bersicht_screen/bersicht_screen.dart';
import '../presentation/geld_tracker_screen/geld_tracker_screen.dart';
import '../presentation/sign_up_login_screen/sign_up_login_screen.dart';

class AppRoutes {
  static const String initial = '/';
  static const String signUpLoginScreen = '/sign-up-login-screen';
  static const String bersichtScreen = '/bersicht-screen';
  static const String geldTrackerScreen = '/geld-tracker-screen';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SignUpLoginScreen(),
    signUpLoginScreen: (context) => const SignUpLoginScreen(),
    bersichtScreen: (context) => const BersichtScreen(),
    geldTrackerScreen: (context) => const GeldTrackerScreen(),
  };
}
