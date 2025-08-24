import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:serialno_app/Screen/servicecenter_screen/servicecenter_settingScreen.dart';
import 'package:serialno_app/providers/app_provider/app_provider.dart';

import '../../Screen/servicecenter_screen/home_screen.dart';
import '../../Screen/servicecenter_screen/servicecenter_screen.dart';
import '../../Screen/servicecenter_screen/servicetype_screen.dart';
import '../../utils/color.dart';
import '../my_Appbar.dart';

class CustomServicecenterNavigationbar extends StatefulWidget {
  const CustomServicecenterNavigationbar({super.key});

  @override
  State<CustomServicecenterNavigationbar> createState() =>
      _CustomServicecenterNavigationbarState();
}

class _CustomServicecenterNavigationbarState
    extends State<CustomServicecenterNavigationbar> {
  final List<Widget> _screen = [
    HomeScreen(),
    ServicecenterScreen(),
    ServicetypeScreen(),
    Servicecenter_Settingscreen(),
  ];
  int _currentIndex = 0;
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
          type: BottomNavigationBarType.fixed,
          //backgroundColor: Colors.white,
          selectedItemColor: AppColor().primariColor,
          unselectedItemColor: Colors.grey[600],
          showUnselectedLabels: true,
          selectedFontSize: 12.0,
          unselectedFontSize: 12.0,
          elevation: 5.0,

          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined, size: 33),
              activeIcon: Icon(Icons.home, size: 33),

              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.corporate_fare_outlined, size: 33),
              activeIcon: Icon(Icons.corporate_fare_rounded, size: 33),

              label: "Service-Center",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.category_outlined, size: 33),
              activeIcon: Icon(Icons.category, size: 33),
              label: "Service-Types",
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
