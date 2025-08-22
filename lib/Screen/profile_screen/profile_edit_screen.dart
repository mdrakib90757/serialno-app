


import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../Widgets/my_Appbar.dart';
import '../../Widgets/custom_dilogbox.dart';
import '../../providers/auth_provider/auth_providers.dart';
import '../../providers/profile_provider/getprofile_provider.dart';
import '../../utils/color.dart';

class ProfileEditScreen extends StatefulWidget {

  const ProfileEditScreen({super.key,});

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void _showDialog(BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final result = await showDialog(
      context: context,
      builder: (context) => CustomDilogbox(user: authProvider.userModel!,),

    );

    if (result == true) {
      setState(() {

      }); // force UI rebuild
    }
  }




  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: true);
    final getprofileProvider=Provider.of<Getprofileprovider>(context);
    final profile=getprofileProvider.profileData;
    final String todayDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    if (profile == null) {
      return Scaffold(
        appBar: MyAppbar(),
        body: Center(child: CircularProgressIndicator(
          strokeWidth: 2.5,
          color: AppColor().primariColor,
        )),
      );
    }
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: MyAppbar(),
        body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, ),
            child: SingleChildScrollView(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        IconButton(onPressed: () {
                          Navigator.pop(context);
                        },
                            icon: Icon(
                              Icons.arrow_back, color: AppColor().primariColor,
                              size: 25,)),
                        Text("Basic Information", style: TextStyle(
                            color: AppColor().primariColor,
                            fontSize: 20,
                            fontWeight: FontWeight.bold
                        ),),
                        SizedBox(width: 15,),
                        IconButton(onPressed: () => _showDialog(context),
                            icon: Icon(Icons.edit_sharp, size: 25,
                              color: AppColor().primariColor,))
                      ],
                    ),
                    SizedBox(height: 10,),
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.symmetric(vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey.shade400),
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 15),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Name", style: TextStyle(
                                color: Colors.black.withOpacity(0.6),
                                fontSize: 20
                            ),),
                            Consumer(
                                builder: (context, value, child) {
                                  return Text(
                                    profile!.name,
                                    //authProvider.user_model!.user.name??"",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18
                                    ),);
                                }),
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
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric( horizontal: 20, vertical: 15),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Login Name", style: TextStyle(
                                color: Colors.black.withOpacity(0.6),
                                fontSize: 20
                            ),),
                            Consumer(builder: (context, value, child) {
                              return Text(
                                //authProvider.user_model!.user.loginName??"",
                                profile!.loginName,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18
                                ),);
                            },),
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
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Mobile No", style: TextStyle(
                                color: Colors.black.withOpacity(0.6),
                                fontSize: 20
                            ),),
                            Consumer(builder: (context, value, child) {
                              return Text(
                                //authProvider.user_model!.user.mobileNo??"",
                                profile!.mobileNo,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18
                                ),);
                            },),
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
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child: Padding(

                        padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 15),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Email", style: TextStyle(
                                color: Colors.black.withOpacity(0.6),
                                fontSize: 20
                            ),),
                            Consumer(builder: (context, value, child) {
                              return Text(
                                //authProvider.user_model!.user.email??"",
                               profile!.email,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18
                                ),);
                            },),
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
                          borderRadius: BorderRadius.circular(10)
                      ),

                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 15),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Gender", style: TextStyle(
                                color: Colors.black.withOpacity(0.6),
                                fontSize: 20
                            ),),

                            Text(
                               // authProvider.user_model!.user.profileData!.gender??"",
                             profile?.profileData?.gender??"",
                                style: TextStyle(
                                color: Colors.black,
                                fontSize: 18
                            ),),
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
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 15),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Date of birth", style: TextStyle(
                                color: Colors.black.withOpacity(0.6),
                                fontSize: 20
                            ),),
                            Text(
                              //authProvider.user_model!.user.profileData!.dateOfBirth??"",
                             profile?.profileData?.dateOfBirth?? "No DOB",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18
                            ),),
                          ],
                        ),
                      ),
                    ),



                  ]
              ),
            )
        )
    );
  }


}
