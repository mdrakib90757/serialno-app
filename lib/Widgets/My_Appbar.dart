

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:serial_no_app/providers/serviceCenter_provider/getAddButton_provider.dart';
import 'package:serial_no_app/providers/serviceCenter_provider/getAddButton_serviceType_privider.dart';

import '../Screen/Auth_screen/login_screen.dart';
import '../Screen/profile_screen/profile_screen.dart';
import '../providers/auth_providers.dart';
import '../providers/getprofile_provider.dart';
import '../providers/serviceCenter_provider/get_serialServiceCenter_provider.dart';
import 'Custom_NavigationBar/custom_servicecenter_navigationBar.dart';
import 'Custom_NavigationBar/custom_servicetaker_navigationbar.dart';
import 'custom_sanckbar.dart';

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


    final profileProvider = context.watch<Getprofileprovider>();
    final profile = profileProvider.profileData;
    final String userName = profile?.name ?? "Guest";
    final String email = profile?.email??"guest@example.com";


    return AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 70,
        backgroundColor: Colors.white,
        title: Row(
          children: [
        
        
            SizedBox(
              height: 120,
                width: 130,
                child: GestureDetector(
                  onTap:() {

                    final profileProvider = Provider.of<Getprofileprovider>(context, listen: false);
                    final profile = profileProvider.profileData;
                    String userType = profile?.userType.toLowerCase().trim() ?? "";


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
        
          // SizedBox(width: 35,),
            Padding(
              padding: const EdgeInsets.only(top: 5,),
              child: IconButton(onPressed: () {},
                  icon: Icon(
                    Icons.notifications_none, size: 25, color: Colors.black,)),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
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
                    ),
                    maxLines: 1,
                    softWrap: false,
                    overflow: TextOverflow.ellipsis,
                      
                      
                  )
                      
                ],
              ),
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
                    final navigator = Navigator.of(context);

                    print("--- Clearing all provider states ---");
                    context.read<SerialListProvider>().clearData();

                    context.read<GetAddButton_serviceType_Provider>().clearData();
                    context.read<Getprofileprovider>().clearProfile();
                    context.read<GetAddButtonProvider>().clearData();

                    final authProvider = Provider.of<AuthProvider>(
                        context, listen: false);
                    await context.read<AuthProvider>().LogOut();



                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          elevation: 0,
                          backgroundColor: Colors.transparent,
                          behavior: SnackBarBehavior.floating,
                          content:CustomSnackBarWidget(
                              title: "Error",
                              message: "${authProvider.errorMessage?? "LogOut Success"}"
                          )
                      ),);

                    navigator.pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                          (Route<dynamic> route) => false,
                    );

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
        ),



      );
    }
  }



