
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:serial_managementapp_project/Widgets/My_Appbar.dart';
import 'package:serial_managementapp_project/Widgets/custom_dilogbox.dart';

import 'package:serial_managementapp_project/providers/auth_providers.dart';

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
      builder: (context) => CustomDilogbox(user: authProvider.user_model!,),
    );

    if (result == true) {
      setState(() {}); // force UI rebuild
    }
  }


  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: true);
    Map<String, dynamic> profileInfo = {};

    print("ProfileData Full: ${authProvider.serviceTaker?.profileData
        ?.toJson()}");

    return Scaffold(
        appBar: MyAppbar(),
        body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
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
                            fontSize: 24,
                            fontWeight: FontWeight.bold
                        ),),
                        SizedBox(width: 15,),
                        IconButton(onPressed: () => _showDialog(context),
                            icon: Icon(Icons.edit_sharp, size: 30,
                              color: AppColor().primariColor,))
                      ],
                    ),
                    SizedBox(height: 20,),
                    Container(
                      width: double.infinity,
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
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
                                      authProvider.user_model!.user.name,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18
                                      ),);
                                  }),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text("Login Name", style: TextStyle(
                          color: Colors.black.withOpacity(0.6),
                          fontSize: 20
                      ),),
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Consumer(builder: (context, value, child) {
                          return Text(
                            authProvider.user_model!.user.loginName,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18
                            ),);
                        },)
                    ),
                    SizedBox(height: 10,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text("Mobile No", style: TextStyle(
                          color: Colors.black.withOpacity(0.6),
                          fontSize: 20
                      ),),
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Consumer(builder: (context, value, child) {
                          return Text(
                            authProvider.user_model!.user.mobileNo,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18
                            ),);
                        },)
                    ),
                    SizedBox(height: 10,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text("Email", style: TextStyle(
                          color: Colors.black.withOpacity(0.6),
                          fontSize: 20
                      ),),
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Consumer(builder: (context, value, child) {
                          return Text(
                            authProvider.user_model!.user.email,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18
                            ),);
                        },)
                    ),

                    SizedBox(height: 10,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Text("Gender", style: TextStyle(
                          color: Colors.black.withOpacity(0.6),
                          fontSize: 20
                      ),),
                    ),
                    SizedBox(height: 10,),
                    Text(authProvider.user_model?.user.profileData?.gender ??
                        "No Gender"),

                    SizedBox(height: 10,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Text("Date of birth", style: TextStyle(
                          color: Colors.black.withOpacity(0.6),
                          fontSize: 20
                      ),),
                    ),
                    SizedBox(height: 10,),
                    // Date of Birth
                    Text(authProvider.user_model?.user.profileData
                        ?.dateOfBirth ?? "No DOB"),

                  ]
              ),
            )
        )
    );
  }


}
