import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:serialno_app/Screen/servicecenter_screen/serviceCenter_widget/AssignedServiceCenter/AssignedServiceCenter.dart';
import 'package:serialno_app/global_widgets/custom_shimmer_list/CustomShimmerList%20.dart';
import 'package:serialno_app/model/roles_model.dart';
import 'package:serialno_app/model/serviceCenter_model.dart';
import 'package:serialno_app/providers/serviceCenter_provider/addButton_provider/get_AddButton_provider.dart';
import 'package:serialno_app/providers/serviceCenter_provider/addUser_serviceCenter_provider/addUser_serviceCenter_provider.dart';
import 'package:serialno_app/providers/serviceCenter_provider/addUser_serviceCenter_provider/getAddUser_serviceCenterProvider.dart';
import 'package:serialno_app/providers/serviceCenter_provider/newSerialButton_provider/getNewSerialButton_provider.dart';
import 'package:serialno_app/providers/serviceCenter_provider/roles_service_center_provider/roles_service_center_provider.dart';
import 'package:serialno_app/request_model/serviceCanter_request/addUser_serviceCenterRequest/addUser_ServiceCenter_request.dart';
import 'package:serialno_app/utils/color.dart';
import 'package:serialno_app/utils/date_formatter/date_formatter.dart';
import '../../../../global_widgets/My_Appbar.dart';
import '../../../../global_widgets/custom_circle_progress_indicator/custom_circle_progress_indicator.dart';
import '../../../../global_widgets/custom_dropdown/custom_dropdown.dart';
import '../../../../global_widgets/custom_flushbar.dart';
import '../../../../global_widgets/custom_labeltext.dart';
import '../../../../global_widgets/custom_sanckbar.dart';
import '../../../../global_widgets/custom_textfield.dart';
import '../../../../main_layouts/main_layout/main_layout.dart';
import '../../../../providers/profile_provider/getprofile_provider.dart';

class AddUser_SettingServiceCenterDialog extends StatefulWidget {
  const AddUser_SettingServiceCenterDialog({super.key});

  @override
  State<AddUser_SettingServiceCenterDialog> createState() =>
      _AddUser_SettingServiceCenterDialogState();
}

class _AddUser_SettingServiceCenterDialogState
    extends State<AddUser_SettingServiceCenterDialog> {
  ServiceCenterModel? _selectedServiceCenter;
  List<ServiceCenterModel> _selectedServiceCenters = [];
  List<ServiceCenterModel> _selectedServiceCentersForUser = [];
  DateTime _selectedDate = DateTime.now();
  bool obscureIndex = true;
  bool obscureIndex1 = true;
  final _fromkey = GlobalKey<FormState>();
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;
  Data? _selectedRole;
  bool _isActive = true;

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _loginNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  void _fetchDataForUI() {
    if (_selectedServiceCenter != null) {
      debugPrint(
        " FETCHING SERIALS for Service Center ID: ${_selectedServiceCenter!.id!}",
      );

      final formattedDate = DateFormatter.formatForApi(_selectedDate);

      Provider.of<GetNewSerialButtonProvider>(
        context,
        listen: false,
      ).fetchSerialsButton(_selectedServiceCenter!.id!, formattedDate);
    } else {
      debugPrint("fetchDataForUI called but _selectedServiceCenter is null.");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<RolesProvider>(context, listen: false).fetchRoles();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _loginNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // save adduser setting screen
  Future<void> _saveAddUser() async {
    final addUserButton = Provider.of<AddUserServiceCenterProvider>(
      context,
      listen: false,
    );
    final getAddUserButton = Provider.of<GetAdduserServiceCenterProvider>(
      context,
      listen: false,
    );
    if (!(_fromkey.currentState?.validate() ?? false)) {
      setState(() {
        _autovalidateMode = AutovalidateMode.onUserInteraction;
      });
      return;
    }
    final navigator = Navigator.of(context);
    final companyId = Provider.of<Getprofileprovider>(
      context,
      listen: false,
    ).profileData?.currentCompany.id;

    if (companyId == null) {
      CustomFlushbar.showSuccess(
        context: context,
        title: "Success",
        message: " Added User Successful",
      );
      return;
    }

    AddUserRequest userRequest = AddUserRequest(
      name: _nameController.text,
      loginName: _loginNameController.text,
      email: _emailController.text,
      mobileNo: _phoneController.text,
      password: _passwordController.text,
      confirmPassword: _confirmPasswordController.text,
      roleId: _selectedRole!.id!,
      serviceCenterIds: _selectedServiceCentersForUser
          .map((sc) => sc.id!)
          .toList(),
      isActive: _isActive,
    );
    final success = await addUserButton.addUserButtonProvider(
      userRequest,
      companyId,
    );

    if (success) {
      await getAddUserButton.fetchUsers(companyId);
      navigator.pop();
      await CustomFlushbar.showSuccess(
        context: context,
        title: "Success",
        message: " Add User Successfully",
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: CustomSnackBarWidget(
            title: "Error",
            message: addUserButton.errorMessage ?? "Failed to Add User",
            iconColor: Colors.red.shade400,
            icon: Icons.dangerous_outlined,
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final getAddUserButton = Provider.of<GetAdduserServiceCenterProvider>(
      context,
    );
    final addUserButton = Provider.of<AddUserServiceCenterProvider>(context);
    final serviceCenterProvider = Provider.of<GetAddButtonProvider>(context);
    final rolesProvider = Provider.of<RolesProvider>(context);
    return MainLayout(
      currentIndex: 0,
      onTap: (p0) {},
      color: Colors.white,
      userType: UserType.company,
      child: (rolesProvider.isLoading)
          ? CustomShimmerList(itemCount: 10)
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Form(
                key: _fromkey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Add User",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 13),
                      const CustomLabeltext("Name"),
                      const SizedBox(height: 8),
                      CustomTextField(
                        controller: _nameController,
                        isPassword: false,
                        hintText: "Name",
                        // prefixIcon: Icons.person,
                        prefixIconConstraints: const BoxConstraints(
                          minWidth: 0,
                          minHeight: 0,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const CustomLabeltext("Login Name"),
                      const SizedBox(height: 8),
                      CustomTextField(
                        controller: _loginNameController,
                        hintText: "Login Name",
                        isPassword: false,
                        prefixIconConstraints: const BoxConstraints(
                          minWidth: 0,
                          minHeight: 0,
                        ),
                        //controller: phone
                      ),
                      const SizedBox(height: 10),
                      const CustomLabeltext("Email Address"),
                      const SizedBox(height: 8),
                      CustomTextField(
                        controller: _emailController,
                        hintText: "Email address",
                        isPassword: false,
                        keyboardType: TextInputType.emailAddress,
                        //prefixIcon: Icons.email_outlined,
                        prefixIconConstraints: const BoxConstraints(
                          minWidth: 0,
                          minHeight: 0,
                        ),
                        //controller: phone
                      ),
                      const SizedBox(height: 10),
                      const CustomLabeltext("Mobile Number"),
                      const SizedBox(height: 8),
                      CustomTextField(
                        controller: _phoneController,
                        hintText: "Mobile Number",
                        isPassword: false,
                        keyboardType: TextInputType.number,
                        //controller: phone,
                        //prefixIcon: Icons.call,
                      ),
                      const SizedBox(height: 10),
                      const CustomLabeltext("Role"),
                      const SizedBox(height: 10),
                      CustomDropdown<Data>(
                        hinText: "Select Role",
                        items: rolesProvider.roles,
                        value: _selectedRole,
                        selectedItem: _selectedRole,
                        onChanged: (Data? newValue) {
                          setState(() {
                            _selectedRole = newValue;
                          });
                        },
                        itemAsString: (Data? item) => item?.name ?? "No name",
                        validator: (value) {
                          if (value == null) return "Please select a Role";
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      CustomLabeltext(
                        "Assigned Service Center",
                        showStar: false,
                      ),
                      const SizedBox(height: 10),
                      AssignedServiceCentersDropdown(
                        availableServiceCenters:
                            serviceCenterProvider.serviceCenterList,
                        initialSelectedCenters: _selectedServiceCentersForUser,
                        onSelectionChanged: (selectedList) {
                          setState(() {
                            _selectedServiceCentersForUser = selectedList;
                          });
                        },
                      ),
                      const SizedBox(height: 10),
                      const CustomLabeltext("Password"),
                      const SizedBox(height: 12),
                      CustomTextField(
                        controller: _passwordController,
                        // prefixIcon: Icons.lock,
                        hintText: "Password",
                        isPassword: true,
                        // controller: password,
                      ),
                      const SizedBox(height: 10),
                      CustomLabeltext("Confirm Password"),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _confirmPasswordController,
                        onChanged: (value) {
                          setState(
                            () => _autovalidateMode = AutovalidateMode.always,
                          );
                          _fromkey.currentState?.validate();
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Required";
                          } else {
                            if (value != _passwordController.text) {
                              return "Passwords do not match";
                            }
                          }
                          return null;
                        },

                        // controller: confirmPassword,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 12,
                          ),
                          isDense: true,
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey.shade400),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey.shade400),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey.shade400),
                          ),
                          // prefixIcon: Icon(
                          //   Icons.lock_outline,
                          //   color: Colors.grey.shade400,
                          // ),
                          hintText: "Confirm password",
                          hintStyle: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 15,
                          ),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                obscureIndex1 = !obscureIndex1;
                                _fromkey.currentState?.validate();
                              });
                            },
                            icon: Icon(
                              obscureIndex1
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_off_outlined,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ),
                        cursorColor: Colors.grey.shade500,
                        obscureText: obscureIndex1,
                        obscuringCharacter: "*",
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _isActive == true ? "Active" : "Inactive",
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Transform.scale(
                            scale: 1,
                            child: Switch(
                              padding: EdgeInsets.all(5),
                              value: _isActive,
                              onChanged: (bool newValue) {
                                setState(() {
                                  _isActive = newValue;
                                });
                              },
                              activeColor: Colors.white,
                              activeTrackColor: AppColor().primariColor,
                              inactiveTrackColor: Colors.grey.shade200,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadiusGeometry.circular(5),
                              ),
                              backgroundColor: AppColor().primariColor,
                            ),
                            onPressed: _saveAddUser,
                            child: addUserButton.isLoading
                                ? Text(
                                    "Please Wait",
                                    style: TextStyle(color: Colors.white),
                                  )
                                : Text(
                                    "Save",
                                    style: TextStyle(color: Colors.white),
                                  ),
                          ),
                          SizedBox(width: 8),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadiusGeometry.circular(5),
                              ),
                              backgroundColor: Colors.white,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              "cancel",
                              style: TextStyle(color: AppColor().primariColor),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
