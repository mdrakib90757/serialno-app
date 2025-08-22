import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:serialno_app/Screen/servicecenter_screen/serviceCenter_widget/add_service_type_dialog/add_service_type_dialog.dart';
import 'package:serialno_app/Screen/servicecenter_screen/serviceCenter_widget/edit_service_type_dialog/edit_service_type_dialog.dart';
import 'package:serialno_app/Widgets/custom_flushbar.dart';
import 'package:serialno_app/Widgets/custom_labeltext.dart';
import 'package:serialno_app/Widgets/custom_sanckbar.dart';
import 'package:serialno_app/Widgets/custom_textfield.dart';
import 'package:serialno_app/model/service_type_model.dart';
import 'package:serialno_app/providers/auth_provider/auth_providers.dart';
import 'package:serialno_app/providers/profile_provider/getprofile_provider.dart';
import 'package:serialno_app/providers/serviceCenter_provider/addButtonServiceType_Provider/addButtonServiceType_Provider.dart';
import 'package:serialno_app/providers/serviceCenter_provider/addButtonServiceType_Provider/getAddButtonServiceType.dart';
import 'package:serialno_app/providers/serviceCenter_provider/editButtonServiceType_provider/editButtonServiceType_provider.dart';
import 'package:serialno_app/providers/serviceCenter_provider/editButtonServiceType_provider/getEditButtonServiceType_Provider.dart';
import 'package:serialno_app/request_model/serviceCanter_request/addButton_serviceType_request/addButtonServiceType_request.dart';
import 'package:serialno_app/request_model/serviceCanter_request/editButtonServiceType_request/editButtonServiceType_reqeust.dart';
import 'package:serialno_app/utils/color.dart';

class ServicetypeScreen extends StatefulWidget {
  const ServicetypeScreen({super.key});

  @override
  State<ServicetypeScreen> createState() => _ServicetypeScreenState();
}

class _ServicetypeScreenState extends State<ServicetypeScreen> {
  final GlobalKey _deleteButtonKey = GlobalKey();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialData();
    });
  }

  Future<void> _loadInitialData() async {
    final profileProvider = context.read<Getprofileprovider>();
    final serviceTypeProvider = context
        .read<GetAddButtonServiceType_Provider>();

    if (profileProvider.profileData == null) {
      await profileProvider.fetchProfileData();
    }
    final companyId = profileProvider.profileData?.currentCompany.id;
    if (mounted && companyId != null) {
      await serviceTypeProvider.fetchGetAddButton_ServiceType(companyId);
    } else {
      if (mounted) {
        debugPrint("❌ Error in ServicetypeScreen: Could not find Company ID.");
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // create add button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
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
            serviceTypeProvider.isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      color: AppColor().primariColor,
                      strokeWidth: 2.5,
                    ),
                  )
                : serviceTypeProvider.serviceTypeList.isEmpty
                ? Center(child: Text("No ServiceType Founds"))
                : Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: serviceTypeProvider.serviceTypeList.length,
                      itemBuilder: (context, index) {
                        final type = serviceTypeProvider.serviceTypeList[index];
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
                                            _showDialogBoxEDIT(context, type);
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
                                            // Builder ব্যবহার করে সঠিক context নিশ্চিত করুন
                                            return GestureDetector(
                                              onTap: () {
                                                _showDeleteConfirmationMenu(
                                                  context,
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
                  ),
          ],
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

  void _showDeleteConfirmationMenu(BuildContext menuContext) {
    // menuContext
    final RenderBox renderBox = menuContext.findRenderObject() as RenderBox;
    final Offset offset = renderBox.localToGlobal(Offset.zero);
    final Size size = renderBox.size;

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
                    onTap: () {
                      Navigator.of(menuContext).pop(true);
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
