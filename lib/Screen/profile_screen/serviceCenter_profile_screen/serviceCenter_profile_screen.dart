import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:serialno_app/Screen/profile_screen/service_taker_profileEdit_screen/serviceTaker_profile_edit_screen.dart';

import '../../../main_layouts/main_layout/main_layout.dart';
import '../../../providers/auth_provider/auth_providers.dart';
import '../../../providers/profile_provider/getprofile_provider.dart';
import '../service_center_password_screen/service_center_password_screen.dart';
import '../service_center_profileEdit_screen/service_center_profileEdit_screen.dart';
import '../service_taker_password_screen/service_taker_password_screen.dart';

class serviceCenter_profile_screen extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;
  const serviceCenter_profile_screen({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  State<serviceCenter_profile_screen> createState() =>
      _serviceCenter_profile_screenState();
}

class _serviceCenter_profile_screenState
    extends State<serviceCenter_profile_screen> {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final getupdateprofile = Provider.of<Getprofileprovider>(context);

    return MainLayout(
      userType: UserType.company,
      color: Colors.white,
      currentIndex: widget.currentIndex,
      onTap: widget.onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 80),
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
                    final authProvider = Provider.of<AuthProvider>(
                      context,
                      listen: false,
                    );
                    final profileProvider = Provider.of<Getprofileprovider>(
                      context,
                      listen: false,
                    );
                    final profile = profileProvider.profileData;
                    bool isCompanyUser =
                        authProvider.userType?.toLowerCase().trim() ==
                        "company";

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => serviceCenter_ProfileEditScreen(),
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
                    final authProvider = Provider.of<AuthProvider>(
                      context,
                      listen: false,
                    );

                    final profileProvider = Provider.of<Getprofileprovider>(
                      context,
                      listen: false,
                    );
                    final profile = profileProvider.profileData;
                    bool CompanyuserType =
                        profile?.userType.toLowerCase().trim() == "company";

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => serviceCenter_PasswordScreen(),
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
  }
}
