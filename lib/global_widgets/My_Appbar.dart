import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:serialno_app/Screen/Auth_screen/login_screen.dart';
import 'package:serialno_app/Screen/profile_screen/serviceCenter_profile_screen/serviceCenter_profile_screen.dart';
import 'package:serialno_app/providers/auth_provider/auth_providers.dart';
import 'package:serialno_app/providers/profile_provider/getprofile_provider.dart';
import '../main_layouts/service_center_layout/service_center_layout.dart';
import '../main_layouts/service_taker_layout/service_taker_layout.dart';
import '../providers/serviceCenter_provider/newSerialButton_provider/getNewSerialButton_provider.dart';
import '../utils/color.dart';

class MyAppbar extends StatefulWidget implements PreferredSizeWidget {
  final VoidCallback? onLogotap;
  final VoidCallback? onNotificationTap;

  const MyAppbar({super.key, this.onLogotap, this.onNotificationTap});

  @override
  State<MyAppbar> createState() => _MyAppbarState();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(75);
}

class _MyAppbarState extends State<MyAppbar> {
  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final profileProvider = context.watch<Getprofileprovider>();
    final profile = profileProvider.profileData;

    final String userName = authProvider.userModel?.user.name ?? "Loading...";
    final String userEmail = authProvider.userModel?.user.email ?? "Loading...";

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
              onTap: () {
                final authProvider = Provider.of<AuthProvider>(
                  context,
                  listen: false,
                );
                final userType =
                    authProvider.userType?.toLowerCase().trim() ?? '';

                if (userType == "company") {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ServiceCenterLayout(),
                    ),
                    (route) => false,
                  );
                } else {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ServiceTakerLayout(),
                    ),
                    (route) => false,
                  );
                }
              },
              child: Image.asset(
                "assets/image/serialman (2).png",
                fit: BoxFit.contain,
              ),
            ),
          ),

          SizedBox(width: 35),
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.notifications_none,
                size: 25,
                color: Colors.black,
              ),
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  userName,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),

                Text(
                  userEmail,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                  maxLines: 1,
                  softWrap: false,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          SizedBox(width: 7),

          GestureDetector(
            onTap: () => _showAccountDialog(context),
            child: CircleAvatar(
              radius: 25,
              backgroundColor: Colors.grey.shade400,
              child: Icon(CupertinoIcons.person, size: 20, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  // You'd call this function when the profile icon is tapped
  void _showAccountDialog(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final String userName = authProvider.userModel?.user.name ?? "Loading...";
    final String userEmail = authProvider.userModel?.user.email ?? "Loading...";
    final userType = authProvider.userType?.toLowerCase().trim() ?? '';
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
          child: Dialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
              side: BorderSide(color: Colors.grey.shade300), // Rounded corners
            ),
            elevation: 10,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.grey.shade200,
                    child: Text(
                      'H',
                      style: TextStyle(
                        fontSize: 30,
                        color: AppColor().primariColor,
                      ),
                    ), // Fallback initial
                  ),
                  SizedBox(height: 10),
                  Text(
                    userName,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(userEmail, style: TextStyle(color: Colors.grey[600])),
                  Divider(
                    height: 30,
                    thickness: 2,
                    color: Colors.grey.shade200,
                  ),
                  if (userType == "company") ...[
                    _buildDialogOption(
                      icon: Icons.person_outline,
                      text: 'View Profile',
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (_, __, ___) =>
                                serviceCenter_profile_screen(
                                  currentIndex: 0,
                                  onTap: (int) {},
                                ),
                            transitionsBuilder: (_, anim, __, child) {
                              return FadeTransition(
                                opacity: anim,
                                child: child,
                              );
                            },
                            fullscreenDialog: true,
                          ),
                        );
                      },
                    ),
                  ],

                  _buildDialogOption(
                    icon: Icons.settings_outlined,
                    text: 'App Settings',
                    onTap: () {
                      Navigator.of(context).pop();
                      // Navigate to settings screen
                    },
                  ),
                  _buildDialogOption(
                    icon: Icons.logout,
                    text: 'Logout',
                    textColor: AppColor().primariColor,

                    onTap: () async {
                      final navigator = Navigator.of(context);

                      print("--- Clearing all provider states ---");
                      context.read<GetNewSerialButtonProvider>().clearData();

                      final authProvider = Provider.of<AuthProvider>(
                        context,
                        listen: false,
                      );
                      await authProvider.logout();

                      navigator.pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                        (Route<dynamic> route) => false,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDialogOption({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
    Color? textColor,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 7.0),
        child: Row(
          children: [
            Icon(icon, color: textColor ?? Colors.grey.shade600),
            SizedBox(width: 15),
            Text(
              text,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: textColor ?? Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
