import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:serial_managementapp_project/Widgets/My_Appbar.dart';
import 'package:serial_managementapp_project/providers/auth_providers.dart';
import 'package:serial_managementapp_project/utils/color.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  void initState() {
    super.initState();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    authProvider.loadUserFromToken();
  }
  @override
  Widget build(BuildContext context) {

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    //null check function
    if (authProvider.user_model == null || authProvider.isLoading) {
      return  Scaffold(
        body: Center(
          child: CircularProgressIndicator(
              color: AppColor().primariColor
          ),
        ),
      );
    }


    return Scaffold(

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 15),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [


              Text(authProvider.user_model!.user.name,style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 25
              ),),
             SizedBox(height: 50,),
              Center(child: Text("User Type: ${authProvider.userType}")),
            ],
          ),
      ),
    );
  }
}
