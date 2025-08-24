import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:serialno_app/Screen/servicecenter_screen/serviceCenter_widget/setting_serviceCenterdialo/setting_serviceCenterdialo.dart';
import 'package:serialno_app/model/AddUser_serviceCenterModel.dart';
import 'package:serialno_app/providers/profile_provider/getprofile_provider.dart';
import 'package:serialno_app/providers/serviceCenter_provider/addUser_serviceCenter_provider/getAddUser_serviceCenterProvider.dart';
import 'package:serialno_app/providers/serviceCenter_provider/business_type_provider/business_type_provider.dart';
import 'package:serialno_app/providers/serviceCenter_provider/company_details_provider/company_details_provider.dart';
import 'package:serialno_app/providers/serviceCenter_provider/roles_service_center_provider/roles_service_center_provider.dart';
import 'package:serialno_app/utils/color.dart';

import '../../model/roles_model.dart';

class Servicecenter_Settingscreen extends StatefulWidget {
  const Servicecenter_Settingscreen({super.key});

  @override
  State<Servicecenter_Settingscreen> createState() =>
      _Servicecenter_SettingscreenState();
}

class _Servicecenter_SettingscreenState
    extends State<Servicecenter_Settingscreen> {
  Data? _selectedRole;
  List<Data> rolesList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final profileProvider = Provider.of<Getprofileprovider>(
        context,
        listen: false,
      );

      final companyId = profileProvider.profileData?.currentCompany.id;
      if (companyId != null && companyId.isNotEmpty) {
        debugPrint("🚀 Calling fetchDetails for Company ID: $companyId");
        Provider.of<CompanyDetailsProvider>(
          context,
          listen: false,
        ).fetchDetails(companyId);
        Provider.of<BusinessTypeProvider>(
          context,
          listen: false,
        ).fetchBusinessTypes();

        Provider.of<GetAdduserServiceCenterProvider>(
          context,
          listen: false,
        ).fetchUsers(companyId);
        Provider.of<RolesProvider>(context, listen: false).fetchRoles();
      } else {
        debugPrint("❌ initState: Company ID is null. Cannot fetch details.");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final rolesProvider = Provider.of<RolesProvider>(context);
    final getAdduser = Provider.of<GetAdduserServiceCenterProvider>(context);
    final businessType = Provider.of<BusinessTypeProvider>(context);
    final companyDetails = Provider.of<CompanyDetailsProvider>(context);
    if (companyDetails.isLoading || businessType.isLoading) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: CircularProgressIndicator(
            strokeWidth: 2.5,
            color: AppColor().primariColor,
          ),
        ),
      );
    }

    if (companyDetails.errorMessage != null) {
      return Scaffold(body: Center(child: Text(companyDetails.errorMessage!)));
    }

    if (companyDetails.companyDetails == null) {
      return Scaffold(
        body: Center(child: Text("Could not load company info.")),
      );
    }

    final company_man = companyDetails.companyDetails!;
    final String businessTypeName =
        businessType.getBusinessTypeNameById(company_man.businessTypeId) ??
        'N/A';
    print("businessTypeName ${businessTypeName}");

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Organization info",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.edit, color: AppColor().primariColor),
                ),
              ],
            ),
            Row(
              children: [
                Text("Name : ", style: TextStyle(color: Colors.grey.shade600)),
                Text(
                  "${company_man.name}",
                  style: TextStyle(color: Colors.black),
                ),
              ],
            ),
            SizedBox(height: 15),
            Row(
              children: [
                Text(
                  "Address Line1 : ",
                  style: TextStyle(color: Colors.grey.shade600),
                ),
                Text(
                  "${company_man.addressLine1} ",
                  style: TextStyle(color: Colors.black),
                ),
              ],
            ),
            SizedBox(height: 15),
            Row(
              children: [
                Text(
                  "AddressLine2: ",
                  style: TextStyle(color: Colors.grey.shade600),
                ),
                Text(
                  "${company_man.addressLine2}",
                  style: TextStyle(color: Colors.black),
                ),
              ],
            ),
            SizedBox(height: 15),
            Row(
              children: [
                Text("Email: ", style: TextStyle(color: Colors.grey.shade600)),
                Text(
                  "${company_man.email}",
                  style: TextStyle(color: Colors.black),
                ),
              ],
            ),
            SizedBox(height: 15),
            Row(
              children: [
                Text("Phone : ", style: TextStyle(color: Colors.grey.shade600)),
                Text(
                  "${company_man.phone} ",
                  style: TextStyle(color: Colors.black),
                ),
              ],
            ),
            SizedBox(height: 15),
            Row(
              children: [
                Text(
                  "Business Type : ",
                  style: TextStyle(color: Colors.grey.shade600),
                ),
                Text(
                  "${companyDetails.companyDetails?.businessType?.name}",
                  style: TextStyle(color: Colors.black),
                ),
              ],
            ),
            SizedBox(height: 15),
            Row(
              children: [
                Text(
                  "Division : ",
                  style: TextStyle(color: Colors.grey.shade600),
                ),
                Text(
                  "${company_man.division?.name}",
                  style: TextStyle(color: Colors.black),
                ),
              ],
            ),
            SizedBox(height: 15),
            Row(
              children: [
                Text(
                  "District :",
                  style: TextStyle(color: Colors.grey.shade600),
                ),
                Text(
                  "${company_man.district?.name}",
                  style: TextStyle(color: Colors.black),
                ),
              ],
            ),
            SizedBox(height: 15),
            Row(
              children: [
                Text("Thana : ", style: TextStyle(color: Colors.grey.shade600)),
                Text(
                  "${company_man.thana?.name} ",
                  style: TextStyle(color: Colors.black),
                ),
              ],
            ),
            SizedBox(height: 15),
            Row(
              children: [
                Text("Area : -", style: TextStyle(color: Colors.grey.shade600)),
                Text(
                  "${company_man.area}",
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ],
            ),
            SizedBox(height: 30),

            //add user Button
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Service Man",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        _showDialogBox(context);
                      },
                      child: Container(
                        height: 35,
                        width: 110,
                        decoration: BoxDecoration(
                          color: AppColor().primariColor,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 18,
                              weight: 8,
                            ),
                            SizedBox(width: 5),
                            Center(
                              child: Text(
                                "Add User",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Name",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        "Role",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                        ),
                      ),

                      Text(
                        "Active",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                        ),
                      ),

                      Text(
                        "Action",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: 10),

            Expanded(
              child: Consumer<GetAdduserServiceCenterProvider>(
                builder: (context, getAddUser_Provider, child) {
                  if (getAddUser_Provider.isLoading &&
                      getAddUser_Provider.users.isEmpty) {
                    return Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: AppColor().primariColor,
                      ),
                    );
                  }

                  final userList = getAddUser_Provider.users;
                  if (userList.isEmpty) {
                    return Center(child: Text("No users found."));
                  }

                  return ListView.builder(
                    itemCount: userList.length,
                    itemBuilder: (context, index) {
                      final User = userList[index];

                      final String? userRoleId = User.roleId;
                      String roleName = 'N/A';

                      print("--- Checking User: ${User.name} ---");
                      print("User's Role ID: '$userRoleId'");

                      if (userRoleId != null &&
                          rolesProvider.roles.isNotEmpty) {
                        try {
                          final foundRole = rolesProvider.roles.firstWhere(
                            (role) => role.id == userRoleId,
                          );
                          roleName = foundRole.name ?? 'N/A';
                        } catch (e) {
                          roleName = 'Unknown Role';
                        }
                      }

                      return Container(
                        padding: EdgeInsets.all(8),
                        margin: EdgeInsets.symmetric(vertical: 2),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.white,
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 18,
                              backgroundColor: Colors.grey.shade400,
                              child: Icon(
                                Icons.person_outline_rounded,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(child: Text(User.name)),
                                  SizedBox(width: 20),
                                  Expanded(child: Text(roleName)),
                                  Expanded(
                                    child: Text(
                                      User.isActive == true ? "Yes" : "No",
                                    ),
                                  ),

                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      GestureDetector(
                                        onTap: () {},
                                        child: Text(
                                          "Edit",
                                          style: TextStyle(
                                            color: AppColor().scoenddaryColor,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      GestureDetector(
                                        onTap: () {},
                                        child: Text(
                                          "Delete",
                                          style: TextStyle(
                                            color: AppColor().scoenddaryColor,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDialogBox(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return SettingServiceCenterDialog();
      },
    );
  }
}
