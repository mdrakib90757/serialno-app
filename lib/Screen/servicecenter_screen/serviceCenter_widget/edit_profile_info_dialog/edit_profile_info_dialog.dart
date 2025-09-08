import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:serialno_app/request_model/update_profile_request.dart';

import '../../../../global_widgets/custom_dropdown/custom_dropdown.dart';
import '../../../../global_widgets/custom_flushbar.dart';
import '../../../../global_widgets/custom_labeltext.dart';
import '../../../../global_widgets/custom_sanckbar.dart';
import '../../../../global_widgets/custom_textfield.dart';
import '../../../../model/user_model.dart';
import '../../../../providers/auth_provider/auth_providers.dart';
import '../../../../providers/profile_provider/getprofile_provider.dart';
import '../../../../providers/profile_provider/profile_update_provider.dart';
import '../../../../utils/color.dart';

class edit_profile_info_dialog extends StatefulWidget {
  final User_Model user;
  final User_Model? serviceTaker;
  const edit_profile_info_dialog({
    super.key,
    required this.user,
    this.serviceTaker,
  });

  @override
  State<edit_profile_info_dialog> createState() =>
      _edit_profile_info_dialogState();
}

class _edit_profile_info_dialogState extends State<edit_profile_info_dialog> {
  DateTime date = DateTime(2022, 12, 24);
  bool isSelect = false;
  String? _selectGenter;
  final _formkey = GlobalKey<FormState>();
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;

  final List<String> genderList = ["Male", "Female", "Other"];

  final TextEditingController name = TextEditingController();
  final TextEditingController loginName = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController mobileNo = TextEditingController();
  final TextEditingController dateOfBirth = TextEditingController();

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

    final getProfileProvider = Provider.of<Getprofileprovider>(context);
    final profile = getProfileProvider.profileData;

    return Center(
      child: Dialog(
        backgroundColor: Colors.white,
        insetPadding: EdgeInsets.all(10),
        shape: RoundedRectangleBorder(
          side: BorderSide(color: AppColor().primariColor),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Container(
            //height: 760,
            width: double.infinity,
            decoration: BoxDecoration(color: Colors.white),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Edit Profile Information",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.close_sharp),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  CustomLabeltext(
                    "Name",
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                  SizedBox(height: 10),
                  CustomTextField(
                    controller: name,
                    hintText: "name",
                    isPassword: false,
                  ),
                  SizedBox(height: 10),

                  CustomLabeltext("Login Name"),
                  SizedBox(height: 10),
                  CustomTextField(
                    enabled: false,
                    filled: true,
                    //fillColor: Colors.orange.shade400,
                    controller: loginName,
                    hintText: "Login name",
                    isPassword: false,
                  ),
                  SizedBox(height: 10),

                  CustomLabeltext("Mobile No"),
                  SizedBox(height: 10),
                  CustomTextField(
                    controller: mobileNo,
                    hintText: "mobile no",
                    isPassword: false,
                  ),
                  SizedBox(height: 10),
                  CustomLabeltext("Email"),
                  SizedBox(height: 10),
                  CustomTextField(
                    controller: email,
                    hintText: "email",
                    isPassword: false,
                  ),
                  SizedBox(height: 10),
                  CustomLabeltext("Gender"),
                  SizedBox(height: 12),
                  Container(
                    height: 45,
                    child: CustomDropdown<String>(
                      items: genderList,
                      value: _selectGenter,
                      itemAsString: (item) => item,
                      // validator: (value) {
                      //   if (value == null)
                      //     return "Please select a Gender";
                      //   return null;
                      // },
                      onChanged: (newValue) {
                        setState(() {
                          _selectGenter = newValue;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade400),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _selectGenter ?? "Select Gender",
                              style: TextStyle(
                                color: _selectGenter != null
                                    ? Colors.black
                                    : Colors.grey.shade600,
                              ),
                            ),
                            Icon(
                              Icons.arrow_drop_down,
                              color: Colors.grey.shade600,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 10),
                  CustomLabeltext("Date of Birth"),
                  SizedBox(height: 10),
                  CustomTextField(
                    controller: dateOfBirth,
                    hintText: dateOfBirth.text.isEmpty
                        ? "${date.year}-${date.month}-${date.day}"
                        : dateOfBirth.text,
                    textStyle: TextStyle(color: Colors.black),
                    isPassword: false,
                    suffixIcon: IconButton(
                      onPressed: () async {
                        DateTime? newDate = await showDatePicker(
                          builder: (context, child) {
                            return Theme(
                              data: Theme.of(context).copyWith(
                                useMaterial3: false,
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
                                  ),
                                ),
                                textButtonTheme: TextButtonThemeData(
                                  style: TextButton.styleFrom(
                                    foregroundColor: AppColor()
                                        .primariColor, // Button text color
                                  ),
                                ),
                              ),
                              child: child!,
                            );
                          },
                          context: context,
                          initialDate: date,
                          firstDate: DateTime(1900),
                          lastDate: DateTime(2100),
                        );
                        if (newDate == null) return;
                        setState(() {
                          date = newDate;
                          dateOfBirth.text =
                              "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
                        });
                      },
                      icon: Icon(
                        Icons.date_range_outlined,
                        color: Colors.grey.shade400,
                      ),
                    ),
                  ),

                  SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Consumer<ProfileProvider>(
                        builder: (context, value, child) {
                          return ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColor().primariColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            onPressed: UpdateProfile.isLoading
                                ? null
                                : () async {
                                    UpdateProfileRequest request =
                                        UpdateProfileRequest(
                                          name: name.text,
                                          mobileNo: mobileNo.text,
                                          email: email.text,
                                          gender: _selectGenter,
                                          dateOfBirth:
                                              dateOfBirth.text.isNotEmpty
                                              ? dateOfBirth.text
                                              : null,
                                        );

                                    final success =
                                        await UpdateProfile.updateUserProfile(
                                          request,
                                        );

                                    if (success) {
                                      await Provider.of<Getprofileprovider>(
                                        context,
                                        listen: false,
                                      ).fetchProfileData();
                                      await CustomFlushbar.showSuccess(
                                        context: context,
                                        title: "Success",
                                        message: "Profile update Successful",
                                      );
                                      Navigator.pop(context);
                                    } else {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: CustomSnackBarWidget(
                                            title: "Error",
                                            message:
                                                UpdateProfile.errorMessage ??
                                                "Profile Update Failed",
                                            iconColor: Colors.red.shade400,
                                            icon: Icons.dangerous_outlined,
                                          ),
                                          backgroundColor: Colors.transparent,
                                          elevation: 0,
                                          behavior: SnackBarBehavior.floating,
                                          duration: Duration(seconds: 3),
                                        ),
                                      );
                                    }
                                  },
                            child: Center(
                              child: Text(
                                UpdateProfile.isLoading
                                    ? "Please Wait.. "
                                    : "Update",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          );
                        },
                      ),

                      SizedBox(width: 10),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Cancel",
                          style: TextStyle(color: AppColor().primariColor),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
