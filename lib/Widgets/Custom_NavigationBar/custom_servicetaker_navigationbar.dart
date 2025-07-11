import 'package:flutter/material.dart';
import 'package:serial_managementapp_project/Screen/servicetaker_screen/appointments_screen.dart';
import 'package:serial_managementapp_project/Screen/servicetaker_screen/servicetaker_homescreen.dart';
import 'package:serial_managementapp_project/Screen/servicetaker_screen/setting_screen.dart';

import '../../utils/color.dart';
import '../My_Appbar.dart';

class CustomServicetakerNavigationbar extends StatefulWidget {
  const CustomServicetakerNavigationbar({super.key});

  @override
  State<CustomServicetakerNavigationbar> createState() => _CustomServicetakerNavigationbarState();
}

class _CustomServicetakerNavigationbarState extends State<CustomServicetakerNavigationbar> {
  int _currentIndex=0;
  final List<Widget>_screen=[
  ServicetakerHomescreen(),
    AppointmentsScreen(),
    SettingScreen()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppbar(
        onLogotap: () {
          setState(() {
            _currentIndex=0;
          });
        },
      ),
        body: _screen[_currentIndex],
        bottomNavigationBar:Container(
          height: 70,
          decoration: BoxDecoration(

            boxShadow: [
              BoxShadow(
                  color: Colors.black12,
                  spreadRadius: 2,
                  blurRadius: 3
              )
            ],
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20)
            ),
          ),
          child: BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: (index) {
                setState(() {

                  _currentIndex=index;
                });
              },

              elevation: 50,
              selectedItemColor: AppColor().primariColor,
              unselectedItemColor: Colors.grey.shade600,
              type: BottomNavigationBarType.fixed,
              iconSize: 25,
              items: [
                BottomNavigationBarItem(icon:Image.asset("assets/image/house-chimney (1).png",
                  height: 29,width: 29,),label: "Home"),
                BottomNavigationBarItem(icon: Image.asset("assets/image/time-past.png",
                  height: 29,width: 29,),label: "Appointments"),
                BottomNavigationBarItem(icon: Image.asset("assets/image/setting.png",
                  height: 29,width: 29,),label: "Settings"),
              ]),
        )
    );

  }
}
