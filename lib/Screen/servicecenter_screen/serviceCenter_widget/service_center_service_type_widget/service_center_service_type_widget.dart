import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:serialno_app/Screen/servicecenter_screen/serviceCenter_widget/add_service_center_service_type_dialog/add_service_center_service_type_dialog.dart';
import 'package:serialno_app/Screen/servicecenter_screen/serviceCenter_widget/update_service_center_service_type_dialog/update_service_center_service_type_dialog.dart';

import '../../../../global_widgets/custom_circle_progress_indicator/custom_circle_progress_indicator.dart';
import '../../../../global_widgets/custom_dropdown/custom_dropdown.dart';
import '../../../../global_widgets/custom_flushbar.dart';
import '../../../../model/serviceCenter_model.dart';
import '../../../../model/service_type_model.dart';
import '../../../../providers/profile_provider/getprofile_provider.dart';
import '../../../../providers/serviceCenter_provider/addButtonServiceType_Provider/deleteServiceTypeProvider/deleteServiceTypeProvider.dart';
import '../../../../providers/serviceCenter_provider/addButtonServiceType_Provider/getAddButtonServiceType.dart';
import '../../../../providers/serviceCenter_provider/addButton_provider/get_AddButton_provider.dart';
import '../../../../providers/serviceCenter_provider/delete_service_type_service_type_provider/delete_service_type_service_type_provider.dart';
import '../../../../providers/serviceCenter_provider/get_serviceCenter_serviceType_provider/get_service_center_service_type_provider.dart';
import '../../../../utils/color.dart';

class service_center_service_type_widget extends StatefulWidget {
  const service_center_service_type_widget({super.key});

  @override
  State<service_center_service_type_widget> createState() =>
      _service_center_service_type_widgetState();
}

class _service_center_service_type_widgetState
    extends State<service_center_service_type_widget> {
  serviceTypeModel? _selectedServiceType;
  ServiceCenterModel? _selectedServiceCenter;
  List<ServiceCenterModel> serviceCenterList = [];

  @override
  void initState() {
    super.initState();
    final getProfileProvider = Provider.of<Getprofileprovider>(
      context,
      listen: false,
    );
    final companyId = getProfileProvider.profileData?.currentCompany.id;
    // Use a Future.delayed or addPostFrameCallback to ensure provider is ready
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final getAddButtonProvider = Provider.of<GetAddButtonProvider>(
        context,
        listen: false,
      );
      await getAddButtonProvider.fetchGetAddButton(companyId!);
      // Set the first service center as selected after data is fetched
      if (getAddButtonProvider.serviceCenterList.isNotEmpty) {
        setState(() {
          _selectedServiceCenter = getAddButtonProvider.serviceCenterList.first;
          // Also fetch service types for the initially selected service center
          Provider.of<get_service_center_service_type_provider>(
            context,
            listen: false,
          ).fetch_service_center_service_type(_selectedServiceCenter!.id!);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final serviceCenterProvider = Provider.of<GetAddButtonProvider>(context);
    final String? serviceTypeId = _selectedServiceType?.id;
    final secondGetServiceType =
        Provider.of<get_service_center_service_type_provider>(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Service Center`s Service Type",
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 47,
                  child: CustomDropdown<ServiceCenterModel>(
                    selectedItem: _selectedServiceCenter,
                    items: serviceCenterProvider.serviceCenterList,
                    onChanged: (ServiceCenterModel? newValue) {
                      setState(() {
                        _selectedServiceCenter = newValue;
                        if (_selectedServiceCenter != null) {
                          // Fetch service types for the newly selected service center
                          Provider.of<get_service_center_service_type_provider>(
                            context,
                            listen: false,
                          ).fetch_service_center_service_type(
                            _selectedServiceCenter!.id!,
                          );
                        } else {
                          // Clear the list if no service center is selected
                          Provider.of<get_service_center_service_type_provider>(
                            context,
                            listen: false,
                          ).clearData(); // You'll need to add this method to your provider
                        }
                      });
                    },
                    itemAsString: (ServiceCenterModel item) => item.name ?? "",

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
                          serviceCenterProvider.isLoading
                              ? CustomLoading(
                                  strokeWidth: 2.5,
                                  color: AppColor().primariColor,
                                  size: 20,
                                )
                              : Text(
                                  _selectedServiceCenter == null
                                      ? "Select Service Center"
                                      : _selectedServiceCenter!.name ?? "",
                                  style: TextStyle(
                                    color: _selectedServiceCenter != null
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
              ),
              SizedBox(width: 5),

              GestureDetector(
                onTap: () {
                  // Second ServiceType add Button
                  _SecondShowDialogBox(context);
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
              ),
            ],
          ),
          SizedBox(height: 10),
          secondGetServiceType.isLoading
              ? Center(
                  child: CustomLoading(
                    color: AppColor().primariColor,
                    strokeWidth: 2.5,
                  ),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount:
                      secondGetServiceType.serviceTypesOfSelectedCenter.length,
                  itemBuilder: (context, index) {
                    final serviceType = secondGetServiceType
                        .serviceTypesOfSelectedCenter[index];
                    return Container(
                      margin: EdgeInsets.symmetric(vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${serviceType.name}",
                              style: TextStyle(
                                color: AppColor().primariColor,
                                fontSize: 18,
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  "${serviceType.price} BDT",
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
                                          serviceType,
                                        );
                                      },
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
                                    Builder(
                                      builder: (BuildContext context) {
                                        return GestureDetector(
                                          onTap: () {
                                            _showDeleteConfirmationMenu(
                                              context,
                                              serviceType,
                                              _selectedServiceCenter!,
                                            );
                                          },
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
                            Text(
                              "${serviceType.defaultAllocatedTime} Minutes",
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
    );
  }

  //service type add_dialog box
  void _SecondShowDialogBox(BuildContext context) {
    if (_selectedServiceCenter != null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return add_service_center_service_type_dialog(
            selectedServiceCenter:
                _selectedServiceCenter, // Pass the selected model here
          );
        },
      );
    } else {
      // Optionally show a message if no service center is selected
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select a Service Center first.")),
      );
    }
  }

  //service type Edit dialogBox
  void _showDialogBoxEDIT(
    BuildContext context,
    serviceTypeModel serviceTypeModel,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return update_servive_center_service_type_dialog(
          serviceType_model: serviceTypeModel,
          selectedServiceCenter: _selectedServiceCenter,
        );
      },
    );
  }

  void _showDeleteConfirmationMenu(
    BuildContext menuContext,
    serviceTypeModel typeModel,
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
    final deleteProvider = Provider.of<DeleteServiceTypeServiceTypeProvider>(
      context,
      listen: false,
    );

    final get_addButton = Provider.of<get_service_center_service_type_provider>(
      context,
      listen: false,
    );

    final String ServiceTypeId = typeModel.id;
    final String ServiceCenterId = serviceCenterModel.id;

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
                  SizedBox(width: 8),
                  Text(
                    "Confirmation",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Text(
                "Are you sure to delete?",
                style: TextStyle(color: Colors.grey.shade800, fontSize: 15),
              ),
              SizedBox(height: 8),
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
                  SizedBox(width: 8),
                  GestureDetector(
                    onTap: () async {
                      Navigator.of(menuContext).pop(true);

                      final success = await deleteProvider
                          .delete_ServiceCenter_serviceType(
                            ServiceCenterId,
                            ServiceTypeId,
                          );
                      if (mounted && success) {
                        await get_addButton.fetch_service_center_service_type(
                          ServiceCenterId,
                        );
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
