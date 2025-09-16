import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:serialno_app/request_model/update_profile_request.dart';

import '../../../../global_widgets/custom_dropdown/custom_dropdown.dart';
import '../../../../global_widgets/custom_flushbar.dart';
import '../../../../global_widgets/custom_labeltext.dart';
import '../../../../global_widgets/custom_sanckbar.dart';
import '../../../../global_widgets/custom_textfield.dart';
import '../../../../main_layouts/main_layout/main_layout.dart';
import '../../../../model/user_model.dart' hide UserType;
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
  DateTime _selectedDate = DateTime(01 - 01 - 2000);
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
    // final user = widget.user;
    // name.text = user.user.name;
    // loginName.text = user.user.loginName;
    // email.text = user.user.email;
    // mobileNo.text = user.user.mobileNo;
    // final profileData = widget.serviceTaker?.serviceTaker?.profileData
    //     ?? user.user.profileData;
    //
    // if (profileData != null) {
    //   if (genderList.contains(profileData.gender)) {
    //     _selectGenter = profileData.gender;
    //   }
    //
    //   if (profileData.dateOfBirth != null) {
    //     dateOfBirth.text = profileData.dateOfBirth!;
    //   }
    // }
    _initializeProfileData();
  }

  void _initializeProfileData() {
    final user = widget.user;
    name.text = user.user.name;
    loginName.text = user.user.loginName;
    email.text = user.user.email;
    mobileNo.text = user.user.mobileNo;

    final profileDataToUse =
        widget.serviceTaker?.user.profileData ?? user.user.profileData;

    if (profileDataToUse != null) {
      // 1. Initialize Gender
      if (profileDataToUse.gender != null &&
          genderList.contains(profileDataToUse.gender!)) {
        _selectGenter = profileDataToUse.gender!;
      } else {
        _selectGenter =
            null; // Ensure it's explicitly null if no match or null in profile
      }
      debugPrint("Initialized Gender: $_selectGenter");

      // 2. Initialize Date of Birth
      if (profileDataToUse.dateOfBirth != null &&
          profileDataToUse.dateOfBirth!.isNotEmpty) {
        try {
          _selectedDate = DateFormat(
            'dd-MM-yyyy',
          ).parse(profileDataToUse.dateOfBirth!);
          dateOfBirth.text = DateFormat(
            'dd-MM-yyyy',
          ).format(_selectedDate); // Display in YYYY-MM-DD in TextField
          debugPrint("Initialized Date of Birth (Parsed): ${dateOfBirth.text}");
        } catch (e) {
          debugPrint(
            "Error parsing dateOfBirth '${profileDataToUse.dateOfBirth}' from profile: $e",
          );
          // Fallback if parsing fails
          _selectedDate = DateTime(2000, 1, 1);
          dateOfBirth.text = DateFormat('dd-MM-yyyy').format(_selectedDate);
        }
      } else {
        // If profileDataToUse.dateOfBirth is null or empty
        _selectedDate = DateTime(2000, 1, 1);
        dateOfBirth.text = DateFormat('dd-MM-yyyy').format(_selectedDate);
        debugPrint("Initialized Date of Birth (Default): ${dateOfBirth.text}");
      }
    } else {
      // If no profileData is available at all
      _selectGenter = null;
      _selectedDate = DateTime(2000, 1, 1);
      dateOfBirth.text = DateFormat('dd-MM-yyyy').format(_selectedDate);
      debugPrint("No profileData available. All fields set to defaults.");
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final UpdateProfile = Provider.of<ProfileProvider>(context, listen: false);
    final getProfileProvider = Provider.of<Getprofileprovider>(context);
    final profile = getProfileProvider.profileData;

    final authProvider = Provider.of<AuthProvider>(context);
    UserType currentUserLayoutType;
    if (authProvider.userType?.toLowerCase().trim() == "customer") {
      currentUserLayoutType = UserType.customer;
    } else {
      currentUserLayoutType = UserType.company;
    }

    return MainLayout(
      currentIndex: 0,
      onTap: (p0) {},
      color: Colors.white,
      userType: currentUserLayoutType,
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
                  ],
                ),
                const SizedBox(height: 20),
                CustomLabeltext(
                  "Name",
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  controller: name,
                  hintText: "name",
                  isPassword: false,
                ),
                const SizedBox(height: 10),

                const CustomLabeltext("Login Name"),
                const SizedBox(height: 10),
                CustomTextField(
                  enabled: false,
                  filled: true,
                  //fillColor: Colors.orange.shade400,
                  controller: loginName,
                  hintText: "Login name",
                  isPassword: false,
                ),
                const SizedBox(height: 10),

                const CustomLabeltext("Mobile No"),
                const SizedBox(height: 10),
                CustomTextField(
                  controller: mobileNo,
                  hintText: "mobile no",
                  isPassword: false,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 10),
                const CustomLabeltext("Email"),
                const SizedBox(height: 10),
                CustomTextField(
                  controller: email,
                  hintText: "email",
                  isPassword: false,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 10),
                const CustomLabeltext("Gender"),
                const SizedBox(height: 12),
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
                    selectedItem: _selectGenter,
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

                const SizedBox(height: 10),
                const CustomLabeltext("Date of Birth"),
                const SizedBox(height: 10),
                CustomTextField(
                  controller: dateOfBirth,
                  hintText: "Select Date of Birth",
                  textStyle: TextStyle(color: Colors.grey.shade400),
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
                        initialDate: _selectedDate,
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                      );

                      if (newDate == null) return;
                      setState(() {
                        _selectedDate = newDate; // Update the DateTime state
                        dateOfBirth.text = DateFormat(
                          'dd-MM-yyyy',
                        ).format(newDate); //
                      });
                    },

                    icon: Icon(
                      Icons.date_range_outlined,
                      color: Colors.grey.shade400,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
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
                                        dateOfBirth: dateOfBirth.text.isNotEmpty
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
                                    ScaffoldMessenger.of(context).showSnackBar(
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
                            child: UpdateProfile.isLoading
                                ? Text(
                                    "Please Wait..",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  )
                                : Text(
                                    "Update",
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

                    const SizedBox(width: 10),
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
    );
  }
}
