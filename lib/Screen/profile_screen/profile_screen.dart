import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:serialno_app/Screen/profile_screen/profile_edit_screen.dart';
import '../../global_widgets/Custom_NavigationBar/custom_servicecenter_navigationBar.dart';
import '../../global_widgets/Custom_NavigationBar/custom_servicetaker_navigationbar.dart';
import '../../global_widgets/Custom_NavigationBar/my_bottom_navigationBar/my_bottom_navigationBar.dart';
import '../../global_widgets/My_Appbar.dart';
import '../../providers/auth_provider/auth_providers.dart';
import '../../providers/profile_provider/getprofile_provider.dart';
import 'password_screen.dart';

class ProfileScreen extends StatefulWidget {
  final bool showAppBar;
  final bool showBottomNavBar;
  final bool isServiceTaker;
  const ProfileScreen({
    super.key,
    this.showAppBar = true,
    this.showBottomNavBar = false,
    this.isServiceTaker = false,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final getupdateprofile = Provider.of<Getprofileprovider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: widget.showAppBar ? MyAppbar() : null,
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
                  child: Icon(
                    CupertinoIcons.person,
                    size: 60,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 20),
                Divider(height: 3),
                SizedBox(height: 10),
                GestureDetector(
                  onTap: () async {
                    //await getupdateprofile.fetchProfileData();
                    // final profileProvider = Provider.of<Getprofileprovider>(
                    //   context,
                    //   listen: false,
                    // );
                    // final profile = profileProvider.profileData;
                    // String userType = profile?.userType.toLowerCase().trim() ?? "";
                    // bool isServiceTakerUser = (userType == "customer");
                    final authProvider = Provider.of<AuthProvider>(
                      context,
                      listen: false,
                    );

                    bool isServiceTakerUser =
                        authProvider.userType?.toLowerCase().trim() ==
                        "customer";

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfileEditScreen(
                          showAppBar: true,
                          showBottomNavBar: true,
                          isServiceTaker: isServiceTakerUser,
                        ),
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
                SizedBox(height: 10),
                GestureDetector(
                  onTap: () async {
                    // final profileProvider = Provider.of<Getprofileprovider>(
                    //   context,
                    //   listen: false,
                    // );
                    // final profile = profileProvider.profileData;
                    // String userType =
                    //     profile?.userType.toLowerCase().trim() ?? "";
                    // bool isServicetakerUser = (userType == "customer");

                    final authProvider = Provider.of<AuthProvider>(
                      context,
                      listen: false,
                    );

                    bool isServiceTakerUser =
                        authProvider.userType?.toLowerCase().trim() ==
                        "customer";

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PasswordScreen(
                          showAppBar: true,
                          showBottomNavBar: true,
                          isServiceTaker: isServiceTakerUser,
                        ),
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

      bottomNavigationBar: widget.showBottomNavBar
          ? MyBottomNavigationBar(
              currentIndex: 0,
              onTap: (index) {
                if (widget.isServiceTaker) {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => CustomServicetakerNavigationbar(),
                    ),
                    (route) => false,
                  );
                } else {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => CustomServicecenterNavigationbar(),
                    ),
                    (route) => false,
                  );
                }
              },
              isServicetaker: widget.isServiceTaker,
            )
          : null,
    );
  }
}
