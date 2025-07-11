


import 'dart:convert';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:serial_managementapp_project/model/user_model.dart' show User_Model;



import '../providers/auth_providers.dart';
import '../providers/profile_update_provider.dart';
import '../utils/color.dart';
import 'custom_labeltext.dart';
import 'custom_textfield.dart';

class CustomDilogbox extends StatefulWidget{
  final User_Model user;
  final User_Model? serviceTaker;
  const CustomDilogbox({super.key, required this.user,  this.serviceTaker});

  @override
  State<CustomDilogbox> createState() => _CustomDilogboxState();
}

class _CustomDilogboxState extends State<CustomDilogbox> {


  DateTime date = DateTime(2022, 12, 24);
  bool isSelect = false;
  String?_selectGenter;
  final _formkey = GlobalKey<FormState>();
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;

  final List<String>genderList = ["Male", "Female", "Other"];

  final  TextEditingController name =TextEditingController();
  final TextEditingController loginName = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController mobileNo=TextEditingController();
  final TextEditingController dateOfBirth=TextEditingController();

  @override
  void dispose() {
    name.dispose();
    loginName.dispose();
    email.dispose();
    mobileNo.dispose();
    dateOfBirth.dispose();
    super.dispose();
  }



  @override
  void initState() {
    super.initState();

    final user = widget.user;

    // ✅ User_Model থেকে
    name.text = user.user.name;
    loginName.text = user.user.loginName;
    email.text = user.user.email;
    mobileNo.text = user.user.mobileNo;

    // ✅ ServiceTaker থেকে gender ও dateOfBirth
    final profileData = widget.serviceTaker?.serviceTaker?.profileData;

    if (profileData != null) {
      if (genderList.contains(profileData.gender)) {
        _selectGenter = profileData.gender!;
      }

      if (profileData.dateOfBirth != null) {
        dateOfBirth.text = profileData.dateOfBirth!;
      }
    }
  }

      @override
      Widget build(BuildContext context) {
        final authProvider = Provider.of<AuthProvider>(context, listen: false,);
        final UpdateProfile = Provider.of<ProfileProvider>(context, listen: false);
        return Center(
          child: Dialog(
            backgroundColor: Colors.white,
            insetPadding: EdgeInsets.all(10),
            shape: RoundedRectangleBorder(
              side: BorderSide(color: AppColor().primariColor),
                borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20,),
              child: Container(
                //height: 760,
                width: double.infinity,
                decoration: BoxDecoration(

                  color: Colors.white,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Edit Profile Information", style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold
                          ),),
                          IconButton(onPressed: () {
                            Navigator.pop(context);
                          }, icon: Icon(Icons.close_sharp))
                        ],
                      ),
                      SizedBox(height: 20,),
                      CustomLabeltext("Name", color: Colors.black,
                        fontWeight: FontWeight.w500,),
                      SizedBox(height: 10,),
                      CustomTextField(
                          controller: name,
                          hintText: "name",
                          isPassword: false
                      ),
                      SizedBox(height: 20,),

                      CustomLabeltext("Login Name"),
                      SizedBox(height: 10,),
                      CustomTextField(
                       enabled: false,
                         filled: true,
                          //fillColor: Colors.orange.shade400,
                          controller: loginName,
                          hintText: "Login name",
                          isPassword: false
                      ),
                      SizedBox(height: 20,),


                      CustomLabeltext("Mobile No"),
                      SizedBox(height: 10,),
                      CustomTextField(
                          controller: mobileNo,
                          hintText: "mobile no",
                          isPassword: false
                      ),
                      SizedBox(height: 20,),
                      CustomLabeltext("Email"),
                      SizedBox(height: 10,),
                      CustomTextField(
                          controller: email,
                          hintText: "email",
                          isPassword: false
                      ),
                      SizedBox(height: 20,),
                      CustomLabeltext("Gender"),
                      SizedBox(height: 12,),
                      DropdownButtonFormField<String>(
                        validator: (value) => value == null || value.isEmpty ? "Required" : null,
                        autovalidateMode: _autovalidateMode,
                        onChanged: (newValue) {
                          setState(() {
                            _autovalidateMode = AutovalidateMode.always;
                            _selectGenter = newValue;
                          });
                        },
                        decoration: InputDecoration(
                          hintText: "Gender",
                          hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 15),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(color: Colors.grey.shade400),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(color: Colors.red),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(color: Colors.grey.shade400),
                          ),
                        ),
                        value: _selectGenter,
                        items: genderList.map((String value) {
                          return DropdownMenuItem(value: value, child: Text(value));
                        }).toList(),
                      ),
                      SizedBox(height: 20,),
                      CustomLabeltext("Date of Birth"),
                      SizedBox(height: 10,),
                      CustomTextField(
                        controller: dateOfBirth,
                        hintText: dateOfBirth.text.isEmpty ? "${date
                            .year}/${date.month}/${date.day}" : dateOfBirth
                            .text,
                        textStyle: TextStyle(
                            color: Colors.black
                        ),
                        isPassword: false,
                        suffixIcon: IconButton(onPressed: () async
                        {
                          DateTime? newDate = await showDatePicker(
                              builder: (context, child) {
                                return Theme(data: Theme.of(context).copyWith(
                                  colorScheme: ColorScheme.light(
                                    primary: AppColor().primariColor,
                                    // Header color
                                    onPrimary: Colors.white,
                                    // Header text color
                                    onSurface: Colors.black, // Body text color
                                  ),
                                    dialogTheme: DialogTheme(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16.0),
                                      )),
                                  textButtonTheme: TextButtonThemeData(
                                    style: TextButton.styleFrom(
                                      foregroundColor: AppColor()
                                          .primariColor, // Button text color
                                    ),
                                  ),
                                ), child: child!);
                              },
                              context: context,
                              initialDate: date,
                              firstDate: DateTime(1900),
                              lastDate: DateTime(2100)
                          );
                          if (newDate == null) return;
                          setState(() {
                            date = newDate;
                            dateOfBirth.text =
                            "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
                          });
                        },
                            icon: Icon(Icons.date_range_outlined,
                              color: Colors.grey.shade400,)),
                      ),


                      SizedBox(height: 20,),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Consumer<ProfileProvider>(builder: (context, value, child) {
                            return ElevatedButton(
                              style: ElevatedButton.styleFrom(

                                backgroundColor: AppColor().primariColor,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5)),

                              ),
                              onPressed: () async {

                                final success = await UpdateProfile.updateProfile(
                                  name: "user-bappyb",
                                  loginName: "User-Rakib",
                                  mobileNo: "01601711260",
                                  email: "user-bappyb@gmail.com",
                                  gender: "Male",
                                  dateOfBirth: null, // or "2025-07-11T02:43:26.322Z"
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(success ? ' Profile Updated' : ' Failed')));

                              },child:  Text("Update",style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold
                            ),),
                            );
                          },),

                          SizedBox(width: 10,),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(

                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5)
                                  )
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              }, child: Text("Cancel", style: TextStyle(
                              color: AppColor().primariColor
                          ),))
                            ],
                      ),
                      SizedBox()



                    ],
                  ),
                ),
              ),
            ),


          ),
        );
      }
    }
