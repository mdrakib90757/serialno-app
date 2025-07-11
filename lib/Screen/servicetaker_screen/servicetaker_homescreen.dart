import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:serial_managementapp_project/Widgets/My_Appbar.dart';
import 'package:serial_managementapp_project/providers/auth_providers.dart';
import 'package:serial_managementapp_project/utils/color.dart';

import '../Auth_screen/login_screen.dart';

class ServicetakerHomescreen extends StatefulWidget {
  const ServicetakerHomescreen({super.key});

  @override
  State<ServicetakerHomescreen> createState() => _ServicetakerHomescreenState();
}

class _ServicetakerHomescreenState extends State<ServicetakerHomescreen> {
  @override
  void initState() {
    super.initState();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    authProvider.loadUserFromToken();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider=Provider.of<AuthProvider>(context);
    return Scaffold(
      body:  authProvider.isLoading?CircularProgressIndicator():
      authProvider.user_model==null?Text("No User Data found"):
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
              width: 220,
                decoration: BoxDecoration(
                  color: AppColor().primariColor,
                  borderRadius: BorderRadius.circular(5)
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add,color: Colors.white,weight: 5,),
                      SizedBox(width: 8,),
                      Text("Make Appointment",style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w600
                      ),)
                    ],
                  ),
                ),
              ),

          SizedBox(height: 100,),
              Text("ServiceTaker-HomeScreen-2"),
              SizedBox(height: 30,),
              Text(authProvider.user_model!.user.name),
              Text(authProvider.user_model!.user.email),
              //Text(authProvider.user_model!.serviceTaker.profileData.gender)
              Text("User Type: ${authProvider.userType}"),
            ],
          ),
        ),
      ),
    );
  }
}
