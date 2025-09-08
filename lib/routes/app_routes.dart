import 'package:flutter/material.dart';
import 'package:serialno_app/global_widgets/Custom_NavigationBar/custom_servicecenter_navigationBar.dart';
import 'package:serialno_app/global_widgets/Custom_NavigationBar/custom_servicetaker_navigationbar.dart';
import '../Screen/Auth_screen/login_screen.dart';

class AppRouteNames {
  static const String login = '/login';
  static const String companyHome = '/home';
  static const String customerHome = '/customerHome';
}

class AppRouter {
  static final Map<String, WidgetBuilder> routes = {
    AppRouteNames.login: (context) => const LoginScreen(),
    AppRouteNames.companyHome: (context) =>
        const CustomServicecenterNavigationbar(),
    AppRouteNames.customerHome: (context) =>
        const CustomServicetakerNavigationbar(),
  };
}
