import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:serialno_app/Screen/servicecenter_screen/serviceCenter_widget/add_service_center_dialog/add_service_center_dialog.dart';
import 'package:serialno_app/Screen/servicecenter_screen/serviceCenter_widget/edit_service_center_dialog/edit_service_center_dialog.dart';
import '../../model/serviceCenter_model.dart';
import '../../model/user_model.dart';
import '../../providers/profile_provider/getprofile_provider.dart';
import '../../providers/serviceCenter_provider/addButton_provider/get_AddButton_provider.dart';

import '../../utils/color.dart';

class ServicecenterScreen extends StatefulWidget {
  final User_Model? user;
  const ServicecenterScreen({super.key, this.user});

  @override
  State<ServicecenterScreen> createState() => _ServicecenterScreenState();
}

class _ServicecenterScreenState extends State<ServicecenterScreen>
    with SingleTickerProviderStateMixin {
  Businesstype? _userBusinessType;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final profileProvider = Provider.of<Getprofileprovider>(
        context,
        listen: false,
      );
      final companyId = profileProvider.profileData?.currentCompany.id;

      if (companyId != null && companyId.isNotEmpty) {
        Provider.of<GetAddButtonProvider>(
          context,
          listen: false,
        ).fetchGetAddButton(companyId);
      } else {
        debugPrint(
          "❌ ServicecenterScreen: Company ID not found on init. Cannot fetch list.",
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final getprofile = Provider.of<Getprofileprovider>(context);
    final profile = getprofile.profileData;
    final getAddButtonProvider = Provider.of<GetAddButtonProvider>(context);
    final bool shouldShowAddButton =
        profile?.currentCompany.businessTypeId == 1;

    debugPrint("--- ServiceCenterScreen Build ---");
    if (profile != null) {
      debugPrint("  -> Company Name: ${profile.currentCompany.name}");
      debugPrint(
        "  -> Business Type ID: ${profile.currentCompany.businessTypeId}",
      );
      debugPrint("  -> Should Show Add Button: $shouldShowAddButton");
    }

    return Form(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // create add button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Service Center",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (shouldShowAddButton) _buildAddButton(context),
                  ],
                ),
                SizedBox(height: 10),
                getAddButtonProvider.isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                          color: AppColor().primariColor,
                          strokeWidth: 2.5,
                        ),
                      )
                    : getAddButtonProvider.serviceCenterList.isEmpty
                    ? Center(child: Text("No Service Center Found."))
                    : ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount:
                            getAddButtonProvider.serviceCenterList.length,
                        itemBuilder: (context, index) {
                          final serviceCenter =
                              getAddButtonProvider.serviceCenterList[index];
                          return Container(
                            margin: EdgeInsets.symmetric(vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: ListTile(
                              title: Text(
                                serviceCenter.name ?? "NO Name",
                                style: TextStyle(
                                  color: AppColor().primariColor,
                                  fontSize: 18,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    serviceCenter.hotlineNo ?? "No HotlineNo",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                    ),
                                  ),
                                  Text(
                                    serviceCenter.email ?? "No Email",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),

                              trailing: GestureDetector(
                                onTap: () {
                                  _showDialogBoxEDIT(context, serviceCenter);
                                },
                                child: Text(
                                  "Edit",
                                  style: TextStyle(
                                    color: AppColor().scoenddaryColor,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ///  Correct Widget return type for Add Button
  Widget _buildAddButton(BuildContext context) {
    final getAddButtonProvider = Provider.of<GetAddButtonProvider>(
      context,
      listen: false,
    );
    return GestureDetector(
      onTap: () {
        _showDialogBox(context, getAddButtonProvider);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        decoration: BoxDecoration(
          color: AppColor().primariColor,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          children: [
            Icon(Icons.add, color: Colors.white, size: 15),
            SizedBox(width: 5),
            Text(
              "Add",
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDialogBox(
    BuildContext context,
    GetAddButtonProvider getAddButtonProvider,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return const AddServiceCenterDialog();
      },
    );
  }

  void _showDialogBoxEDIT(
    BuildContext context,
    ServiceCenterModel serviceCenter,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return EditServiceCenterDialog(serviceCenter: serviceCenter);
      },
    );
  }
}
