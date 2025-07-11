import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:serial_managementapp_project/Screen/password_screen.dart';
import 'package:serial_managementapp_project/Screen/profile_screen/profile_edit_screen.dart';
import 'package:serial_managementapp_project/Widgets/My_Appbar.dart';

import '../../providers/auth_providers.dart';
import '../../providers/profile_update_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    return Scaffold(
      appBar: MyAppbar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 80),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 70,
                  backgroundColor: Colors.grey.shade400,
                  child: Icon(CupertinoIcons.person, size: 60, color: Colors.white),
                ),
                SizedBox(height: 20,),
                Divider(
                  height: 3,
                ),
                SizedBox(height: 10,),
                GestureDetector(
                  onTap: () async {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) => ProfileEditScreen(),));

                  },

                  child: Container(
                    height: 50,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade400),
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Profile information",style: TextStyle(
                            color: Colors.black.withOpacity(0.9),
                            fontSize: 18
                          ),),
                          Icon(Icons.arrow_forward_ios,size: 20,)
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10,),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) => PasswordScreen(),));
                  },
                  child: Container(
                    height: 50,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade400),
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Change Password",style: TextStyle(
                              color: Colors.black.withOpacity(0.9),
                              fontSize: 18
                          ),),
                          Icon(Icons.arrow_forward_ios,size: 20,)
                        ],
                      ),
                    ),
                  ),
                )

              ],
            ),
          ),
        ),
      ),

    );
  }
}
