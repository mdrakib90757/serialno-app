import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:serialno_app/Screen/profile_screen/service_taker_profileEdit_screen/serviceTaker_profile_edit_screen.dart';
import '../../../providers/auth_provider/auth_providers.dart';
import '../../../providers/profile_provider/getprofile_provider.dart';
import '../service_taker_password_screen/service_taker_password_screen.dart';

class serviceTaker_profile_screen extends StatefulWidget {
  const serviceTaker_profile_screen({super.key});

  @override
  State<serviceTaker_profile_screen> createState() =>
      _serviceTaker_profile_screenState();
}

class _serviceTaker_profile_screenState
    extends State<serviceTaker_profile_screen> {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final getupdateprofile = Provider.of<Getprofileprovider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const SizedBox(height: 20),
                CircleAvatar(
                  radius: 70,
                  backgroundColor: Colors.grey.shade400,
                  child: Icon(
                    CupertinoIcons.person,
                    size: 60,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                Divider(height: 3),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () async {
                    final profileProvider = Provider.of<Getprofileprovider>(
                      context,
                      listen: false,
                    );
                    final profile = profileProvider.profileData;
                    bool CustomeruserType =
                        authProvider.userType?.toLowerCase().trim() ==
                        "customer";

                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (_, __, ___) =>
                            serviceTakerProfileEditScreen(),
                        transitionsBuilder: (_, anim, __, child) {
                          return FadeTransition(opacity: anim, child: child);
                        },
                        fullscreenDialog: true,
                      ),
                    );

                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => serviceTakerProfileEditScreen(),
                    //   ),
                    // );
                    Future.microtask(() {
                      getupdateprofile.fetchProfileData();
                    });
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
                          Text(
                            "Profile Information",
                            style: TextStyle(
                              color: Colors.black.withOpacity(0.9),
                              fontSize: 18,
                            ),
                          ),
                          Icon(Icons.arrow_forward_ios, size: 20),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () async {
                    final profileProvider = Provider.of<Getprofileprovider>(
                      context,
                      listen: false,
                    );
                    final profile = profileProvider.profileData;
                    bool CustomerUserType =
                        profile?.userType.toLowerCase().trim() == "customer";
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (_, __, ___) =>
                            serviceTaker_PasswordScreen(),
                        transitionsBuilder: (_, anim, __, child) {
                          return FadeTransition(opacity: anim, child: child);
                        },
                        fullscreenDialog: true,
                      ),
                    );

                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => serviceTaker_PasswordScreen(),
                    //   ),
                    // );
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
                          Text(
                            "Change Password",
                            style: TextStyle(
                              color: Colors.black.withOpacity(0.9),
                              fontSize: 18,
                            ),
                          ),
                          Icon(Icons.arrow_forward_ios, size: 20),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
