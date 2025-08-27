import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:serialno_app/providers/app_provider/app_provider.dart';

import '../../Screen/servicetaker_screen/appointments_screen.dart';
import '../../Screen/servicetaker_screen/servicetaker_homescreen.dart';
import '../../Screen/servicetaker_screen/setting_screen.dart';
import '../../utils/color.dart';
import '../my_Appbar.dart';

class CustomServicetakerNavigationbar extends StatefulWidget {
  const CustomServicetakerNavigationbar({super.key});

  @override
  State<CustomServicetakerNavigationbar> createState() =>
      _CustomServicetakerNavigationbarState();
}

class _CustomServicetakerNavigationbarState
    extends State<CustomServicetakerNavigationbar> {
  int _currentIndex = 0;
  final List<Widget> _screen = [
    ServicetakerHomescreen(businessTypeId: ''),
    AppointmentsScreen(),
    SettingScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppbar(
        onLogotap: () {
          setState(() {
            _currentIndex = 0;
          });
        },
      ),
      body: _screen[_currentIndex],
      bottomNavigationBar: Container(
        height: 70,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(color: Colors.black12, spreadRadius: 2, blurRadius: 3),
          ],
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.white,
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },

          elevation: 50,
          selectedItemColor: AppColor().primariColor,
          unselectedItemColor: Colors.grey.shade600,
          type: BottomNavigationBarType.fixed,
          iconSize: 25,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined, size: 33),
              activeIcon: Icon(Icons.home, size: 33),

              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.sync, size: 33),
              activeIcon: Icon(Icons.cloud_sync, size: 33),
              label: "My Serials",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings_outlined, size: 33),
              activeIcon: Icon(Icons.settings, size: 33),
              label: "Settings",
            ),
          ],
        ),
      ),
    );
  }
}
