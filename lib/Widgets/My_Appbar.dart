import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:serial_managementapp_project/Screen/profile_screen/profile_screen.dart';
import 'package:serial_managementapp_project/Screen/servicecenter_screen/home_screen.dart';
import 'package:serial_managementapp_project/Screen/servicetaker_screen/servicetaker_homescreen.dart';
import 'package:serial_managementapp_project/Widgets/Custom_NavigationBar/custom_servicecenter_navigationBar.dart';
import 'package:serial_managementapp_project/Widgets/Custom_NavigationBar/custom_servicetaker_navigationbar.dart';


import '../providers/auth_providers.dart';
import '../providers/profile_update_provider.dart';

class MyAppbar extends StatefulWidget implements PreferredSizeWidget{
  final VoidCallback?onLogotap;

  const MyAppbar({super.key, this.onLogotap});

  @override
  State<MyAppbar> createState() => _MyAppbarState();

  @override
// TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(75);
}

class _MyAppbarState extends State<MyAppbar> {


  @override
  Widget build(BuildContext context) {

    final authProvider = Provider.of<AuthProvider>(context,);
    final String userName = authProvider.user_model?.user?.name ?? "Guest";
    final String email = authProvider.user_model?.user?.email ?? "guest@example.com";


    return AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 70,
        title: SizedBox(
          height: 150,
            width: 150,
            child: GestureDetector(
              onTap:() {
                final authProvider=Provider.of<AuthProvider>(context,listen: false);
                String userType = authProvider.userType?.toLowerCase().trim() ?? "";
                if(userType=="company"){
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => CustomServicecenterNavigationbar()),
                        (route) => false,
                  );
                }else{
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => CustomServicetakerNavigationbar()),
                        (route) => false,
                  );
                }
              },
                child: Image.asset("assets/image/1st-removebg-preview.png",fit: BoxFit.contain,))),
        backgroundColor: Colors.white,

        actionsPadding: EdgeInsets.symmetric(horizontal: 15),
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 7),
            child: IconButton(onPressed: () {},
                icon: Icon(
                  Icons.notifications_none, size: 25, color: Colors.black,)),
          ),

          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(userName,
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 14
                ),),
              Text(email,
                style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 13
                ),)

            ],
          ),

          SizedBox(width: 7,),

          PopupMenuButton<String>(
            menuPadding: EdgeInsets.symmetric(horizontal: 30),
            elevation: 4,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
              side: BorderSide(color: Colors.grey.shade400)
            ),
            offset: const Offset(0, 70),
            itemBuilder: (BuildContext context) =>
            [
              PopupMenuItem<String>(
                onTap: () {
                  Navigator.push(
                      context, MaterialPageRoute(
                    builder: (context) => ProfileScreen(),));
                },
                child: Text('Account profile', style:
                TextStyle(
                  fontSize: 19,
                  color: Colors.black.withOpacity(0.8),
                )),),

              PopupMenuItem<String>(

                onTap: () async {
                  final authProvider = Provider.of<AuthProvider>(
                      context, listen: false);
                  await authProvider.LogOut();
                  print("Logout success");
                  Navigator.pushReplacementNamed(context, '/login');
                },
                child: Text('Logout', style: TextStyle(
                    color: Colors.black.withOpacity(0.8),
                    fontSize: 19)),
              ),
            ],
            child: const CircleAvatar(
              radius: 25,
              backgroundColor: Colors.grey,
              child: Icon(CupertinoIcons.person, size: 20, color: Colors.white),
            ),

          )
        ],
      );
    }
  }



