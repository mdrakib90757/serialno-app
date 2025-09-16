import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:serialno_app/Screen/servicecenter_screen/serviceCenter_widget/add_service_type_dialog/add_service_type_dialog.dart';
import 'package:serialno_app/Screen/servicecenter_screen/serviceCenter_widget/edit_service_type_dialog/edit_service_type_dialog.dart';
import 'package:serialno_app/Screen/servicecenter_screen/serviceCenter_widget/service_center_service_type_widget/service_center_service_type_widget.dart';
import 'package:serialno_app/model/service_type_model.dart';
import 'package:serialno_app/providers/profile_provider/getprofile_provider.dart';
import 'package:serialno_app/providers/serviceCenter_provider/addButtonServiceType_Provider/deleteServiceTypeProvider/deleteServiceTypeProvider.dart';
import 'package:serialno_app/providers/serviceCenter_provider/addButtonServiceType_Provider/getAddButtonServiceType.dart';
import 'package:serialno_app/utils/color.dart';
import '../../global_widgets/custom_circle_progress_indicator/custom_circle_progress_indicator.dart';
import '../../global_widgets/custom_dropdown/custom_dropdown.dart';
import '../../global_widgets/custom_flushbar.dart';
import '../../global_widgets/custom_shimmer_list/CustomShimmerList .dart';
import '../../model/serviceCenter_model.dart';
import '../../providers/serviceCenter_provider/addButton_provider/get_AddButton_provider.dart';
import '../../providers/serviceCenter_provider/get_serviceCenter_serviceType_provider/get_service_center_service_type_provider.dart';

class ServicetypeScreen extends StatefulWidget {
  const ServicetypeScreen({super.key});

  @override
  State<ServicetypeScreen> createState() => _ServicetypeScreenState();
}

class _ServicetypeScreenState extends State<ServicetypeScreen> {
  final GlobalKey _deleteButtonKey = GlobalKey();
  serviceTypeModel? _selectedServiceType;
  ServiceCenterModel? _selectedServiceCenter;
  List<ServiceCenterModel> serviceCenterList = [];
  bool _isScreenLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialData();
    });
  }

  Future<void> _loadInitialData() async {
    if (mounted) {
      setState(() {
        _isScreenLoading = true;
      });
    }
    final profileProvider = context.read<Getprofileprovider>();
    final serviceTypeProvider = context
        .read<GetAddButtonServiceType_Provider>();
    final serviceCenterProvider = context.read<GetAddButtonProvider>();

    if (profileProvider.profileData == null) {
      await profileProvider.fetchProfileData();
    }
    final companyId = profileProvider.profileData?.currentCompany.id;
    if (mounted && companyId != null) {
      await Future.wait([
        serviceTypeProvider.fetchGetAddButton_ServiceType(companyId),
        serviceCenterProvider.fetchGetAddButton(companyId),
      ]);
      if (mounted && serviceCenterProvider.serviceCenterList.isNotEmpty) {
        setState(() {
          _selectedServiceCenter =
              serviceCenterProvider.serviceCenterList.first;
        });
      }
    } else {
      if (mounted) {
        debugPrint(" Error in ServicetypeScreen: Could not find Company ID.");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final serviceTypeProvider = Provider.of<GetAddButtonServiceType_Provider>(
      context,
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: serviceTypeProvider.isLoading
          ? CustomShimmerList(itemCount: 10)
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // create add button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Service Type",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            //add Button
                            _showDialogBox(context);
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 7,
                            ),
                            decoration: BoxDecoration(
                              color: AppColor().primariColor,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.add, color: Colors.white, size: 15),
                                SizedBox(width: 5),
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
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    serviceTypeProvider.serviceTypeList.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.inbox_outlined,
                                  size: 60,
                                  color: Colors.grey.shade300,
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'No Service Type Found',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[300],
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            // scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount:
                                serviceTypeProvider.serviceTypeList.length + 1,
                            itemBuilder: (context, index) {
                              if (index >=
                                  serviceTypeProvider.serviceTypeList.length) {
                                return service_center_service_type_widget();
                              }
                              final type =
                                  serviceTypeProvider.serviceTypeList[index];
                              return Container(
                                margin: EdgeInsets.symmetric(vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                    color: Colors.grey.shade300,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        type.name ?? "N/A",
                                        style: TextStyle(
                                          color: AppColor().primariColor,
                                          fontSize: 18,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "${type.price.toString()} BDT",
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 15,
                                            ),
                                          ),
                                          Spacer(),
                                          Row(
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  _showDialogBoxEDIT(
                                                    context,
                                                    type,
                                                  );
                                                },
                                                child: Text(
                                                  "Edit",
                                                  style: TextStyle(
                                                    color: AppColor()
                                                        .scoenddaryColor,
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              Builder(
                                                builder: (BuildContext context) {
                                                  return GestureDetector(
                                                    onTap: () {
                                                      _showDeleteConfirmationMenu(
                                                        context,
                                                        type,
                                                      );
                                                    },
                                                    child: Text(
                                                      "Delete",
                                                      style: TextStyle(
                                                        color: AppColor()
                                                            .scoenddaryColor,
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
                                      Text(
                                        "${type.defaultAllocatedTime.toString()} Minutes",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ],
                ),
              ),
            ),
    );
  }

  //service type add_dialog box
  void _showDialogBox(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AddServiceTypeDialog();
      },
    );
  }

  //service type Edit dialogBox
  void _showDialogBoxEDIT(
    BuildContext context,
    serviceTypeModel serviceTypeModel,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return EditServiceTypeDialog(serviceType_model: serviceTypeModel);
      },
    );
  }

  void _showDeleteConfirmationMenu(
    BuildContext menuContext,
    serviceTypeModel typeModel,
  ) {
    // menuContext
    final RenderBox renderBox = menuContext.findRenderObject() as RenderBox;
    final Offset offset = renderBox.localToGlobal(Offset.zero);
    final Size size = renderBox.size;
    final companyId = Provider.of<Getprofileprovider>(
      context,
      listen: false,
    ).profileData?.currentCompany.id;
    final deleteProvider = Provider.of<DeleteServiceTypeProvider>(
      context,
      listen: false,
    );
    final getAddButtonServiceType =
        Provider.of<GetAddButtonServiceType_Provider>(context, listen: false);
    final String ServiceTypeId = typeModel.id;

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
                  const Text(
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
                      final success = await deleteProvider.delete_serviceType(
                        companyId,
                        ServiceTypeId,
                      );
                      if (mounted && success) {
                        await getAddButtonServiceType
                            .fetchGetAddButton_ServiceType(companyId);
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
