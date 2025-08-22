
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
  State<CustomServicecenterNavigationbar> createState() => _CustomServicecenterNavigationbarState();
}

class _CustomServicecenterNavigationbarState extends State<CustomServicecenterNavigationbar> {
  
  final List<Widget>_screen=[
    HomeScreen(),
    ServicecenterScreen(),
    ServicetypeScreen(),
   Servicecenter_Settingscreen()
  ];
  int _currentIndex=0;
  @override
  Widget build(BuildContext context) {

    return  Scaffold(
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
            backgroundColor: Colors.white,
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

              items: [
                BottomNavigationBarItem(icon:Image.asset("assets/image/house-chimney (1).png",
                  height: 29,width: 29,),label: "Home",),
                BottomNavigationBarItem(icon:Image.asset("assets/image/building (1).png"
                  ,height: 29,width: 29,),label: "Service-Center"),
                BottomNavigationBarItem(icon:Image.asset("assets/image/network.png",
                  height: 29,width: 29,),label: "Service-Types"),
                BottomNavigationBarItem(icon:Image.asset("assets/image/setting.png"
                  ,height: 29,width: 29,),label: "Settings"),
              ]),

        )
    );

  }
}
