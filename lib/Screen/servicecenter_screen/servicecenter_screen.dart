import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:serialno_app/Screen/servicecenter_screen/serviceCenter_widget/add_service_center_dialog/add_service_center_dialog.dart';
import 'package:serialno_app/Screen/servicecenter_screen/serviceCenter_widget/edit_service_center_dialog/edit_service_center_dialog.dart';
import 'package:serialno_app/providers/serviceCenter_provider/addButton_provider/deleteServiceCenter/delete_serviceCenter.dart';
import '../../global_widgets/custom_circle_progress_indicator/custom_circle_progress_indicator.dart';
import '../../global_widgets/custom_flushbar.dart';
import '../../global_widgets/custom_shimmer_list/CustomShimmerList .dart';
import '../../model/serviceCenter_model.dart';
import '../../model/user_model.dart';
import '../../providers/auth_provider/auth_providers.dart';
import '../../providers/profile_provider/getprofile_provider.dart';
import '../../providers/serviceCenter_provider/addButton_provider/get_AddButton_provider.dart';

import '../../utils/color.dart';

class ServicecenterScreen extends StatefulWidget {
  final User_Model? user;
  final ServiceCenterModel? serviceCenterModel;
  const ServicecenterScreen({super.key, this.user, this.serviceCenterModel});

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
        print("companyid-$companyId");
        debugPrint(
          " ServicecenterScreen: Company ID not found on init. Cannot fetch list.",
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<Getprofileprovider>(context);
    final companyId = profileProvider.profileData?.currentCompany.id;

    if (companyId == null) {
      return Scaffold(
        body: Center(child: CustomLoading(color: AppColor().primariColor)),
      );
    }

    final getAddButtonProvider = Provider.of<GetAddButtonProvider>(context);

    if (getAddButtonProvider.serviceCenterList.isEmpty &&
        !getAddButtonProvider.isLoading) {
      // Fetch once companyId is ready
      WidgetsBinding.instance.addPostFrameCallback((_) {
        getAddButtonProvider.fetchGetAddButton(companyId);
      });
    }
    return Form(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: getAddButtonProvider.isLoading
            ? CustomShimmerList(itemCount: 10)
            : Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 15,
                ),
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
                          _buildAddButton(context),
                        ],
                      ),
                      SizedBox(height: 10),
                      _buildServiceCenterList(),
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
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        bool isServiceTakerUser =
            authProvider.userType?.toLowerCase().trim() == "customer";

        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) =>
                Add_button_Dialog_serviceCenter_screen(),
            transitionsBuilder: (_, anim, __, child) {
              return FadeTransition(opacity: anim, child: child);
            },
            fullscreenDialog: true,
          ),
        );
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
            const SizedBox(width: 5),
            const Text(
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

  Widget _buildServiceCenterList() {
    final getAddButtonProvider = context.watch<GetAddButtonProvider>();

    if (getAddButtonProvider.isLoading) {
      return Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 50.0),
          child: CustomLoading(
            color: AppColor().primariColor,
            //size: 20,
            strokeWidth: 2.5,
          ),
        ),
      );
    }

    if (getAddButtonProvider.serviceCenterList.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 50.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.inbox_outlined, size: 60, color: Colors.grey.shade300),
              const SizedBox(height: 12),
              Text(
                'No Service Center Found',
                style: TextStyle(fontSize: 16, color: Colors.grey.shade300),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: getAddButtonProvider.serviceCenterList.length,
      itemBuilder: (context, index) {
        final serviceCenter = getAddButtonProvider.serviceCenterList[index];

        return Container(
          margin: const EdgeInsets.symmetric(vertical: 2),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  serviceCenter.name ?? "NO Name",
                  style: TextStyle(
                    color: AppColor().primariColor,
                    fontSize: 18,
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            serviceCenter.hotlineNo ?? "No HotlineNo",
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                            ),
                          ),
                          Text(
                            serviceCenter.email ?? "No Email",
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        final authProvider = Provider.of<AuthProvider>(
                          context,
                          listen: false,
                        );

                        bool isServiceTakerUser =
                            authProvider.userType?.toLowerCase().trim() ==
                            "customer";
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (_, __, ___) =>
                                EditServiceCenterDialog(
                                  showAppBar: true,
                                  showBottomNavBar: true,
                                  isServiceTaker: isServiceTakerUser,
                                  serviceCenter: serviceCenter,
                                ),
                            transitionsBuilder: (_, anim, __, child) {
                              return FadeTransition(
                                opacity: anim,
                                child: child,
                              );
                            },
                            fullscreenDialog: true,
                          ),
                        );

                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => EditServiceCenterDialog(
                        //       showAppBar: true,
                        //       showBottomNavBar: true,
                        //       isServiceTaker: isServiceTakerUser,
                        //       serviceCenter: serviceCenter,
                        //     ),
                        //   ),
                        // );
                      },
                      child: Text(
                        "Edit",
                        style: TextStyle(
                          color: AppColor().scoenddaryColor,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Builder(
                      builder: (BuildContext menuContext) {
                        return GestureDetector(
                          onTap: () => _showDeleteConfirmationMenu(
                            menuContext,
                            serviceCenter,
                          ),
                          child: Text(
                            "Delete",
                            style: TextStyle(
                              color: AppColor().scoenddaryColor,
                              fontSize: 15,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showDeleteConfirmationMenu(
    BuildContext menuContext,
    ServiceCenterModel serviceCenterModel,
  ) {
    // menuContext
    final RenderBox renderBox = menuContext.findRenderObject() as RenderBox;
    final Offset offset = renderBox.localToGlobal(Offset.zero);
    final Size size = renderBox.size;

    final companyId = Provider.of<Getprofileprovider>(
      context,
      listen: false,
    ).profileData?.currentCompany.id;
    final deleteProvider = Provider.of<DeleteServiceCenterProvider>(
      context,
      listen: false,
    );
    final getAddButtonProvider = Provider.of<GetAddButtonProvider>(
      context,
      listen: false,
    );
    final String serviceCenterIdToDelete = serviceCenterModel.id;
    showMenu<bool>(
      context: menuContext,
      color: Colors.white,
      elevation: 8.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      position: RelativeRect.fromLTRB(
        offset.dx,
        offset.dy + size.height * -5, // Top
        offset.dx + size.width, // Right
        offset.dy + size.height, // Bottom
      ),
      items: [
        PopupMenuItem(
          // value: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.warning_rounded, color: Colors.orange, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    "Confirmation",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                "Are you sure to delete?",
                style: TextStyle(color: Colors.grey.shade800, fontSize: 15),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(menuContext).pop(false);
                    },
                    child: Container(
                      height: 30,
                      width: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey.shade400),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Center(
                        child: Text(
                          "No",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () async {
                      Navigator.of(menuContext).pop(true);
                      if (companyId == null) return;

                      final success = await deleteProvider.delete_serviceCenter(
                        companyId,
                        serviceCenterIdToDelete,
                      );
                      if (mounted && success) {
                        await getAddButtonProvider.fetchGetAddButton(companyId);
                        CustomFlushbar.showSuccess(
                          context: context,
                          message: "User deleted successfully.",
                          title: 'Success',
                        );
                      } else if (mounted) {
                        CustomFlushbar.showSuccess(
                          context: context,
                          message:
                              deleteProvider.errorMessage ??
                              "Failed to delete user.",
                          title: 'Failed',
                        );
                      }
                    },
                    child: Container(
                      height: 30,
                      width: 50,
                      decoration: BoxDecoration(
                        color: AppColor().primariColor,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Center(
                        child: Text(
                          "Yes",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ).then((value) {
      if (value == true) {
        print("Delete confirmed!");
      } else {
        print("Delete canceled.");
      }
    });
  }
}
