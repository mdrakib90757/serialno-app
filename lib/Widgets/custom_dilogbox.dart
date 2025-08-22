




import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:serialno_app/request_model/update_profile_request.dart';

import '../model/user_model.dart';
import '../providers/auth_provider/auth_providers.dart';
import '../providers/profile_provider/getprofile_provider.dart';
import '../providers/profile_provider/profile_update_provider.dart';
import '../utils/color.dart';
import 'custom_flushbar.dart';
import 'custom_labeltext.dart';
import 'custom_sanckbar.dart';
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

    name.text = user.user.name;
    loginName.text = user.user.loginName;
    email.text = user.user.email;
    mobileNo.text = user.user.mobileNo;


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

     final UpdateProfile = Provider.of<ProfileProvider>(context, listen: false);

     final getProfileProvider=Provider.of<Getprofileprovider>(context);
        final profile=getProfileProvider.profileData;




        return Center(
          child: Dialog(
            backgroundColor: Colors.white,
            insetPadding: EdgeInsets.all(10),
            shape: RoundedRectangleBorder(
              side: BorderSide(color: AppColor().primariColor),
                borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 15),
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
                      DropdownSearch<String>(
                        popupProps: PopupProps.menu(
                          menuProps: MenuProps(
                              backgroundColor: Colors.white,
                              borderRadius: BorderRadius.circular(10)
                          ),
                          constraints: BoxConstraints(
                              maxHeight: 150
                          ),

                          emptyBuilder: (context, searchEntry) {
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 24.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [

                                  ],
                                ),
                              ),
                            );
                          },
                        ),

                        dropdownDecoratorProps: DropDownDecoratorProps(
                          dropdownSearchDecoration: InputDecoration(
                            hintText: "Gender",
                            hintStyle: TextStyle(
                                color: Colors.grey.shade400
                            ),
                            suffixIcon: Icon(Icons.date_range_outlined),
                            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: BorderSide(
                                  color: Colors.grey.shade400,
                                )
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: BorderSide(
                                    color: AppColor().primariColor,
                                    width: 2
                                )
                            ),
                            errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: BorderSide(
                                    color: Colors.red
                                )
                            ),
                            disabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: BorderSide(
                                  color: Colors.grey.shade300),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: BorderSide(
                                  color: Colors.grey.shade400),
                            ),

                          ),
                        ),
                        validator: (value) => value == null || value.isEmpty ? "Required" : null,
                        autoValidateMode: _autovalidateMode,
                        items:genderList,
                        //items: ['Google', 'Meta', 'Amazon', 'Netflix'],

                        onChanged: (newValue) {
                          setState(() {
                            _autovalidateMode = AutovalidateMode.always;
                            _selectGenter = newValue;
                          });
                        },
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
                                    dialogTheme: DialogThemeData(
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
                              onPressed: UpdateProfile.isLoading ? null: () async {

                                UpdateProfileRequest request = UpdateProfileRequest(
                                  name: name.text,
                                  mobileNo: mobileNo.text,
                                  email: email.text,
                                  gender: _selectGenter,
                                  dateOfBirth: dateOfBirth.text.isNotEmpty ? dateOfBirth.text : null,
                                );

                                final success = await UpdateProfile.updateUserProfile(request);

                                if(success){

                                  await Provider.of<Getprofileprovider>(context, listen: false).fetchProfileData();
                                 await CustomFlushbar.showSuccess(
                                     context: context,
                                     title: "Success",
                                     message: "Profile update Successful"
                                 );
                                  Navigator.pop(context);

                                }else{

                                 ScaffoldMessenger.of(context).showSnackBar(
                                     SnackBar(
                                         content: CustomSnackBarWidget(
                                             title: "Error",
                                             message:UpdateProfile.errorMessage?? "Profile Update Failed",
                                           iconColor: Colors.red.shade400,
                                           icon: Icons.dangerous_outlined,),
                                           backgroundColor: Colors.transparent,
                                           elevation: 0,
                                           behavior: SnackBarBehavior.floating,
                                           duration: Duration(seconds: 3),
                                         )

                                 );
                                }


                              },child: Center(
                              child: Text( UpdateProfile.isLoading?"Please Wait.. ":"Update",style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600
                              ),),)

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
