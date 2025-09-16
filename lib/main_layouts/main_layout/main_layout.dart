// main_layout.dart
import 'package:flutter/material.dart';

import '../../Screen/profile_screen/serviceTaker_profile_screen/service_taker_profile_screen.dart';
import '../../Screen/servicecenter_screen/home_screen.dart';
import '../../Screen/servicecenter_screen/servicecenter_screen.dart';
import '../../Screen/servicecenter_screen/servicecenter_settingScreen.dart';
import '../../Screen/servicecenter_screen/servicetype_screen.dart';
import '../../Screen/servicetaker_screen/appointments_screen.dart';
import '../../Screen/servicetaker_screen/servicetaker_homescreen.dart';
import '../../Screen/servicetaker_screen/setting_screen.dart';
import '../../global_widgets/Custom_NavigationBar/custom_servicecenter_navigationBar.dart';
import '../../global_widgets/Custom_NavigationBar/custom_servicetaker_navigationbar.dart'; // Import the servicetaker navigation bar
import '../../global_widgets/My_Appbar.dart';

enum UserType { customer, company }

class MainLayout extends StatefulWidget {
  final Widget child;
  final int? currentIndex;
  final Function(int) onTap;
  final Color color;
  final UserType userType;

  const MainLayout({
    super.key,
    required this.child,
    required this.currentIndex,
    required this.onTap,
    required this.color,
    required this.userType,
  });

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  void _onNavTapped(BuildContext context, int index) {
    Widget targetScreen;

    if (widget.userType == UserType.company) {
      switch (index) {
        case 0:
          targetScreen = HomeScreen();
          break;
        case 1:
          targetScreen = ServicecenterScreen();
          break;
        case 2:
          targetScreen = ServicetypeScreen();
          break;
        case 3:
          targetScreen = Servicecenter_Settingscreen();
          break;
        default:
          targetScreen = HomeScreen();
      }
    } else {
      switch (index) {
        case 0:
          targetScreen = ServicetakerHomescreen(businessTypeId: '');
          break;
        case 1:
          targetScreen = AppointmentsScreen();
          break;
        case 2:
          targetScreen = SettingScreen();
          break;
        case 3:
          targetScreen = serviceTaker_profile_screen();
          break;
        default:
          targetScreen = ServicetakerHomescreen(businessTypeId: '');
      }
    }

    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => MainLayout(
          onTap: (p0) {},
          color: Colors.white,
          child: targetScreen,
          currentIndex: index,
          userType: widget.userType,
        ),
        transitionsBuilder: (_, anim, __, child) {
          return FadeTransition(opacity: anim, child: child);
        },
        fullscreenDialog: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppbar(onLogotap: () => widget.onTap(0)),
      body: widget.child,
      backgroundColor: widget.color,
      bottomNavigationBar: widget.userType == UserType.customer
          ? CustomServicetakerNavigationbar(
              currentIndex: widget.currentIndex ?? -1,
              onTap: (i) => _onNavTapped(context, i),
            )
          : CustomServicecenterNavigationbar(
              currentIndex: widget.currentIndex ?? -1,
              onTap: (i) => _onNavTapped(context, i),
            ),
    );
  }
}
