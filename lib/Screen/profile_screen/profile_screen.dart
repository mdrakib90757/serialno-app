import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:serialno_app/Screen/profile_screen/password_screen.dart';
import 'package:serialno_app/Screen/profile_screen/profile_edit%20screen.dart';
import 'package:serialno_app/Screen/profile_screen/service_taker_profileEdit_screen/serviceTaker_profile_edit_screen.dart';

import '../../../main_layouts/main_layout/main_layout.dart';
import '../../../providers/auth_provider/auth_providers.dart';
import '../../../providers/profile_provider/getprofile_provider.dart';

class profile_screen extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;
  const profile_screen({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  State<profile_screen> createState() => _profile_screenState();
}

class _profile_screenState extends State<profile_screen> {
  @override
  Widget build(BuildContext context) {
    final getupdateprofile = Provider.of<Getprofileprovider>(context);
    final authProvider = Provider.of<AuthProvider>(context);

    bool isCompanyUser =
        authProvider.userType?.toLowerCase().trim() == "company";

    // Define the core content of the profile screen
    Widget profileContent = Scaffold(
      // Use Scaffold here to provide a basic structure
      backgroundColor: Colors.white, // Match the background color

      body: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 20,
        ), // Adjust vertical padding as needed
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
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
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (_, __, ___) => ProfileEditScreen(),
                        transitionsBuilder: (_, anim, __, child) {
                          return FadeTransition(opacity: anim, child: child);
                        },
                        fullscreenDialog: true,
                      ),
                    );
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
                            "Profile information",
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
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (_, __, ___) => PasswordScreen(),
                        transitionsBuilder: (_, anim, __, child) {
                          return FadeTransition(opacity: anim, child: child);
                        },
                        fullscreenDialog: true,
                      ),
                    );
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

    // Conditionally wrap with MainLayout
    if (isCompanyUser) {
      UserType currentUserLayoutType =
          UserType.company; // For company, it's always company type

      return MainLayout(
        userType: currentUserLayoutType,
        color: Colors.white,
        currentIndex: null,
        onTap: widget.onTap,
        child: profileContent,
        isExtraScreen: true,
      );
    } else {
      return profileContent;
    }
  }
}
