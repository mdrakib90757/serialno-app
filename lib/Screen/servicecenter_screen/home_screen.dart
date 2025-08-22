import 'dart:async';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:serialno_app/Screen/servicecenter_screen/serviceCenter_widget/new_serial_button_dialog/new_serial_button_dialog.dart';
import 'package:serialno_app/Widgets/custom_dropdown/custom_dropdown.dart';
import 'package:serialno_app/providers/serviceCenter_provider/nextButton_provider/nextButton_provider.dart';
import 'package:serialno_app/request_model/serviceCanter_request/newSerialButton_request/newSerialButton_request.dart';
import 'package:serialno_app/utils/date_formatter/date_formatter.dart';
import '../../Widgets/custom_flushbar.dart';
import '../../Widgets/custom_labeltext.dart';
import '../../Widgets/custom_sanckbar.dart';
import '../../Widgets/custom_tabbar.dart';
import '../../Widgets/custom_textfield.dart';
import '../../model/serialService_model.dart';
import '../../model/serviceCenter_model.dart';
import '../../model/service_type_model.dart';
import '../../providers/auth_provider/auth_providers.dart';
import '../../providers/profile_provider/getprofile_provider.dart';
import '../../providers/serviceCenter_provider/addButtonServiceType_Provider/getAddButtonServiceType.dart';
import '../../providers/serviceCenter_provider/addButton_provider/get_AddButton_provider.dart';
import '../../providers/serviceCenter_provider/newSerialButton_provider/getNewSerialButton_provider.dart';
import '../../providers/serviceCenter_provider/newSerialButton_provider/newSerialProvider.dart';
import '../../utils/color.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  String _FormatedDateTime = "";
  Timer? _timer;
  ServiceCenterModel? _selectedServiceCenter;
  DateTime _selectedDate = DateTime.now();

  //TabBar List
  final List<String> tabList = ["Queue", "Served "];
  int indexNo = 0;
  late TabController tabController;

  void _fetchDataForUI() {
    if (_selectedServiceCenter != null) {
      debugPrint(
        "🚀 FETCHING SERIALS for Service Center ID: ${_selectedServiceCenter!.id!}",
      );

      final formattedDate = DateFormatter.formatForApi(_selectedDate);

      Provider.of<GetNewSerialButtonProvider>(
        context,
        listen: false,
      ).fetchSerialsButton(_selectedServiceCenter!.id!, formattedDate);
    } else {
      debugPrint(
        "⚠️ _fetchDataForUI called but _selectedServiceCenter is null.",
      );
    }
  }

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: tabList.length, vsync: this);
    _updateTime();
    _timer = Timer.periodic(Duration(seconds: 1), (Timer t) => _updateTime());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initialDataLoad();
    });
  }

  Future<void> _initialDataLoad() async {
    final profileProvider = context.read<Getprofileprovider>();
    final addButtonProvider = context.read<GetAddButtonProvider>();
    final serviceTypeProvider = context
        .read<GetAddButtonServiceType_Provider>();

    await profileProvider.fetchProfileData();
    final companyId = profileProvider.profileData?.currentCompany.id;

    if (mounted && companyId != null) {
      debugPrint("✅ Using Company ID for fetching data: $companyId");

      await Future.wait([
        addButtonProvider.fetchGetAddButton(companyId),
        serviceTypeProvider.fetchGetAddButton_ServiceType(companyId),
      ]);

      final serviceCenters = addButtonProvider.serviceCenterList;
      if (mounted && serviceCenters.isNotEmpty) {
        setState(() {
          _selectedServiceCenter = serviceCenters.first;
        });
        debugPrint(
          "✅ INITIAL LOAD: Automatically selected Service Center ID: ${_selectedServiceCenter?.id}",
        );
        _fetchDataForUI();
      }
    } else {
      if (mounted) {
        debugPrint("❌ Error in HomeScreen: Could not find Company ID.");
      }
    }
  }

  void _updateTime() {
    final DateTime now = DateTime.now();
    final String formatted = DateFormat('EEEE, dd MMMM,\nyyyy ').format(now);
    setState(() {
      _FormatedDateTime = formatted;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    tabController.dispose();
    super.dispose();
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final getProfile = Provider.of<Getprofileprovider>(context, listen: false);
    final profile = getProfile.profileData;
    final bool shouldShowAddButton =
        profile?.currentCompany.businessTypeId == 1;
    final getAddButtonProvider = Provider.of<GetAddButtonProvider>(
      context,
      listen: false,
    );
    ServiceCenterModel? defaultSelectItem;
    if (getAddButtonProvider.serviceCenterList.isNotEmpty) {
      defaultSelectItem = getAddButtonProvider.serviceCenterList.first;
    }

    if (profile == null || profile.currentCompany.name.isEmpty) {
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
    final company = profile.currentCompany;
    final Timedate = _FormatedDateTime;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              company.name,
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  Timedate,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                //Serial Button
                GestureDetector(
                  onTap: () async {
                    final NewSerialButton =
                        Provider.of<NewSerialButtonProvider>(
                          context,
                          listen: false,
                        );

                    if (_selectedServiceCenter == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "Please select a service center first.",
                          ),
                        ),
                      );
                      return;
                    }
                    final bool? wasSuccessful = await showDialog<bool?>(
                      context: context,
                      builder: (context) {
                        return NewSerialButtonDialog(
                          serviceCenterModel: _selectedServiceCenter!,
                        );
                      },
                    );

                    if (mounted) {
                      if (wasSuccessful == true) {
                        await CustomFlushbar.showSuccess(
                          context: context,
                          title: "Success",
                          message: "New serial has been booked successfully.",
                        );

                        _fetchDataForUI();
                      } else if (wasSuccessful == false) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            elevation: 0,
                            backgroundColor: Colors.transparent,
                            behavior: SnackBarBehavior.floating,
                            content: CustomSnackBarWidget(
                              title: "Error",
                              message:
                                  NewSerialButton.errorMessage ??
                                  "Failed to create new serial. Please try again.",
                            ),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Please select a service center first.",
                            ),
                          ),
                        );
                      }
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColor().primariColor,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 7,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add, color: Colors.white, size: 15),
                          SizedBox(width: 5),
                          Text(
                            "New Serial",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                //NextButton
                GestureDetector(
                  onTap: () async {
                    final nextButton = Provider.of<nextButtonProvider>(
                      context,
                      listen: false,
                    );
                    final serialListProvider =
                        Provider.of<GetNewSerialButtonProvider>(
                          context,
                          listen: false,
                        );

                    final String? serviceCenterId = _selectedServiceCenter?.id;
                    final String formattedDate = DateFormat(
                      'yyyy-MM-dd',
                    ).format(_selectedDate);
                    final bool success = await nextButton.NextButton(
                      serviceCenterId: serviceCenterId ?? "",
                      date: formattedDate,
                    );

                    if (serviceCenterId == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Please select a service center."),
                        ),
                      );
                      return;
                    }

                    if (success && mounted) {
                      debugPrint(
                        "✅ Next button action successful. Refreshing list...",
                      );
                      await serialListProvider.fetchSerialsButton(
                        serviceCenterId!,
                        formattedDate,
                      );
                    } else if (mounted) {
                      debugPrint("❌ Next button action failed.");
                      final errorMessage =
                          nextButtonProvider().errorMessage ??
                          "An unknown error occurred.";

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          elevation: 0,
                          backgroundColor: Colors.transparent,
                          behavior: SnackBarBehavior.floating,
                          content: CustomSnackBarWidget(
                            title: "Error",
                            message: errorMessage,
                          ),
                        ),
                      );
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 7),

                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: AppColor().primariColor,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: Text(
                            "Next",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                          size: 15,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            if (shouldShowAddButton) ...[
              Container(
                height: 55,
                child: CustomDropdown(
                  items: Provider.of<GetAddButtonProvider>(
                    context,
                  ).serviceCenterList,
                  onChanged: (ServiceCenterModel? newvalue) {
                    debugPrint(
                      "🔄 DROPDOWN CHANGED: User selected Service Center ID: ${newvalue?.id}",
                    );
                    setState(() {
                      _selectedServiceCenter = newvalue;
                    });
                    _fetchDataForUI();
                  },
                  itemAsString: (ServiceCenterModel item) =>
                      item.name ?? "No Name",
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
                          _selectedServiceCenter?.name ??
                              "Select Service Center",
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
            ],
            TabBar(
              controller: tabController,
              indicatorSize: TabBarIndicatorSize.tab,
              unselectedLabelColor: Colors.grey.shade600,
              labelColor: AppColor().primariColor,
              labelStyle: TextStyle(fontWeight: FontWeight.w500),
              indicatorColor: AppColor().primariColor,
              tabs: [
                Tab(text: "Queue"),
                Tab(text: "Served"),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: tabController,
                children: [_buildQueueList(), _buildServedList()],
              ),
            ),
          ],
        ),
      ),
    );
  }

  //Status DialogBox
  void _showDialogBoxManage(SerialModel serial) {
    final String? serviceCenterId = _selectedServiceCenter?.id;
    final String? serviceId = serial.id;

    if (serviceCenterId == null || serviceId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Error: ID is missing!")));
      return;
    }

    debugPrint("✅ Opening Manage Dialog with:");
    debugPrint("   - Service Center ID: $serviceCenterId");
    debugPrint("   - Service (Serial) ID: $serviceId");

    final String formattedDate = DateFormatter.formatForApi(_selectedDate);

    showDialog<bool?>(
      context: context,
      builder: (context) {
        return ManageSerialDialog(
          initialStatus: serial.status ?? "",
          serviceCenterId: serviceCenterId,
          serviceId: serviceId,
          date: formattedDate,
        );
      },
    ).then((wasSuccessful) {
      if (mounted) {
        if (wasSuccessful == true) {
          debugPrint("✅ Dialog returned success. Refreshing UI...");
          _fetchDataForUI();
        }
      }
    });
  }

  Widget _buildQueueList() {
    return Consumer<GetNewSerialButtonProvider>(
      builder: (context, serialProvider, child) {
        if (serialProvider.isLoading) {
          return Center(
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              color: AppColor().primariColor,
            ),
          );
        }
        final queueList = serialProvider.queueSerials;
        if (queueList.isEmpty) {
          return const Center(child: Text("No items in the queue."));
        }
        return ListView.builder(
          itemCount: queueList.length,
          itemBuilder: (context, index) {
            final serial = queueList[index];
            final String displayTime = DateFormatter.formatApiTimeToDisplayTime(
              serial.date,
            );
            return Container(
              margin: EdgeInsets.symmetric(vertical: 5),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      "${serial.serialNo}.",
                      style: TextStyle(
                        color: AppColor().primariColor,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.grey.shade500,
                    radius: 22,
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              serial.name ?? "N/A",
                              style: TextStyle(
                                color: AppColor().primariColor,
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            GestureDetector(
                              onTap: () async {
                                _showDialogBoxManage(serial);
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 5),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Center(
                                  child: Text(
                                    serial.status.toString(),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: AppColor.getStatusColor(
                                        serial.status,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(displayTime),
                            Text(displayTime, style: TextStyle(fontSize: 10)),
                          ],
                        ),
                        Text(serial.serviceType!.name.toString()),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // HomeScreen.dart
  Widget _buildServedList() {
    return Consumer<GetNewSerialButtonProvider>(
      builder: (context, serialProvider, child) {
        if (serialProvider.isLoading) {
          return Center(
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              color: AppColor().primariColor,
            ),
          );
        }

        final servedList = serialProvider.servedSerials;

        if (servedList.isEmpty) {
          return const Center(child: Text("No items have been served yet."));
        }

        return ListView.builder(
          itemCount: servedList.length,
          itemBuilder: (context, index) {
            final serial = servedList[index];
            final String displayTime = DateFormatter.formatApiTimeToDisplayTime(
              serial.date,
            );
            return Container(
              margin: EdgeInsets.symmetric(vertical: 5),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      "${serial.serialNo}.",
                      style: TextStyle(
                        color: AppColor().primariColor,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(width: 5),
                  CircleAvatar(
                    backgroundColor: Colors.grey.shade500,
                    radius: 22,
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                  SizedBox(width: 8),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              serial.name ?? "N/A",
                              style: TextStyle(
                                color: AppColor().primariColor,
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            GestureDetector(
                              onTap: () async {
                                _showDialogBoxManage(serial);
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 5),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Center(
                                  child: Text(
                                    serial.status.toString(),
                                    style: TextStyle(
                                      color: AppColor.getStatusColor(
                                        serial.status,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(displayTime),
                            Text(
                              displayTime,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                        Text(serial.serviceType!.name.toString()),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
