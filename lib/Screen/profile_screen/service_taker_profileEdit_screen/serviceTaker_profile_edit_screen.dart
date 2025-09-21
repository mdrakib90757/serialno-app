import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:serialno_app/global_widgets/custom_shimmer_list/CustomShimmerList%20.dart';
import 'package:serialno_app/main_layouts/main_layout/main_layout.dart';
import '../../../global_widgets/Custom_NavigationBar/custom_servicecenter_navigationBar.dart';
import '../../../global_widgets/Custom_NavigationBar/custom_servicetaker_navigationbar.dart';
import '../../../global_widgets/My_Appbar.dart';
import '../../../global_widgets/custom_circle_progress_indicator/custom_circle_progress_indicator.dart';
import '../../servicecenter_screen/serviceCenter_widget/edit_profile_info_dialog/edit_profile_info_dialog.dart';
import '../../../providers/auth_provider/auth_providers.dart';
import '../../../providers/profile_provider/getprofile_provider.dart';
import '../../../utils/color.dart';

class serviceTakerProfileEditScreen extends StatefulWidget {
  const serviceTakerProfileEditScreen({super.key});

  @override
  State<serviceTakerProfileEditScreen> createState() =>
      _serviceTakerProfileEditScreenState();
}

class _serviceTakerProfileEditScreenState
    extends State<serviceTakerProfileEditScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  String _formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) {
      return "Not set";
    }
    try {
      final DateTime parsedDate = DateTime.parse(dateString);
      return DateFormat('dd/MM/yyyy').format(parsedDate);
    } catch (e) {
      return dateString;
    }
  }

  void _showDialog(BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final result = await showDialog(
      context: context,
      builder: (context) =>
          edit_profile_info_dialog(user: authProvider.userModel!),
    );

    if (result == true) {
      setState(() {}); // force UI rebuild
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: true);
    final getprofileProvider = Provider.of<Getprofileprovider>(context);
    final profile = getprofileProvider.profileData;
    final String todayDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

    return MainLayout(
      userType: UserType.customer,
      currentIndex: 0,
      onTap: (p0) {},
      color: Colors.white,
      child: (profile == null)
          ? CustomShimmerList(itemCount: 10)
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Basic Information",
                          style: TextStyle(
                            color: AppColor().primariColor,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 15),
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder: (_, __, ___) =>
                                    edit_profile_info_dialog(
                                  user: authProvider.userModel!,
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

                            // Navigator.pushReplacement(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) => edit_profile_info_dialog(
                            //       user: authProvider.userModel!,
                            //     ),
                            //   ),
                            // );
                          },
                          icon: Icon(
                            Icons.edit_sharp,
                            size: 25,
                            color: AppColor().primariColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.symmetric(vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey.shade400),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 15,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Name",
                              style: TextStyle(
                                color: Colors.black.withOpacity(0.6),
                                fontSize: 15,
                              ),
                            ),
                            Consumer(
                              builder: (context, value, child) {
                                return Text(
                                  profile!.name,
                                  //authProvider.user_model!.user.name??"",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 17,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),

                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.symmetric(vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey.shade400),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 15,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Login Name",
                              style: TextStyle(
                                color: Colors.black.withOpacity(0.6),
                                fontSize: 15,
                              ),
                            ),
                            Consumer(
                              builder: (context, value, child) {
                                return Text(
                                  //authProvider.user_model!.user.loginName??"",
                                  profile!.loginName,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 17,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),

                    // SizedBox(height: 5,),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 3),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey.shade400),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 15,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Mobile No",
                              style: TextStyle(
                                color: Colors.black.withOpacity(0.6),
                                fontSize: 15,
                              ),
                            ),
                            Consumer(
                              builder: (context, value, child) {
                                return Text(
                                  //authProvider.user_model!.user.mobileNo??"",
                                  profile!.mobileNo,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 17,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),

                    //SizedBox(height: 5,),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 3),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey.shade400),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 15,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Email",
                              style: TextStyle(
                                color: Colors.black.withOpacity(0.6),
                                fontSize: 15,
                              ),
                            ),
                            Consumer(
                              builder: (context, value, child) {
                                return Text(
                                  //authProvider.user_model!.user.email??"",
                                  profile!.email,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 17,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),

                    //SizedBox(height: 5,),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 3),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey.shade400),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 15,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Gender",
                              style: TextStyle(
                                color: Colors.black.withOpacity(0.6),
                                fontSize: 15,
                              ),
                            ),
                            Text(
                              profile?.profileData?.gender ?? "",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 17,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    //SizedBox(height: 5,),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 3),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey.shade400),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 15,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Date of birth",
                              style: TextStyle(
                                color: Colors.black.withOpacity(0.6),
                                fontSize: 15,
                              ),
                            ),
                            Text(
                              _formatDate(profile?.profileData?.dateOfBirth) ??
                                  "No DOB",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 17,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
