import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:serialno_app/Widgets/custom_dropdown/custom_dropdown.dart';
import 'package:serialno_app/Widgets/custom_labeltext.dart';
import 'package:serialno_app/Widgets/custom_textfield.dart';
import 'package:serialno_app/model/AddUser_serviceCenterModel.dart';
import 'package:serialno_app/model/roles_model.dart';
import 'package:serialno_app/model/serviceCenter_model.dart';
import 'package:serialno_app/providers/serviceCenter_provider/addUser_serviceCenter_provider/update_addUser_serviceCenter/update_addUser_serviceCenter.dart';
import 'package:serialno_app/request_model/serviceCanter_request/addUser_serviceCenterRequest/editUserRequest/editUserRequest.dart';
import 'package:serialno_app/utils/color.dart';
import '../../../../Widgets/custom_flushbar.dart';
import '../../../../Widgets/custom_sanckbar.dart';
import '../../../../providers/profile_provider/getprofile_provider.dart';
import '../../../../providers/serviceCenter_provider/addButton_provider/get_AddButton_provider.dart';
import '../../../../providers/serviceCenter_provider/addUser_serviceCenter_provider/getAddUser_serviceCenterProvider.dart';
import '../../../../providers/serviceCenter_provider/roles_service_center_provider/roles_service_center_provider.dart';
import '../AssignedServiceCenter/AssignedServiceCenter.dart';

class EditAdduserSettingDialog extends StatefulWidget {
  final AddUserModel? userModel;
  final List<ServiceCenterModel> availableServiceCenters;
  final List<Data> availableRoles;
  const EditAdduserSettingDialog({
    super.key,
    this.userModel,
    required this.availableServiceCenters,
    required this.availableRoles,
  });

  @override
  State<EditAdduserSettingDialog> createState() =>
      _EditAdduserSettingDialogState();
}

class _EditAdduserSettingDialogState extends State<EditAdduserSettingDialog> {
  final _fromKey = GlobalKey<FormState>();
  Data? _selectedRole;
  ServiceCenterModel? _selectedServiceCenter;
  List<ServiceCenterModel> _selectedServiceCenters = [];
  List<ServiceCenterModel> _selectedServiceCentersForUser = [];
  bool _isActive = true;
  AutovalidateMode _autoValidateMode = AutovalidateMode.disabled;

  late TextEditingController _nameController;
  late TextEditingController _loginNameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final currentUser = widget.userModel;
    if (currentUser != null) {
      _nameController = TextEditingController(text: currentUser.name);
      _loginNameController = TextEditingController(text: currentUser.loginName);
      _emailController = TextEditingController(text: currentUser.email);
      _phoneController = TextEditingController(text: currentUser.mobileNo);
      _isActive = currentUser.isActive ?? true;

      final String? userRoleId = currentUser.roleId;
      if (userRoleId != null && widget.availableRoles.isNotEmpty) {
        try {
          _selectedRole = widget.availableRoles.firstWhere(
            (role) => role.id == userRoleId,
          );
        } catch (e) {
          debugPrint("Role with ID $userRoleId not found in available roles.");
          _selectedRole = null;
        }
      }

      final List<String> assignedIds = currentUser.serviceCenterIds;
      if (widget.availableServiceCenters.isNotEmpty && assignedIds.isNotEmpty) {
        _selectedServiceCentersForUser = widget.availableServiceCenters
            .where((center) => assignedIds.contains(center.id))
            .toList();
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _loginNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _UpdateAddUserInfo() async {
    if (!(_fromKey.currentState?.validate() ?? false)) {
      setState(() {
        _autoValidateMode = AutovalidateMode.onUserInteraction;
      });
      return;
    }

    final updateAddUserProvider = Provider.of<UpdateAddUserProvider>(
      context,
      listen: false,
    );
    final getAddUserButton = Provider.of<GetAdduserServiceCenterProvider>(
      context,
      listen: false,
    );
    final String? userId = widget.userModel?.id;
    final companyId = Provider.of<Getprofileprovider>(
      context,
      listen: false,
    ).profileData?.currentCompany.id;

    final navigator = Navigator.of(context);
    if (companyId == null) {
      CustomFlushbar.showSuccess(
        context: context,
        title: "Success",
        message: "  User Update Successful",
      );
      return;
    }
    EditUserRequest userRequest = EditUserRequest(
      name: _nameController.text,
      loginName: _loginNameController.text,
      email: _emailController.text,
      mobileNo: _phoneController.text,
      roleId: _selectedRole!.id!,
      serviceCenterIds: _selectedServiceCentersForUser
          .map((sc) => sc.id!)
          .toList(),
      isActive: _isActive,
    );
    final success = await updateAddUserProvider.UpdateAddUserButton(
      userRequest,
      companyId,
      userId!,
    );
    if (success) {
      await getAddUserButton.fetchUsers(companyId);
      navigator.pop();
      await CustomFlushbar.showSuccess(
        context: context,
        title: "Success",
        message: "  User Update Successfully",
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: CustomSnackBarWidget(
            title: "Error",
            message: updateAddUserProvider.errorMessage ?? "Failed to Add User",
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
    final updateProvider = Provider.of<UpdateAddUserProvider>(
      context,
      listen: false,
    );
    final serviceCenterProvider = Provider.of<GetAddButtonProvider>(context);
    final rolesProvider = Provider.of<RolesProvider>(context);
    if (rolesProvider.isLoading || serviceCenterProvider.isLoading) {
      return Dialog(
        child: Center(
          child: CircularProgressIndicator(
            color: AppColor().primariColor,
            strokeWidth: 2.5,
          ),
        ),
      );
    }
    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.all(10),
      shape: RoundedRectangleBorder(
        // side: BorderSide(color: AppColor().primariColor),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Form(
          key: _fromKey,
          autovalidateMode: _autoValidateMode,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Edit Service Man",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(Icons.close, color: Colors.black),
                    ),
                  ],
                ),
                SizedBox(height: 10),

                CustomLabeltext("Name"),
                SizedBox(height: 8),
                CustomTextField(
                  controller: _nameController,
                  isPassword: false,
                  hintText: "Name",
                  prefixIcon: Icons.person,
                ),
                SizedBox(height: 10),

                CustomLabeltext("Login Name"),
                SizedBox(height: 8),
                CustomTextField(
                  controller: _loginNameController,
                  hintText: "Login Name",
                  isPassword: false,
                  //controller: phone
                ),
                SizedBox(height: 10),

                CustomLabeltext("Email Address"),
                SizedBox(height: 8),
                CustomTextField(
                  controller: _emailController,
                  hintText: "Email address",
                  isPassword: false,
                  prefixIcon: Icons.email_outlined,
                  //controller: phone
                ),
                SizedBox(height: 10),

                CustomLabeltext("Mobile Number"),
                SizedBox(height: 8),
                CustomTextField(
                  controller: _phoneController,
                  hintText: "Mobile Number",
                  isPassword: false,
                  //controller: phone,
                  prefixIcon: Icons.call,
                ),
                SizedBox(height: 10),

                CustomLabeltext("Role"),
                SizedBox(height: 10),
                CustomDropdown<Data>(
                  items: widget.availableRoles,
                  value: _selectedRole,
                  onChanged: (Data? newValue) {
                    setState(() {
                      _selectedRole = newValue;
                    });
                  },
                  itemAsString: (Data? item) => item?.name ?? "No name",
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _selectedRole?.name ?? "Select Role",
                          style: TextStyle(
                            color: _selectedRole != null
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
                SizedBox(height: 10),

                Text(
                  "Assigned Service Center",
                  style: TextStyle(color: Colors.black, fontSize: 15.20),
                ),
                SizedBox(height: 10),
                AssignedServiceCentersDropdown(
                  availableServiceCenters: widget.availableServiceCenters,
                  initialSelectedCenters: _selectedServiceCentersForUser,
                  onSelectionChanged: (selectedList) {
                    setState(() {
                      _selectedServiceCentersForUser = selectedList;
                    });
                  },
                ),
                SizedBox(height: 13),

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
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadiusGeometry.circular(5),
                        ),
                        backgroundColor: AppColor().primariColor,
                      ),
                      onPressed: _UpdateAddUserInfo,
                      child: Text(
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
